# Objekty
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
- non-emuberable means it will not show in for( ... in ... )", 
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
    conosle.log(k);
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

### Introspection Table

|                                      | String    | Number    | Symbols   | Inherited | Non-Enum. |   Get     |    Set    |
|--------------------------------------|-----------|-----------|-----------|-----------|-----------|-----------|-----------|
| `x = o.p`                            | **Yes†** |   No      |   -       | **Yes**   | **Yes**   | **Yes**   |   -       |
| `x = o[p]`                           | **Yes**   | **Yes**   | **Yes**   | **Yes**   | **Yes**   | **Yes**   |   -       |
| `Object.keys()`                      | **Yes**   | **Yes\*** |   No      |   No      |   No      | **Yes**   | **Yes**   |
| `Object.entries()`                   | **Yes**   | **Yes\*** |   No      |   No      |   No      | **Yes**   | **Yes** |
| `Object.values()`                    | **Yes**   | **Yes\*** |   No      |   No      |   No      | **Yes**   | **Yes** |
| `for...in`                           | **Yes**   | **Yes**   |   No      | **Yes**   |   No      | **Yes**   | **Yes**   |
| `in operator`                        | **Yes**   | **Yes**   | **Yes**   | **Yes**   | **Yes**   | **Yes**   | **Yes**   |
| `delete`                             | **Yes**   | **Yes**   | **Yes**   |   No      | **Yes**   | **Yes**   | **Yes**   |
| `Object.getOwnPropertyNames()`       | **Yes**   | **Yes**   |   No      |   No      | **Yes**   | **Yes**   | **Yes**   |
| `Object.getOwnPropertySymbols()`     |   No      |   No      | **Yes**   |   No      | **Yes**   | **Yes‡** | **Yes‡** |
| `Object.getOwnPropertyDescriptors()` |   -       |   -       |   -       |   No      |   -       |   -       |   -       |
| `JSON.stringify()`                   | **Yes**   | **Yes**   |   No      |   No      |   No      | **Yes**   |   -       |
| `Object.assign()`                    | **Yes**   |   No\*    | **Yes**   |   No      |   No      | **Yes**   | **Yes**   |
| `Object.prototype.hasOwnProperty()`  | **Yes**   |   No\*    | **Yes**   |   No      | **Yes**   | **Yes**   | **Yes**   |

† The key can not contain whitespace.

‡ The key has to be `Symbol`.

\* The key will always be converted to a string.
