# Funkcie

- function expression
- function declaration
- arrow function

## Primary unit of execution
**run-to-completion** – whole function is executed (na stacu kym nedobehne).
![](images/03-primary-unit-of-execution.jpg)

## parametre, argumenty
- parameter
  - to čo je v definícii
  - optional
  - have no type
- argument
  - to čo je vo volaní funkcie 
  - special keyword

![](images/03-parameters-arguments.png)

## rest parametre
![](images/03-rest-parameters.png)

## default parametre
![](images/03-default-parameters.png)

## first class object
vsade kde sa da poslat objekt tam aj funkcia
![](images/03-first-class-object.png)

## this
![](images/03-this.png)

### this - in constructor
![](images/03-this-in-constructor.png)

## scope a closures

- **scope**
  - ake premenne a funkcie „vidim“/“mam dostupne“ v danom kuse kodu
- **closure**
  - funkcia s odpamätanými premennými z okolia
- **Lexical Environment**
   - zoznam identifikátorov definovaných v danom scope a linka na outer scope environment

![](images/03-scope-closures.png)

### closures

> fenomen JS, ze funkcia na tom mieste kde je zadefinovava, si uklada pointre.

# Na skúšku
- Uvedomiť si že JS funkcie sú asi iné ako poznáte z iných jazykov
- Rozoznať function declaration od function expression v kóde
- Vysvetliť pojem „function is first-class object“
- Poznať syntax arrow function a dokázať povedať čo funkcia vracia (v uvedenom príklade)
- Dokázať používať this a rozumieť, kedy má akú hodnotu podľa spôsobu definície a typu volania funkcie
- Určiť na príklade ktoré identifikátory sú dostupné pri volaní funkcie a vysvetliť prečo 
