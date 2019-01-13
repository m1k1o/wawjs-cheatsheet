# Patterny

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
