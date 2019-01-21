# Jazyk

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
