board_inicial = [
  [ {}, {}, {}, {} ]
  [ {}, {}, {}, {} ]
  [ {}, {}, { green: 2 }, {} ]
  [ { red: 3, black: 4 }, {}, {}, {} ]
]

model = board: board_inicial
empty = board: [[]]

Polymer
  is: '#GRUNT_COMPONENT_NAME'

  properties:

    model:
      type: Object
      value: model
      notify: true
    jsonModel:
      type: Object
      value: model

  listeners:
    'jsoneditor.change': '_jsonChange'

  _jsonChange: ->
    @async @_forceRender, 0

  _forceRender: ->
    @model = empty
    @async @_setModel, 0

  _setModel: ->
    @model = model
