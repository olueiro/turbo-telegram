turbo-telegram
==============
Fully-featured Telegram Bot API for [Turbo.lua](http://turbo.readthedocs.io)

Hello World
-----------

```lua
_G.TURBO_SSL = true
local turbo = require("turbo)
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

