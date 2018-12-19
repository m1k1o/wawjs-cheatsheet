# Async
![](images/08-async-parallel-concurrency.png)

## Patterns
![](images/08-async-patterns.png)

## Callback hell
Ku hlavných problémom programovania s callbackmi patrí:
- CB môže byť buď sync alebo async.
- CB sa moze zavolať viac krát alebo dokonca vôbec.
- CB pošle akékoľvek parametre chce.

![](images/08-callback-hell.png)

## Cooperative concurrency
![](images/08-cooperative-concurrency.png)
![](images/08-cooperative-concurrency1.png)
![](images/08-cooperative-concurrency-demo.png)

## Timers
- nextTick - immediate
- SetImmediate - after event loop

![](images/08-timers.png)

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
![](images/08-timers-next-tick.png)

## Promies
![](images/08-promises-api.png)

### Chaining
![](images/08-promises-chaining.png)

### Error Handling
![](images/08-promises-then-catch.png)
![](images/08-promises-then-finally.png)

### Patterns

**All**
![](images/08-promise-all.png)

**Race**
![](images/08-promise-race.png)

## Await
![](images/08-await.png)
![](images/08-await-demo.png)
