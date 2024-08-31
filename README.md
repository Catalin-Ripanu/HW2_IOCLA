# HW2_IOCLA

x86 32 bit Assembly homework using NASM assembler.

## Implementation

- I used 32-bit registers (eax, ebx, ecx, etc.).
- I also used certain helper variables (to free up registers).
- On the second day, I implemented the columnar function.
- I encountered a few obstacles on this day.
- I had to find a way to traverse the matrix that was formed using the string given as a parameter.
- I spent a few hours debugging.
- I used valgrind and GDB. Valgrind reported the most errors.

Meanings of the following variables/fields:
From ages.asm
day -> field representing the day from the date of birth.
month -> field representing the month from the date of birth.
year -> field representing the year from the date of birth.
aux -> variable that helps free up the eax register.
aux stores the value of 'len'.

From columnar.asm
aux_len -> stores the number of rows.
aux_helper -> helps preserve the address in edx.
copy_len_key -> saves the value stored by len_cheie.
contor -> a counter used to construct 'ciphertext'.

From cache.asm
aux_reg -> variable that stores the register address.
aux_address -> variable that stores the address given as an argument.
aux_offset -> variable that helps calculate the offset.
contor -> a counter used in loops and offset calculation.
aux_helper_offset -> variable that stores the offset value (3 bits).
aux_helper -> helps preserve an important value (for determining the position in the matrix).

Implementation ideas:
The rotp function was simple. The 'ciphertext' string was constructed in a 'create_string' loop using the 'loop' instruction.
The 'bl' subregister was used because the size of a character is 1 byte.
This subregister keeps the characters that result from performing the XOR operation.
Also, the address of esi is incremented to obtain the next character.
Example:
0x... -> "Tema"
0x... + 0x1 -> "ema"
Obviously, it takes into account that the size of a character is 1 byte.
At the end, the result is stored in the edx register. It operates with the address edx+eax (eax increases by 1 at each iteration).

The ages function was straightforward. All cases were handled to obtain the ages.
The first part involves iterating through the 'my_date' vector using the eax register.
The construction [vector_name+type_size*index+struct.year] is used to retrieve the year of the element at position 'index' from the 'vector_name' vector.
If the year from the date of birth is after the year from the present date, 0 is placed in the age vector.
Obviously, the 'sub' operation is used to obtain an age. In the first part, it takes into account the month from the respective birth date.
Example:
Present: 07.06.2021
Date of birth: 15.07.2001 
We can't say the age is 20 ("sub 2021,2001").
In this case, it jumps to 'get_year_decrement' (the result is dec 20 -> 19).
If the months from the birth date and 'present' coincide, it moves to 'get_year_decision' to obtain the corresponding days.
Example:
Present: 07.12.2021
Date of birth: 06.12.2001 
We can say the age is 20.
In this case, it jumps to 'get_year_normal' from 'get_year_decision'.

The columnar function was not trivial.
The main idea of the program implementing the columnar function is:

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
eax-> 6 (number of rows)
edx-> 5 (number of columns)
edi-> [0,2,4,1,3] (order vector)
   
A construction to traverse the string correctly:
    
[esi+edx*(eax-1)+ecx]

Using the above construction, a way was found to transform the row and column into a single index.
The ecx register receives elements from the order vector (the vector in edi).
In the first part, the number of rows and columns is calculated. The calculation of the number of rows depends on the remainder of dividing 'len_haystack' by 'len_cheie'.
If the remainder is 0, it moves to 'define_row_column_1'.
Obviously, the 'ciphertext' string will be constructed within the 'create_ciphertext_1.. jl' loop in both situations.
In 'create_ciphertext', the order vector from the edi register is traversed.
In the eax register, that special index presented earlier is formed. The eax register will store the value from edx*[len_cheie]+ecx.
The obtained character is saved in the 'al' register. Also, this character is introduced into the content of the address in [ebx+edx] (edx->iterator).
The 'jump_continue' label is used to avoid exceeding the length (invalid read).
An 'aux_helper' variable is used to help recover the value from edx (using 'mul').
Obviously, edx and 'aux_helper' have the value 0 (to avoid messing up calculations) when moving to the next column.

The cache function was the most complex.
Global variables were used to free up registers.
In the 'calculate_tag_offset' loop, the offset and tag of the address in edx were calculated using shr and shl operations.
The last 3 bits were extracted from that address. Obviously, the aux_helper_offset variable stores the base 10 representation.
Example:
   address-> 10101....101
   Then aux_helper_offset stores the value 5=2^0*1+2^1*0+2^2*1. (101 in binary)
The 'contor' variable has the role of transforming the numeric result to base 10.
The 'aux_address' variable stores the tag calculated in edx.
As with columnar, a way was found to transform the row and column into a single index.

```
Example:
     Let the matrix be of size 4x3
     This matrix is stored in esi
     
     1 4 5
     6 7 4
     44 67 43
     34 76 45
```

In reality: 1 4 5 6 7 4 44 67 43 34 76 45.
Then
  [esi+1]-> 4
  [esi+2]-> 5
  [esi+3]-> 6
  etc.
 The necessary construction to access an element k on row i and column j is: [esi+i*size_column+j].

If you want to access element 34, use the form [esi+3*3+0].
In the 'search_tag' loop, the previously calculated tag is searched for.
Knowing this information, elements are placed on the 'to_replace' line from the cache (in case of a 'cache miss').
Obviously, esi stores the address of the element that needs to be put in the register.
At the end, the calculated tag is introduced into the tag vector from ebx.
The 'tag_found' case is simple, the value from edi is directly put into the register ( mov [esi],edi ).
