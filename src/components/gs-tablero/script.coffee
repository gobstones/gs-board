Polymer
  is: '#GRUNT_COMPONENT_NAME'
  
  properties:
    
    rows:
      type: Array
      notify: true
      observer: '_rows_change'
      
    columnsMaxLength:
      type: String
      value: 0
    
    hardcode_false:
      comment: 'polymer does not allow literal false in html'
      type: Boolean
      value: false
  
  _generate_empty_row: ->
    {} for _ in [0...8]
    
  _generate_empty_rows: ->
    @_generate_empty_row() for _ in [0...8]
    
  ready: ->
    @rows = @_generate_empty_rows()
  
  _rows_change: ->
    @columnsMaxLength = 0
    for row in @rows
      if row.length > @columnsMaxLength
        @columnsMaxLength = row.length
    
    
    
  