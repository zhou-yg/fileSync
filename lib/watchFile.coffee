#本地的局域网同步
fs = require 'fs'
DiectorySet = require '../dslib/directorySet.js'
dirWacher   = require './dirWacher.j'

SYNC_TO_LOCAL = 'local'
SYNC_TO_LAN_S = 'lan_server'
SYNC_TO_LAN_C = 'lan_client'

#根目录对象集合
dirObjArr = []
type = null

setDirs = (_dirObjArr,_type)->
  dirObjArr = _dirObjArr
  type = _type
  #do readFiles
  do setFileWatch1

setFileWatch1 = ->
  fileWatcher = null

  dirObjArr.forEach (_dirObj)->
    fileWatcher = dirWacher.setFileWatch _dirObj

  fileWatcher.on 'change',(_mydirObj,_filename)->

    if type is SYNC_TO_LOCAL
      dirObjArr.forEach (__dirObj)->

        if _mydirObj.rootPath isnt __dirObj.rootPath
          fileWatcher.emit 'writeLocal',__dirObj,_mydirObj,_filename
    else if type is SYNC_TO_LAN_S
      
    else if type is SYNC_TO_LAN_C
###
#read files
readFiles = ->
  readAllFilesSync = (_rootPath,_dirObj,_tier)->
    _tier++
    filenameArr = fs.readdirSync (_rootPath+'\\'+_dirObj.dirPath)

    filenameArr.forEach (_f)->
      #相对目录命f，目录下文件命_f
      if _dirObj.dirPath
        intactPath = _rootPath+'\\'+_dirObj.dirPath+'\\'+_f
        f = _dirObj.dirPath+'\\'+_f
      else
        intactPath = _rootPath+'\\'+_f
        f = _f

      stat = fs.statSync intactPath

      if stat.isDirectory()

        intactPath = new DirectorySet(_rootPath,f)
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

        baseDirPath = mydir.dirPath
        allFiles    = mydir.display 1

        for f in allFiles
          do ->
            myfile = f
            fileChangeTrigger = 1

            fileWatcher = (_evt,_filename)->
              if _evt is 'change' and fileChangeTrigger++%2 is 0
                dirObjArr.forEach (__dirObj)->

                  targetDir = __dirObj.searchDirByPath baseDirPath

                  targetPath = targetDir.rootPath
                  if targetDir.dirPath
                    targetPath += '\\'+targetDir.dirPath+'\\'+_filename;
                  else
                    targetPath += '\\'+_filename

                  if targetPath isnt myfile
                    do fwMap[targetPath].close

                    fs.readFile myfile,(_err,_data)->
                      fs.writeFile targetPath,_data,(_err)->
                        fwMap[targetPath] = fs.watch f,fileWatcher

            fwMap[myfile] = fs.watch myfile,fileWatcher
  return

exports.setDirs = setDirs