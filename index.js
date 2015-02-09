(function() {
  var Dir, JsonReader, SYNC_TO_LAN_C, SYNC_TO_LAN_S, SYNC_TO_LOCAL, configFilePath, dirArr, init, jsonReaderP, syncType, watchFile;

  watchFile = require('./lib/watchFile');

  Dir = require('./dslib/directorySet');

  JsonReader = require('./bin/JsonReader');

  SYNC_TO_LOCAL = 'local';

  SYNC_TO_LAN_S = 'lan_server';

  SYNC_TO_LAN_C = 'lan_client';

  configFilePath = 'config.json';

  syncType = '';

  dirArr = [];

  init = function() {
    return watchFile.setDirs(dirArr, syncType);
  };

  jsonReaderP = JsonReader.read(configFilePath);

  jsonReaderP.done(function(_dataObj) {
    syncType = _dataObj.mode;
    dirArr.push(new Dir(_dataObj.src, ''));
    dirArr.push(new Dir(_dataObj.dest, ''));
    return init();
  });

  console.log('fileSync System running...');

}).call(this);
