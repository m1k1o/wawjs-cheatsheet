# Prehľad

- [01 Platforma & node a npm](#anchor_1)
- [02 Jazyk](#anchor_2)
- [03 Funkcie](#anchor_3)
- [04 Objekty](#anchor_4)
- [05 Patterny](#anchor_5)
- [06 Funkcionálne prog.](#anchor_6)
- [07 Streamy](#anchor_7)
- [08 Async](#anchor_8)
- [09 Testing](#anchor_9)
# <a name="anchor_1"></a> 1 Platforma & node a npm

Ako sa volá JS runtime s najnovšou verziou Javy?
- Neexistuje (s VS8 je nashorn, rhino a ďalšie pre staršie verzie...)

Čo to je traceur?
- Traceur is a JavaScript.next-to-JavaScript-of-today compiler.

Kde sú alokované všetky JS objekty?
- Heap je vo V8 (okrem bufferov, node ma na ne vlastny heap).

Event loop
- stack, program, node, lib uv, queue, stack...

```
Zjednodušený (nekompletný) event loop.

   ┌───────────────────────────┐
┌─>│ setTimeout / setInterval  │
│  └─────────────┬─────────────┘      ┌───────────────┐
│  ┌─────────────┴─────────────┐      │   incoming:   │
│  │           poll            │<─────┤  connections, │
│  └─────────────┬─────────────┘      │   data, etc.  │
│  ┌─────────────┴─────────────┐      └───────────────┘
│  │        setImmediate       │
│  └─────────────┬─────────────┘
│  ┌─────────────┴─────────────┐
└──┤      close callbacks      │
   └───────────────────────────┘
```

## Core modules and APIs

### Functionality

| Networking   | Filesystem | Processes     |
|--------------|------------|---------------|
| http         | fs\*       | child_process |
| http2        |            | process       |
| https        |            |               |
| net          |            |               |
| dgram        |            |               |
| dns\*        |            |               |

*promises API.

### Concepts
- events
- stream
- buffer

### libuv
- event loop
- network I/O
- file I/O
- epoll, kqueue, event ports, iocp, ...
- thread pool

## npm

### package.json
Originaly designed for dependecies, **Now** everything.

```json
{
  "name": "my_package",
  "description": "",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "repository": {
    "type": "git",
    "url": "https://github.com/sample_user/my_package.git"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "bugs": {
    "url": "https://github.com/sample_user/my_package/issues"
  },
  "homepage": "https://github.com/sample_user/my_package"
}
```
### Versioning
```
MAJOR.MINOR.PATCH
  1  .  0  .  4 
  -- releases --
  *  .  ^  .  ~ 
  x  . 1.x . 1.0.x
```

### Commands

| Command          | Description                   |
|------------------|-------------------------------|
| `npm test`       | Test a package                |
| `npm run`        | Run arbitrary package scripts |
|                                                  |
| `npm init`       | create a package.json file    |
| `npm start`      | Start a package               |
| `npm stop`       | Stop a package                |
| `npm restart`    | Restart a package             |
|                  |                               |
| `npm ls`         | List installed packages       |
| `npm outdated`   | Check for outdated packages   |
|                  |                               |
| `npm install`    | Install a package             |
| `npm update`     | Update a package              |
| `npm uninstall`  | Remove a package              |
# <a name="anchor_2"></a> 2 Jazyk

- statements
- functions
- objects

## Using Logical Operators with Non-Boolean Values
The value produced by a `&&` or `||` operator is not necessarily of type Boolean. The value produced will always be the value of one of the two operand expressions.

```js
"foo" && "bar"; // "bar"
"bar" && "foo"; // "foo"
"foo" && "";    // ""
""    && "foo"; // ""

"foo" || "bar"; // "foo"
"bar" || "foo"; // "bar"
"foo" || "";    // "foo"
""    || "foo"; // "foo"
```

Both `&&` and `||` result in the value of (exactly) one of their operands:
- `A && B` returns the value **A** if **A** can be coerced into `false`; otherwise, it returns **B**.
- `A || B` returns the value **A** if **A** can be coerced into `true`; otherwise, it returns **B**.

## JavaScript data types and data structures

### Data Types
- Primitives
    - undefined
    - null
    - symbol\*
    - string\*
    - number\*
    - boolean\*
- Object
    - Function *(Functions are regular objects with the additional capability of being callable.)*
    - Symbol\*
    - String\*
    - Number\*
    - Boolean\*
    - Date
    - RegExp
    - Array
    - Set
    - Map
    - ...

\* Define methods of primitives. Perform explicit conversion.

https://developer.mozilla.org/en-US/docs/Web/JavaScript/Data_structures

### Data Structures
- ArrayBuffer
- DataView
- Int*Array
- UInt*Array
- Float*Array

https://developer.mozilla.org/en-US/docs/Web/JavaScript/Typed_Arrays

## Coercion

    undefined  =>              => number
    null       =>              => string
    boolean    =>  operation   => boolean
    number     =>  or context  => 
    string     =>              => 
    object     =>              => 

### toString

#### Explicit
```js
String(undefined)   // 'undefined'
String(null)        // 'null'
String(123)         // '123'
String(-12.3)       // '-12.3'
String(true)        // 'true'
String(false)       // 'false'
String(Symbol('s')) // 'Symbol('s')'
```

#### Implicit - triggred by:

```js
// A) binary + operator, left or right is a string.
"..." + undefined   // '...undefined'
"..." + null        // '...null'
"..." + 123         // '...123'
"..." + -12.3       // '...-12.3'
"..." + true        // '...true'
"..." + false       // '...false'

"..." + Symbol('s') // TypeError:

// B) template literal substitution
`...${undefined}`
```

`==` never triggers ToString conversion. `str1 == str2` performs `str1 === str2`.

### toNumber

#### Explicit

```js
Nubmer(undefined)   // NaN
Nubmer(null)        // 0
Nubmer(" 123 ")     // 12
Nubmer("-12.34")    // -12.34
Nubmer("\n")        // 0
Nubmer(" 12s ")     // NaN
Nubmer(123)         // 123
Nubmer(true)        // 1
Nubmer(false)       // 0
Nubmer(Symbol('s')) // TypeError:
```

#### Implicit - triggred by:

```js
// A) unary + operator
+"123"

// B) arithmetic operators (- + * / %)
3 * "10"
5 / null

// C) comparsions operators (> < <= >=)
4 > "5"

// D) bitwise operators (| & ^ ~)
true | 0
~ -1

// E) loose equality operator (== !=)
123 != "456"
    // number compared with string or boolean
    // NaN != NaN

// border cases
0 == null      // false
0 == undefined // false
```

### toBoolean

#### Explicit

```js
// Falsy values
Boolean(undefined) // false
Boolean(null)      // false
Boolean("")        // false
Boolean(0)         // false
Boolean(-0)        // false
Boolean(NaN)       // false
Boolean(false)     // false

// All other primitive values or objects
Boolean("false")  // true
Boolean(1)        // true
```

#### Implicit - triggred by:
```js
// A) logical operator !
!!2
!~-1

// B) logical operators || &&
let x = 'hello' && 123; // x === 123
let p = p || (p = 1);   // x === 123

// C) logical boolean context (for, if, while...)
if(''){}                // cond.: false
if(2){}                 // cond.: true
'slon' ? 1000 : 10      // cond.: true

// D) loose equality operator (==, !=)
// 
10 == true

```

`bool1 == bool2` performs `bool1 === bool2`.

## Variable declaration & Scoping
- var, let, const
- Scope
- Hoisting
- Mutability
    - let, var
    - const
- Scope (Lexical Environment)
    - var - function or global
    - let, const - block, function, global

## Equality

|                   |                              |
|-------------------|------------------------------|
| `a == b`          | Abstract Equality Comparison |
| `a === b`         | Strict Equality Comparison   |
| `[a].includes(b)` | SameValueZero                |
| `Object.is(a, b)` | SameValue                    |

https://developer.mozilla.org/en-US/docs/Web/JavaScript/Equality_comparisons_and_sameness

```js
/* Abstract Equality Comparison */
       undefined == null         // true
              10 == "10"         // true
               0 == []           // true
       
              10 == 10           // true
             NaN == NaN          // false
               0 == -0           // true
       
          [1, 2] == [1, 2]       // false
              {} == {}           // false

/* Strict Equality Comparison */
       undefined === null        // false <==
              10 === "10"        // false <==
               0 === []          // false <==

              10 === 10          // true
             NaN === NaN         // false
               0 === -0          // true

          [1, 2] === [1, 2]      // false
              {} === {}          // false

/* SameValueZero */
[ undefined ].includes( null   ) // false
[        10 ].includes( "10"   ) // false
[         0 ].includes( []     ) // false

[        10 ].includes( 10     ) // true
[       NaN ].includes( NaN    ) // true  <==
[         0 ].includes( -0     ) // true

[    [1, 2] ].includes( [1, 2] ) // false
[        {} ].includes( {}     ) // false

/* SameValue */
Object.is(undefined, null   )    // false
Object.is(       10, "10"   )    // false
Object.is(        0, []     )    // false

Object.is(       10, 10     )    // true
Object.is(      NaN, NaN    )    // true
Object.is(        0, -0     )    // false <==

Object.is(   [1, 2], [1, 2] )    // false
Object.is(       {}, {}     )    // false
```

### Equality Matrix

`a == b` - Abstract Equality Comparison

|             | `undefined` | `null`      | `"0"`       | `0`         | `-0`        | `NaN`       |
|-------------|-------------|-------------|-------------|-------------|-------------|-------------|
| `undefined` |   `true`    |   `true`    |    false    |    false    |    false    |    false    |
| `null`      |   `true`    |   `true`    |    false    |    false    |    false    |    false    |
| `"0"`       |    false    |    false    |   `true`    |   `true`    |   `true`    |    false    |
| `0`         |    false    |    false    |   `true`    |   `true`    |   `true`    |    false    |
| `-0`        |    false    |    false    |   `true`    |   `true`    |   `true`    |    false    |
| `NaN`       |    false    |    false    |    false    |    false    |    false    |    false    |

`a === b - Strict Equality Comparison`

|             | `undefined` | `null`      | `"0"`       | `0`         | `-0`        | `NaN`       |
|-------------|-------------|-------------|-------------|-------------|-------------|-------------|
| `undefined` |   `true`    |    false    |    false    |    false    |    false    |    false    |
| `null`      |    false    |   `true`    |    false    |    false    |    false    |    false    |
| `"0"`       |    false    |    false    |   `true`    |    false    |    false    |    false    |
| `0`         |    false    |    false    |    false    |   `true`    |   `true`    |    false    |
| `-0`        |    false    |    false    |    false    |   `true`    |   `true`    |    false    |
| `NaN`       |    false    |    false    |    false    |    false    |    false    |    false    |

`[a].includes(b)` - SameValueZero

|             | `undefined` | `null`      | `"0"`       | `0`         | `-0`        | `NaN`       |
|-------------|-------------|-------------|-------------|-------------|-------------|-------------|
| `undefined` |   `true`    |    false    |    false    |    false    |    false    |    false    |
| `null`      |    false    |   `true`    |    false    |    false    |    false    |    false    |
| `"0"`       |    false    |    false    |   `true`    |    false    |    false    |    false    |
| `0`         |    false    |    false    |    false    |   `true`    |   `true`    |    false    |
| `-0`        |    false    |    false    |    false    |   `true`    |   `true`    |    false    |
| `NaN`       |    false    |    false    |    false    |    false    |    false    |   `true`    |

`Object.is(a, b)` - SameValue

|             | `undefined` | `null`      | `"0"`       | `0`         | `-0`        | `NaN`       |
|-------------|-------------|-------------|-------------|-------------|-------------|-------------|
| `undefined` |   `true`    |    false    |    false    |    false    |    false    |    false    |
| `null`      |    false    |   `true`    |    false    |    false    |    false    |    false    |
| `"0"`       |    false    |    false    |   `true`    |    false    |    false    |    false    |
| `0`         |    false    |    false    |    false    |   `true`    |    false    |    false    |
| `-0`        |    false    |    false    |    false    |    false    |   `true`    |    false    |
| `NaN`       |    false    |    false    |    false    |    false    |    false    |   `true`    |

## Language Evolution

- **ES 5. 5.1 (2009, 2011)**
  - Array functions (filter, map, reduce,...)
- **ES 2015 (6th)**
  - Promise, Generators
  - Arrow functions
- **ES 2017 (8th)**
  - Async Functions, await operator
- **ES 2018 (9th)**
  - Promise.prototype.finally()
# <a name="anchor_3"></a> 3 Funkcie

## Function declaration

```js
function add(num1, num2) {
	return num1 + num2;
}
```

## Function expression

```js
var add = function (num1, num2) {
	return num1 + num2;
};
```

## Arrow function

```js
var add = (num1, num2) => num1 + num2;
```

Arrow functions are anonymous and change the way `this` binds in functions.

```js
let Object2 = {
    method1: function() {
        this === Object2;

        setTimeout(function() {
            this !== Object2;
        }, 0);

        setTimeout(() => {
            this === Object2;
        }, 0);
    },
    method2: () => {
        this !== Object2;
    }
}
```

## Primary unit of execution
- **evented** - event handling code is written as function.
- only one function executed at the time (stack, event loop)
- **run-to-completion** – whole function is executed (na stacu kym nedobehne).

## Parametre, Argumenty
### Parameter
- to čo je v definícii funkcie
- optional
- have no type

```js
function fn(a, b, c) {
    return a + b + c;
}
const fn = function(a, b, c) {
    return a + b + c;
}
const fn = (a, b, c) => a + b + c;
```

#### Rest Parametre
- Rest parameter must be last formal parameter.

```js
function f4(a, b, c, ...others) {
    return a * b * c *
        others.reduce((p, c) => p * c, 1);
}
```

#### Default Parametre

```js
function f2(a, b = 1, c = 1) {
    return a * b * c;
}

// < ES 2015
function f2(a, b , c ) {
    b == undefined && (b = 1);
    c == undefined && (c = 1);
    return a * b * c;
}
```

### Argument
- to čo je vo volaní funkcie 
- special keyword

```js
fn(10, 20, 30);
fn(10); // b,c is undefined
fn(); // a,b,c is undefined
fn(10, 20, 30, 40) // 40 is accessible by arguments[3]
```

## First class object
- vsade kde sa da pouzit objekt tam sa da pouzit aj funkcia.
- vsetko co sa da spravit s objektom sa da spravit aj s funkciou.

```js
var o = {};     /**/   var o = function() { /*...*/ };
var o1 = {};    /**/   var o1 = function() { /*...*/ };
arr[3] = {};    /**/   arr[3] = function() { /*...*/ };
arr.push({});   /**/   arr.push(function() { /*...*/ });
o1.data = {};   /**/   o1.data = function() { /*...*/ };
```
## this
### Objektovo Orientovane programovanie
- In OO objects have behavior (methods)
- We call methods on specific objects.
- Context is enclosing/parent object.

```js
let john = {
    name: "John",
    greet() { return this.name; }
};
let jane = {
    name: "Jane",
    greet() { return this.name; }
};

john.greet();
jane.greet();
```

### Funkcionalne programovanie
- In FP objects are pure data.
- We call function with specific objects (context).
- Context is what we decide when invoking function.

```js
// data
let john = {
    name: "John"
};
let jane = {
    name: "Jane"
};

// behavior
function greet() { return this.name; }

greet.call(john);
greet.call(jane);
```

### this in Arrow function
```js
function Person(){
  this.age = 0;

  setInterval(() => {
    this.age++; // |this| properly refers to the Person object
  }, 1000);
}

var p = new Person();
```

### this in Constructor
- Constructor is just normal function to be used with `new` keyword.
- `this` is bound to the new object being constructed.
- To prevent constructor to be used without new, `use strict` mode.
- `ArrowFunctionExpression` is not usable as constructor.

```js
'use strict';

function Person(name) {
    this.name = name;
    this.greet = function() {
        return "I'm " + this.name;
    }
    //return this;
}

var p1 = new Person('james');

p1.name; // james
p1.greet(); // I'm james

// incorrect usage
var p2 = Person('james');

p2.name; // 'name' of undefined
p2.greet(); // 'greet' of undefined
```

## Hoisting
All of the functions written with **function declarations** are “known” before any code is run. This allows you to call a function before you declare.

```js
/**
 * This works!
 */
function add(num1, num2) {
	return num1 + num2;
}
add(3, 3); // returns 6


/**
 * This does, too!
 */
substract(7, 4); // returns 3
function subtract(num1, num2) {
	return num1 - num2;
}
```

When declared with a **function expression**, functions are not hoisted to the top of the current scope.

```js
substract(7, 4); // returns Uncaught TypeError: subtract is not a function
var subtract = function (num1, num2) {
	return num1 - num2;
};
```

## Scope
- Ake premenne a funkcie „vidim“ / “mam dostupne“ v danom kuse kodu.
- A scope in JavaScript defines what variables you have access to.

### Global scope
```js
const globalVariable = 'global value'

function func() {
    console.log(globalVariable)
}

console.log(globalVariable) // 'global value'
func() // 'global value'
```

### Local Scope - Function scope
When you declare a variable in a function, you can access this variable only within the function. You can't get this variable once you get out of it.

- Functions do not have access to each other's scopes

```js
function func() {
    const localVariable = 'local value'
    console.log(localVariable)
}

func() // 'local value'
console.log(localVariable) // Error, localVariable is not defined
```

### Local scope - Block scope
When you declare a variable with `const` or `let` within a curly brace (`{}`), you can access this variable only within that curly brace.

```js
{
    const localVariable = 'local value'
    var globalVariable = 'global value'
    console.log(localVariable)
}

console.log(localVariable) // Error, localVariable is not defined
console.log(globalVariable) // 'global value'
```

### Nested scopes
```js
function outerFunction () {
  const outer = `I'm the outer function!`

  function innerFunction() {
    const inner = `I'm the inner function!`
    console.log(outer) // I'm the outer function!
  }

  console.log(inner) // Error, inner is not defined
}
```

## Closures
> fenomen JS, ze funkcia na tom mieste kde je zadefinovava, si uklada pointre.

```js
function outerFunction () {
  const outer = `I see the outer variable!`

  function innerFunction() {
    console.log(outer)
  }

  return innerFunction
}

outerFunction()() // I see the outer variable!
```

## Lexical Environment
> Zoznam identifikátorov definovaných v danom scope a linka na outer scope environment.

Lexical Environment is the environment of the function where it is written. That is, the static order/place where it is situated, regardless from where it is called from.
# <a name="anchor_4"></a> 4 Objekty
- JS *DOES NOT* have **classes**
  - It is syntactic sugar over prototypes.
- JS have **decorators**
  - On those classes.
- JS have **getters** and **setters**
  - On those classes, and on objects.
- JS *DOES NOT* have **packages** or **namespaces**
  - We just simulate them with modules and returned objects.
- JS *DOES NOT* have **aspects**
  - We just simulate them with functional concepts.
- JS *DOES NOT* have **multiple class inheritance**
  - Do we really need this ? **in JS you don't need classes nor prototypes to create object**.

## Prototypes

> JavaScript objects are dynamic "bags" of properties (referred to as own properties). JavaScript objects have a link to a prototype object. When trying to access a property of an object, the property will not only be sought on the object but on the prototype of the object, the prototype of the prototype, and so on until either a property with a matching name is found or the end of the prototype chain is reached. (MDN)

```js
const Car = function(color, model, dateManufactured) {
    this.color = color;
    this.model = model;
    this.dateManufactured = dateManufactured;
}
Car.prototype.getColor = function() {
    return this.color;
}
Car.prototype.getModel = function() {
    return this.model;
}
Car.prototype.carDate = function() {
    return `This ${this.model} was manufactured in the year ${this.dateManufactured}`
}

let firstCar = new Car('red', 'Ferrari', '1985');
console.log(firstCar);
console.log(firstCar.carDate()); // This Ferrari was manufactured in the year 1985.
```

## Writable, Enumerable, Configurable
`Object.defineProperty`, `Object.create` methods allows a precise addition to or modification of a property on an object.

- **readonly** properties
- **non enumerable** (hidden) properties, ktoré sa neobjavia pri enumerácií pomocou `for in` alebo `Object.keys()`.
- **configurable**, nedajú sa zmazať ani zmeniť ich správanie.

```js
const object1 = {};

Object.defineProperty(object1, 'property1', {
  value: 42,
  writable: false,
  enumerable: false,
  configurable: false
});

object1.property1 = 77; // throws an error in strict mode
```

https://developer.mozilla.org/en-US/docs/Web/JavaScript/Enumerability_and_ownership_of_properties

## Getters, Setters
- `Object.defineProperty` is one of the ways to define setters and getters.
- You cannot set the same property as the name of setter.

```js
const o = {
    firstName: "John"
};

Object.defineProperty(o, 'age', {
    set: function(val) {
        if(!Number.isInteger(val)) {
            throw new TypeError('age must be integer');
        }

        this._age = val;
    },
    get: function() {
        return this._age;
    },
    enumerable: true
});

o.age = 20;
o.age = "slon"; // TypeError: age must be integer

/* o */
{
    "firstName": "John",
    "age": 20,
    "_age": 20
}
```

## Symbols
- The data type "symbol" is a **primitive data type**.
- This data type is used as the key for an object property when the property is intended to be **private, for the internal use** of a class or an object type
- When a symbol value is used as the identifier in a property assignment, the property (like the symbol) is anonymous; and also is **non-enumerable**. 
- non-emuberable means it will not show in for( ... in ...)", 
- anonymous, it will not show up in the result array of `Object.getOwnPropertyNames()`.

```js
const o = {
    firstName: "John"
};

const kAge = Symbol("age");
Object.defineProperty(o, 'age', {
    set: function(val) {
        if(!Number.isInteger(val)) {
            throw new TypeError('age must be integer');
        }

        this[kAge] = val;
    },
    get: function() {
        return this[kAge];
    },
    enumerable: true
});

o.age = 20;
o.age = "slon"; // TypeError: age must be integer

{
    "firstName": "John",
    "age": 20
}
```

## Introspection
- In computing, type introspection is the ability of a program to **examine the type or properties of an object at runtime**.

### Enumerability
An enumerable property is one that can be included in and visited during `for..in` loops or a similar iteration of properties, like:
- `Object.keys()`
- `Object.entries()`
- `Object.values()`
- `Object.assign()`
- `JSON.stringify()`

The `obj.propertyIsEnumerable()` method returns a Boolean indicating whether the specified property is enumerable.

### Ownership
Ownership of properties is determined by whether the property belongs to the object directly and not to its prototype chain.
- `Object.getOwnPropertyNames()`
- `Object.getOwnPropertySymbols()`
- `Object.getOwnPropertyDescriptors()`

The `obj.hasOwnProperty()` method returns a boolean indicating whether the object has the specified property as its own property (as opposed to inheriting it).

```js
var o = {
    firstName: "John",
    age: 20
};

for (let k in o) {
    conosle.log(l);
}

/*
firstName
age
*/

var e = Object.create(o);
e.job = "programmer";

for (let k in e) {
    conosle.log(k);
}

/*
job
firstName
age
*/

for (let k in e) {
    if(e.hasOwnProperty(k)) {
        conosle.log(k);
    }
}

/*
job
*/
```
# <a name="anchor_5"></a> 5 Patterny

## sync

### Imperativny, Sekvencny
```js
const fs = require("fs");

let data = fs.readFileSync(from);
fs.writeFileSync(to, data);

console.log("done");
```

#### Error handling
- Nevyzaduje nic (unchecked exceptions).
- Unhandled exceptions crash js runtime.
- `throw new Error()`.

```js
try {
    let data = fs.readFileSync(from);
    fs.writeFileSync(to, data);
} catch (err) {
    /* ... */
} finally {
    /* ... */
}
```

## async

### Event-driven (OO, statefull)
```js
const fs = require("fs");
const stream = fs.createReadStream(from)

stream.on("data", (chunk) => {
    fs.appendFileSync(to, chunk);
});

stream.on("end", () => {
    console.log("done");
});
```

#### Error handling
- Spravidla event s nazvom `error`.
- Unchecked exceptions crash process (default error handler je `throw` exception).

```js
stream.on("error", (err) => {
    /* ... */
});
```

#### try..catch nefunguje
- synchrónne errory z inicializácie objektu

```js
try {
    const stream = fs.createReadStream(from);     // <==
    stream.on("data", (chunk) => { /* ... */ });
    stream.on("end", () => { /* ... */ });
    stream.on("error", (err) => { /* ... */ });
} catch (err) {

}
```

### Callbacks (F, stateless)
```js
const fs = require("fs");

fs.readFile(from, (err, data) => {
    if (err) { /* */ return; }
    fs.writeFile(to, data, (err) => {
        if (err) { /* */ return; }

        console.log("done");
    });
});
```

#### Error handling
- this style forces you to deal with errors.
- if you don't deal with them, then rest of your code will fail with obscure error or produce buggy results.

```js
if (err) { /* */ return; }
```

### Promises (stateless)
```js
const fs = require("fs").promises;
const promise = fs.readFile(from);

promise.then((data) => {
    return fs.writeFile(to, data);
});
promise.then(() => {
    console.log("done");
});
```

#### Error handling
- Errors thrown from functions in `then(f)` are catched as well.

```js
promise.catch((err) => {
    /* ... */
});
promise.finally(() => {
    /* ... */
});
```

`p.then(onFulfilled[, onRejected])`
- onFulfilled - next step.
- onRejected - error handler for previous step (same as `(err, data)` in callbacks).

```js
promise.then((data) => {
    /* ... */
}, (err) => {
    /* ... */
});
```

## Streams (pipe)
```js
const fs = require("fs");

fs.createReadStream(from)
    .pipe(fs.createWriteStream(to))
    .on("finish", () => {
        console.log("done");
    });
```

#### Error handling
- Pomocou eventov nad streamami.
- `try..catch` okolo pipe nefunguje (je to async call).
- Problematicky Finally - Tak ako u eventov musime mat spolocnu vetvu v `on(error)` a `on(finish)`.

```js
const fs = require("fs");

const readable = fs.createReadStream(from);
const writable = fs.createWriteStream(to);

readable.on("error", (err) => {
    /* ... */
});
writable.on("error", (err) => {
    /* ... */
});

readable
    .pipe(writable)
    .on("finish", () => {
        console.log("done");
    });
```

`stream.pipeline(...streams, callback)`

A module method to pipe between streams forwarding errors and properly cleaning up and provide a callback when the pipeline is complete.

`stream.finished(stream[, options], callback)`

A function to get notified when a stream is no longer readable, writable or has experienced an error or a premature close event.

## Module Pattern
Global namespace variable (`$, jQuery, dojo, ...`).

```js
var mylib = {};

(function(){
    var counter = 0;

    function increment() {
        return counter++;
    }

    mylib.increment = increment;
}());

mylib.add = (function() {
    return function(x, y) {
        return x + y;
    };
}())
```

### CommonJS (node.js modules)
- `exports` variable, or `module.exports`.
- `require()` function to load dependencies.
- Sync load and execution.
- Dynamic module structure.

```js
// library source code
var counter = 0;

function increment() {
    return counter++;
}

exports.increment = increment;
exports.add = function(x, y) {
    return x + y;
};

/*
module.exports = {
    increment,
    add
};
*/
```

```js
// usage code
var mylib = require("./mylib.cjs.js");

console.log(mylib.increment());
```
### ESM
- `export` statement: `export default` or named..
- `import` statement.
- Sync / async loading.
- Static module structure.

```js
// library source code
var counter = 0;

function increment() {
    return counter++;
}

export {increment};

export const add = function(x, y) {
    return x + y;
};

/*
export default {
    increment,
    add
};
*/
```

```js
// usage code
import * as mylib from "./mylib.mjs";

console.log(mylib.increment());
```

## Creation Method Pattern
```js
// library source code
function Caseless(dict) {
    this.dict = dict || {};
}
Caseless.prototype.set = function( /* ... */ ) {}
Caseless.prototype.get = function(name) {}

module.exports = function(dict) {  // <==
    return new Caseless(dict);     // <==
}                                  // <==
```

```js
// usage code
var caseless = require("caseless");
var o = /*new*/ caseless({ "A": 10, "b": 20 });
o.get("a");
```

## Creation Method Pattern vs. Module Pattern

### Module Pattern
```js
var mylib = {};

(function(){
    /* ... */

    mylib = ;
}());

mylib.add = (function() {
    /* ... */

    return ;
}())
```

### Creation Method Pattern
```js
function mylib() {
    /* ... */
}
Caseless.prototype.add = /* ... */;
```

## Optional parametes (combinations)
```js
// usage:
// func(add1, add2, multiply);
// OR
// func(add1, multiply);

function func(add1, add2, multiply) {
    if(typeof multiply === 'undefined')
        multiply = add2;
        add2 = 0;
    }

    return (add1 + add2) * multiply;
}
```

## Polyfill, Shim
- A **shim** is a library, that brings a new API to an older environment, using only the means of that environment.
- A **polyfill** is a shim for a browser API. It typically checks if a browser supports an API. If it doesn’t, the polyfill installs its own implementation. That allows you to use the API in either case.

```js
var isArray = Array.isArray || function isArray(obj) {
    return toStr(obj) === '[object Array]';
};
```
# <a name="anchor_6"></a> 6 Funkcionálne programovanie

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
# <a name="anchor_7"></a> 7 Streamy
- Načo sú nám streamy a čo sú to streamy
- Čo to znamená programovať streamovo
- Aké streamy máme v node.js
- Ako fungujú streamy v node.js
  - Backpresure, buffering
- Ako používať/nepoužívať streamy
  - Čitanie
  - Zápis
  - Tranformácie
- Streams API vs. PIPE 

## Types of streams
- **Readable** - môžeme z nich čítať
- **Writable** - môžeme do nich zapisovať.
- Duplex - aj čítať aj zapisovať.
- **Transform** - špeciálny prípad duplexu, transformujúci všetky vstupy.

## Pipe
Use of `readable.pipe()` method is reccomended for most users as it has been implemented to provide the easiest way of consuming stream.

```js
const readable = require('stream').Readable;
const transform = require('stream').Transform;
const writable = require('stream').Writable;

readable
    .pipe(transform)
    .pipe(writable);
```

### Backpressure
**Streams may operate at different speed**, we can have fast data producers and slow writers or slow transform in the middle. When that occurs, **the consumer will begin to queue all the chunks of data for later consumption**. The write queue will get longer and longer, and because of this more data must be kept in memory until the entire process has completed.

**Backpressure** will occur because the writer will not be able to keep up with the speed from the reader.

`push` will return false if the stream you are writing to has too much data buffered.

```js
// This ignores the backpressure mechanisms Node.js has set in place,
// and unconditionally pushes through data, regardless if the
// destination stream is ready for it or not.
readable.on('data', (data) =>
  writable.write(data)
);
```

### Error handling
```js
stream.on('error', (err) => {
    /* ... */
});
```
Ak mam viacej streamov v `.pipe().pipe().pipe()` a niekde nastane chyba, v akom stave zostanú ostatné streamy?
- ich fyzické resources (FileHandle)
- ich interné resources (memory structure, buffers, ...)
- ich stav (sú použiteľné ďalej)

```js
const input = fs.createReadStream(file);

const transform = new Transform({
    transform(ch, enc, cb) { cb(new Error()); }
});

const output = new Writable({
    write(chunk, enc, cb) { cb(); }
});

input
    .pipe(transfrom) //!!!
    .pipe(output);

lsof.assertOpen(file); // Súbor zostal otvorený.
```

Akonahle pajpujeme 2 3 4 streamy, už je tažký error handling. Ak nastane chyba, niektoré možno zostanú otvorené.
- Hlavná výhoda metódy `pipeline()` je, že v prípade chyby uzavre streamy.

```js
pipeline(input, transform, output, () => {
    console.log("done");
});

lsof.assertNotOpen(file); // Súbor je zatvorený.
```

### Object streams
Convert string streams to objects streams for easier manipulations.

```js
stream.objectMode = true;
```

- **Buffer** – processing binary data.
- **String** - processing decoded strings.
- **Object** – processing business objects.

## Streams API
- `.on('close', cb)`
- `.on('data', cb)`
- `.on('drain', cb)`
- `.on('unpipe', cb)`
- `.on('error', cb)`
- `.on('finish', cb)`
- `.on('end', cb)`
- ...

### Readable

`Readable.on("data")`
```js
let buff = "";

stream.on("data", (chunk) => {
    buff += chunk;
});

stream.on("end", () => {
    let obj = JSON.parse(buff);
    console.log(buff);
});
```

`Readable.on("readable")` + `Readable.read([size])`

If size bytes are not available to be read, 
- `null` will be returned,
- unless the stream has ended, in which case all of the data remaining in the internal buffer will be returned.

```js
let buff = "";

stream.on("readable", () => {
    let chunk;

    while(null !== (chunk = stream.read(/*size*/))) {
        buff += chunk;
    }
});

stream.on("end", () => {
    let obj = JSON.parse(buff);
    console.log(buff);
});
```

`Readable.destroy([error])`

Destroys the stream, and emit `error` and `close` (`end` not emited).

#### Close event
Kedže pracujeme zo streamami (arbitrary size or endless data), potrebujeme vedieť kedy sme už dočítali, prípadne kedy skončiť, lebo stream sa uzavrel a podobne:

- `end` event
    - The 'end' event is emitted when there is **no more data to be consumed** from the stream.
    - **Will not be emitted** unless the data is **completely consumed** (read, or flowing).
- `close` event
    - The 'close' event is emitted when the stream and any of its underlying resources (a file descriptor, for example) have been closed. The event indicates that no more events will be emitted, and no further computation will occur.
- `finished(stream)` method:
    - A function to get notified when a **stream is no longer readable**, writable or has **experienced an error or a premature close event**. Especially useful in error handling scenarios where a stream is destroyed prematurely (like an aborted HTTP request), and will not emit 'end' or 'finish'.

### Writable
If a call to `stream.write(chunk)` returns `false`, the `drain` event will be emitted when it is appropriate to resume writing data to the stream.

```js
let i = 0;
let l = 100e6;

const write = () => {
    while(i < l) {
        let b = stream.write(`${i}\tLorem ipsum dolor sit amet\n`);
        i++;

        if(!b) break;
    }
}

if(i === l) stream.end();
else stream.once("drain", write);
```

### Encoding
By default, no encoding is assigned and stream data will be returned as **Buffer objects**.

```js
const stream = fs.createReadStream(fileUtf8, "utf8");

const stream = fs.createReadStream(fileUtf8, {
    highWatermark: 7,
    encoding: "utf8"
});
```

The Readable stream will properly handle multi-byte characters delivered through the stream that would otherwise become improperly decoded if simply pulled from the stream as Buffer objects.

```js
// text:
žaba ťava vôl.

// without encoding:
žaba ?
?ava v?
?l

// with encoding:
žaba
ťava v
ôl
```

## Buffer
Instances of the Buffer class are similar to arrays of integers but correspond to 
- fixed-sized. 
- raw memory allocations **outside the V8 heap**. 
- The size of the Buffer is established when it is created and cannot be changed.

### API

`buffer.slice`
- Returns a new Buffer that references the same memory as the original, but offset and cropped by the start and end indices.
# <a name="anchor_8"></a> 8 Async

**Asynchronous**
- async is about the **gap between *now* and *later***.
- Implementation: Event loop.
- Granularity: **function** is single event loop queue entry.

**Parallel**
- Things being able to execute at the same **instant of time**.
- Implementation: processes, threads.
- Granularity: Each statement is broken to **several low-level operations**.

## Patterns

### Series
- `series` - array of data from all tasks (fail if any fails).
- `waterfall`- data of last task (fail if any fails).
- `tryEach` - data of first finished task (fail is all tasks fail).

### Parallel
- `parallel` (`parallelLimit`) - array of data from all tasks (fail if any fails).
- `race` - data of first finished task (if first finished fails).
- `applyEach` - array of data from all tasks (fail if any fails).

...

## Callbacks

### Sync
```js
function a(cb) {
  cb();
}
```

### Async
```js
function c(cb) {
  setTimeout(cb, 0);
}
```

### Example
```js
a(function() {
  b();

  c(function() {
    d();
  })

  e();
});
f();
```

|                 | `a()` async   | `a()` sync    |
|-----------------|---------------|---------------|
| **`c()` async** | `a,f,b,c,e,d` | `a,b,c,e,f,d` |
| **`c()` sync**  | `a,f,b,c,d,e` | `a,b,c,d,e,f` |

### Callback hell
Ku hlavných problémom programovania s callbackmi patrí:
- CB môže byť buď sync alebo async.
- CB sa moze zavolať viac krát alebo dokonca vôbec.
- CB pošle akékoľvek parametre chce.

```js
f1((err, data) => {
    if(err) /* ... */ return;
    f2(data, (err, data) => {
        if(err) /* ... */ return;
        f3(data, (err, data) => {
            if(err) /* ... */ return;
            // ...
        });
    });
});
```

## Cooperative concurrency
The goal is to take a **long-running "process"** and **break it up into steps** or batches or chunks so that **other** concurrent "processes" have a chance to interleave their operations into the event loop queue.

```
   ┌───────────────────────────┬───────────────────────────┐
   │             x             │             y             │
   └───────────────────────────┴───────────────────────────┘
********───────────────────────┘                           │
                            *********──────────────────────┘
   ┌───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┐
   │ x │ y │ x │ y │ x │ y │ x │ y │ x │ y │ x │ y │ x │ y │
   └───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┘
********───┘                 ********──┘
```

If callback takes a lot of time, eg. processes a lot of data items in „loop“ nothing else can happen:
- in browser – no rendering, no clicks, ...
- on web server – no other requests can be served ...

```js
function func(start = 0) {
    for(var i = start; i < 10e6; i++) {
        if(i == start+100) {
            setTimeout(() => func(i), 0);
            break;
        }

        /* ... */
    }
}
```

## Timers

`setTimeout(callback, delay[, ...args])`
- Schedules execution of a **one-time callback** after `delay` milliseconds

`setInterval(callback, delay[, ...args])`
- Schedules **repeated execution** of callback every `delay` milliseconds.

`setImmediate(callback[, ...args])`
- Schedules the "immediate" execution of the callback **after I/O events** callbacks.

`process.nextTick(callback[, ...args])`
- Schedules after the current operation on the JavaScript stack runs to completion and before the event loop is allowed to continue.

`queueMicrotask(callback)` - *expeimental*
- Microtask queue is managed by V8 and may be used in a similar manner to the `process.nextTick`.

`clearTimeout(timeout)`, `clearInterval(timeout)`, `clearImmediate(immediate)`
- Cancels scheduled timeout or immediate.

### Event loop
```
   ┌───────────────────────────┐
┌─>│           timers          │
│  └─────────────┬─────────────┘
│  ┌─────────────┴─────────────┐
│  │     pending callbacks     │
│  └─────────────┬─────────────┘
│  ┌─────────────┴─────────────┐
│  │       idle, prepare       │
│  └─────────────┬─────────────┘      ┌───────────────┐
│  ┌─────────────┴─────────────┐      │   incoming:   │
│  │           poll            │<─────┤  connections, │
│  └─────────────┬─────────────┘      │   data, etc.  │
│  ┌─────────────┴─────────────┐      └───────────────┘
│  │           check           │
│  └─────────────┬─────────────┘
│  ┌─────────────┴─────────────┐
└──┤      close callbacks      │
   └───────────────────────────┘
```
**timers**

This phase executes callbacks scheduled by `setTimeout()` and `setInterval()`.

**check**

`setImmediate()` callbacks are invoked here.

**all phses**

`process.nextTick()` is not technically part of the event loop. Instead, the nextTickQueue will be processed after the current operation on stack completes, regardless of the current phase of the event loop.

## Promies
- `.then()`
- `.catch()`
- `.finally()`
- `Promise.all()`
- `Promise.race()`

Non standard
- `.done()`
- `.cancel()`
- `Promise.any()`

### Chaining
```js
let promise = asyncFunction() // => #1
    .then((v) => { /* #1 fullfiled */ }, (e) => { /* #1 rejected */ }) // => #2 pending
    .then((v) => { /* #2 fullfiled */ }, (e) => { /* #2 rejected */ }) // => #3 pending
    .then((v) => { /* #3 fullfiled */ }, (e) => { /* #3 rejected */ }) // => #4 pending

promise; // #4 pending.
```

### Error Handling

`then(onRejected)` - If not a function, it is replaced with a "Thrower" function (it throws an error it received as argument).

```js
then((v) => { /* ... */ });
// Same as
then((v) => { /* ... */ }, (err) => { throw err; });
```

#### then and catch
The `catch()` method returns a Promise and deals with rejected cases only. It behaves the same as calling `Promise.prototype.then(undefined, onRejected)`.

```js
let promise = asyncFunction() // => #1 is fullfiled
    .then((v) => { throw new Error(); }) // => #2 is rejected
    .then((v) => {}) // => #3 is rejected
    .then((v) => {}) // => #4 is rejected
    .then((v) => {}) // => #5 is rejected
    .catch((e) => { /* ... */ }) // => #6 is fullfiled
```

#### then and finally
- Handling **settled promise** (rejected or fulfilled).
- It receives **no argument**.
- It returns Promise, which is resolved or rejected „based on previous promise“.
- Unless finally throws, then the promise is rejected with thrown error.
- `return` from finally is ignored.

```js
let promise = asyncFunction()
    .then().then().then()
    .finally(() => { /* ... */ })
```

### Patterns

### `Promise.all`
- The `Promise.all` (iterable) method **returns a single Promise**.
- **That resolves** when all of the promises in the iterable argument have resolved or when the iterable argument contains no promises.
- **It rejects** with the reason of the first promise that rejects.

```js
Promise.all([
    async1(),
    async2(),
    async3()
])
.then((data) => {
    // [async1, async2, async3]
})
.catch((err) => {
    
})
```

### `Promise.race`
- The `Promise.race` (iterable) method **returns a promise**.
- **That resolves** or rejects as soon as one of the promises in the iterable resolves or rejects, with the value or reason from that promise.

```js
Promise.race([
    async1(),
    async2(), // Fastest
    async3()
])
.then((data) => {
    // async2
})
.catch((err) => {
    
})
```

### `waterfall`
This pattern is not part of the promises API, it can be implemented by chaining with `reduce()` or by other techniques.

```js
waterfall([
    async1(), // async1
    async2(), //    .then(async2)
    async3()  //    .then(async3)
])
.then((data) => {

})
.catch((err) => {
    
})
```

## `async` / `await`

The `async function` declaration defines an asynchronous function, which returns an AsyncFunction object. An asynchronous function is a function which operates asynchronously via the event loop, using an **implicit Promise to return its result**. 

```js
async function af() {}
const af = async function () {}
const af = async () => {}
let obj = {
    async af() {}
}
```

The `await` operator is used to wait for a Promise.

```js
a()
    .then((r) => console.log(r));

// Same as

let r = await a();
console.log(r);
```
# <a name="anchor_9"></a> 9 Testing

## Assert equals

### Truth
`assert(value[, message])`
- The input that is checked for being truthy.

`assert.ok(value[, message])`
- Tests if value is truthy. It is equivalent to `assert.equal(!!value, true, message)`.

### Shallow equality
`assert.strictEqual(actual, expected[, message])`
- Tests strict equality between the actual and expected parameters as determined by the SameValue Comparison.

`assert.notStrictEqual(actual, expected[, message])`

### Deep equality
`assert.deepStrictEqual(actual, expected[, message])` - Primitives: **SameValue Comparison**, Type Tags, Prototypes === , enumberable own properties + symbols, unordered properties,…

`assert.notDeepStrictEqual(actual, expected[, message])` - Tests for **deep strict inequality**. Opposite of `assert.deepStrictEqual()`.

### Errors

`assert.throws(fn[, error][, message])`
- Expects the function fn to throw an error.

`assert.doesNotThrow(fn[, error][, message])`
- Asserts that the function fn does not throw an error. Is actually not useful.

`assert.ifError(value)`
- Testing the error argument in callbacks. Throws value if value is not `undefined` or `null`.

`assert.fail([message])`
- Throws an AssertionError with the provided error message or a default error message.

### Promises

`assert.rejects(asyncFn[, error][, message])`
- Awaits the asyncFn promise or asyncFn() promise,  check that the promise is rejected

`assert.doesNotReject(asyncFn[, error][, message])`
- Awaits the asyncFn promise or asyncFn() promise,  check that the promise is not rejected

## Mutation Testing
Mutation testing (or mutation analysis or program mutation) is used to 
- design new software tests and 
- evaluate the quality of existing software tests. 

Mutation testing involves modifying a program in small ways. Each mutated version is called a mutant and tests detect and reject mutants by causing the behavior of the original version to differ from the mutant. This is called killing the mutant. 
- Test suites are measured by the percentage of mutants that they kill.
- New tests can be designed to kill additional mutants.

Mutants are based on well-defined mutation operators that 
- either mimic typical programming errors (such as using the wrong operator or variable name) or 
- force the creation of valuable tests (such as dividing each expression by zero). 

The purpose is to help the tester develop effective tests or locate weaknesses in the test data used for the program or in sections of the code that are seldom or never accessed during execution. Mutation testing is a form of white-box testing.
- manual
- automated

## Snapshot Testing
Snapshot tests are a very useful tool whenever you want to make sure your code did not change unexpectedly. 

Písať testy na každú jednu property komplexných výstupov je problémové, testy už aj tak píšete na rôzne časti výstupu v rámci iných (unit) testov
Cieľom testu je zistiť či sa výstup predošlého behu zhoduje z výstupom tohto behu testu.

Ak sa nezhoduje, reba došetriť či je to želaná zmena (pridané nejaké properties do objektu), alebo neželaná zmena (chuba kdesi v algoritme).

Po došetrení buď nový výstup prehlásite za OK, alebo opravíte algoritmus.

### Princíp implementácie
- Máte vstupy a k nim očakávane výstupy, kludne ponahrávané nejakým automatom prípadne vykonaním testu samotného
- Výstupy nekontrolujete a keď tak len zbezne, ručne, tie majú byť pokryté inými testami
- Musíte si niekde vstupy ukladať a verzionovat (disk a git).
- Musíte dokázať porovnať z predošlým snapshotom.
- Musíte ho dokázať revertnúť alebo komitnúť (zase git).
