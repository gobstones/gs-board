Polymer
  is: '#GRUNT_COMPONENT_NAME'

Polymer
  is: 'dom-iterate'
  extends: 'template'
  _template: null
  
  properties: 
    from: 
      type: Number
      value: 0
    to: 
      type: Number
      value: 0
    count: 
      type: Number,
      observer: '_countChanged'
      
  observers: [
      '_repeat_changed(from, to)'
    ],
    
  behaviors: [
      Polymer.Templatizer
    ]
    
  created: ()->
    @._instances = []
    
  ready: ()->
    this._instanceProps = 
      __key__: true
    this._instanceProps['indice'] = true;
    console.log 'ready'
    unless @ctor then @templatize(@)
    
  render: ()->
    @_flushTemplates()

  attached: ()->
    parent = @._getParentElement()
    for instance of @._instances
      @._attachInstance instance, parent

  detached: ()->
    for instance of @._instances
      @._detachInstance(instance);

  _attachInstance: (instance, parent)->
    parent = parent or @._getParentElement()
    @._insertBefore instance,
      parent: parent

  _insertBefore: (instance, target)->
    target = target or {}
    parent = target.parent or @._getParentElement()
    before = target.before or @
    parent.insertBefore(instance.root, before)
    instance

  _detachInstance: (instance)->
    for child of instance._children
      Polymer.dom(instance.root).appendChild(child);

  _getParentElement: ()->
    parentNode = Polymer.dom(this).parentNode;
    Polymer.dom(parentNode);

  _repeat_changed: (from, to)->
    console.log 'repeat-change'
    
  _countChanged: (count, oldValue)->
    @_debounceTemplate ->
      oldValue = oldValue or 0
      if count < oldValue
        this._detachInstances(count)
      else
        this._insertItems(count - oldValue, oldValue)

  _detachInstances: (start, count)->
    start = start or 0
    count = count or @._instances.length - start
    instances = @._instances.splice(start, count)
    self = this
    instances.map((inst) -> self._detachInstance(inst))

  _insertItems: (count, startIndex)->
    startIndex = startIndex or 0
    parent = @._getParentElement()
    if startIndex is @._instances.length
      before = @
    else
      beforeRow = @._instances[startIndex]
      before = beforeRow._children[0]
    self = @
    if this.from > this.to
      include_last = -1
    else
      include_last = +1
    for index in [this.from ... this.to + include_last]
      model = ''
      instance = ''
      console.log index
    instances = Array.from(length: count)
      .map((value, i) -> 
        (indice: i)
      ).map((model) -> 
        #stamp deletes model attributes value
        #self.stamp(model)
        new self.ctor(model, self)
      ).map((instance) -> self._insertBefore(instance, 
        parent: parent
        before: before
      ))

    #this._instances.splice(startIndex, 0, ...instances);

###
_showHideChildren: (hidden)->
  for instance of @._instances
    instance._showHideChildren(hidden)
###



