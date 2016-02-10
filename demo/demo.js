(function() {
  var buffer, negro4, rojo_3, tablero_inicial, vacio0, varias, verde2;

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

  vacio0 = function() {
    return {};
  };

  verde2 = function() {
    return {
      VERDE: 2
    };
  };

  rojo_3 = function() {
    return {
      ROJO: 3
    };
  };

  negro4 = function() {
    return {
      NEGRO: 4
    };
  };

  varias = function() {
    return {
      NEGRO: 4,
      ROJO: 4
    };
  };

  tablero_inicial = [[verde2(), vacio0(), vacio0(), vacio0(), vacio0(), vacio0(), vacio0(), vacio0()], [verde2(), vacio0(), vacio0(), vacio0(), rojo_3(), vacio0(), vacio0(), vacio0()], [vacio0(), vacio0(), rojo_3(), vacio0(), vacio0(), vacio0(), vacio0(), vacio0()], [rojo_3(), rojo_3(), vacio0(), vacio0(), vacio0(), vacio0(), rojo_3(), vacio0()], [vacio0(), vacio0(), vacio0(), vacio0(), rojo_3(), vacio0(), vacio0(), vacio0()], [vacio0(), vacio0(), vacio0(), vacio0(), vacio0(), vacio0(), vacio0(), vacio0()], [vacio0(), vacio0(), rojo_3(), vacio0(), rojo_3(), vacio0(), vacio0(), vacio0()], [vacio0(), vacio0(), vacio0(), vacio0(), vacio0(), vacio0(), vacio0(), vacio0()]];

  document.addEventListener('DOMContentLoaded', function() {
    var gsTablero;
    gsTablero = document.querySelector('gs-tablero');
    document.querySelector('#load').addEventListener('click', function() {
      return buffer.send(buffer.ACTION.SHOW, tablero_inicial);
    });
    return document.querySelector("#clean").addEventListener('click', function() {
      return console.log('clean');
    });
  });

}).call(this);
