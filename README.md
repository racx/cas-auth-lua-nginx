# NGINX CAS authentication module in Lua
This is a POC project of a Lua module to authenticate CAS users on NGINX before reaching the application.

## How the module works
After authenticating, the following cookies are created:

usrtoken: is a sha1 + base64 signed cookie with a secret

usrid: is a base64 signed cookie representing the CAS username

## Configuration
Edit the nginx configuration: config/default

Replace $cas_server with your CAS ticket authentication URL

Replace $secret with a secretive token

## Example
The example rails application demonstrates how to verify the signed cookie
