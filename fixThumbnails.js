
/******************************************/
const IS_PRODUCTION = true;
const SIMULATE = true;
/******************************************/

let adminKeyFile;
let storageKeyFile;

if (IS_PRODUCTION) {
  adminKeyFile = './../firebase/functions/adminkey.json';
  storageKeyFile = './../firebase/functions/Medcorder-0c50a30fae7e.json';
} else {
  adminKeyFile = './../firebase/functions/adminkey_staging.json';
  storageKeyFile = './../firebase/functions/medcorder-staging-28e2ef491368.json';
}

const fs = require('fs');
var admin = require('firebase-admin');
const {Storage} = require('@google-cloud/storage');

var serviceAccount = require(adminKeyFile);

const projectId = serviceAccount.project_id;

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://' + projectId + '.firebaseio.com',
});

// As an admin, the app has access to read and write all data, regardless of Security Rules
var db = admin.database();
var roomsRef = db.ref('/rooms');

const storage = new Storage({
  keyFilename: storageKeyFile,
});

const bucket = storage.bucket(projectId + '.appspot.com');

const getRooms = async () => {
   const roomsSnapshot = await roomsRef.once('value');
   const rooms = roomsSnapshot.val();
   return rooms;
}

const asyncForEach = async (obj, callback) => {
  for (const key in obj) {
    if ({}.hasOwnProperty.call(obj, key)) {
      await callback(obj[key], key);
    }
  }
};

const fileExists = async (name) => {
  const file = bucket.file(name);
  const ex = await file.exists();
  return ex[0];
}

const logObj = {};

const SaveLogToJson = () => {
  fs.writeFileSync('./tmp/fixThumbnailsLog.' + projectId + '.' + Date.now() + '.json', JSON.stringify(logObj, null, 2));
}

const checkAndUpdate = async (rooms, roomID, msgID, field, newVal) => {
  const oldVal = rooms[roomID]['messages'][msgID][field];

  logKey = [roomID, msgID, field].join('/');

  if(oldVal === newVal){
    console.log('OK', field, '===', oldVal);
    logObj[logKey] = {
      status: 'OK',
      oldVal,
      newVal,
    };
  }else{
    console.log('FIXING', field, 'FROM', oldVal, 'TO', newVal);
    logObj[logKey] = {
      status: 'FIXING',
      oldVal,
      newVal,
    };
    if (!SIMULATE){
      await roomsRef.child(roomID).child('messages').child(msgID).child(field).set(newVal);
    }
  }
}

const getLastPathName = (tryPath) => tryPath.split('/').pop(-1);

const getMsgLink = (roomID, msgID) => {
  return 'https://console.firebase.google.com/project/' + projectId + '/database/'+ projectId +'/data/rooms/'+roomID+'/messages/' + msgID;
}

const startProcess = async () => {
  console.log(projectId, 'requesting rooms');
  const rooms = await getRooms();
  await asyncForEach(rooms, async (room, roomID) => {
    const messages = room.messages || {};
    await asyncForEach(messages, async (originalMsg, msgID) => {
      const msg = {...originalMsg};

      if(['Photo', 'Video'].includes(msg.type) && msg['fileStatus'] == 'OK'){
        console.log('\nPROCESSING', getMsgLink(roomID, msgID));

        if(!msg.ext){
          console.log('MSG EXT NOT FOUND')
          if(msg.type === 'Photo'){
            const tryExt = 'JPG';
            const mediaFile = 'sounds/' + roomID + '/'+ msgID + '.' + tryExt;
            if(await fileExists(mediaFile)){
              msg.ext = tryExt;
              console.log('ext fixing');
              await checkAndUpdate(rooms, roomID, msgID, 'ext', tryExt);
            }
          }
          if(msg.type === 'Video'){
            const tryExtensions = ['MOV', 'MP4', '3GP'];
            for (i in tryExtensions){
              const tryExt = tryExtensions[i];
              const mediaFile = 'sounds/' + roomID + '/'+ msgID + '.' + tryExt;
              if(await fileExists(mediaFile)){
                msg.ext = tryExt;
                console.log('ext fixing');
                await checkAndUpdate(rooms, roomID, msgID, 'ext', tryExt);
                break;
              }              
            }
          }
        }
        
        const mediaFile = 'sounds/' + roomID + '/'+ msgID + '.' + msg.ext;
        if (!( msg.ext && await fileExists(mediaFile))){
          console.log('!!! FILE NOT FOUND');
          return;
        }

        if(msg.thumbUrl){
          const tryPath = 'sounds/' + roomID + '/'+ msg.thumbUrl;
          if (await fileExists(tryPath)){
            console.log('preview Found', tryPath);
            await checkAndUpdate(rooms, roomID, msgID, 'preview', tryPath)
            await checkAndUpdate(rooms, roomID, msgID, 'thumbUrl', getLastPathName(tryPath))
            await checkAndUpdate(rooms, roomID, msgID, 'previewStatus', 'OK')
            return;
          }
        }

        if(msg.preview){
          if(msg.preview.startsWith('sounds/')){
            const tryPath = msg.preview;
            if (await fileExists(tryPath)){
              console.log('preview Found', tryPath);
              await checkAndUpdate(rooms, roomID, msgID, 'preview', tryPath)
              await checkAndUpdate(rooms, roomID, msgID, 'thumbUrl', getLastPathName(tryPath))
              await checkAndUpdate(rooms, roomID, msgID, 'previewStatus', 'OK')
              return;
            }
          }else{
            const tryPath = 'sounds/' + roomID + '/'+ msg.preview;
            if (await fileExists(tryPath)){
              console.log('preview Found', tryPath);
              await checkAndUpdate(rooms, roomID, msgID, 'preview', tryPath)
              await checkAndUpdate(rooms, roomID, msgID, 'thumbUrl', getLastPathName(tryPath))
              await checkAndUpdate(rooms, roomID, msgID, 'previewStatus', 'OK')
              return;
            }
          }
        }

        console.log('preview NOT Found');
        await checkAndUpdate(rooms, roomID, msgID, 'previewStatus', '');
        await checkAndUpdate(rooms, roomID, msgID, 'previewStatus', 'NEED');
      }
    })
  });
  SaveLogToJson();
};

startProcess().then(() => {
  console.log('END');
  process.exit();
});