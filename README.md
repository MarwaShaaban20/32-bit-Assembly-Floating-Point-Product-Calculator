#Task
* Write a 32-bits intel-syntax assembly program that can be compiled in the same way the 32-bits lab samples are compiled.
The program should take the following inputs from the user:
* An integer n.
* n floating point numbers (Use the "double" type. Do not use "float" type.)
The program should output ((n) + 1/1) * ((n-1) + 1/2) * ((n-2) + 1/3) * ((n-3) + 1/4) * ... * (2 + 1/(n-1)) * (1 + 1/(n)).
Example:
The user inputs: 3
The program outputs: sum=13.333
