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
      dist_demo:
        files: [
          dot: true
          src: ['<%= yeoman.dist %>/demo/**/*']
        ]
        
    #################################################
    #                    styles                     #
    #################################################      
      
    sass:
      src_tmp:
        options:
          style: 'expanded'
        files: [
          expand: true
          cwd: '<%= yeoman.src %>'
          src: '**/*.scss'
          dest: '<%= yeoman.tmp %>'
          ext: '.css'
        ]
      dist_compress:
        options:
          style: 'compressed'
        files: [
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
        context:
          PRODUCTION: 'PRODUCTION'
          STAGGING:   'STAGGING'
          DEVELOP:    'DEVELOP'
          ENV:        'DEVELOP'
      src_tmp_html:
        files: [
          expand: true
          cwd: '<%= yeoman.src %>'
          src: ['**/*.{htm,html}','!demo/**']
          dest: '<%= yeoman.tmp %>'
          ext: '.html'
        ]
      tmp_script:
        files: [
          expand: true
          cwd: '<%= yeoman.tmp %>'
          src: ['**/*.coffee','!demo/**']
          dest: '<%= yeoman.tmp %>'
          ext: '.preprocessed.coffee'
        ]
      src_dist_html_demo:
        files: [
          expand: true
          cwd: '<%= yeoman.src %>/demo'
          src: '**/*.{htm,html}'
          dest: '<%= yeoman.dist %>/demo'
          ext: '.html'
        ]
      src_tmp_script_demo:
        files: [
          expand: true
          cwd: '<%= yeoman.src %>/demo'
          src: '**/*.coffee'
          dest: '<%= yeoman.tmp %>/demo'
          ext: '.preprocessed.coffee'
        ]

    #################################################
    #                  copy helper                  #
    #################################################  

    copy:
      json_src_tmp:
        files: [
          expand: true
          cwd: '<%= yeoman.src %>'
          src: '**/*.json'
          dest: '<%= yeoman.tmp %>'
        ]
      demo_src_staging:
        files: [
          expand: true
          cwd: '<%= yeoman.src %>/demo'
          src: '**/*'
          dest: '<%= yeoman.staging %>/demo'
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
          src: ['**/*.preprocessed.coffee','!demo/**']
          dest: '<%= yeoman.tmp %>'
          ext: '.js'
        ]
      tmp_src_preprocessed_demo:
        options:
          sourceMap: false
          sourceRoot: ''
        files: [
          expand: true
          cwd: '<%= yeoman.tmp %>/demo'
          src: '**/*.preprocessed.coffee'
          dest: '<%= yeoman.dist %>/demo'
          ext: '.js'
        ]
        
    uglify:
      dist:
        files: [
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
        files: [
          expand: true
          cwd: '<%= yeoman.src %>'
          src: '**/component.json'
          dest: '<%= yeoman.tmp %>/'
          ext: '.js'
        ]
        
    components_build:
      tmp_staging:
        options:
          html: 'template.html'
          script: 'script.js'
          style: 'style.css'
        files: [
          expand: true
          cwd: '<%= yeoman.tmp %>'
          src: '**/component.json'
          dest: '<%= yeoman.staging %>/'
        ]
        
  grunt.registerMultiTask 'components_prepare', 'process json files', (target)->
    GRUNT_COMPONENT_NAME = '#GRUNT_COMPONENT_NAME'
    task_options = this.options()
    script_name = task_options.script_name or 'script.js'
    this.files.forEach (file)->
      json_src = require('path').parse file.src[0]
      json_dst = require('path').parse file.dest
      component = grunt.file.readJSON file.src[0]
      script_path = "#{json_src.dir}/#{script_name}"
      script_content = grunt.file.read script_path
      fixed_content = script_content.replace GRUNT_COMPONENT_NAME, component.name
      script_path_dest = "#{json_dst.dir}/#{script_name}"
      grunt.file.write script_path_dest, fixed_content

  grunt.registerMultiTask 'components_build', 'becomes files into polymer components', ()->
    task_options = this.options()
    new_line= '\n'
    new_line_re= /\n(?=[^\n$])/g
    indent= '  '
    
    mkindent = (text, amount)->
      amount = if amount > 0 then amount else 0
      space = ''
      while amount--
        space += indent
      space + text.replace(new_line_re, new_line + space)
    if task_options.compress
      new_line = indent = ''
      mkindent = (text, amount)-> text
    mkimport = (src)->"<link rel=\"import\" href=\"#{src}\">"
    mktag = (name, content)->
      mkindent('<'+name+'>', 1)+ 
      new_line + 
      mkindent(content, 2) + 
      new_line + 
      mkindent('</'+name+'>', 1)+ 
      new_line
    this.files.forEach (file)->
      json_src = require('path').parse file.src[0]
      json_dst = require('path').parse file.dest
      component = grunt.file.readJSON file.src[0]
      
      content = ''
      for external_component in component.imports
        content += mkimport(external_component) + new_line
        
      content += "<dom-module id=\"#{component.name}\">" + new_line
      
      style_path = "#{json_src.dir}/#{task_options.style}"
      style_content = grunt.file.read style_path
      content += mktag 'style', style_content
      
      html_path = "#{json_src.dir}/#{task_options.html}"
      html_content = grunt.file.read html_path
      content += mktag 'template', html_content
      
      script_path = "#{json_src.dir}/#{task_options.script}"
      script_content = grunt.file.read script_path
      content += mktag 'script', script_content
      
      content += "</dom-module>"
      grunt.log.write content
      
      reg_exp = new RegExp(component.name + '\/?$')
      if reg_exp.test json_dst.dir
        grunt.log.write 'replacing directory by file' + json_src.dir + '\n'
        file_dest = json_dst.dir.replace(reg_exp, '') + component.name + '.html'
      else
        grunt.log.write 'creating file into directory' + json_src.dir + '\n'
        file_dest = json_dst.dir + '/' + component.name + '.html'
        
      grunt.log.write 'file: ' + file_dest + '\n'
      
      grunt.file.write file_dest, content
      
      #grunt.log.write reg_exp  + '\n'
      #grunt.log.writeflags json_src
      #grunt.log.write json_src.dir + ' is equal ' + component.name + '\n'
      #mkimport('index.html')
      
  grunt.registerTask 'demo', (target) ->
    grunt.task.run [
      'clean:dist_demo'
      'preprocess:src_dist_html_demo'
      'preprocess:src_tmp_script_demo'
      'coffee:tmp_src_preprocessed_demo'
    ]
  grunt.registerTask 'server', (target) ->
    grunt.task.run [
      'clean:staging'
      'clean:tmp'
      'components_prepare:src_tmp'
      'copy:json_src_tmp'
      'preprocess:src_tmp_html'
      'preprocess:tmp_script'
      'coffee:tmp_preprocessed'
      'sass:src_tmp'
      'components_build:tmp_staging'
      'demo'
    ]
