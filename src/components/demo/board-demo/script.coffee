initial_table = [
  [ {}, {}, {}, {} ]
  [ {}, {}, {}, {} ]
  [ { black: 1 }, { blue: 8 }, { green: 2 }, {} ]
  [ { red: 3, black: 4 }, {}, {}, {} ]
]

model = table: initial_table

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
    @model = null
    @async @_setModel, 0

  _setModel: ->
    @model = model
