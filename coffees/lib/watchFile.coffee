#本地的局域网同步
fs = require 'fs'
DiectorySet = require '../dslib/directorySet.js'
dirWacher   = require './dirWacher.js'

SYNC_TO_LOCAL = 'local'
SYNC_TO_LAN_S = 'lan_server'
SYNC_TO_LAN_C = 'lan_client'

#根目录对象集合
dirObjArr = []
syncType = null

setDirs = (_dirObjArr,_type)->
  dirObjArr = _dirObjArr
  syncType = _type
  do setFileWatch

setFileWatch = ->
  fileWatcher = null

  dirObjArr.forEach (_dirObj)->
    fileWatcher = dirWacher.setFileWatch _dirObj

  fileWatcher.on 'change',(_mydirObj,_filename)->

    if syncType is SYNC_TO_LOCAL
      dirObjArr.forEach (__dirObj)->

        if _mydirObj.rootPath isnt __dirObj.rootPath
          fileWatcher.emit 'writeLocal',__dirObj,_mydirObj,_filename
    else if syncType is SYNC_TO_LAN_S
      console.log 's'
    else if syncType is SYNC_TO_LAN_C
      console.log 'c'
    
module.exports =
  setDirs:setDirs