Polymer
  is: '#GRUNT_COMPONENT_NAME'

  properties:
    color: String
    amount:
      type: Number
      value: 0
      notify: true
      observer: "_sanitizeAmount"
    options: Object

  listeners:
    click: "_leftClick"
    contextmenu: "_rightClick"

  ready: ->
    @_sanitizeAmount()
    throw new Error("The options are required") if not @options?

  cssClass: ->
    if @options.editable then "pointer"
    else ""

  _sanitizeAmount: ->
    unless typeof @amount is "number" and @amount >= 0
      @amount = 0

  _leftClick: (event) ->
    board = @domHost.domHost
    return if not @options.editable or board.isCtrlPressed()

    @fire "board-changed"
    @amount += 1
    event.stopPropagation()

  _rightClick: (event) ->
    return if not @options.editable
    event.preventDefault()

    @fire "board-changed"
    @amount -= 1
