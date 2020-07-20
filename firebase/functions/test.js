const {google} = require('googleapis');

// eslint-disable-next-line max-len
const recaptchaToken = '03AGdBq272Yq1ZYjek9XCu1NyqBcucm0RsBV0rmmtuJyXm22ZUCaMM_yQl9eJ5cn910FffZ1hJCjxNxfX1EHVUnBkXZjCCIfrmGzi2rhOlamkMRMgW7ih3Rh8FaNSYMhVi_JnV8RDxB9udmQKAqHnYPkBBSpDcdgnlTkTA4_tIeiamh8VpwyTkpCqNfZJDm8iWrTmWwMO13tEpM6DrBMWBp_fy7EjSyu2b_OX3CPXViF6O8bKi7bs5rVy-FnhX0E6khemTEq_kk2ubS0qTgc_W4rNgWDs1My8UzfyQPHo-Er9TtTNO46VheY5DjIL7faFQnZ1FTKDq7nol2-Bu1c_CDx402g2bxh3WHzqFUW-JaTFAueZH2Toi20-aN-4tAt3f6eZ7R9U9e7MU';
const phoneNumber = '+375295738689';

const identityToolkit = google.identitytoolkit({
  auth: 'GC_KEY',
  version: 'v3',
});

const sendSMS = async () => {
  try {
    // save sessionInfo into db. You will need this to verify the SMS code
    const response = await identityToolkit.relyingparty.sendVerificationCode({
      phoneNumber,
      recaptchaToken: recaptchaToken,
    });

    const sessionInfo = response.data.sessionInfo;

    console.log(sessionInfo);
  } catch (e) {
    console.log(e);
  }
};

sendSMS();
