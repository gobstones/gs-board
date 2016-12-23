Polymer
  is: '#GRUNT_COMPONENT_NAME'

  properties:
    cellIndex: Number
    rowIndex: Number
    cell: Object
    table: Array
    attire:
      type: Object
      notify: "_updateStyles"
    boom: Boolean
    backgroundUrl: String
    header:
      type: Object
      notify: true
    options: Object

  listeners:
    click: "_leftClick"

  observers: [
    '_updateStyles(attire.enabled)'
  ]

  ready: ->
    @_validateData()
    @_updateStyles()

  cssClass: (header) ->
    return "" if not header?
    theHeaderIsHere = @x() is header.x and @y() is header.y

    if theHeaderIsHere and not @boom then "gh" else ""

  x: -> @cellIndex
  y: -> @domHost.getRowNumber @table, @rowIndex

  _leftClick: (event) ->
    return if not @options.editable

    if @domHost.isCtrlPressed()
      @fire "board-changed"
      @header = { x: @x(), y: @y() }

  _validateData: ->
    throw new Error("The table is required") if not @table?
    throw new Error("The header is required") if not @header?
    throw new Error("The options are required") if not @options?

    throw new Error("The cell is required") if not @cell?
    throw new Error("The coordinates are required") if not @cellIndex? or not @rowIndex?

  _updateStyles: ->
    url = @$.dresser.getImage @cell, @attire

    @customStyle["--stones-visibility"] = if url? or @boom then "hidden" else "visible"
    if url? then @customStyle["--background-url"] = "url(#{url})"
    else delete @customStyle["--background-url"]

    @updateStyles()
