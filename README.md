# Push_swap

This project involves sorting data on a stack, with a limited set of instructions, and the smallest number of moves. To make this happen, you will have to manipulate various sorting algorithms and choose the most appropriate solution(s) for optimized data sorting.

## Project Overview

Push_swap is a sorting algorithm project that sorts a list of random numbers using two stacks (a and b) with a limited set of operations. The goal is to sort the numbers in stack a in ascending order with the minimum number of operations possible.

### Available Operations

- `sa`: swap the first 2 elements at the top of stack a
- `sb`: swap the first 2 elements at the top of stack b
- `ss`: sa and sb at the same time
- `pa`: take the first element at the top of b and put it at the top of a
- `pb`: take the first element at the top of a and put it at the top of b
- `ra`: rotate stack a - shift up all elements of stack a by 1
- `rb`: rotate stack b - shift up all elements of stack b by 1
- `rr`: ra and rb at the same time
- `rra`: reverse rotate a - shift down all elements of stack a by 1
- `rrb`: reverse rotate b - shift down all elements of stack b by 1
- `rrr`: rra and rrb at the same time

## Algorithm

The implementation uses a chunk-based sorting approach that:
1. Divides numbers into chunks
2. Strategically pushes numbers to stack B
3. Sorts back to stack A in order

## Performance

The algorithm performs within the following limits:
- 3 numbers: ≤ 3 operations
- 5 numbers: ≤ 12 operations
- 100 numbers: ≤ 700 operations
- 500 numbers: ≤ 5500 operations

## Known Limitations

While the algorithm successfully handles most cases within the required operation limits, there are certain number sequences that can exceed these limits. For example:

```bash
# One challenging case:
./push_swap "99 48 97 46 95 44 93 42 91 40 89 38 87 36 85 34 83 32 81 30 79 28 77 26 75 24 73 22 71 20 69 18 67 16 65 14 63 12 61 10 59 8 57 6 55 4 53 2 51 0 98 47 96 45 94 43 92 41 90 39 88 37 86 35 84 33 82 31 80 29 78 27 76 25 74 23 72 21 70 19 68 17 66 15 64 13 62 11 60 9 58 7 56 5 54 3 52 1 50 49"
```

This demonstrates a fundamental challenge in sorting algorithms - certain patterns can be particularly difficult to handle efficiently. While it would be possible to optimize for these specific cases through pattern detection or alternative sorting strategies, the current implementation prioritizes a general solution that works well for the majority of cases.

The choice to maintain this implementation reflects real-world engineering trade-offs between:
- Handling edge cases vs maintaining clean, maintainable code
- Performance optimization vs development time
- Generic solutions vs pattern-specific optimizations

## Usage

```bash
# Compile
make

# Run with numbers
./push_swap 2 1 3 6 5 8

# Test with random numbers
ARG=$(python3 -c "import random; print(' '.join([str(x) for x in random.sample(range(-50, 50), 100)]))"); ./push_swap $ARG | wc -l

# Run with checker
ARG="4 67 3 87 23"; ./push_swap $ARG | ./checker $ARG
```

## Installation

```bash
git clone [repository-url]
cd push_swap
make
```

## Contributing

Feel free to submit issues and enhancement requests!

## Author

- [@elkhailiissam](https://github.com/issamelkhaili)

## Acknowledgments

- 42 School for the project requirements and constraints
- Fellow 42 students for testing and feedback
