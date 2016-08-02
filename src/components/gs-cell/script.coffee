Polymer
  is: '#GRUNT_COMPONENT_NAME'

  properties:
    cellIndex: Number
    rowIndex: Number
    cell: Object
    board: Array
    header:
      type: Object
      notify: true
    options: Object

  listeners:
    tap: '_processTap'

  ready: ->
    @_validateData()
    @_keyTracker = new KeyTracker()

  cssClass: ->
    return "" if not @header?
    theHeaderIsHere = @x() is @header.x and @y() is @header.y

    if theHeaderIsHere then "gh" else ""

  # ---
  # // TODO: Duplicated code with #gs-board
  # // I tried to send directly the { x, y } to this component
  # // but Polymer doesn't support expressions in arguments yet.
  x: -> @cellIndex
  y: -> @getRowNumber @rowIndex
  getRowNumber: (rowIndex) ->
    @board.length - 1 - rowIndex
  # ---

  _processTap: (event) ->
    return if not @options.editable

    if @_keyTracker.isPressed "Control"
      @header.x = @x()
      @header.y = @y()
      # // TODO: Don't pass the event to the child stones
      # // TODO: Fix problem with two-way-binding
      console.log "The new header is in", @header

  _validateData: ->
    throw new Error("The board is required") if not @board?
    throw new Error("The header is required") if not @header?
    throw new Error("The options are required") if not @options?

    throw new Error("The cell is required") if not @cell?
    throw new Error("The coordinates are required") if not @cellIndex? or not @rowIndex?

# ------------------------------

# // TODO: Move to another place
class KeyTracker
  constructor: ->
    @_pressedKeys = []

    @_listenTo "keydown", ({ key }) =>
      @_pressedKeys.push key if not @isPressed key

    @_listenTo "keyup", ({ key }) =>
      @_pressedKeys.splice @_indexOf(key), 1 if @isPressed key

  isPressed: (key) =>
    @_indexOf(key) isnt -1

  _indexOf: (key) =>
    @_pressedKeys.indexOf key

  _listenTo: (eventName, handler) =>
    window.addEventListener eventName, handler, false
