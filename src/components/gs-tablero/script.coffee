Polymer
  is: '#GRUNT_COMPONENT_NAME'
  
  properties:
    board:
      type: Array
      observer: '_reverse'
    rows:
      type: Array
      observer: '_update'
    columnAmount:
      type: Number
    lastIndex:
      type: Number
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
    pos = x:-window.scrollX,y:-window.scrollY
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
    pointer_to_center_y = viewport_center_y - viewport_to_pointer_y 
    
    next_pointer_to_center_x = pointer_to_center_x * delta_zoom
    next_pointer_to_center_y = pointer_to_center_y * delta_zoom
    
    next_center_x = pointer_x + next_pointer_to_center_x
    next_center_y = pointer_y + next_pointer_to_center_y
    
    @positionX = next_center_x - (viewport_w * @zoom / (100*2))
    @positionY = next_center_y - (viewport_h * @zoom / (100*2))
    
    @_render()
    
  normalize_delta: (evnt)->
    spin_y = 0
    if 'wheelDelta' of evnt
      spin_y = -evnt.wheelDelta / 120
    else if 'wheelDeltaY' of evnt
      spin_y = -evnt.wheelDeltaY / 120
    else if 'detail' of evnt
      spin_y = evnt.detail / 3
    spin_y
    
  _make_zoom: (evnt)->
    evnt.preventDefault()
    MAX_ZOOM = 400
    MIN_ZOOM = 35
    ZOOM_DELTA = 1.2
    initial_zoom = @zoom
    delta = @normalize_delta evnt
    if delta < 0
      @zoom *= -delta * ZOOM_DELTA
      if @zoom > MAX_ZOOM then @zoom = MAX_ZOOM
    else if delta > 0
      @zoom /= (delta * ZOOM_DELTA)
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
    @set 'rows', rows

  attached:->
    @has_been_attached = true
    @zoom = 100
    @_render()

  _update: ->
    @columnAmount = 0
    for row in @rows
      if row.length > @columnAmount
        @columnAmount = row.length
    @lastIndex = @rows.length - 1
    @_sanitize_rows()
    @_render()

  _render:->
    if @has_been_attached
      zoom = @zoom / 100
      if !!window.chrome and !!window.chrome.webstore
        #cero divided support
        movex = @positionX / zoom
        movey = @positionY / zoom
        @viewport.style.transform = "translate3d(#{movex}px,#{movey}px,0)"
        @viewport.style.zoom = zoom
      else
        #scale fix strategy
        viewport_h = @viewport.clientHeight
        viewport_w = @viewport.clientWidth
        fix_x = (viewport_w - (viewport_w * zoom)) / 2
        fix_y = (viewport_h - (viewport_h * zoom)) / 2
        #cero divided support
        movex = (@positionX - fix_x) / zoom
        movey = (@positionY - fix_y) / zoom
        @viewport.style.transform = "scale(#{zoom}) translate3d(#{movex}px,#{movey}px,0)"
      
      @ruleTop.style.marginLeft = @ruleBottom.style.marginLeft = @positionX + 'px'
      @ruleLeft.style.marginTop = @ruleRight.style.marginTop = @positionY + 'px'

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
    




