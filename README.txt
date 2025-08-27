# Small Instruction Register Processor

Building a our own microprocessor with constraints


1.	Explain which programs/features work 
All of all programs and features worked as we wanted/designed.
Our testbenches are labelled as:
"prog1_tb.sv"
"prog2_tb.sv"
"prog3_tb.sv"

Our asssembly code are labelled as:
"program1_assembly.txt"
"program2_assembly.txt"
"program3_assembly.txt"

Our machine code are labelled as:
"mach_code_program1"
"mach_code_program2"
"mach_code_program3"

Our assembler is label as "Assembler.java"

Screenschots of each program output are labelled as:
Program1 is split into two images as it did not fit into one screenshot
"program1_output_part1.png"
"program1_output_part2.png"

Program2 is spilt into three images as it did not fit into one screenshot
"program2_output_part1.png"
"program1_output_part2.png"
"program1_output_part3.png"

Program3 has three different outputs for different patterns:
"program3_output_easy.png" -> all zeros
"program3_output_hard.png" -> more complex test
"program3_output_random.png" -> random pattern


All our programs should run when given the correct machine code as an input.
2.	Explain which programs/features don’t work and what challenges you faced when implementing your design.
We encounted the following challenges:
-Branching: We has trouble deciding on whether to use relative or absolute branching. We eventually decided on relative branching. R0 held the amount we wanted to branch. We used two's complement numbers so we could branch up and down our code. Coding in assembly with our branches was also difficult because we had to do double branching and count line numbers.
-Designing ISA: We went back and forth on a lot of designs as we only had 9 bits of machine code to work with. We had to get creative with some of our instructions to include all the instuctions we wanted to be able to use. For example, our "OR" instruction is extra unique taking on an accumulator design, since we ran out of bits to specify two registers. "OR" only takes in one register and uses RO as a default source and destination register. In addition, almost all of our instructions uses R0 as a default destination register.
-Writing Assembly: We had to figure out how to work with 8 registers (when we were used to having 16). We also had to figure out how to use R0 for everything.
-Debugging Assembly: We only had the waveform to help us debug, so we had to get really good at reading the wave. We added wires to allow us to see our values in data mem and our registers.
3.	Include the link and passcode to your zoom video (see above) 
We have put out video into a google drive folder.
Access link: https://drive.google.com/file/d/1ojAQqXNT58Q2uXqzDKhXmNXrYhVPAhCr/view?usp=sharing
