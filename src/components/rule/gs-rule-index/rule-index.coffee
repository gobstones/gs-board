
if typeof window.GS is 'undefined'
  window.GS = {}
  
GS.RuleIndex =
  
  properties:
    ruleIndex:  
      type:Number
    zoom:
      type:Number
      observer: '_render'
      
  parse_px: (in_px)->
    if in_px is '' 
      value = 0
    else if /px$/.test in_px
      value = parseFloat in_px.slice(0, -2)
    else
      value = in_px
    value
      
  get_originals:->
    style = window.getComputedStyle(@);
    @originals =
      height:      @parse_px style.height
      width:       @parse_px style.width
      marginTop:   @parse_px style.marginTop
      marginLeft:  @parse_px style.marginLeft
      paddingTop:  @parse_px style.paddingTop
      indexHeight: @$.ruleIndex.clientHeight
    
  attached:->
    unless @originals then @get_originals()
  
  