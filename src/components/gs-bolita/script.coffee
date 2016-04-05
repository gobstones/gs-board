
Polymer
  is: '#GRUNT_COMPONENT_NAME'

  properties:
    color:
      type: String
      value: 'unknow'
    amountView:
      type: String
      value: ''
      observer: '_amount_view_change'
    amount:
      type: Number
      value: 0
      notify: true
      observer: '_amount_change'
    cell:
      type: Object
      observer: '_update_amount'
    twoDigits:
      type: Object
      observer: '_two_digits_change'
    editable:
      type: Object
      observer: '_editable_change'
    ballTitle:
      type:String
      value: 'NaN:NaN'
    rowIndex:
      type: Number
      value: 0
      observer: '_update_title'
    columnIndex:
      type: Number
      value: 0
      observer: '_update_title'
      
    observers:[
      '_update_amount(cell.*)'
    ]

  ready: ->
    @_update_amount()
    @_addObserverEffect()
    
  attached:->
    @editable and @_editable_change(true)
    @_update_title()
    @process_two_digits()
  
  _update_amount:->
    @amount = @cell[@color]
  
  detached:->
    @editable and @_editable_change(false)
    
  _editable_change:(value)->
    if value
      @listen @, 'mousedown',   '_mousedown'
      @listen @, 'contextmenu', '_prevent_default'
    else
      @unlisten @, 'mousedown',   '_mousedown'
      @unlisten @, 'contextmenu', '_prevent_default'

  _amount_change: ->
    unless typeof @amount is 'number' and @amount >= 0 
      @amount = 0
    @cell and @cell[@color] = @amount
    @amountView = if @amount > 99 then '+' else @amount
    @_update_title()
    
  _two_digits_change:->
    if @twoDigits
      @classList.add 'two-digits'
    else
      @classList.remove 'two-digits'
    
  process_two_digits:->
    if @amount > 9
      @twoDigits = true
      
  _amount_view_change:->
    if @amount > 9
      @twoDigits = true
    if @amount <= 9
      @twoDigits = false
      
    
  _update_title: ()->
    @ballTitle = '[' + @rowIndex + ':' + @columnIndex + '] - ' + @color + '[' + @amount + ']'
    
  _prevent_default:(evnt)->
    evnt.preventDefault()
    false
    
  _mousedown: (evnt)->
    if evnt.which is 3 
      evnt.preventDefault()
      @amount -= 1
    else if evnt.which is 1
      context = item:@
      mousemove = (evnt) => 
        @make_move context, evnt
      mouseup = (evnt) =>
        unless evnt.which is 1 then return 
        @finish_move context, evnt
        window.removeEventListener("mousemove", mousemove)
        window.removeEventListener("mouseup", mouseup)
      window.addEventListener("mouseup", mouseup)
      window.addEventListener("mousemove", mousemove)

  init_move:(context, evnt)->
    context.initial_mouse_x = evnt.clientX
    context.initial_mouse_y = evnt.clientY
    
  make_move:(context, evnt)->
    context.move = true
    
  finish_move:(context, evnt)->
    unless context.move
      @amount += 1
    

