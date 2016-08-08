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

    options:
      type: Object
      observer: "_updateIsEditable"
    # ^ { editable: false }

  listeners:
    resize: "_onResize"

  ready: ->
    @_initializeTable()
    @_initializeOptions()

  getRowNumber: (rowIndex) ->
    @table.length - 1 - rowIndex

  columnIndexes: (table) ->
    [0 ... @size.x]

  isCtrlPressed: ->
    @$.keyTracker.isPressed "Control"

  _onResize: ({ detail: delta }) ->
    @size.x = @size.x + delta.deltaX
    @size.y = @size.y + delta.deltaY
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
    for i in [0 ... @size.y]
      for j in [0 ... @size.x]
        @table[i] ?= []
        @table[i] = limit @table[i], @size.x
        @table[i][j] ?= {}
    @table = limit @table, @size.y

  _initializeOptions: ->
    @options ?= {}
    @options.editable ?= false

  _updateColumnIndexes: ->
    @columnIndexes = [0 ... @size.x]

  _updateIsEditable: ->
    @isEditable = @options.editable
