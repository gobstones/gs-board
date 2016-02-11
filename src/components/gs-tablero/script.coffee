
generar_fila_vacia = ()->
  {} for _ in [0...8]
generar_filas_vacias = ()->
  generar_fila_vacia() for index_fila in [0...8]
    
Polymer
    is: '#GRUNT_COMPONENT_NAME',

    # Fires when an instance of the element is created
    created: ()->
      console.log 'poly-demo-footer created'

    # Fires when the local DOM has been fully prepared
    ready: ()->
        console.log $
        this.filas = generar_filas_vacias()
    
    hostAttributes:
      "mi-atributo": "mivalor"
      
    # Fires when the element was inserted into the document
    attached: ()->

    # Fires when the element was removed from the document
    detached: ()->

    # Fires when an attribute was added, removed, or updated
    attributeChanged: (name, type)->
