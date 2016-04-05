
Polymer
  is: '#GRUNT_COMPONENT_NAME'
  
  behaviors:[GS.RuleIndex]
  
  ready: ->
    
  attached:->
    @_render()

  _render:->
    if @originals
      initial_height = @originals.height + @originals.paddingTop
      nextHeight = initial_height * @zoom / 100
      paddingTop = (nextHeight - @originals.indexHeight) / 2
      if paddingTop < 0
        indexZoom = nextHeight / (@$.ruleIndex.clientHeight + paddingTop)
        @$.ruleIndex.style.zoom = indexZoom
        paddingTop = 0
      else
        @$.ruleIndex.style.zoom = 1
      @style.height     = (nextHeight - paddingTop) + 'px'
      @style.paddingTop = paddingTop + 'px'
      @style.marginTop  = (@originals.marginTop  * @zoom / 100) + 'px'
      
