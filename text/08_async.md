# Async

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

## Callback hell
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
