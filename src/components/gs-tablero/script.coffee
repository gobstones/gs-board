Polymer
  is: '#GRUNT_COMPONENT_NAME'

  properties:
    board: Array
    # ^ [[{ red: 2, blue: 1 }, { black: 3 }], [...]]

    size:
      type: Object
      value: { x: 2, y: 2 }
    # ^ if `board` exists, this field is ignored

    head:
      type: Object
      value: { x: 0, y: 0 }

    editable:
      type: Boolean
      value: false

  ready: ->
    if not @board?
      @_initializeBoard()

  getRowNumber: (rowIndex) ->
    @board.length - 1 - rowIndex

  columnIndexes: (board) ->
    [0 ... board[0].length]

  headCssClassFor: (rowIndex, cellIndex) ->
    rowNumber = @getRowNumber rowIndex

    console.log rowNumber, "rowNumber"
    console.log cellIndex, "cellIndex"
    if rowNumber is @head.y and cellIndex is @head.x
      "gh"
    else ""

  _initializeBoard: ->
    @board =
      for i in [1 .. @size.y]
        for j in [1 .. @size.x]
          {}
