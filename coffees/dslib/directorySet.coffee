#对象夹：结构对象
#包含当前夹下的文件和子文件夹对象
class DirecotrySet
  constructor:(@rootPath,@dirPath='',@tier=1,@index=0)->
    @index = 0
    @files = []
    @childesDirArr = []

  append:(_node)->
    if _node.constructor isnt DirecotrySet
      return false

    @childesDirArr.push _node
    _node.index = @childesDirArr.length - 1

  push:(_f)->
    if _f
      if _f.constructor is Array
        @files = @files.concat(_f)
      else
        @files.push(_f)

  searchDirByPath:(_path)->
    #通过相对路径
    if !_path && _path isnt ''
      return false

    if @dirPath is _path
      return @
    else
      if @childesDirArr
        for c in @childesDirArr
          return c.searchDirByPath(_path)
      else
        return null

  searchFileByIndex:(_tier,_index)->
    if typeof  _tier isnt 'number' or typeof _index isnt 'number'
      return null

    if _tier is 1
      return file = @childesDirArr[_index-1]
    else

      _tier--
      for c in @childesDirArr
        file = c.searchFileByIndex(_tier,_index)
        if file
          break

      return file

  display:(_tier)->
    if @dirPath
      dirPath = @rootPath+'\\'+@dirPath
    else
      dirPath = @rootPath

    filesArr = []
    @files.forEach (_filename)->
      filesArr.push dirPath+'\\'+_filename


    if --_tier isnt 0
      for c in @childesDirArr
        c.display(_tier).forEach (_filename)->
          filesArr.push _filename

    return filesArr

  iterateObj:(_tier)->
    dirArr = [@]

    if --_tier isnt 0
      for c in @childesDirArr
        c.iterateObj(_tier).forEach (_dir)->
          dirArr.push _dir

    return dirArr

  clone:->
    obj = {}

    for p of @
      obj[p] = @[p]

    return obj

module.exports = DirecotrySet