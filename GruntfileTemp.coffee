

module.exports = (grunt) ->
  require('load-grunt-tasks') grunt
  require('time-grunt') grunt
  
  grunt.loadNpmTasks 'grunt-angular-templates'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  
  grunt.initConfig
    
    tac_templates:
      tac_components_tmp:
        files:[
          expand: true
          cwd: 'tac_components'
          src: '**/tmpl/'
          dest: 'temporal'
          ext: '.js'
        ]
        
    tac_images:
      src_dist:
        files:[
          expand: true
          cwd: 'repositories'
          src: '**/src/**/*.{jpeg,jpg,png,svg,bmp,gif}'
          dest: 'repositories'
        ]
    
    tac_options:
      temp_dist:
        files:[
          expand: true
          cwd: 'temporal'
          src: '**/tac.json'
          dest: 'repositories'
        ]
    uglify:
      dist:
        files:[
          expand: true
          cwd: 'repositories'
          src: '**/dist/**/*.js'
          dest: 'repositories'
          ext: '.min.js'
        ]
        
    clean:
      repositories:
        files: [
          dot: true
          src: ['repositories/**/{src,dist,wiki}/']
        ]
      temporal:
        files: [
          dot: true
          src: ['temporal/**/*']
        ]
        
    sass:
      dist:
        options:
          style: 'expanded'
        files:[
          expand: true
          cwd: 'repositories'
          src: '**/dist/*.scss'
          dest: 'repositories'
          ext: '.css'
        ]
      dist_compress:
        options:
          style: 'compressed'
        files:[
          expand: true
          cwd: 'repositories'
          src: '**/dist/*.scss'
          dest: 'repositories'
          ext: '.min.css'
        ]  
        
    copy:
      tac_options:
        files:[
          expand: true
          cwd: 'tac_components'
          src: '**/tac.json'
          dest: 'temporal'
        ]
      sources:
        files:[
          expand: true
          cwd: 'tac_components'
          src: '**/src/**/*'
          dest: 'repositories'
        ]
      wikies:
        files:[
          expand: true
          cwd: 'tac_components'
          src: '**/wiki/**/*'
          dest: 'repositories'
        ]
      readmes:
        files:[
          expand: true
          cwd: 'tac_components'
          src: '**/{readme,README,documentation.es}*{,.md,.MD,.txt}'
          dest: 'repositories'
        ]
      bower:
        files:[
          expand: true
          cwd: 'tac_components'
          src: '**/bower.json'
          dest: 'repositories'
        ]
      styles_tmp:
        files:[
          expand: true
          cwd: 'tac_components'
          src: '**/*.scss'
          dest: 'temporal'
        ]
        
    coffee:
      src_to_temp:
        options:
          sourceMap: false
          sourceRoot: ''
        files: [
          expand: true
          cwd: 'tac_components'
          src: '**/*.coffee'
          dest: 'temporal'
          ext: '.js'
        ]
    
  grunt.registerMultiTask 'tac_templates', 'becomes html files into angular templates', ()->
    task_options = this.options()
    grunt.config.set 'ngtemplates',
      options:
        url: (file, options)->
          file.replace /^[\s\S]*tmpl\//g, ''
    this.files.forEach (file)->
      options_path = file.src + 'options.json'
      if grunt.file.isFile options_path
        options = grunt.file.readJSON options_path
        task = options.module.replace(/\./g, '-') + '-' + options.filename.replace(/\./g, '-')
        grunt.log.writeln 'generated ngtemplates:'+ task
        if grunt.config 'ngtemplates.'+ task
          grunt.fail.warn 'collision found with \'' + options.module + '\' '+
          'and filename \'' + options.filename + '\' templates: \n'
        else  
          dest_path = require('path').parse file.dest
          grunt.config 'ngtemplates.'+ task, 
            options:
              module: options.module
              source: (text)-> text
            src: file.src + '/**/*.html'
            dest: dest_path.dir + '/' + options.filename + dest_path.name
          grunt.task.run 'ngtemplates:'+ task
      else
        grunt.fail.warn 'must provide an \'options.json\' file in: \n' +
        ' ->>> \'' + file.src + '\'\n'
  
  grunt.registerMultiTask 'tac_options', 'concat js and scss files', ()->
    this.files.forEach (file)->
      options = grunt.file.readJSON file.src[0]
      src = require('path').parse file.src[0]
      dest = require('path').parse file.dest
      task = src.dir.replace(/\//g, '-')
      if options.js and options.js.main
        jstask = task + '-js'
        jssources = grunt.file.expand src.dir + '/**/*.js'
        jsmain = src.dir + '/src/' + options.js.main
        main_index = jssources.indexOf jsmain
        if main_index is -1
          grunt.fail.warn 'apparently ' + jsmain + ' does not exist in scripts sources directory'
        else
          jssources.splice(main_index, 1)
        jssources.unshift jsmain
        grunt.config 'concat.'+ jstask,
          src: jssources
          dest: dest.dir + '/dist/' + options.js.main
        grunt.task.run 'concat:'+ jstask
      if options.scss and options.scss.files
        name = options.scss.name or 'styles'
        scsstask = task + '-scss'
        sources = (src.dir + '/src/' + file for file in options.scss.files)
        #grunt.log.writeln sources
        grunt.config 'concat.'+ scsstask,
          src: sources
          dest: dest.dir + '/dist/' + name + '.scss'
        grunt.task.run 'concat:'+ scsstask
          
  grunt.registerMultiTask 'tac_images', 'copy images', ()->
    this.files.forEach (file)->
      srcpath = file.src[0]
      destpath = srcpath.replace('src', 'dist')
      grunt.file.copy srcpath, destpath
        
  grunt.registerTask 'package', (target) ->
    grunt.task.run [
      'clean:repositories'
      'clean:temporal'
      'copy:sources'
      'copy:wikies'
      'copy:readmes'
      'copy:styles_tmp'
      'tac_templates:tac_components_tmp'
      'coffee:src_to_temp'
      'copy:tac_options'
      'tac_options:temp_dist'
      'uglify:dist'
      'sass:dist'
      'sass:dist_compress'
      'tac_images:src_dist'
      'copy:readmes'
      'copy:bower'
    ]
