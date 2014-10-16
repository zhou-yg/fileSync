watchFile = require './files/watchFile'
Dir = require './jslibs/directorySet'
#'localhost':sync dirs between local directories
# provide path of directories
#'net':sync dirs or files between computers
# provide ip:port,a path of dir (to save these files)
type = ''
#get directory
#(or get a file,current doesn't support)

dirArr = []
process.argv.forEach (_v, _i)->
  if _i isnt 0 and _i isnt 1
    if _i is 2
      type = _v
    else
      dirArr[_i - 3] = new Dir(_v,'');
  return

watchFile.setDirs dirArr