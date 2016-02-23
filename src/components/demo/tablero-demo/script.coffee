
vacio0 = ()-> {}
verde2 = ()-> verde: 2
rojo_3 = ()-> rojo:  3
negro4 = ()-> negro: 4
varias = ()-> negro: 4, rojo: 4

tablero_inicial = [
  [verde2(), vacio0(), vacio0(), vacio0(), vacio0(), vacio0(), vacio0(), vacio0()]
  [verde2(), vacio0(), vacio0(), vacio0(), rojo_3(), vacio0(), vacio0(), vacio0()]
  [vacio0(), vacio0(), rojo_3(), vacio0(), vacio0(), vacio0(), vacio0(), vacio0()]
  [rojo_3(), rojo_3(), vacio0(), vacio0(), vacio0(), vacio0(), rojo_3(), vacio0()]
  [vacio0(), vacio0(), vacio0(), vacio0(), rojo_3(), vacio0(), vacio0(), vacio0()]
  [vacio0(), vacio0(), vacio0(), vacio0(), vacio0(), vacio0(), vacio0(), vacio0()]
  [vacio0(), vacio0(), rojo_3(), vacio0(), rojo_3(), vacio0(), vacio0(), vacio0()]
  [vacio0(), vacio0(), vacio0(), vacio0(), vacio0(), vacio0(), vacio0(), vacio0()]
]

model = tablero: tablero_inicial

Polymer
  is: '#GRUNT_COMPONENT_NAME'
  
  properties:
    
    model: 
      type: Object
      value: model
    jsonModel:
      type: Object
      value: model
      
  listeners: 
    'jsoneditor.change': '_json_change'
  
  _json_change: ()->
    @async @_force_render, 0
  
  _force_render: ->
    @model = {}
    @async @_set_model, 0
  
  _set_model: ->
    @model = model
  
  
  