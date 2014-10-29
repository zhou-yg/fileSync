(function() {
  var DirecotrySet;

  DirecotrySet = (function() {
    function DirecotrySet(rootPath, dirPath, tier, index) {
      this.rootPath = rootPath;
      this.dirPath = dirPath != null ? dirPath : '';
      this.tier = tier != null ? tier : 1;
      this.index = index != null ? index : 0;
      this.index = 0;
      this.files = [];
      this.childesDirArr = [];
    }

    DirecotrySet.prototype.append = function(_node) {
      if (_node.constructor !== DirecotrySet) {
        return false;
      }
      this.childesDirArr.push(_node);
      return _node.index = this.childesDirArr.length - 1;
    };

    DirecotrySet.prototype.push = function(_f) {
      if (_f) {
        if (_f.constructor === Array) {
          return this.files = this.files.concat(_f);
        } else {
          return this.files.push(_f);
        }
      }
    };

    DirecotrySet.prototype.searchDirByPath = function(_path) {
      var c, _i, _len, _ref;
      if (!_path && _path !== '') {
        return false;
      }
      if (this.dirPath === _path) {
        return this;
      } else {
        if (this.childesDirArr) {
          _ref = this.childesDirArr;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            c = _ref[_i];
            return c.searchDirByPath(_path);
          }
        } else {
          return null;
        }
      }
    };

    DirecotrySet.prototype.searchFileByIndex = function(_tier, _index) {
      var c, file, _i, _len, _ref;
      if (typeof _tier !== 'number' || typeof _index !== 'number') {
        return null;
      }
      if (_tier === 1) {
        return file = this.childesDirArr[_index - 1];
      } else {
        _tier--;
        _ref = this.childesDirArr;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          c = _ref[_i];
          file = c.searchFileByIndex(_tier, _index);
          if (file) {
            break;
          }
        }
        return file;
      }
    };

    DirecotrySet.prototype.display = function(_tier) {
      var c, dirPath, filesArr, _i, _len, _ref;
      if (this.dirPath) {
        dirPath = this.rootPath + '\\' + this.dirPath;
      } else {
        dirPath = this.rootPath;
      }
      filesArr = [];
      this.files.forEach(function(_filename) {
        return filesArr.push(dirPath + '\\' + _filename);
      });
      if (--_tier !== 0) {
        _ref = this.childesDirArr;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          c = _ref[_i];
          c.display(_tier).forEach(function(_filename) {
            return filesArr.push(_filename);
          });
        }
      }
      return filesArr;
    };

    DirecotrySet.prototype.iterateObj = function(_tier) {
      var c, dirArr, _i, _len, _ref;
      dirArr = [this];
      if (--_tier !== 0) {
        _ref = this.childesDirArr;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          c = _ref[_i];
          c.iterateObj(_tier).forEach(function(_dir) {
            return dirArr.push(_dir);
          });
        }
      }
      return dirArr;
    };

    DirecotrySet.prototype.clone = function() {
      var obj, p;
      obj = {};
      for (p in this) {
        obj[p] = this[p];
      }
      return obj;
    };

    return DirecotrySet;

  })();

  module.exports = DirecotrySet;

}).call(this);
