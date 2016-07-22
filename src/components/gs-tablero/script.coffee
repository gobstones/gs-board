Polymer
  is: '#GRUNT_COMPONENT_NAME'

  properties:
    board: Array

  getRowNumber: (rowIndex) ->
    @board.length - rowIndex

  columnIndexes: (board) ->
    [0 ... board[0].length]
