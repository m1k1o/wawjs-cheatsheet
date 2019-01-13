# Funkcionálne programovanie

## JavaScript - array extras vs ugly “for”

|   Function   |       In       |          Out           |                 loop eq.                 |
|--------------|----------------|------------------------|------------------------------------------|
| map          | `[]`, N        | `[]`, N                | `var [], for, push, return []`           |
| filter       | `[]`, N        | `[]`, M < N            | `var [], for, if, push, return []`       |
| reduce       | `[]`           | `{}`, `[]`, whatever,… | `var [], for, if, push, return {}`       |
| reduceRight  | `[]`           | `{}`, `[]`, whatever,… | `var [], for (i--), if, push, return {}` |
| some         | `[]`           | boolean                | `var b, for, if return true`             |
| every        | `[]`           | boolean                | `var b, for, if return false`            |
| forEach      | `[]`           |                        | `for`                                    |
|              |                |                        |                                          |
| find         | `[]` of items  | item                   | `for, if return a[i]; return;`           |
| fill         | `[]`, item     | `[]` of items          | `var [], for, push, return []`           |
| from         | `[]`, iterable | `[]`                   | `var [], for, push, return []`           |

- over **index** from `0` to `length - 1` (vsetky polozky)
    - ostatne
- over **defined** array keys (iba definovane polozky)
    - `Array.prototype.indexOf()`
    - `Array.prototype.lastIndexOf()`
    - `Array.prototype.map()`* – but returns length
    - `Array.prototype.filter()`
    - `Array.prototype.reduce()`
    - `Array.prototype.reduceRight()`
    - `Array.prototype.some()`
    - `Array.prototype.every()`
    - `Array.prototype.forEach()`

## Composition vs. Pipeline
- In computer science, function composition is an act or mechanism to combine simple functions to build more complicated ones. 
- **Composition** of functions deals with **finite data and sequential execution**.
- when speaking about **infinite data** (e.g. streams) and possibly **parallel processing** we call it **pipeline**.

```js
const compose = (f1, f2) => value => f1(f2(value));
const compose = (f1, f2, f3, f4) => value => f1(f2(f3(f4(value))));
```

## Pure functions
Function cannot depend on any mutable state.

### Bad - dependency on: 
- captured let, var 
- captured const but with with mutable value
- dependency on mutable or impure function
- methods are impure by definition

```js
function(n, options) {
    return n < options.limit;
}

var LIMIT = 100;
function below(n) {
    return n < LIMIT;
}

const constants = { LIMIT: 100 };
function below(n) {
    return n < constants.LIMIT;
}

let LIMIT = () => 100;
function below(n) {
    return n < LIMIT();
}

function below(n) {
    conosle.log(n);
    return n < LIMIT();
}
```

### Ok – dependency on:
- no captured variables
- captured primitive const
- captured frozen object const
- on constant and pure function
- on immutable captured argument

```js
function below(n, limit) {
    return n < limit;
}

function below(n) {
    var LIMIT = 100;
    return n < LIMIT;
}

const LIMIT = 100;
function below(n) {
    return n < LIMIT;
}

const LIMIT = () => 100;
function below(n) {
    return n < LIMIT();
}

function below(limit) {
    return function(n) {
        return n < limit;
    }
}
below(100)(10);
```

**Referential transparency**: The function always gives the same return value for the same arguments. This means that the function cannot depend on any mutable state.

**Side-effect free**: The function cannot cause any side effects. Side effects may include I/O (e.g., writing to the console or a log file), modifying a mutable object, reassigning a variable, etc.

## High order functions
Higher order function is a function that does one of or both:
- takes a **function as an argument**
- returns **function**

### Both
```js
var f1 = function(exec) {
    return function() {
        exec();
    }
}

f1(() => console.log("done"))();
```

### Function as Argument
```js
setTimeout(function(){ /* ... */ }, 0)
```

- callback of async task
- parametrized algorithms
    - namiesto vymýšlania mien funkcii a wrapovania funkcionality, vymýšlame názvy replacerov, filtrov, comparatorov a reusujeme ich. `replaceSpaces(str) => str.replace(spaces,"-")`
- transforming function 
    - change signature, bind parameters, change context, add functionality (aspects), curry
- parametrized iterations
    - repeat, until, whilst

### Functions Returning Functions
Transform one function somehow: change signature, bind parameters, change context, add functionality (aspects). Curry..

## Transforming Functions
Create new function, call the original.

```js
function orig1(b, c) { return b + c; }
function orig1(x, y, z) { return x * y * z; }

function wrap(fn) {
    return function(newParam, ...originalParams) {
        console.log(newParam);
        return fn.apply(null, originalParams);
    }
}

const wrapped1 = wrap(orig1);
const wrapped2 = wrap(orig2);

wrapped1("test1", 1, 2) // 3
wrapped1("test1", 1, 2, 3); // 6
```

## Immutability
By default things are **mutable** in JS. An **immutable object** is an object whose state cannot be modified after it is created. 

- **Shared state** is *fine* if it is immutable.
- **Mutable state** is *fine* if it is not shared.

### Immutable
```js
var name = "Bill";
var full_name = name.concat(" Gates");

name; // Bill
full_name; // Bill Gates
```

