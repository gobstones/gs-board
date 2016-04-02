Polymer
  is: '#GRUNT_COMPONENT_NAME'
  
  properties:
    
    board:
      type: Array
      observer: '_reverse'
      
    rows:
      type: Array
      observer: '_update'
      
    columnsAmount:
      type: String
      value: 0
      
    editable:
      type: Object
      value: false
    
    panelHeight:
      type: Number
      observer: '_panel_height_change'
      
    positionX:
        type: Number
        value: 0
    positionY:
        type: Number
        value: 0
    zoom:
        type: Number
        value: 100
        
  _generate_empty_row: ->
    {} for _ in [0...8]
    
  _generate_empty_rows: ->
    @_generate_empty_row() for _ in [0...8]
    
  get_screen_pos:->
    pos = x:0,y:0
    current = @screen
    while current
      pos.x += current.offsetLeft
      pos.y += current.offsetTop
      current = current.offsetParent
    pos
    
  _make_zoom_aux:(evnt, initial_zoom)->
    viewport_w = @viewport.clientWidth
    viewport_h = @viewport.clientHeight
    screen_pos = @get_screen_pos()
    pointer_x = evnt.clientX - screen_pos.x
    pointer_y = evnt.clientY - screen_pos.y
    
    delta_zoom = @zoom / initial_zoom
    viewport_center_x = (viewport_w * initial_zoom / (2 * 100))
    viewport_center_y = (viewport_h * initial_zoom / (2 * 100))
    viewport_to_pointer_x = pointer_x - @positionX
    viewport_to_pointer_y = pointer_y - @positionY
    
    pointer_to_center_x = viewport_center_x - viewport_to_pointer_x
    pointer_to_center_y = viewport_center_x - viewport_to_pointer_y 
    
    next_pointer_to_center_x = pointer_to_center_x * delta_zoom
    next_pointer_to_center_y = pointer_to_center_y * delta_zoom
    
    next_center_x = pointer_x + next_pointer_to_center_x
    next_center_y = pointer_y + next_pointer_to_center_y
    
    @positionX = next_center_x - (viewport_w * @zoom / (100*2))
    @positionY = next_center_y - (viewport_h * @zoom / (100*2))
    
    @_render()
    
  _make_zoom: (evnt)->
    MAX_ZOOM = 400
    MIN_ZOOM = 30
    initial_zoom = @zoom
    delta = (evnt.wheelDelta or evnt.detail) / 100
    if delta > 0
      @zoom *= delta
      if @zoom > MAX_ZOOM then @zoom = MAX_ZOOM
    else if delta < 0
      @zoom /= -delta
      if @zoom < MIN_ZOOM then @zoom = MIN_ZOOM
    if initial_zoom isnt @zoom
      @_make_zoom_aux evnt, initial_zoom
      
      
      
      
    
  bind_mouse:->
    for key in ['mousewheel','DOMMouseScroll','onmousewheel']
      @listen @, key, '_make_zoom'
    @listen @screen, 'mousedown', '_begin_move'
    
  ready: ->
    @board = @board or @_generate_empty_rows()
    @viewport = @$.viewport
    @screen = @$.screen
    @ruleLeft = @$.ruleLeft
    @ruleRight = @$.ruleRight
    @ruleTop = @$.ruleTop
    @ruleBottom = @$.ruleBottom
    @bind_mouse()
    @_reverse()

  _sanitize_rows: ->
    #TODO assert rows structure

  _reverse:->
    @board = @board or []
    rows = @board.slice().reverse()
    last = rows.length - 1
    for item in rows
      item.reverseIndex = last--
    #trigger efects over @rows
    @rows = rows

  attached:->
    @has_been_attached = true
    @zoom = 100
    @_render()

  _update: ->
    @columnsAmount = 0
    for row in @rows
      if row.length > @columnsAmount
        @columnsAmount = row.length
    @_sanitize_rows()
    @_render()

  _render:->
    if @has_been_attached
      zoom = @zoom / 100
      console.log @zoom
      console.log @positionX
      console.log @positionY
      viewport_h = @viewport.clientHeight
      viewport_w = @viewport.clientWidth
      
      
      ### scale fix strategy
      fix_x = (viewport_w - (viewport_w * zoom)) / 2
      fix_y = (viewport_h - (viewport_h * zoom)) / 2
      #cero divided support
      movex = (@positionX - fix_x) / zoom
      movey = (@positionY - fix_y) / zoom
      ###
      
      #cero divided support
      movex = @positionX / zoom
      movey = @positionY / zoom
      
      @viewport.style.transform = "translate3d(#{movex}px,#{movey}px,0)"
      @viewport.style.zoom = zoom
      
      @ruleTop.style.marginLeft = @ruleBottom.style.marginLeft = @positionX + 'px'
      @ruleLeft.style.marginTop = @ruleRight.style.marginTop = @positionY + 'px'
      

  _auto_resize: ->

  _auto_resize2: ->
    
    h_fix = screen_h / viewport_h
    w_fix = screen_w / viewport_w
    if w_fix > h_fix 
      zoom = h_fix 
    else 
      zoom = w_fix
    
  _begin_move:(evnt)->
    unless evnt.which is 1 then return 
    evnt.cancelBubble = true
    evnt.preventDefault()
    context = item:@
    mousemove = (evnt) => 
      evnt.cancelBubble = true
      evnt.preventDefault()
      @make_move context, evnt
    mouseup = (evnt) =>
      unless evnt.which is 1 then return 
      evnt.cancelBubble = true
      evnt.preventDefault()
      @finish_move context, evnt
      window.removeEventListener("mousemove", mousemove)
      window.removeEventListener("mouseup", mouseup)
    window.addEventListener("mouseup", mouseup)
    window.addEventListener("mousemove", mousemove)
    @init_move context, evnt
    
  init_move:(context, evnt)->
    context.initial_x = @positionX
    context.initial_y = @positionY
    context.initial_mouse_x = evnt.clientX
    context.initial_mouse_y = evnt.clientY
    
  make_move:(context, evnt)->
    @positionX = context.initial_x + evnt.clientX - context.initial_mouse_x
    @positionY = context.initial_y + evnt.clientY - context.initial_mouse_y
    @_render()
    
  finish_move:(context, evnt)->
    

  _panel_height_change:->
    @_auto_resize()




