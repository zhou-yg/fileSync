fs = require 'fs'
Dir = require '../jslibs/fileTree.js'

dirObjArr = []
filesArr = []

#
setDirs = (_dirObjArr)->
  dirObjArr = _dirObjArr
  do readFiles

#read files
readFiles = ->
  readAllFilesSync = (_dirObj)->

    filenameArr = fs.readdirSync _dirObj.path

    filenameArr.forEach (_f)->
      _f = _dirObj.path + '\\' + _f
      stat = fs.statSync _f

      if stat.isDirectory()
        _f = new Dir(_f)
        _dirObj.append _f
        readAllFilesSync _f
      else
        _dirObj.push _f

  ###
  readAllFilesSync = (_path,_filesArr)->
    stat = fs.statSync _path

    if stat.isDirectory()

      filenameArr = fs.readdirSync _path

      _filesArr.push []
      _filesArr[_filesArr.length-1].push _path

      if _path.indexOf('/') isnt -1
        p = '/'
      else
        p = '\\'

      filenameArr.forEach (_f)->
        readAllFiles  "#{_path}#{p}#{_f}",_filesArr[_filesArr.length-1]
    else
      _filesArr.push _path

    return
  ###
  readAllFiles = (_path,_filesArr)->

    fs.stat _path,(_e,_stat)->
      if _e then throw _e
      if _stat.isDirectory()

        fs.readdir _path,(_e,_files)->
          if _e then throw _e

          _filesArr.push []
          _filesArr[_filesArr.length-1].push _path

          if _path.indexOf('/') is -1
            p = '\\'
          else
            p = '/'
          _files.forEach (_f)->

            readAllFiles "#{_path}#{p}#{_f}",_filesArr[_filesArr.length-1]
      else
        _filesArr.push _path
    return

  dirObjArr.forEach (_dirObj)->
    readAllFilesSync _dirObj

  dirObjArr.forEach (_dirObj)->
    do _dirObj.display

  return

#watch same name files
fileWatch = (_evt,_baseDir,_filename)->
  if _evt is 'change' and fileChangeTrigger++%2 is 0

    dirArr.forEach (_dir,_i)->
      if dir isnt _dir

        targetPath = _dir + '\\' + _filename
        do fwMap[targetPath].close

        fs.readFile path,(_err,_data)->
          if _err then throw _err

          fs.writeFile targetPath,_data,(_err)->
            if _err then throw _err
            fwMap[targetPath] = fs.watch targetPath,fileWatch
  return
###
fwMap = {}
setWatch = ->

  filesArr.forEach (_files,_i)->
    _files.forEach (_file)->
      dir = dirArr[_i]
      path = dir + '\\'+_file

      fileChangeTrigger = 1

      fileWatch = (_evt,_filename)->
        if _evt is 'change' and fileChangeTrigger++%2 is 0

          dirArr.forEach (_dir,_i)->
            if dir isnt _dir

              targetPath = _dir + '\\' + _filename
              do fwMap[targetPath].close

              fs.readFile path,(_err,_data)->
                if _err then throw _err

                fs.writeFile targetPath,_data,(_err)->
                  if _err then throw _err
                  fwMap[targetPath] = fs.watch targetPath,fileWatch
        return

      fwMap[path] = fs.watch path,fileWatch
###
exports.setDirs = setDirs