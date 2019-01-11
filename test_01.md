# http://javascript-puzzlers.herokuapp.com/
```js
[typeof null, null instanceof Object]
```

`["object", false]`

typeof will always return "object" for native non callable objects.

---

```js
[].reduce(Math.pow)
```

`an error`

Per spec: reduce on an empty array without an initial value throws TypeError.

---

```js
var name = 'World!';
(function () {
    if (typeof name === 'undefined') {
        var name = 'Jack';
        console.log('Goodbye ' + name);
    } else {
        console.log('Hello ' + name);
    }
})();
```

`Goodbye Jack`

The var declaration is hoisted to the function scope, but the initialization is not.

---

```js
var ary = [0,1,2];
ary[10] = 10;
ary.filter(function(x) { return x === undefined;});
```

`[]`

Array.prototype.filter is not invoked for the missing elements.

---

```js
function showCase(value) {
    switch(value) {
    case 'A':
        console.log('Case A');
        break;
    case 'B':
        console.log('Case B');
        break;
    case undefined:
        console.log('undefined');
        break;
    default:
        console.log('Do not know!');
    }
}
showCase(new String('A'));
```

`Do not know!`

switch uses `===` internally and `new String(x) !== x`.

---

```js
[] == [] // false
```

---

```js
'5' + 3
'5' - 3
```

`"53", 2`

Strings know about + and will use it, but they are ignorant of - so in that case the strings get converted to numbers.

---

```js
(function(){
  var x = y = 1;
})();
console.log(y);
console.log(x);
```

`1, error`

y is an automatic global, not a function local one.

---

```js
var a = {}, b = Object.prototype;
[a.prototype === b, Object.getPrototypeOf(a) === b]
```

`[false, true]`

Functions have a prototype property but other objects don't so a.prototype is undefined.

Every Object instead has an internal property accessible via 
Object.getPrototypeOf.

---

```js 
function f() {}
var a = f.prototype, b = Object.getPrototypeOf(f);
a === b
```

`false`

f.prototype is the object that will become the parent of any objects created with new f while Object.getPrototypeOf returns the parent in the inheritance hierarchy.

---

```js
function foo(a) {
    var a;
    return a;
}
function bar(a) {
    var a = 'bye';
    return a;
}
[foo('hello'), bar('hello')]
```

`["hello", "bye"]`

Variabled declarations are hoisted, but in this case since the variable exists already in the scope, they are removed altogether. In bar() the variable declaration is removed but the assignment remains, so it has effect.