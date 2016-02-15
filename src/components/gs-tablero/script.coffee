
generar_fila_vacia = ()->
  {} for _ in [0...8]
generar_filas_vacias = ()->
  generar_fila_vacia() for index_fila in [0...8]
    
Polymer
  is: '#GRUNT_COMPONENT_NAME'
  
  properties:
    filas:
      type: Array
      notify: true
    lastIndex:
      type: String
      value: 0
    tableroRows:
      type: String
      value: 8
      observer: '_rows_change'

  # Fires when an instance of the element is created
  created: ()->
    console.log 'gs-tablero created'
    #@last_index = 5

  # Fires when the local DOM has been fully prepared
  ready: ()->
    this.filas = generar_filas_vacias()
  
  hostAttributes:
    "mi-atributo": "mivalor"
    
  # Fires when the element was inserted into the document
  attached: ()->

  # Fires when the element was removed from the document
  detached: ()->

  # Fires when an attribute was added, removed, or updated
  attributeChanged: (name, type)->

  _rows_change: ->
    console.log @tableroRows
    this.filas and this.splice('filas', 1, 1);
    console.log this.filas
    
  load: ->
    console.log 'tablero loading'
    
    
  