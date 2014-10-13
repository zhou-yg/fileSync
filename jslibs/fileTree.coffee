class Dir
  constructor:(@path)->
    @index = 0
    @files = []
    @childes = []

  append:(_node)->
    if _node.constructor isnt Dir
      return false

    @childes.push _node
    _node.index = @childes.length - 1

  push:(_f)->
    if _f
      if _f.constructor is Array
        @files = @files.concat(_f)
      else
        @files.push(_f)

  searchFile:(_filename)->
    if !_filename
      return false

    if @files.indexOf(_filename) is -1

      if @childes
        for c in @childes
          return c.searchFile(_filename)
      else
        return null
    else
      return @

  display:->
    console.log @path,"->",@files
    for c in @childes
      c.display()

module.exports = Dir