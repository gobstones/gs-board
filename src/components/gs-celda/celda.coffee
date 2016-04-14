
Polymer
  is: '#GRUNT_COMPONENT_NAME'

  properties:
    cell:
      type: Object
    colors:
      type: Array
      value: ['azul', 'negro', 'rojo', 'verde']
    rowIndex:
      type: Number
    rowsAmount:
      type: Number
    columnIndex:
      type: Number
    columnAmount:
      type: Number
    customClass:
      type: String
      value: ''
    cellTitle:
      type: String
      value: 'NaN:NaN'
      
  observers: [
      '_update(rowIndex,rowsAmount,columnIndex,columnAmount)'
    ]
    
  created: ->
    @_custom_classes = []
      
  ready:->
    @_update()
    
  _update: ()->
    @cellTitle = @rowIndex + ':' + @columnIndex
    @_custom_classes.length = 0
    if @rowIndex is 0
      @_custom_classes.push 'first-row'
    else if @rowIndex is (@rowsAmount - 1)
      @_custom_classes.push 'last-row'
    if @columnIndex is 0
      @_custom_classes.push 'first-column'
    else if @columnIndex is (@columnAmount - 1)
      @_custom_classes.push 'last-column'
    @customClass = @_custom_classes.join ' '
