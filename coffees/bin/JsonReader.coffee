fs = require 'fs'
Q = require 'Q'

#返回对应json文件的json对象
parseJsonFile = (filePath)->
  d = Q.defer()

  charsFilterRegExp = /\/\*[\s\S]+?\*\//g

  fs.exists filePath,(isExists)->
    if !isExists
      d.resolve isExists
    else
      fs.readFile filePath,(err,data)->
        if err
          console.log err

        data = data.toString()
        data = data.replace charsFilterRegExp,''
        data = JSON.parse data
        d.resolve data

  return d.promise

module.exports =
  read:(filePath)->
    d = Q.defer()
    parseP = parseJsonFile filePath
    parseP.done (data)->
      if !data
        console.log '.json not exist'
        d.resolve {result:null}
      else
        d.resolve data

    return d.promise
