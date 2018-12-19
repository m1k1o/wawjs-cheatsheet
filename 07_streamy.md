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
![](images/07-types-of-streams.png)

## Streams API
![](images/07-streams-api.png)
![](images/07-streams-api-implementing.png)

## Backpressure
![](images/07-backpressure.png)
![](images/07-backpressure1.png)

## Error handling

![](images/07-error-handling.png)
![](images/07-error-handling1.png)

Akonahle pajpujeme 2 3 4 streamy, uz je tazky error handling. Ak nastane chyba, niektore mozno zostanu otvorene.
- halvna vyhoda metody pipeline je, ze v pripade chyby uzvare streamy.

![](images/07-error-handling-pipeline.png)

## Object streams
![](images/07-object-streams.png)
