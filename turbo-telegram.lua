--[[
The MIT License (MIT)
Copyright (c) 2016 olueiro <github.com/olueiro>
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

_G.TURBO_SSL = true
local turbo = require("turbo")
local fetch = require("turbo-fetch")
local multipart = require("turbo-multipart-post")
local huntable = require("huntable")

local API_NAME = "turbo-telegram"
local API_URL = "https://api.telegram.org/bot%s/%s"

assert(turbo, "(" .. API_NAME .. ") Turbo.lua required")

local function request(parent, method, options, callback)
  local params = {
    method = "POST"
  }
  local file = false
  for _, value in pairs(options) do
    if type(value) == "table" and value.__type == "file" then
      file = true
      break
    end
  end
  if file then
    params.request_timeout = 6000
    local body, contentType = multipart.encoder(turbo, options, turbo.escape.json_encode)
    params.body = body
    params.on_headers = function(headers)
      headers:add("Content-Type", contentType)
    end
  else
    params.body = turbo.escape.json_encode(options)
    params.on_headers = function(headers)
      headers:add("Content-Type", "application/json")
    end
  end
  local handler = function(data)
    method = string.lower(method)
    local success, failure = function() end, function() end
    if type(callback) == "table" then
      if type(callback.success) == "function" then
        success = callback.success
      end
      if type(callback.failure) == "function" then
        failure = callback.failure
      end
    elseif type(callback) == "function" then
      success = callback
    end
    if not data or data.error then
      parent:log("error", "No response")
      failure("No response", method, parent)
      return false
    end
    local status, result = pcall(turbo.escape.json_decode, data.body)
    if not status then
      parent:log("error", result)
      failure(result, method, parent)
      return false
    end
    if not result.ok then
      parent:log("warning", result.description .. " (" .. result.error_code .. ")")
      failure(result.description .. " (" .. result.error_code .. ")", method, parent)
      return false
    end
    if turbo.log.categories.debug then
      parent:log("debug", turbo.log.stringify(result, "Response"))
    end
    parent:log("success", method .. " parsed")
    success(result.result, method, parent)
    return true
  end
  fetch(turbo, string.format(API_URL, parent._token, method), params, handler)
end

local function update(parent, data)
  for index = 1, #parent._evts do
    if huntable(data, parent._evts[index][1]) then
      local nodes = {}
      for key, _ in pairs(data) do
        nodes[#nodes + 1] = key
      end
      parent:log("success", turbo.escape.json_encode(nodes) .. " triggered")
      if turbo.log.categories.debug then
        parent:log("debug", turbo.log.stringify(data, "Response"))
      end
      local prop = parent._evts[index][2](data, parent)
      if prop == true then
        break -- stop propagation
      end
    end
  end
end

local TG = class(API_NAME)

TG.updater = {

  getUpdates = function(self, options)
    local function upd(args)
      local self, options = args[1], args[2]
      self:say("getUpdates", {
        offset = self._updateOffset and self._updateOffset + 1 or nil,
        limit = 100
      }, {
        success = function(data)
          for _, data in ipairs(data) do
            if not self._updateOffset or (self._updateOffset < data.update_id) then
              self._updateOffset = data.update_id
              update(self, data)
            end
          end
          if options.method == "step" then
            upd({self, options})
          end
        end,
        failure = function()
          if options.method == "step" then
            upd({self, options})
          end
        end
      })
    end
    turbo.ioloop.instance():add_callback(function(args)
      local self, options = args[1], args[2]
      if options.method == "loop" then
        turbo.ioloop.instance():set_interval(options.interval, upd, {self, options})
      elseif options.method == "step" then
        upd({self, options})
      end
    end, {self, options})
  end,

  webhooks = function(self, options)
    local upd = class("update", turbo.web.RequestHandler)
    upd.parent = self
    function upd:post()
      local status, data = pcall(self.get_json, self, true)
      if status then
        if not self.parent._updateId then
          self.parent._updateId = {}
        end
        if not self.parent._updateId[data.update_id] then
          self.parent._updateId[data.update_id] = os.time()
          update(self.parent, data)
        end
      end
    end
    if not options.application then
      options.application = turbo.web.Application()
      options.application:listen(options.port, options.host, options.kwargs)
      self:log("debug", "started at " .. (options.host or "127.0.0.1") .. ":" .. options.port)
    end
    options.application:add_handler(options.url, upd)
  end

}

function TG:initialize(token, options)
  self._token = token
  self._evts = {}

  self.options = {
    logs = true,
    updater = "getUpdates",
    getUpdates = {
      method = "loop",
      interval = 100
    },
    webhooks = {
      port = 80,
      url = "^/" .. string.gsub(string.lower(self._token), "%W", "%%%0") .. "$"
    }
  }

  turbo.util.tablemerge(self.options, options or {})

  if not string.find(self.options.webhooks.url, "^^/.-$$") then
    self.options.webhooks.url = "^/" .. self.options.webhooks.url .. "$"
  end

  self._updater = TG.updater[self.options.updater]
  self._updater(self, self.options[self.options.updater])

  self:log("debug", self.options.updater .. " method")

end

function TG:log(log, message)
  if self.options.logs then
    turbo.log[log]("(" .. API_NAME .. ") " .. (self.options.name and self.options.name .. ": " or "") .. message)
  end
end

function TG:hear(conditions, callback)
  if type(conditions) ~= "table" then
    conditions = { conditions }
  end
  if type(callback) ~= "function" then
    return self, false
  end
  self._evts[#self._evts + 1] = { conditions, callback }
  return self, true
end

function TG:say(method, options, callback)
  return self, request(self, method, options or {}, callback)
end

function TG.file(path, name, mime)
  return multipart.file(turbo, path, name, mime)
end

return TG
