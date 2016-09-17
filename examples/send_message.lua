_G.TURBO_SSL = true
local turbo = require("turbo")
local telegram = require("turbo-telegram")

local my_bot = telegram("<INSERT YOUR TOKEN HERE>")

my_bot:hear("text", function(data)

  my_bot:say("sendMessage", {
    chat_id = data.message.chat.id,
    text = "Hello World"
  })

end)

turbo.ioloop.instance():start()