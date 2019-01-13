# Platforma & node a npm

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
| http         | fs         | child_process |
| http2        |            | process       |
| https        |            |               |
| net          |            |               |
| dgram        |            |               |
| dns          |            |               |

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
