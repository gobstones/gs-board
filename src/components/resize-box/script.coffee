Polymer
  is: '#GRUNT_COMPONENT_NAME'

  listeners:
    mousedown: "_mouseDown"

  ready: ->
    @state = dragging: false

    @unitWidth = 50 # // TODO: Cambiar
    @unitHeight = 50 # // TODO: Cambiar

    @_listenTo "mousemove", (e) => @_mouseMove e
    @_listenTo "mouseup", (e) => @_mouseUp e

  _listenTo: (event, handler) ->
    window.addEventListener event, (e) =>
      return unless @state.dragging
      handler e

  _mouseDown: (e) ->
    @state =
      dragging: true
      initialPosition: e

  _mouseUp: (e) ->
    @state.dragging = false

  _mouseMove: (e) ->
    delta = @_getDelta e
    return if delta.deltaX is 0 and delta.deltaY is 0

    this.fire "resize", delta
    console.log "RESIZEAR", delta # // TODO: Borrar
    @state.initialPosition = e

  _getDelta: (e) ->
    deltaX: Math.ceil (e.x - @state.initialPosition.x) / @unitWidth
    deltaY: Math.ceil (e.y - @state.initialPosition.y) / @unitHeight
