
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
      
  listeners:
    tap: '_process_tap'
    contextmenu: '_right_click'
    
  ready: ->
    @_sanitize_amount()
        
  _sanitize_amount: ->
    unless typeof @amount is 'number' and @amount >= 0 
      @amount = 0
    
  _process_tap: (evnt)->
    @amount += 1

  _right_click: (evnt)->
    evnt.preventDefault()
    @amount -= 1
