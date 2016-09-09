turbo-telegram
==============
Fully-featured Telegram Bot API for [Turbo.lua](http://turbo.readthedocs.io)

Requisites
----------

1. Install `luarocks`. Instructions [here](https://luarocks.org/#quick-start).

Installation
------------

1. Install `turbo-telegram` via `luarocks`

   ```$ luarocks install turbo-telegram```

2. You're ready to start your huge project!

Hello-World.lua
-----------

```lua
local turbo = require("turbo")
local telegram = require("turbo-telegram")

local my_bot = telegram("YOUR-TOKEN-HERE")

my_bot:hear("text", function(data)
  my_bot:say("sendMessage", {
    chat_id = data.chat.id,
    text = "Hello World!"
  })
end)

turbo.ioloop.instance():start()
```

_Do you not have created a bot? [Click here](http://telegram.me/botfather?start=/newbot)_

Send any message to your bot and wait a reply from it.



Features
--------

* Fast;
* Easy to implement;
* Fast;
* Supports inline commands;
* Fast;
* Supports webhooks;
* Fast;
* Uses LuaJIT (thanks to Turbo);
* Fast;
* Debug-friendly;
* Fast...

Methods
-------

`bot:hear(conditions, action)` Create an event to trigger if `conditions` (see below) matches and execute `action` passing the update as first argument, return `true` in function to kill this update.

`bot:say(command, parameters[, callback])` Send a message or media to bot. Check [Available methods](https://core.telegram.org/bots/api#available-methods) to view all supported `command`s and yours `parameters`. Pass a function or a table (with success or failure keys) to `callback`, the result will pass as first argument.

`bot:file(filepath[, filename[, mime_type]])` Use this function inside `parameters` to send file when specified.
