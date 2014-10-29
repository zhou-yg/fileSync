watchFile = require './lib/watchFile'
Dir = require './dslib/directorySet'
#'local':sync dirs between local directories
#'lan_server':has latest version of files.sync dirs or files between computers
#'lan_client':connect to and get the latest of flies.sync dirs or files between computers
#in local
#一个目录参数为主目录，后续的为目录参数为次目录参数,
#区别在于，程序启动时，会自动将主目录的内容同步到次目录。
#in lan
SYNC_TO_LOCAL = 'local'
SYNC_TO_LAN_S = 'lan_server'
SYNC_TO_LAN_C = 'lan_client'
syncType = ''

dirArr = []
process.argv.forEach (_v, _i)->
  if _i isnt 0 and _i isnt 1
    if _i is 2
      syncType = _v
    else
      dirArr[_i - 3] = new Dir(_v,'');
  return

if syncType is 'local'
  dirArr.push process.argv[3]
  dirArr.push process.argv[4]
  formats   = process.argv[5].split ','

else if syncType is 'lan_server ' or  syncType is 'lan_client'
  dirArr.push process.argv[3]
  formats = process.argv[4].split ','

else
  console.log 'first arg must be "local" or "lan_server" or "lan_clent"'
  return

watchFile.setDirs dirArr,syncType
console.log 'fileSync System running...'