
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


Polymer
  is: '#GRUNT_COMPONENT_NAME'
  
  properties:
    model: 
      type: Object
      value: tablero: tablero_inicial
    
  