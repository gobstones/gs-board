
Polymer
  is: '#GRUNT_COMPONENT_NAME'

  properties:
    
    cell:
      type: Object
    
    rowIndex:
      type: Number
      value: 0
      
    rowsAmount:
      type: Number
      value: 0
    
    columnIndex:
      type: Number
      value: 0
      
    columnsAmount:
      type: Number
      value: 0
    
    customClass:
      type: String
      value: ''
      
    computedTitle:
      type: String
      value: 'NaN:NaN'
      
  observers: [
      '_update(rowIndex, rowsAmount, columnIndex, columnAmount)'
    ]
  
  created: ->
    @_custom_classes = []
      
  ready:->
    @_update()
    
  _update: ()->
    @computedTitle = @rowIndex + ':' + @columnIndex
    @_custom_classes.length = 0
    if @rowIndex is 0
      @_custom_classes.push 'first-row'
    else if @rowIndex is (@rowsAmount - 1)
      @_custom_classes.push 'last-row'
    if @columnIndex is 0
      @_custom_classes.push 'first-column'
    else if @columnIndex is (@columnsAmount - 1)
      @_custom_classes.push 'last-column'
    @customClass = @_custom_classes.join ' '
