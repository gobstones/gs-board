# tablero

gobstones grid Polymer component (aka: tablero)

Version: 0.1.0

### deploy

```
npm   update
bower update
grunt server
```

### build
grunt build


## using

```html
<gs-tablero board="{{model}}" editable="true"></gs-tablero>
```

```javascript
Polymer({
  is: 'my-custom-container',
  properties:{
	model: {
	  type:Array
	}
  },
  attached:function(){
    // 3x2 boad
    this.model = [[{rojo:1,negro:2},{},{}],[{},{},{}]];
  }
});
```

###dinamically 

```javascript
element = document.createElement('gs-tablero');
element.board = tablero_inicial();
element.editable = true;
```
