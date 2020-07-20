const {google} = require('googleapis');

// eslint-disable-next-line max-len
const recaptchaToken = '03AGdBq25Sb7_x0aE975HN7UcnAixEQsssP_iuRGRWoL2lY7VSfvBfJZpWQAkVOAOPDg3HahbsgOI6hbShGHXSBNqIIODA2selirYIzC3s5V6BQM4sT8gcgqzWlmnaX3Sxz1W8o_atZKaGJ9kzYDuO2SLp6W7iBJIDQY4svaFVxrAx0A3k2NSYgkHkaW5YOT-m0A5RYOPjSriSP9Z_nyfGEUD9h2OF9Eyd4pOvC2CC7Yguo5FmOU716zQQlz1nrjopSIMSDkxk5REISuZxNL9kl3L2OO1LK5mkQxlfbBhK0zWbXV_8J1DRHdz6rh_bYM1Zl7aNhbuKzLtE9yfvbV3KZl7RB3gtf-pRa2WN16b2I2XWStBbaJ0xN50TlEM4sWHFypU1uRRaEC4H';
const phoneNumber = '+375295738689';

const identityToolkit = google.identitytoolkit({
  auth: 'GC_API_KEY',
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
