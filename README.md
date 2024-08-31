# HW2_IOCLA

x86 32-bit Assembly homework using NASM assembler.

## Implementation Overview

- Used 32-bit registers (eax, ebx, ecx, etc.)
- Utilized helper variables to free up registers
- Implemented the columnar function on the second day
- Encountered obstacles in traversing the matrix formed from the input string
- Spent hours debugging using valgrind and GDB

## Variables and Fields

### ages.asm
- `day`: Day from the date of birth
- `month`: Month from the date of birth
- `year`: Year from the date of birth
- `aux`: Helper variable to free up eax register, stores the value of 'len'

### columnar.asm
- `aux_len`: Stores the number of rows
- `aux_helper`: Preserves the address in edx
- `copy_len_key`: Saves the value stored by len_cheie
- `contor`: Counter used to construct 'ciphertext'

### cache.asm
- `aux_reg`: Stores the register address
- `aux_address`: Stores the address given as an argument
- `aux_offset`: Helps calculate the offset
- `contor`: Used in loops and offset calculation
- `aux_helper_offset`: Stores the offset value (3 bits)
- `aux_helper`: Preserves important values for matrix position determination

## Implementation Details

### rotp function
- Constructs 'ciphertext' string in 'create_string' loop using 'loop' instruction
- Uses 'bl' subregister for XOR operation (1 byte per character)
- Increments esi address to get next character
- Stores result in edx register, operating with edx+eax

### ages function
- Handles all cases to calculate ages
- Iterates through 'my_date' vector using eax register
- Uses construction `[vector_name+type_size*index+struct.year]` to retrieve year
- Implements logic for different date scenarios (e.g., birth date after present date)

### columnar function
- Transforms string into matrix form
- Main idea illustrated with examples:

```
esi->  Hai s|a dam| mana| cu m|ana! (test 1)
esi->  Nu te| intr|eba n|imeni| nimi|c! (test 2)

   0 1 2 3 4
 1 h a i   s
 2 a   d a m      <- Test 1
 3   m a n a
 4   c u   m
 5 a n a ! -     
        
   0 1 2 3 4                  
 1 N u   t e                          
 2   i n t r                           
 3 e b a   n      <- Test 2                
 4 i m e n i                       
 5   n i m i                       
 6 c ! - - -
```

- Uses construction `[esi+edx*(eax-1)+ecx]` to traverse string correctly
- Calculates number of rows and columns
- Constructs 'ciphertext' string in loops
- Implements logic to avoid invalid reads

### cache function
- Most complex implementation
- Uses global variables to free up registers
- Calculates offset and tag of address in edx
- Extracts last 3 bits from address
- Transforms row and column into single index
- Implements 'search_tag' loop to find previously calculated tag
- Handles 'cache miss' scenario by placing elements on 'to_replace' line
- Directly puts value from edi into register for 'tag_found' case

## Matrix Indexing Example

```
Let the matrix be of size 4x3
This matrix is stored in esi

 1  4  5
 6  7  4
44 67 43
34 76 45

In memory: 1 4 5 6 7 4 44 67 43 34 76 45

To access element 34, use: [esi+3*3+0]
```

The construction to access an element k on row i and column j is: `[esi+i*size_column+j]`
