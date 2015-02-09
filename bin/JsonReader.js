(function() {
  var Q, fs, parseJsonFile;

  fs = require('fs');

  Q = require('Q');

  parseJsonFile = function(filePath) {
    var charsFilterRegExp, d;
    d = Q.defer();
    charsFilterRegExp = /\/\*[\s\S]+?\*\//g;
    fs.exists(filePath, function(isExists) {
      if (!isExists) {
        return d.resolve(isExists);
      } else {
        return fs.readFile(filePath, function(err, data) {
          if (err) {
            console.log(err);
          }
          data = data.toString();
          data = data.replace(charsFilterRegExp, '');
          data = JSON.parse(data);
          return d.resolve(data);
        });
      }
    });
    return d.promise;
  };

  module.exports = {
    read: function(filePath) {
      var d, parseP;
      d = Q.defer();
      parseP = parseJsonFile(filePath);
      parseP.done(function(data) {
        if (!data) {
          console.log('.json not exist');
          return d.resolve({
            result: null
          });
        } else {
          return d.resolve(data);
        }
      });
      return d.promise;
    }
  };

}).call(this);
