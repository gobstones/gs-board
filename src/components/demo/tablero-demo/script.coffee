vacio0 = -> {}
verde2 = -> verde: 2
rojo_3 = -> rojo:  3
negro4 = -> negro: 4
varias = -> negro: 4, rojo: 4

tablero_inicial = [
  [verde2(), vacio0(), vacio0(), vacio0(), vacio0()]
  [verde2(), vacio0(), vacio0(), vacio0(), rojo_3()]
  [vacio0(), vacio0(), rojo_3(), vacio0(), vacio0()]
  [rojo_3(), rojo_3(), vacio0(), vacio0(), vacio0()]
  [vacio0(), vacio0(), vacio0(), vacio0(), rojo_3()]
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
