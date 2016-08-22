# gs-board

gobstones grid Polymer component (aka: board)

Version: 0.1.0

## install
```
npm install
bower install
```

## run
```
grunt
```

## usage

### install
```
bower install --save gobstones/gs-board
```

### import
```html
<link rel="import" href="{BOWER_COMPONENTS}/gs-board/dist/components/gs-board.html">
```

### initial board (editable)
```html
<gs-board size='{ "x": 4, "y": 4 }' options='{ "editable": true }'></gs-board>
```

### final board (fixed)
```html
<template is="dom-if" if="{{finalState}}" restamp="true">
  <gs-board table='{{finalState.table}}' header="{{finalState.header}}"></gs-board>
</template>
```
```
finalState.table = [[{}, { "red": 3 }], [{ "black": 1 }, {}]]
```

### setting header position
```html
<gs-board size='{ "x": 4, "y": 4 }' header='{ "x": 1, "y": 3 }'></gs-board>
```

### with boom
```html
<gs-board size='{ "x": 4, "y": 4 }' boom></gs-board>
```

## deploy

Create tags in `#master`.
