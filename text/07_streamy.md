# Streamy
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
- Halvná výhoda metódy `pipeline()` je, že v prípade chyby uzvare streamy.

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
