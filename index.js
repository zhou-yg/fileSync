(function() {
  var Dir, SYNC_TO_LAN_C, SYNC_TO_LAN_S, SYNC_TO_LOCAL, dirArr, formats, syncType, watchFile;

  watchFile = require('./lib/watchFile');

  Dir = require('./dslib/directorySet');

  SYNC_TO_LOCAL = 'local';

  SYNC_TO_LAN_S = 'lan_server';

  SYNC_TO_LAN_C = 'lan_client';

  syncType = '';

  dirArr = [];

  process.argv.forEach(function(_v, _i) {
    if (_i !== 0 && _i !== 1) {
      if (_i === 2) {
        syncType = _v;
      } else {
        dirArr[_i - 3] = new Dir(_v, '');
      }
    }
  });

  if (syncType === 'local') {
    dirArr.push(process.argv[3]);
    dirArr.push(process.argv[4]);
    formats = process.argv[5].split(',');
  } else if (syncType === 'lan_server ' || syncType === 'lan_client') {
    dirArr.push(process.argv[3]);
    formats = process.argv[4].split(',');
  } else {
    console.log('first arg must be "local" or "lan_server" or "lan_clent"');
    return;
  }

  watchFile.setDirs(dirArr, syncType);

  console.log('fileSync System running...');

}).call(this);
