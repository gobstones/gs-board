Polymer
  is: '#GRUNT_COMPONENT_NAME'
  
  properties:
    row: 
      type: Array
      value: []
      observer: '_row_change'
      
  _row_change: ->
    #console.log @row