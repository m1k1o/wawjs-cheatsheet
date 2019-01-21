# Funkcie

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
