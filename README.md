turbo-telegram
==============
Fully-featured Telegram Bot API for [Turbo.lua](http://turbo.readthedocs.io)

Requirements
------------

1. `luarocks`. Installation instructions [here](https://luarocks.org/#quick-start).

Installation
------------

1. Install `turbo-telegram` via `luarocks`

   ```$ luarocks install turbo-telegram```

2. You're ready to start your huge project!

Hello-World.lua
-----------

```lua
_G.TURBO_SSL = true
local turbo = require("turbo")
local telegram = require("turbo-telegram")

local my_bot = telegram("YOUR-TOKEN-HERE")

my_bot:hear("text", function(data)
  my_bot:say("sendMessage", {
    chat_id = data.message.chat.id,
    text = "Hello World!"
  })
end)

turbo.ioloop.instance():start()
```

_Do you not have created a bot? [Click here](http://telegram.me/botfather?start=/newbot)_

Replace *YOUR-TOKEN-HERE* with your real token. Execute this example `$ sudo luajit Hello-World.lua`, and send any message to your bot and wait a reply from it.

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

`bot:hear(conditions, action)` Create an event to trigger if `conditions` ([Examples](https://github.com/olueiro/huntable#sample)) matches and execute `action` passing the update as first argument, return `true` in function to kill this update.

`bot:say(command, parameters[, callback])` Send a message or media to bot. Check [Available methods](https://core.telegram.org/bots/api#available-methods) to view all supported `command`s and yours `parameters`. Pass a function or a table (with success or failure keys) to `callback`, the result will pass as first argument.

![Sample](https://raw.githubusercontent.com/olueiro/turbo-telegram/master/docs/sample.png)

`bot.file(filepath[, filename[, mime_type]])` Use this function inside `parameters` to send file when required.



Examples
--------

_Coming soon_

License
-------

The MIT License (MIT)

Copyright (c) 2016 olueiro

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
