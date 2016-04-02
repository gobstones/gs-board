
Polymer
  is: '#GRUNT_COMPONENT_NAME'

  properties:
    color:
      type: String
      value: 'unknow'
    amount:
      type: Number
      value: 0
      notify: true
      observer: '_sanitize_amount'
    editable:
      type: Object
      observer: '_editable_change'
      
  ready: ->
    @_sanitize_amount()
    
  attached:->
    @editable and @_editable_change(true)
    
  detached:->
    @editable and @_editable_change(false)
    
  _editable_change:(value)->
    if value
      @listen @, 'tap',         '_process_tap'
      @listen @, 'contextmenu', '_right_click'
    else
      @unlisten @, 'tap',         '_process_tap'
      @unlisten @, 'contextmenu', '_right_click'

  _sanitize_amount: ->
    unless typeof @amount is 'number' and @amount >= 0 
      @amount = 0
    
  _process_tap: (evnt)->
    @editable and @amount += 1

  _right_click: (evnt)->
    if @editable
      evnt.preventDefault()
      @amount -= 1
