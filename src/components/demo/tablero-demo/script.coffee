vacio0 = -> {}
verde2 = -> green: 2
rojo_3 = -> red:  3
negro4 = -> black: 4
varias = -> black: 4, red: 4

tablero_inicial = [
  [verde2(), vacio0(), vacio0(), vacio0(), vacio0()]
  [verde2(), vacio0(), vacio0(), vacio0(), negro4()]
  [vacio0(), vacio0(), verde2(), vacio0(), vacio0()]
  [rojo_3(), rojo_3(), vacio0(), vacio0(), vacio0()]
  [vacio0(), vacio0(), varias(), vacio0(), rojo_3()]
]

model = tablero: tablero_inicial
empty = tablero: [[]]

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
