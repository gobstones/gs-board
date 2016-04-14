'use strict'

version = '1.0.0'

LIVERELOAD_PORT = 35730
lrSnippet = require('connect-livereload')(port: LIVERELOAD_PORT)
exec = require('child_process').execSync;

# var conf = require('./conf.'+process.env.NODE_ENV);
mountFolder = (connect, dir) ->
  connect.static require('path').resolve(dir)

app_name = require('./bower.json').name

# # Globbing
# for performance reasons we're only matching one level down:
# 'test/spec/{,*}*.js'
# use this if you want to recursively match all subfolders:
# 'test/spec/**/*.js'
module.exports = (grunt) ->
  
  unless app_name
    throw new TypeError('must specify an application name in bower.json file')
    
  grunt.log.write 'application name: ' + app_name + '\n'
    
  require('load-grunt-tasks') grunt
  require('time-grunt') grunt
  # configurable paths
  
  yeomanConfig =
    bower:   'bower_components'
    src:     'src'
    dist:    'dist'
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
  grunt.loadNpmTasks 'grunt-contrib-htmlmin'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-html-angular-validate'
  grunt.loadNpmTasks 'grunt-preprocess'
  grunt.loadNpmTasks 'grunt-string-replace'
  
  grunt.initConfig
    yeoman: yeomanConfig
    
    #################################################
    #                  livereload                   #
    #################################################
    # watch: cada vez que un archivo cambia 
    # dentro de 'files' se ejecutan las correspodientes 'tasks'
    watch:

      coffee_components:
        files: ['<%= yeoman.src %>/components/**/*.coffee']
        tasks: ['scripts:components','components_build:tmp_dist_server']
      coffee_demo:
        files: ['<%= yeoman.src %>/demo/**/*.coffee']
        tasks: ['scripts:demo']
      sass_common_and_components:
        files: ['<%= yeoman.src %>/{components,common}/**/*.scss']
        tasks: ['sass:src_tmp_server','components_build:tmp_dist_server']
      sass_demo:
        files: ['<%= yeoman.src %>/demo/**/*.scss']
        tasks: ['sass:demo']
      html_components:
        files: ['<%= yeoman.src %>/components/**/*.html']
        tasks: ['html:components','components_build:tmp_dist_server']
      html_demo:
        files: ['<%= yeoman.src %>/demo/**/*.html']
        tasks: ['html:demo']
      json_components:
        files: ['<%= yeoman.src %>/components/**/*.json']
        tasks: ['copy:json_src_tmp','scripts:components','components_build:tmp_dist_server']
      resources_src_dist:
        files: ['<%= yeoman.src %>/**/*.{jpg,jpeg,gif,svg,png,ttf}', '!<%= yeoman.src %>/demo/**/*']
        tasks: ['copy:resources_src_dist']
      resources_src_demo:
        files: ['<%= yeoman.src %>/demo/**/*.{jpg,jpeg,gif,svg,png,ttf}']
        tasks: ['copy:resources_src_demo']
      
      # watch.livereload: files which demand the page reload
      livereload:
        options:
          livereload: LIVERELOAD_PORT
        files: [
          '<%= yeoman.dist %>/**/*'
          'demo/**/*'
        ]
    
    connect:
      options:
        port: 9002
        # default 'localhost'
        # Change this to '0.0.0.0' to access the server from outside.
        hostname: "localhost"
      livereload:
        options:
          middleware: (connect) ->
            [lrSnippet, mountFolder(connect, '.')]

    open:
      server:
        url: 'http://<%= connect.options.hostname %>:<%= connect.options.port %>/bower_components/' + app_name + '/demo'
        
    clean:
      dist:
        files: [
          dot: true
          src: ['<%= yeoman.dist %>/**/*','!<%= yeoman.dist %>/bower_components/**']
        ]
      tmp:
        files: [
          dot: true
          src: ['<%= yeoman.tmp %>/**/*']
        ]
      dist_demo:
        files: [
          dot: true
          src: ['demo/**/*']
        ]
        
    #################################################
    #                    styles                     #
    #################################################      
      
    sass:
      src_tmp_server:
        options:
          style: 'expanded'
        files: [
          expand: true
          cwd: '<%= yeoman.src %>'
          src: '**/*.scss'
          dest: '<%= yeoman.tmp %>'
          ext: '.normal.css'
        ]
      src_tmp_compress:
        options:
          style: 'compressed'
        files: [
          expand: true
          cwd: '<%= yeoman.src %>/components'
          src: '**/*.scss'
          dest: '<%= yeoman.tmp %>/components'
          ext: '.min.css'
        ]
      demo:
        options:
          style: 'expanded'
        files: [
          expand: true
          cwd: '<%= yeoman.src %>/demo'
          src: '**/*.scss'
          dest: 'demo'
          ext: '.css'
        ]
        
    #################################################
    #                     html                      #
    #################################################
    
    preprocess:
      options:
        inline: true
      src_tmp_html:
        files: [
          expand: true
          cwd: '<%= yeoman.src %>'
          src: ['**/*.{htm,html}','!demo/**/*']
          dest: '<%= yeoman.tmp %>'
          ext: '.normal.html'
        ]
      tmp_prepared_script:
        files: [
          expand: true
          cwd: '<%= yeoman.tmp %>'
          src: ['**/*.coffee','!demo/**/*']
          dest: '<%= yeoman.tmp %>'
          ext: '.preprocessed.coffee'
        ]
      src_demo_html:
        options: 
          context: 
            MODE: 'NORMAL'
        files: [
          expand: true
          cwd:  '<%= yeoman.src %>/demo'
          src:  '**/*.{htm,html}'
          dest: 'demo'
          ext:  '.html'
        ]
      src_demo_html_min:
        options: 
          context: 
            MODE: 'COMPRESS'
        files: [
          expand: true
          cwd:  '<%= yeoman.src %>/demo'
          src:  '**/*.{htm,html}'
          dest: 'demo'
          ext:  '.min.html'
        ]
      src_demo_tmp_script:
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
      resources_src_demo:
        files: [
          expand: true
          cwd: '<%= yeoman.src %>/demo'
          src: '**/*.{jpg,jpeg,gif,svg,png,ttf}'
          dest: 'demo'
        ]
      resources_src_dist:
        files: [
          expand: true
          cwd: '<%= yeoman.src %>', 
          src: ['**/*.{jpg,jpeg,gif,svg,png,ttf}', '!./demo/**/*']
          dest: '<%= yeoman.dist %>'
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
          ext: '.normal.js'
        ]
      tmp_preprocessed_demo:
        options:
          sourceMap: false
          sourceRoot: ''
        files: [
          expand: true
          cwd: '<%= yeoman.tmp %>/demo'
          src: '**/*.preprocessed.coffee'
          dest: 'demo'
          ext: '.js'
        ]

    uglify:
      scripts_tmp:
        files: [
          expand: true
          cwd: '<%= yeoman.tmp %>/components'
          src: '**/*.normal.js'
          dest:'<%= yeoman.tmp %>/components'
          ext: '.min.js'
        ]
    htmlmin:
      components_temp: 
        options: 
          removeComments: true,
          collapseWhitespace: true
        files: [
          expand: true
          cwd: '<%= yeoman.tmp %>/components'
          src: '**/*.normal.html'
          dest:'<%= yeoman.tmp %>/components'
          ext: '.min.html'
        ]

    #################################################
    #                    polymer                    #
    #################################################  
             
    components_prepare:
      src_tmp:
        files: [
          expand: true
          cwd: '<%= yeoman.src %>'
          src: '**/**.{comp,cmpt}.json'
          dest: '<%= yeoman.tmp %>/'
        ]

    components_build:
      tmp_dist_server:
        options:
          prefix: '.normal'
        files: [
          expand: true
          cwd: '<%= yeoman.tmp %>'
          src: '**/**.{comp,cmpt}.json'
          dest: '<%= yeoman.dist %>/'
        ]
      tmp_dist_compress:
        options:
          compress: true
          prefix: '.min'
          ext:    '.min.html'
        files: [
          expand: true
          cwd: '<%= yeoman.tmp %>'
          src: '**/**.{comp,cmpt}.json'
          dest: '<%= yeoman.dist %>/'
        ]

  grunt.registerMultiTask 'components_prepare', 'process json files', (target)->
    GRUNT_COMPONENT_NAME = '#GRUNT_COMPONENT_NAME'
    this.files.forEach (file)->
      json_src = require('path').parse file.src[0]
      json_dst = require('path').parse file.dest
      component = grunt.file.readJSON file.src[0]
      component.name = /[^\/]*$/.exec(json_src.dir)[0]
      unless /\-/.test component.name
        throw new do ->
          error = () ->
            this.name = 'BadName'
            this.message = "Cannot register a component without hyphen '-' in its name"
          error.prototype = Error.prototype
          error
      grunt.log.writeln component.name
      scripts = grunt.file.expand(cwd: json_src.dir, '*.coffee')
      for script_name in scripts
        script_src  = "#{json_src.dir}/#{script_name}"
        script_dest = "#{json_dst.dir}/#{script_name}"
        script_content = grunt.file.read script_src
        fixed_content = script_content.replace GRUNT_COMPONENT_NAME, component.name
        grunt.file.write script_dest, fixed_content
      grunt.file.write file.dest, JSON.stringify(component, null, 2)
      
  grunt.registerMultiTask 'components_build', 'becomes files into polymer components', ()->
    task_options = this.options()
    prefix       = task_options.prefix or ''
    ext          = task_options.ext or '.html'
    compress     = task_options.compress
    new_line_re  = /\n(?=[^\n$])/g
    
    if compress
      new_line = indent = ''
      mesh = (text, amount)-> text
    else
      new_line     = '\n'
      indent       = '  '
      mesh = (text, amount)->
        local_indent = mkindent(amount)
        local_indent + text.replace(new_line_re, new_line + local_indent)
      
    mkimport = (src)->"<link rel=\"import\" href=\"#{src}\">"
    mkscript = (src)->"<script type=\"text/javascript\" src=\"#{src}\"></script>"
    mkstyle = (src)->"<link rel=\"stylesheet\" type=\"text/css\" href=\"#{src}\">"
    mktag = (name, content, indent)->
      indent = indent or 0
      open_tag = '<'+name+'>'
      close_tag = '</'+name+'>'
      mesh(open_tag, indent) + new_line + 
      mesh(content, indent+1) + 
      mesh(close_tag, indent) + new_line
      
    mkindent = (amount)->
      amount = if amount > 0 then amount else 0
      space  = ''
      while amount--
        space += indent
      space
    mktags = (maker, sources, indent)->
      tags = ''
      sources = sources or []
      for source in sources
        tags += mkindent(indent) + maker(source) + new_line
      tags
    this.files.forEach (file)->
      json_src = require('path').parse file.src[0]
      json_dst = require('path').parse file.dest
      component = grunt.file.readJSON file.src[0]
      content = ''
      #create import tags
      content += mktags mkimport, component.imports, 0
      content += mktags mkimport, component["imports#{prefix}"], 0
      #create external script tags
      content += mktags mkscript, component.scripts, 1
      #initialize module
      content += "<dom-module id=\"#{component.name}\">" + new_line
      #initialize template
      content += indent + "<template>" + new_line
      #create external style tags
      content += mktags mkstyle, component.styles, 2
      #embed local style tags
      styles = grunt.file.expand(cwd: json_src.dir, "*#{prefix}.css")
      for style_name in styles
        style_src  = "#{json_src.dir}/#{style_name}"
        style_content = grunt.file.read style_src
        if compress then style_content = style_content.trim()
        content += mktag 'style', style_content, 2
      #embed unique template content
      html = grunt.file.expand(cwd: json_src.dir, "*#{prefix}.html")
      #throw error if detect multiple html files
      if html.length > 1
        throw new do ->
          error = () ->
            this.name = 'NotUniqueTemplate'
            this.message = "Cannot declare multiple templates for unique component"
          error.prototype = Error.prototype
          error
      if html.length is 1
        html_src  = "#{json_src.dir}/#{html[0]}"
        html_content = grunt.file.read html_src
        content += mesh(html_content, 2) + new_line
      #close template
      content += indent + "</template>" + new_line
      #embed local script tags
      scripts = grunt.file.expand(cwd: json_src.dir, "*#{prefix}.js")
      for script_name in scripts
        script_src  = "#{json_src.dir}/#{script_name}"
        script_content = grunt.file.read script_src
        script_tag = mktag 'script', script_content, 1
        content += script_tag
      #close module
      content += "</dom-module>"
      #replace last directory name by file
      reg_exp = new RegExp(component.name + '\/?$')
      file_dest = json_dst.dir.replace(reg_exp, '') + component.name + ext
      grunt.log.write 'generate file: ' + file_dest + '\n'
      grunt.file.write file_dest, content
      
  
  grunt.registerTask 'symlinks', (target) ->
    cwd = 'bower_components/' + app_name
    commands = [
      'rm -rf ' + cwd
      'mkdir -p ' + cwd
      'ln -s ../../demo ' + cwd + '/demo'
      'ln -s ../../dist ' + cwd + '/dist'
    ]
    for command in commands
      grunt.log.write command + '\n'
      exec command, cdw: __dirname
      
  grunt.registerTask 'scripts', (target) ->
    switch target
      when 'components'
        grunt.task.run [
          'components_prepare:src_tmp'
          'preprocess:tmp_prepared_script'
          'coffee:tmp_preprocessed'
        ]
      when 'demo'
        grunt.task.run [
          'preprocess:src_demo_tmp_script'
          'coffee:tmp_preprocessed_demo'
        ]
        
  grunt.registerTask 'html', (target) ->
    switch target
      when 'components'
        grunt.task.run [
          'preprocess:src_tmp_html'
        ]
      when 'demo'
        grunt.task.run [
          'preprocess:src_demo_html'
        ]
    
  grunt.registerTask 'demo', (target) ->
    grunt.task.run [
      'clean:dist_demo'
      'html:demo'
      'scripts:demo'
      'sass:demo'
      'copy:resources_src_demo'
    ]
    
  grunt.registerTask 'server', (target) ->
    grunt.task.run [
      'clean:dist'
      'clean:tmp'
      'preprocess:src_tmp_html'
      'scripts:components'
      'sass:src_tmp_server'
      'components_build:tmp_dist_server'
      'copy:resources_src_dist'
      'demo'
      'symlinks'
      'connect:livereload'
      'open'
      'watch'
    ]
    
  grunt.registerTask 'build', (target) ->
    grunt.task.run [
      'clean:dist'
      'clean:tmp'
      'preprocess:src_tmp_html'
      'scripts:components'
      'uglify:scripts_tmp'
      'sass:src_tmp_server'
      'sass:src_tmp_compress'
      'htmlmin:components_temp'
      'components_build:tmp_dist_server'
      'components_build:tmp_dist_compress'
      'copy:resources_src_dist'
      'demo'
      'preprocess:src_demo_html_min'
    ]
