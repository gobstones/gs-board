(function() {
  var buffer;

  window.buffer = buffer = {
    actions: {},
    ACTION: {
      SHOW: 'SHOW',
      LOAD: 'LOAD',
      DUMP: 'DUMP'
    },
    subscribe: function(name, action) {
      if (!buffer.actions[name]) {
        buffer.actions[name] = [];
      }
      return buffer.actions[name].push(action);
    },
    send: function(name, data) {
      var action, actions, _i, _len, _results;
      actions = buffer.actions[name];
      if (actions) {
        _results = [];
        for (_i = 0, _len = actions.length; _i < _len; _i++) {
          action = actions[_i];
          _results.push(action(data));
        }
        return _results;
      }
    }
  };


  /*
  document.addEventListener 'DOMContentLoaded', ()->
    
    json = tablero_inicial
    model = json:json
    json_editor = document.querySelector '#json-editor'
    json_editor.model = model
    window.json = json
    
    document.querySelector('#load').addEventListener 'click', ()->
      buffer.send buffer.ACTION.SHOW, tablero_inicial
    
    document.querySelector("#clean").addEventListener 'click', ()->
      console.log 'clean'
   */

}).call(this);
