#模块方法
fs           = require 'fs'
events       = require 'events'
DirectorySet = require '../dslib/directorySet.js'

config =
  type:null
  main:null
  clients:null
  all:null

isConfig = false

#read all files under a directory
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

readFilesInDir = (_dirObj)->
  if _dirObj.constructor isnt DirectorySet and isConfig
    return null
  else
    readAllFilesSync _dirObj.rootPath,_dirObj,0

#watch all files under this directory
fwMap = {}
fileWatcher = new events.EventEmitter()

fileWatcher.on 'writeLocal',(_rootDirObj,_myDirObj,_filename)->

  myfile = _myDirObj.rootPath
  if _myDirObj.dirPath
    myfile += '\\'+_myDirObj.dirPath+'\\'+_filename
  else
    myfile += '\\'+_filename

  targetDirObj = _rootDirObj.searchDirByPath _myDirObj.dirPath
  targetPath = targetDirObj.rootPath
  if targetDirObj.dirPath
    targetPath += '\\'+targetDirObj.dirPath+'\\'+_filename
  else
    targetPath += '\\'+_filename

  do fwMap[targetPath].close

  fs.readFile myfile,(_err,_data)->
    fs.writeFile targetPath,_data,(_err)->
      setFileWatch targetDirObj,1,_filename

setFileWatch = (_dirObj,_i=0,_filename)->
  if _dirObj.constructor isnt DirectorySet
    return null

  if _filename
    f = _dirObj.rootPath

    if _dirObj.dirPath
      f += '\\'+_dirObj.dirPath+'\\'+_filename
    else
      f += '\\'+_filename
    setWatcher f,_dirObj

   else
    readFilesInDir(_dirObj)
    allDir = _dirObj.iterateObj _i

    for dir in allDir
      do ->
        mydir = dir.clone()
        allFiles = mydir.display 1

        for f in allFiles
          setWatcher(f,mydir)

  return fileWatcher

setWatcher = (_myfile,_mydirObj)->

  myfile = _myfile
  fileChangeTrigger = 1

  watcher = (_evt,_changeFilename)->
    if _evt is 'change'
      if fileChangeTrigger++%2 is 0
        fileWatcher.emit 'change',_mydirObj,_changeFilename
  fwMap[myfile] = fs.watch myfile,watcher

exports.setFileWatch = setFileWatch