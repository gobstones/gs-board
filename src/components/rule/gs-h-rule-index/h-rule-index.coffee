
Polymer
  is: '#GRUNT_COMPONENT_NAME'
  
  behaviors:[GS.RuleIndex]
  
  attached:->
    @_render()

  _render:->
    if @originals
      @style.width  = (@originals.width  * @zoom / 100) + 'px'
      @style.marginLeft  = (@originals.marginLeft * @zoom / 100) + 'px'