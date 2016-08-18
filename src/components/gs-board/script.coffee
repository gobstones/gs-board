Polymer
  is: '#GRUNT_COMPONENT_NAME'

  properties:
    table: Array
    # ^ [[{ red: 2, blue: 1 }, { black: 3 }], [...]]

    size:
      type: Object
      value: { x: 2, y: 2 }
      observer: "_updateColumnIndexes"
    # ^ if `table` exists, this field is ignored

    header:
      type: Object
      value: { x: 0, y: 0 }

    options: Object
    # ^ { editable: false }

    boom:
      type: Boolean
      value: false

    cellSize: type: Number, value: 50
    minWidth: type: Number, value: 127
    minHeight: type: Number, value: 136
    maxWidth: type: Number, value: 677
    maxHeight: type: Number, value: 586

  listeners:
    resize: "_onResize"

  ready: ->
    @_initializeTable()
    @_initializeOptions()
    @_setResizable()

  getRowNumber: (table, rowIndex) ->
    table.length - 1 - rowIndex

  isCtrlPressed: ->
    @$.keyTracker.isPressed "Control"

  boomCssClass: (boom) ->
    if boom then "boom" else ""

  resizeCssClass: (options) ->
    if options.editable then "board_resize" else ""

  _onResize: ({ size, originalSize }) ->
    @fire "board-changed"
    deltaX = (size.width - originalSize.width) / @cellSize
    deltaY = (size.height - originalSize.height) / @cellSize
    @size =
      x: @resizeInitialState.x + deltaX
      y: @resizeInitialState.y + deltaY
    @_fillTable()

  _initializeTable: ->
    if @table?
      @size =
        x: @table[0]?.length || 0
        y: @table.length || 0
    else
      @table = []
      @_fillTable()

  _fillTable: ->
    limit = (array, limit) -> array.slice 0, limit
    table = @table.slice().reverse()
    for i in [0 ... @size.y]
      for j in [0 ... @size.x]
        table[i] ?= []
        table[i] = limit table[i], @size.x
        table[i][j] ?= {}
    table = limit table, @size.y
    @table = table.reverse()
    @_forceHeaderSet()

  _initializeOptions: ->
    @options ?= {}
    @options.editable ?= false

  _setResizable: ->
    return if not @options.editable
    @resizeInitialState = null

    $(@$$(".gbs_board"))
      .resizable
        grid: @cellSize
        minWidth: @minWidth
        minHeight: @minHeight
        maxWidth: @maxWidth
        maxHeight: @maxHeight
      .on "resizestart", (event, resize) =>
        @resizeInitialState = @size
      .on "resize", (event, resize) =>
        @_onResize resize
      .on "resizestop", (event, resize) =>
        @resizeInitialState = null
    setTimeout(=>
      $(@$$(".ui-resizable-s")).hide()
      $(@$$(".ui-resizable-e")).hide()
      $(@$$(".ui-resizable-se"))
        .appendTo @$$(".board_resize")
        .css "position", "relative"
    , 0)

  _updateColumnIndexes: ->
    @columnIndexes = [0 ... @size.x]

  _forceHeaderSet: ->
    x = Math.min @header.x, (@size.x - 1)
    y = Math.min @header.y, (@size.y - 1)

    @header = null
    @header = { x, y }
