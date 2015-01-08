-- Some variable declarations.
local block = ""
local http  = require "resty.http"
local setmetatable = setmetatable
local error = error

local _M = { _VERSION = '0.0.1'}
local mt = { __index = _M }

function _M.new(self, server, secret)
    return setmetatable({
        cas_server = server,
        secret = secret
    }, mt)
end

-- usrtoken: is a sha1 + base64 signed cookie with a secret
-- usrid: is a base64 signed cookie representing the CAS username
function _M.authenticate(self, username, password)

  local httpc = http.new()

  local res, err = httpc:request_uri(self.cas_server, {
    ssl_verify = false,
    method     = "POST",
    body       = "username=" .. username .. "&password=" .. password
  })
  if res.status == ngx.HTTP_CREATED then
    local sha1 = ndk.set_var.set_sha1(self.secret .. username)
    local signature = ndk.set_var.set_encode_base64(sha1);
    local userid = ndk.set_var.set_encode_base64(username);
    ngx.header['Set-Cookie'] = {'usrtoken=' .. signature, 'usrid=' .. userid}

    return true
  else
    return false
  end
end

function _M.authorize(self)
  local userid = ngx.var.cookie_usrid
  local token = ngx.var.cookie_usrtoken

  local username = ndk.set_var.set_decode_base64(userid)
  local sha1 = ndk.set_var.set_sha1(self.secret .. username)
  local signature = ndk.set_var.set_encode_base64(sha1);

  return token == signature

end

return _M
