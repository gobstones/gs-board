(function() {
  document.addEventListener('DOMContentLoaded', function() {
    var gsTablero;
    gsTablero = document.querySelector('gs-tablero');
    document.querySelector('#load').addEventListener('click', function() {
      return console.log('load2');
    });
    return document.querySelector("#clean").addEventListener('click', function() {
      return console.log('clean');
    });
  });

}).call(this);
