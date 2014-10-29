(function() {
  var DiectorySet, SYNC_TO_LAN_C, SYNC_TO_LAN_S, SYNC_TO_LOCAL, dirObjArr, dirWacher, fs, setDirs, setFileWatch, syncType;

  fs = require('fs');

  DiectorySet = require('../dslib/directorySet.js');

  dirWacher = require('./dirWacher.js');

  SYNC_TO_LOCAL = 'local';

  SYNC_TO_LAN_S = 'lan_server';

  SYNC_TO_LAN_C = 'lan_client';

  dirObjArr = [];

  syncType = null;

  setDirs = function(_dirObjArr, _type) {
    dirObjArr = _dirObjArr;
    syncType = _type;
    return setFileWatch();
  };

  setFileWatch = function() {
    var fileWatcher;
    fileWatcher = null;
    dirObjArr.forEach(function(_dirObj) {
      return fileWatcher = dirWacher.setFileWatch(_dirObj);
    });
    return fileWatcher.on('change', function(_mydirObj, _filename) {
      if (syncType === SYNC_TO_LOCAL) {
        return dirObjArr.forEach(function(__dirObj) {
          if (_mydirObj.rootPath !== __dirObj.rootPath) {
            return fileWatcher.emit('writeLocal', __dirObj, _mydirObj, _filename);
          }
        });
      } else if (syncType === SYNC_TO_LAN_S) {
        return console.log('s');
      } else if (syncType === SYNC_TO_LAN_C) {
        return console.log('c');
      }
    });
  };

  module.exports = {
    setDirs: setDirs
  };

}).call(this);
