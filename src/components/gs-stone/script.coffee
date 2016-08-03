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
    click: '_leftClick'
    contextmenu: '_rightClick'

  ready: ->
    @_sanitizeAmount()
    @_keyTracker = new KeyTracker()
    throw new Error("The options are required") if not @options?

  cssClass: ->
    if @options.editable then "pointer"
    else ""

  _sanitizeAmount: ->
    unless typeof @amount is 'number' and @amount >= 0
      @amount = 0

  _leftClick: (event) ->
    return if not @options.editable or @_keyTracker.isPressed "Control"
    @amount += 1
    event.stopPropagation()

  _rightClick: (event) ->
    return if not @options.editable
    event.preventDefault()
    @amount -= 1

# ------------------------------

# // TODO: Duplicated. Move to another place.
class KeyTracker
  constructor: ->
    @_pressedKeys = []

    @_listenTo "keydown", (ev) =>
      key = ev.key || ev.keyIdentifier
      @_pressedKeys.push key if not @isPressed key

    @_listenTo "keyup", (ev) =>
      key = ev.key || ev.keyIdentifier
      @_pressedKeys.splice @_indexOf(key), 1 if @isPressed key

  isPressed: (key) =>
    @_indexOf(key) isnt -1

  _indexOf: (key) =>
    @_pressedKeys.indexOf key

  _listenTo: (eventName, handler) =>
    window.addEventListener eventName, handler, false
