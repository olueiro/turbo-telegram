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

2. You're ready for start your huge project!

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

* Fast
* Easy to implement
* Fast
* Supports inline buttons
* Fast
* Supports webhooks
* Fast
* Uses LuaJIT (thanks to Turbo)
* Fast
* Debug-friendly
* Fast...
