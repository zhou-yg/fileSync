fs = require 'fs'
DirecotrySet = require '../jslibs/directorySet.js'
#根目录对象集合
dirObjArr = []
filesArr = []

#
setDirs = (_dirObjArr)->
  dirObjArr = _dirObjArr
  do readFiles

#read files
readFiles = ->
  readAllFilesSync = (_rootPath,_dirObj,_tier)->
    _tier++
    filenameArr = fs.readdirSync (_rootPath+'\\'+_dirObj.dirPath)

    filenameArr.forEach (_f)->
      intactPath = _rootPath+'\\'+_dirObj.dirPath+'\\'+_f
      stat = fs.statSync intactPath

      if stat.isDirectory()
        intactPath = new DirecotrySet(_rootPath,_f)
        _dirObj.append intactPath
        readAllFilesSync _rootPath,intactPath,_tier
      else
        _dirObj.push _f

  dirObjArr.forEach (_dirObj)->
    readAllFilesSync _dirObj.rootPath,_dirObj,0

  do setFileWatch

  return

setFileWatch = ->

  fwMap = {}

  dirObjArr.forEach (_dirObj)->
    #当前目录下的多有目录对象集合
    allDir = _dirObj.iterateObj 0

    for dir in allDir
      do ->

        mydir = do dir.clone

        myRootPath  = mydir.rootPath
        baseDirPath = mydir.dirPath
        allFiles    = mydir.display 1

        myPath = myRootPath+baseDirPath

        for f in allFiles
          do ->
            fileChangeTrigger = 1

            fileWatcher = (_evt,_filename)->
              if _evt is 'change' and fileChangeTrigger++%2 is 0

                dirObjArr.forEach (__dirObj)->
                  targetDir = __dirObj.searchDirByPath baseDirPath
                  targetPath = targetDir.rootPath+'\\'+targetDir.dirPath+'\\'+_filename;

                  if targetPath isnt f
                    do fwMap[targetPath].close

                    fs.readFile f,(_err,_data)->
                      fs.writeFile targetPath,_data,(_err)->
                        fwMap[targetPath] = fs.watch f,fileWatcher

            fwMap[f] = fs.watch f,fileWatcher


  return
###
#watch same name files
fileWatchXXX = (_evt,_baseDir,_filename)->
  if _evt is 'change' and fileChangeTrigger++%2 is 0

    dirArr.forEach (_dir,_i)->
      if dir isnt _dir

        targetPath = _dir+'\\'+_filename
        do fwMap[targetPath].close

        fs.readFile path,(_err,_data)->
          if _err then throw _err

          fs.writeFile targetPath,_data,(_err)->
            if _err then throw _err
            fwMap[targetPath] = fs.watch targetPath,fileWatch
  return
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