### Mutable
```js
var arr = [1];
var new_arr = arr.push(2);

arr; // [1, 2]
new_arr; // 2 (arr.legth)
```

### How to acheive immutability?
- Primitive data types are immutable. 
- Special userland structures (maps, sets).
- Copy object to change property value.
- Clone array to add, remove or modify items.

#### Constant variable
`const` applies to bindings ("variables"). It creates an immutable binding, i.e. you cannot assign a new value to the binding.
```js
const object1 = {};
const object2 = {};

object1 = object2; // TypeError: Assignment to constant variable.
```

#### Frozen objects
The `Object.freeze()` method freezes an object. A frozen object can no longer be changed.
```js
const object1 = {
  property1: 42
};

const object2 = Object.freeze(object1);

object2.property1 = 33; // Throws an error in strict mode

console.log(object2.property1); // expected output: 42
```

## Object Manipulation
- modify/add property
- remove/clear property
- whitelist/blacklist properties
- clone object (shallow/deep)
- merge objects (shallow/deep)
- traversing objects

### Modify / Add / Remove Property

**Problem:**
```js
const object1 = {
  property1: 42
};

const object2 = object1;

// Add / Modify property
object2.property2 = 9;

object2.property2; // 9
object1.property2; // 9

// Delete property
delete object1.property1;
object2.property1; // undefined

object1 == object2; // both variables point to same objects.
```

**Solution**
```js
const object1 = {
  property1: 42
};

const object2 = { ...object1};
// OR
const object2 = Object.assign({}, oobject1};

// Add / Modify property
object2.property2 = 9;

object2.property2; // 9
object1.property2; // undefined

// Delete property
delete object1.property1;
object2.property1; // 42

object1 != object2; // variables point to different objects.
```

### Whitelist / Blacklist properties

#### Whitelist
Destructure wanted properties (do not mention others) and return object with property shorthand syntax.

```js
const object1 = {
  a: 'a',
  b: 'b',
  c: 'c'
};

let { a, b } = object1;
const object2 = { a, b };

/*
object2 = {
  a: 'a',
  b: 'b'
}
*/
```

#### Blacklist
Destructure object, name blacklisted properties explicitly, and spread ...rest to returned object.

```js
const object1 = {
  a: 'a',
  b: 'b',
  c: 'c'
};

let { a, ...allowed } = object1;
const object2 = { ...allowed };

/*
object2 = {
  b: 'b',
  c: 'c'
}
*/
```

### Cloning

#### Shallow copy
Nested properties are still going to be copied by reference.

```js
let object1 = { a: 42 }; // ...
let object2 = Object.assign({}, object1);
```

#### Deep copy
A deep copy will duplicate every object it encounters. The copy and the original object will not share anything, so it will be a copy of the original.

```js
let object1 = { a: 42 }; // ...
let object1 = JSON.parse(JSON.stringify(object1));
```

`Object.assign()` can be used to copy methods while `JSON.parse(JSON.stringify(obj))` can't be used.

### Traversal
ES has no traversal algorithms build in, except for:
- **JSON.parse**: post order
- **JSON.stringify**: pre order

Process of visiting (checking and/or updating) each node in a tree data structure, exactly once. 

```js
var o = { 
    foo: "bar",
    arr: [1,2,3],
    subo: {
        foo2:"bar2"
    }
};

// called with every property and its value
function process(key, value) {
    console.log(key + " : " + value);
}

function traverse(o, func) {
    for (var i in o) {
        func.apply(this, [i, o[i]]);  
        if (o[i] !== null && typeof(o[i]) == "object") {
            // going one step down in the object tree!!
            traverse(o[i],func);
        }
    }
}

traverse(o, process);
/*
foo : bar
arr : 1,2,3
0 : 1
1 : 2
2 : 3
subo : [object Object]
foo2 : bar2
*/
```

## Rekurzia
```js
function countDown(n) {
    if (n == 0) return;
    else countDown(n - 1)
}

countDown(10);
```

Types of recursion
- Single recursion and multiple recursion.
- Indirect recursion.
- Anonymous recursion.
- Structural versus generative recursion.

## Partial Function
Partial application is the act of taking a function which takes multiple arguments, and “locking in” some of those arguments, producing a function which takes fewer arguments.

```js
>>> var add = function(a, b) { return a + b; };
>>> add(5, 4);
9
>>> var add5 = function(b) { return add(5, b); }
>>> add5(4)
9
```

### Bind
ECMAScript 5 introduced `bind()` which brings (among other things) native partially applied functions to JavaScript.

```js
function add(a,b,c) {
    return a + b + c;
}
```

This is how you partial it using `bind()`.

```js
var intermediate = add.bind(undefined, 1, 2);
var result = intermediate(3); // 6
```

The first argument to `bind()` actually sets the infamous this context of the function. We can leave it undefined here, since it has no effect.

## Curried Function
A function that will return a new function until it receives all it's arguments.

```js
>>> var add = wu.autoCurry(function(a, b, c) { return a + b + c; });
>>> add(1)(1)(1)
3
>>> add(1)()(1)()(1)
3
>>> add(1)(1, 1)
3
>>> add(1, 1, 1)
3
```
