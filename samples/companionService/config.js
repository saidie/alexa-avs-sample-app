/**
 * @module
 * This module defines the settings that need to be configured for a new
 * environment.
 * The clientId and clientSecret are provided when you create
 * a new security profile in Login with Amazon.  
 * 
 * You will also need to specify
 * the redirect url under allowed settings as the return url that LWA
 * will call back to with the authorization code.  The authresponse endpoint
 * is setup in app.js, and should not be changed.  
 * 
 * lwaRedirectHost and lwaApiHost are setup for login with Amazon, and you should
 * not need to modify those elements.
 */
var config = {
  clientId: '$CLIENT_ID',
  clientSecret: '$CLIENT_SECRET',
  redirectUrl: 'https://$HOSTNAME:$PORT/authresponse',
  lwaRedirectHost: 'amazon.com',
  lwaApiHost: 'api.amazon.com',
  validateCertChain: true,
  sslKey: '/data/certs/server.key',
  sslCert: '/data/certs/server.crt',
  sslCaCert: '/data/certs/ca.crt',
  products: {
    "$PRODUCT_ID": ["$SERIAL"],
  },
};

module.exports = config;
