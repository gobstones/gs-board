
document.addEventListener 'DOMContentLoaded', ()->
  gsTablero = document.querySelector('gs-tablero');
  document.querySelector('#load').addEventListener('click', ()->
    console.log 'load2'
  )
  document.querySelector("#clean").addEventListener('click', ()->
    console.log 'clean'
  )
