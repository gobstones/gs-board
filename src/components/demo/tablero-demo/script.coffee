
vacio0 = ()-> {}
verde2 = ()-> verde: 2
rojo_3 = ()-> rojo:  3
negro4 = ()-> negro: 4
varias = ()-> negro: 4, rojo: 4

tablero_inicial = ()-> [
  [verde2(), vacio0(), vacio0(), vacio0(), vacio0(), vacio0(), vacio0(), vacio0()]
  [verde2(), vacio0(), vacio0(), vacio0(), rojo_3(), vacio0(), vacio0(), vacio0()]
  [vacio0(), vacio0(), rojo_3(), vacio0(), vacio0(), vacio0(), vacio0(), vacio0()]
  [rojo_3(), rojo_3(), vacio0(), vacio0(), vacio0(), vacio0(), rojo_3(), vacio0()]
  [vacio0(), vacio0(), vacio0(), vacio0(), rojo_3(), vacio0(), vacio0(), vacio0()]
  [vacio0(), vacio0(), vacio0(), vacio0(), vacio0(), vacio0(), vacio0(), vacio0()]
  [vacio0(), vacio0(), rojo_3(), vacio0(), rojo_3(), vacio0(), vacio0(), vacio0()]
  [vacio0(), vacio0(), vacio0(), vacio0(), vacio0(), vacio0(), vacio0(), vacio0()]
]

deepCopy = (obj) ->
    rv = undefined
    switch typeof obj
      when 'object'
        if obj == null
          rv = null
        else
          switch toString.call(obj)
            when '[object Array]'
              rv = obj.map(deepCopy)
            when '[object Date]'
              rv = new Date(obj)
            when '[object RegExp]'
              rv = new RegExp(obj)
            else
              rv = Object.keys(obj).reduce(((prev, key) ->
                prev[key] = deepCopy(obj[key])
                prev
              ), {})
              break
      else
        rv = obj
        break
    rv

Polymer
  is: '#GRUNT_COMPONENT_NAME'
  
  properties:
    
    jsonModel:
      type: Object
      value: tablero_inicial()
    rows:
      type: Number
    columns:
      type: Number
    
  AFTER:  'AFTER'
  BEFORE: 'BEFORE'
  IDE:    'IDE'
    
  ready:->
    @panels = @$.gsPanels
    @before = @create_board(true)
    @after = @create_board(false)
    
  attached: ->
    @panels.add_horizontal @IDE
    @panels.add @before,
      id: @BEFORE
      into: @IDE
    @panels.add @after,
      id: @AFTER
      into: @IDE
      
  create_board: (editable) ->
    element = document.createElement 'gs-tablero'
    element.board = tablero_inicial()
    element.editable = editable
    element
  
  edit_to_json:->
    @jsonModel = deepCopy @before.board
    
  json_to_edit:->
    @before.board = deepCopy @jsonModel
  
  resize_board:->
    board = deepCopy @before.board
    if board.length < @rows
      for index in [board.length ... @rows]
        board.push({} for _ in [0 ... @columns.length])
    else
      board.length = @rows
    for row in board
      if row.length < @columns
        for index in [row.length ... @columns]
          row.push {}
      else
        row.length = @columns
    @before.board = board
    
  