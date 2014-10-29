(function() {
  var events, fs, net, o;

  fs = require('fs');

  net = require('net');

  events = require('events');

  o = new events.EventEmitter();

  o.on('e1', function(arg) {
    return console.log(arg);
  });

  o.on('e1', function(arg) {
    return console.log(arg);
  });

  o.emit('e1', 'x');


  /*
  clientList = []
  
  server.on 'connection',(_client)->
  
    console.log 'clinet connected'
  
    _client.on 'data',(_data)->
      console.log _data
  
    _client.on 'end',(_data)->
      console.log 'client end',_data
  
  server.listen 8888,->
    console.log 'server is running'
   */

}).call(this);
