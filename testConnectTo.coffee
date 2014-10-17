net = require 'net'

client = net.connect {port:8888},->

  console.log 'client connected'
  client.write 'world'

  i = 0
  si = setInterval ->
    client.write 'number is '+i++
  ,1000
  setTimeout ->
    clearInterval si
    client.end()
  ,3000

client.on 'data',(_data)->
  console.log _data.toString()

client.on 'end',->
  console.log 'client disconnected'