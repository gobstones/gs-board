Polymer
  is: '#GRUNT_COMPONENT_NAME'

  properties:
    table: Array
    # ^ [[{ red: 2, blue: 1 }, { black: 3 }], [...]]

    size:
      type: Object
      value: { x: 2, y: 2 }
    # ^ if `table` exists, this field is ignored

    header:
      type: Object
      value: { x: 0, y: 0 }

    options: Object
    # ^ { editable: false }

  ready: ->
    @_initializeTable()
    @_initializeOptions()

  getRowNumber: (rowIndex) ->
    @table.length - 1 - rowIndex

  columnIndexes: (table) ->
    [0 ... table?[0].length]

  _initializeTable: ->
    @table ?=
      for i in [1 .. @size.y]
        for j in [1 .. @size.x]
          {}

  _initializeOptions: ->
    @options ?= {}
    @options.editable ?= false
