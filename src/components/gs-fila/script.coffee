Polymer
    is: '#GRUNT_COMPONENT_NAME',

    # Fires when an instance of the element is created
    created: ()->
      console.log 'gs-fila created'

    # Fires when the local DOM has been fully prepared
    ready: ()->
      console.log this.celdas

    # Fires when the element was inserted into the document
    attached: ()->

    # Fires when the element was removed from the document
    detached: ()->

    # Fires when an attribute was added, removed, or updated
    attributeChanged: (name, type)->
