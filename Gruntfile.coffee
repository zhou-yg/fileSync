module.exports = (_grunt)->
  _grunt.initConfig
    coffee:
      indexFilesTo:
        expand:true
        cwd:'coffees'
        src:['index.coffee','test.coffee']
        dest:''
        ext:'.js'

      configFilesTo:
        expand:true
        cwd:'coffees/config'
        src:'*.coffee'
        dest:'config'
        ext:'.js'

      dslibFilesTo:
        expand:true
        cwd:'coffees/dslib'
        src:'*.coffee'
        dest:'dslib'
        ext:'.js'

      libFilesTo:
        expand:true
        cwd:'coffees/lib'
        src:'*.coffee'
        dest:'lib'
        ext:'.js'

  _grunt.loadNpmTasks('grunt-contrib-coffee')

  _grunt.registerTask('default', ['coffee']);