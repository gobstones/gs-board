Polymer
  is: '#GRUNT_COMPONENT_NAME'

  properties:
    board: Array
    # ^ [[{ red: 2, blue: 1 }, { black: 3 }], [...]]

    size:
      type: Object
      value: { x: 2, y: 2 }
    # ^ if `board` exists, this field is ignored

    header:
      type: Object
      value: { x: 0, y: 0 }

    options: Object
    # ^ { editable: false }

  ready: ->
    @_initializeBoard()
    @_initializeOptions()

  getRowNumber: (rowIndex) ->
    @board.length - 1 - rowIndex

  columnIndexes: (board) ->
    [0 ... board?[0].length]

  headerCssClassFor: (rowIndex, cellIndex) ->
    rowNumber = @getRowNumber rowIndex

    if rowNumber is @header.y and cellIndex is @header.x
      "gh"
    else ""

  _initializeBoard: ->
    @board ?=
      for i in [1 .. @size.y]
        for j in [1 .. @size.x]
          {}
    @board = @board.map (row) -> row.reverse()

  _initializeOptions: ->
    @options ?= {}
    @options.editable ?= false
