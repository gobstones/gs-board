
window.buffer = buffer = 
  actions: {}

  ACTION:
    SHOW:'SHOW'
    LOAD:'LOAD'
    DUMP:'DUMP'

  subscribe: (name, action)->
    if not buffer.actions[name] then buffer.actions[name] = []
    buffer.actions[name].push action
  
  send: (name, data)->
    actions = buffer.actions[name]
    if actions 
     for action in actions
       action(data)
      
vacio0 = ()-> {}
verde2 = ()-> VERDE: 2
rojo_3 = ()-> ROJO:  3
negro4 = ()-> NEGRO: 4
varias = ()-> NEGRO: 4,ROJO: 4

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

document.addEventListener 'DOMContentLoaded', ()->
  gsTablero = document.querySelector('gs-tablero');
  document.querySelector('#load').addEventListener('click', ()->
    buffer.send buffer.ACTION.SHOW, tablero_inicial
  )
  document.querySelector("#clean").addEventListener('click', ()->
    console.log 'clean'
  )
