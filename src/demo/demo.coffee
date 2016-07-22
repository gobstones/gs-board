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

###
document.addEventListener 'DOMContentLoaded', ()->

  json = tablero_inicial
  model = json:json
  json_editor = document.querySelector '#json-editor'
  json_editor.model = model
  window.json = json

  document.querySelector('#load').addEventListener 'click', ()->
    buffer.send buffer.ACTION.SHOW, tablero_inicial

  document.querySelector("#clean").addEventListener 'click', ()->
    console.log 'clean'

###
