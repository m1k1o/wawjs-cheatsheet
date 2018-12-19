# Funkcionálne programovanie

## for cyklus, prepisat na map filter reduce...
![](images/06-ugly-for.png)

## pipe a compose (vediet rozdiel)
![](images/06-pipe-composition.png)

## ~~funkcie vs metody~~
![](images/06-methods-to-funcs.png)
![](images/06-funcs-to-methods.png)

## pure functions

- **Referential transparency**: The function always gives the same return value for the same arguments. This means that the function cannot depend on any mutable state.
- **Side-effect free**: The function cannot cause any side effects. Side effects may include I/O (e.g., writing to the console or a log file), modifying a mutable object, reassigning a variable, etc.

![](images/06-pure-func.png)

## high order functions
Higher order function is a function that does one of or both:
- takes a **function as an argument**
- returns **function**

### takes a **function as an argument**
![](images/06-func-as-parameter.png)

### returns **function**
![](images/06-returns-func.png)

## transforming functions
![](images/06-transforming-func.png)

## immutability
By default things are **mutable** in JS. An **immutable object** is an object whose state cannot be modified after it is created. 

- **Shared state** is *fine* if it is immutable.
- **Mutable state** is *fine* if it is not shared.

![](images/06-immutability.png)

### How to acheive immutability?
frozen objects
![](images/06-acheive-immutabiliy.png)

## map vracia novy array ale mutuje...
![](images/06-arrays.png)

## object manipulation
- modify/add property
- remove/clear property
- whitelist/blacklist properties
- clone object (shallow/deep)
- merge objects (shallow/deep)
- traversing objects

### modify/add property
![](images/06-obj-add-set-prop.png)

### remove/clear property
![](images/06-obj-remove-clear-prop.png)

### whitelist/blacklist properties
![](images/06-obj-whitelist-blacklist-prop.png)

### cloning
![](images/06-cloning-objects.png)
![](images/06-cloning-objects2.png)

### traversal
ES has no traversal algorithms build in, except for:
- **JSON.parse**: post order
- **JSON.stringify**: pre order

![](images/06-traversal.png)

## rekurzia
![](images/06-resursion.png)
![](images/06-resursion-other-topics.png)

## partial function
> Partial application is the act of taking a function which takes multiple arguments, and “locking in” some of those arguments, producing a function which takes fewer arguments.

```js
>>> var add = function(a, b) { return a + b; };
>>> add(5, 4);
9
>>> var add5 = function(b) { return add(5, b); }
>>> add5(4)
9
```

## curried function
> A function that will return a new function until it receives all it's arguments.

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
### bind
ECMAScript 5 introduced `bind()` which brings (among other things) native currying to JavaScript. Once again, let’s take the add function.

```js
function add(a,b,c) {
    return a + b + c;
}
```

This is how you curry it using `bind()`.

```js
var intermediate = add.bind(undefined, 1, 2);
var result = intermediate(3);// 6
```

The first argument to `bind()` actually sets the infamous this context of the function. We can leave it undefined here, since it has no effect.
