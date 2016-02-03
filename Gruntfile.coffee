'use strict'

LIVERELOAD_PORT = 35730
lrSnippet = require('connect-livereload')(port: LIVERELOAD_PORT)

# var conf = require('./conf.'+process.env.NODE_ENV);
mountFolder = (connect, dir) ->
  connect.static require('path').resolve(dir)

# # Globbing
# for performance reasons we're only matching one level down:
# 'test/spec/{,*}*.js'
# use this if you want to recursively match all subfolders:
# 'test/spec/**/*.js'
module.exports = (grunt) ->
  require('load-grunt-tasks') grunt
  require('time-grunt') grunt
  # configurable paths
  
  yeomanConfig =
    bower:   'bower_components'
    src:     'src'
    dist:    'dist'
    staging: 'staging'
    tmp:     'tmp'
  do ->
    (maybe_dist = grunt.option('dist')) and 
    (typeof maybe_dist is 'string') and 
    yeomanConfig.dist = maybe_dist
  do ->
    (maybe_tmp = grunt.option('tmp')) and 
    (typeof maybe_tmp is 'string') and 
    yeomanConfig.tmp = maybe_tmp
    
  grunt.loadNpmTasks 'grunt-angular-templates'
  grunt.loadNpmTasks 'grunt-bake'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-html-angular-validate'
  grunt.loadNpmTasks 'grunt-preprocess'
  grunt.loadNpmTasks 'grunt-string-replace'
  
  grunt.initConfig
    yeoman: yeomanConfig
    
    clean:
      staging:
        files: [
          dot: true
          src: ['<%= yeoman.staging %>/**/*','!<%= yeoman.staging %>/bower_components/**']
        ]
      tmp:
        files: [
          dot: true
          src: ['<%= yeoman.tmp %>/**/*']
        ]
        
    #################################################
    #                    styles                     #
    #################################################      
      
    sass:
      src_tmp:
        options:
          style: 'expanded'
        files:[
          expand: true
          cwd: '<%= yeoman.src %>'
          src: '**/*.scss'
          dest: '<%= yeoman.tmp %>'
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
        
    #################################################
    #                     html                      #
    #################################################
    
    preprocess: 
      options:
        inline: true
        context :
          PRODUCTION: 'PRODUCTION'
          STAGGING:   'STAGGING'
          DEVELOP:    'DEVELOP'
          ENV:        'DEVELOP'
      src_tmp_html:
        files:[
          expand: true
          cwd: '<%= yeoman.src %>'
          src: '**/*.{htm,html}'
          dest: '<%= yeoman.tmp %>'
          ext: '.preprocessed.html'
        ]
      tmp_prepared_script:
        files:[
          expand: true
          cwd: '<%= yeoman.tmp %>'
          src: '**/*.prepared.coffee'
          dest: '<%= yeoman.tmp %>'
          ext: '.preprocessed.coffee'
        ]
         
    #################################################
    #                  copy helper                  #
    #################################################  
         
    copy:
      json_src_tmp:
        files:[
          expand: true
          cwd: '<%= yeoman.src %>'
          src: '**/*.json'
          dest: '<%= yeoman.tmp %>'
        ]
        
    #################################################
    #                    scripts                    #
    #################################################  
         
    coffee:
      tmp_preprocessed:
        options:
          bare: true
          sourceMap: false
          sourceRoot: ''
        files: [
          expand: true
          cwd: '<%= yeoman.tmp %>'
          src: '**/*.preprocessed.coffee'
          dest: '<%= yeoman.tmp %>'
          ext: '.js'
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
        
    #################################################
    #                    polymer                    #
    #################################################  
             
    components_prepare:
      src_tmp:
        options:
          script_name: 'script.coffee'
        files:[
          expand: true
          cwd: '<%= yeoman.src %>'
          src: '**/component.json'
          dest: '<%= yeoman.tmp %>/'
          ext: '.js'
        ]
        
    components_build:
      tmp_staging:
        options:
          key: 'value'
        files:[
          expand: true
          cwd: '<%= yeoman.tmp %>'
          src: '**/*.preprocessed.html'
          dest: '<%= yeoman.staging %>/'
          ext: '.js'
        ]
        
  grunt.registerMultiTask 'components_prepare', 'process json files', (target)->
    task_options = this.options()
    script_name = task_options.script_name or 'script.js'
    this.files.forEach (file)->
      json_path = require('path').parse file.src[0]
      component = grunt.file.readJSON file.src[0]
      script_path = json_path.dir + '/' + script_name
      script_content = grunt.file.read script_path
      grunt.log.writeflags component
      grunt.log.write script_content
      
  grunt.registerMultiTask 'components_build', 'becomes files into polymer components', ()->
    task_options = this.options()
    mkimport = (src)->"<link rel=\"import\" href=\"#{src}\">"
    this.files.forEach (file)->
      html = grunt.file.read file.src
      out_name = require('path').parse file.src[0]
      grunt.log.write(mkimport('index.html'))
      grunt.log.writeflags out_name
      
  grunt.registerTask 'server', (target) ->
    grunt.task.run [
      'clean:staging'
      'clean:tmp'
      'components_prepare:src_tmp'
      #'copy:json_src_tmp'
      #'preprocess:src_tmp_html'
      #'preprocess:tmp_prepare_script'
      #'coffee:tmp_preprocessed'
      #'sass:src_tmp'
      #'components_build:tmp_staging'
    ]
