Polymer
  is: '#GRUNT_COMPONENT_NAME'

  properties:
    table: Array
    # ^ [[{ red: 2, blue: 1 }, { black: 3 }], [...]]

    size:
      type: Object
      value: { x: 2, y: 2 }
      observer: "_updateSize"
    # ^ if `table` exists, this field is ignored

    header:
      type: Object
      value: { x: 0, y: 0 }

    options: Object
    # ^ { editable: false }

    boom:
      type: Boolean
      value: false

    attire:
      type: Object

  ready: ->
    @_initializeTable()
    @_initializeOptions()

  getRowNumber: (table, rowIndex) ->
    table.length - 1 - rowIndex

  isCtrlPressed: ->
    @$.keyTracker.isPressed "Control"

  boomCssClass: (boom) ->
    if boom then "boom" else ""

  _initializeTable: ->
    if @table?
      @size =
        x: @table[0]?.length || 0
        y: @table.length || 0
    else
      @table = []
      @_fillTable()

  _fillTable: ->
    return if not @table?

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

  _updateSize: ->
    @_fillTable()
    @columnIndexes = [0 ... @size.x]
    @fire "board-changed"

  _forceHeaderSet: ->
    x = Math.min @header.x, (@size.x - 1)
    y = Math.min @header.y, (@size.y - 1)

    @header = null
    @header = { x, y }
