# Details #


## Comparison Array Vs Dictionnary ##

| **Bench topic** | **Bench condition** | **Array** | **Dictionnary** |
|:----------------|:--------------------|:----------|:----------------|
| **loop in object** | 10000 iterations with 20 elements | 7 ms      | 18ms            |
| **loop in object** | 1000 iterations with 200 elements | 8 ms      | 15ms            |
| **loop in object** | 1000 iterations with 2000 elements | 50 ms     | 158ms           |
|                 |                     |           |                 |
| **search an object** | 10000 iterations with 20 elements | 8 ms      | 0ms             |
| **search an object** | 10000 iterations with 200 elements | 44 ms     | 0ms             |
| **search an object** | 10000 iterations with 2000 elements | 203 ms    | 0ms             |
| **search an object** | 10000 iterations with 2000 elements | 2153 ms   | 1ms             |
|                 |                     |           |                 |

## Comparison Loop Vs Array.forEach ##
| | | | |
|:|:|:|:|