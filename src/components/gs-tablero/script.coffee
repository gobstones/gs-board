Polymer
  is: '#GRUNT_COMPONENT_NAME'

  properties:

    board:
      type: Array
      observer: '_update'

    columnsAmount:
      type: String
      value: 0

    hardcode_false:
      comment: 'polymer does not allow literal false in html'
      type: Boolean
      value: false

  _generate_empty_row: ->
    {} for _ in [0...8]

  _generate_empty_rows: ->
    @_generate_empty_row() for _ in [0...8]

  getRowNumber: (rowIndex) ->
    @board.length - rowIndex

  columnIndexes: (board) ->
    [0 ... board[0].length]

  ready: ->
    @board = @board or @_generate_empty_rows()
    @viewport = @$.viewport
    @_update()

  _sanitize_rows: ->
    #TODO assert rows structure

  _update: ->
    @columnsAmount = 0
    @board = @board or []
    for row in @board
      if row.length > @columnsAmount
        @columnsAmount = row.length
    @_sanitize_rows()
    @async @_resize, 1

  _resize: ->
    parent_h = @clientHeight
    parent_w = @clientWidth
    viewport_h = @viewport.clientHeight
    viewport_w = @viewport.clientWidth
    h_fix = parent_h / viewport_h
    w_fix = parent_w / viewport_w
    if w_fix > h_fix
      zoom = h_fix
    else
      zoom = w_fix
    movey = ((parent_h - viewport_h) / 2) / zoom
    movex = ((parent_w - viewport_w) / 2) / zoom
    @viewport.style.transform = "scale(#{zoom}) translate3d(#{movex}px,#{movey}px,0)"





