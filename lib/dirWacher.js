(function() {
  var DirectorySet, config, events, fileWatcher, fs, fwMap, isConfig, readAllFilesSync, readFilesInDir, setFileWatch, setWatcher;

  fs = require('fs');

  events = require('events');

  DirectorySet = require('../dslib/directorySet.js');

  config = {
    type: null,
    main: null,
    clients: null,
    all: null
  };

  isConfig = false;

  readAllFilesSync = function(_rootPath, _dirObj, _tier) {
    var filenameArr;
    _tier++;
    filenameArr = fs.readdirSync(_rootPath + '\\' + _dirObj.dirPath);
    return filenameArr.forEach(function(_f) {
      var f, intactPath, stat;
      if (_dirObj.dirPath) {
        intactPath = _rootPath + '\\' + _dirObj.dirPath + '\\' + _f;
        f = _dirObj.dirPath + '\\' + _f;
      } else {
        intactPath = _rootPath + '\\' + _f;
        f = _f;
      }
      stat = fs.statSync(intactPath);
      if (stat.isDirectory()) {
        intactPath = new DirectorySet(_rootPath, f);
        _dirObj.append(intactPath);
        return readAllFilesSync(_rootPath, intactPath, _tier);
      } else {
        return _dirObj.push(_f);
      }
    });
  };

  readFilesInDir = function(_dirObj) {
    if (_dirObj.constructor !== DirectorySet && isConfig) {
      return null;
    } else {
      return readAllFilesSync(_dirObj.rootPath, _dirObj, 0);
    }
  };

  fwMap = {};

  fileWatcher = new events.EventEmitter();

  fileWatcher.on('writeLocal', function(_rootDirObj, _myDirObj, _filename) {
    var myfile, targetDirObj, targetPath;
    myfile = _myDirObj.rootPath;
    if (_myDirObj.dirPath) {
      myfile += '\\' + _myDirObj.dirPath + '\\' + _filename;
    } else {
      myfile += '\\' + _filename;
    }
    targetDirObj = _rootDirObj.searchDirByPath(_myDirObj.dirPath);
    targetPath = targetDirObj.rootPath;
    if (targetDirObj.dirPath) {
      targetPath += '\\' + targetDirObj.dirPath + '\\' + _filename;
    } else {
      targetPath += '\\' + _filename;
    }
    fwMap[targetPath].close();
    return fs.readFile(myfile, function(_err, _data) {
      return fs.writeFile(targetPath, _data, function(_err) {
        return setFileWatch(targetDirObj, 1, _filename);
      });
    });
  });

  setFileWatch = function(_dirObj, _i, _filename) {
    var allDir, dir, f, _fn, _j, _len;
    if (_i == null) {
      _i = 0;
    }
    if (_dirObj.constructor !== DirectorySet) {
      return null;
    }
    if (_filename) {
      f = _dirObj.rootPath;
      if (_dirObj.dirPath) {
        f += '\\' + _dirObj.dirPath + '\\' + _filename;
      } else {
        f += '\\' + _filename;
      }
      setWatcher(f, _dirObj);
    } else {
      readFilesInDir(_dirObj);
      allDir = _dirObj.iterateObj(_i);
      _fn = function() {
        var allFiles, mydir, _k, _len1, _results;
        mydir = dir.clone();
        allFiles = mydir.display(1);
        _results = [];
        for (_k = 0, _len1 = allFiles.length; _k < _len1; _k++) {
          f = allFiles[_k];
          _results.push(setWatcher(f, mydir));
        }
        return _results;
      };
      for (_j = 0, _len = allDir.length; _j < _len; _j++) {
        dir = allDir[_j];
        _fn();
      }
    }
    return fileWatcher;
  };

  setWatcher = function(_myfile, _mydirObj) {
    var fileChangeTrigger, myfile, watcher;
    myfile = _myfile;
    fileChangeTrigger = 1;
    watcher = function(_evt, _changeFilename) {
      if (_evt === 'change') {
        if (fileChangeTrigger++ % 2 === 0) {
          return fileWatcher.emit('change', _mydirObj, _changeFilename);
        }
      }
    };
    return fwMap[myfile] = fs.watch(myfile, watcher);
  };

  exports.setFileWatch = setFileWatch;

}).call(this);
