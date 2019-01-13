# Testing

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
