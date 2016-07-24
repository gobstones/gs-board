Polymer
  is: '#GRUNT_COMPONENT_NAME'

  properties:
    color: String
    amount:
      type: Number
      value: 0
      notify: true
      observer: '_sanitizeAmount'
    options: Object

  listeners:
    tap: '_processTap'
    contextmenu: '_rightClick'

  ready: ->
    @_sanitizeAmount()
    throw new Error("Options for the stone are required") if not @options?

  cssClass: ->
    if @options.editable then "pointer"
    else ""

  _sanitizeAmount: ->
    unless typeof @amount is 'number' and @amount >= 0
      @amount = 0

  _processTap: (event) ->
    return if not @options.editable
    @amount += 1

  _rightClick: (event) ->
    return if not @options.editable
    event.preventDefault()
    @amount -= 1
