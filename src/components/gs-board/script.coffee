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

  listeners:
    resize: "_onResize"

  ready: ->
    @CELL_SIZE = 50
    @MIN_WIDTH = 127
    @MIN_HEIGHT = 136
    @MAX_WIDTH = 677
    @MAX_HEIGHT = 586

    @_initializeTable()
    @_initializeOptions()
    @_setResizable()
    @resizeInitialState = null

  getRowNumber: (rowIndex) ->
    @table.length - 1 - rowIndex

  isCtrlPressed: ->
    @$.keyTracker.isPressed "Control"

  _onResize: ({ size, originalSize }) ->
    deltaX = (size.width - originalSize.width) / @CELL_SIZE
    deltaY = (size.height - originalSize.height) / @CELL_SIZE
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
    $(@$$(".gbs_board"))
      .resizable
        grid: @CELL_SIZE
        minWidth: @MIN_WIDTH
        minHeight: @MIN_HEIGHT
        maxWidth: @MAX_WIDTH
        maxHeight: @MAX_HEIGHT
      .on "resizestart", (event, resize) =>
        @resizeInitialState = @size
      .on "resize", (event, resize) =>
        @_onResize resize
      .on "resizestop", (event, resize) =>
        @resizeInitialState = null

  _updateColumnIndexes: ->
    @columnIndexes = [0 ... @size.x]

  _forceHeaderSet: ->
    x = @header.x
    y = @header.y
    @header = null
    @header = { x, y }
