Polymer
  is: '#GRUNT_COMPONENT_NAME'

  properties:
    color:
      type: String
      value: 'unknown'
    amount:
      type: Number
      value: 0
      notify: true
      observer: '_sanitizeAmount'

  listeners:
    tap: '_processTap'
    contextmenu: '_rightClick'

  ready: ->
    @_sanitizeAmount()

  _sanitizeAmount: ->
    unless typeof @amount is 'number' and @amount >= 0
      @amount = 0

  _processTap: (event)->
    @amount += 1

  _rightClick: (event)->
    event.preventDefault()
    @amount -= 1
