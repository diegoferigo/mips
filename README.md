#Single-Cycle MIPS (VHDL)
###Supported commands:

|Instruction|Type|Example|Meaning|
|:---|:-:|:--------------|:------------|
|add|R|`add S1 S2 S3`|`$s1 = $s2 + $s3`|
|and|R|`and S1 S2 S3`|`$s1 = $s2 and $s3`|
|or|R|`or S1 S2 S3`|`$s1 = $s2 or $s3`|
|nor|R|`nor S1 S2 S3`|`$s1 = $s2 nor $s3`|
|xor|R|`xor S1 S2 S3`|`$s1 = $s2 xor $s3`|
|shift left|R|`sll S1 S2 3`|`$s1 = $s2 << 3`|
|shift right|R|`slr S1 S2 3`|`$s1 = $s2 >> 3`|
|set on less then|R|`slt S1 S2 25`|`if ($s1 < $s2) $s1=1 else $s1=0`|
|load word|I|`lw S1 S2 3`|`$s1 = Memory [ $s2 + 3 ]`|
|store word|I|`sw S1 S2 3`|`Memory [ $s2 + 3 ] = $s1`|
|add immediate|I|`addi S1 S2 100`|`$s1 = $s2 + 100`|
|branch on equal|I|`beq S1 S2 25`|`if ($s1 == $s2) goto (PC+4) + 100`|
|branch on not equal|I|`beq S1 S2 25`|`if ($s1 < $s2) goto (PC+4) + 100`|
|jump|J|`j 2500`|`goto 10000`|

Be aware to some differences for example the load and store syntax compared to the standard.

### Generate binary machine language from assembly code
1) Write a plain text file with assembly instruction like examples in the table and put it in the _script/_ folder. E.g:
```
addi S1 S10 20
addi S2 S10 10
addi S3 S10 50
add S5 S1 S2
sw S5 S3 5
lw S10 S3 5
```
2) Check if the file contains valid instructions and check the logic
```
diego@xps13 ~script] sh GenInstructionMemoryInit.sh InstructionListTest 
00100001010000010000000000010100
00100001010000100000000000001010
00100001010000110000000000110010
00000000001000100010100000100000
10101100011001010000000000000101
10001100011010100000000000000101
S1 = S10 + 20
S2 = S10 + 10
S3 = S10 + 50
S5 = S1 + S2
Memory[S3 + 5] = S5
S10 = Memory[S3 + 5]
```
If prompts no error go on.

3) Generate the VHDL ready inititialization lines for Instruction Memory
```
[diego@xps13 script]$ sh GenInstructionMemoryInit.sh InstructionListTest1 -m
0 => "00100001",
1 => "01000001",
2 => "00000000",
3 => "00010100",
4 => "00100001",
5 => "01000010",
6 => "00000000",
7 => "00001010",
8 => "00100001",
9 => "01000011",
10 => "00000000",
11 => "00110010",
12 => "00000000",
13 => "00100010",
14 => "00101000",
15 => "00100000",
16 => "10101100",
17 => "01100101",
18 => "00000000",
19 => "00000101",
20 => "10001100",
21 => "01101010",
22 => "00000000",
23 => "00000101",
```
4) Paste the line in InstructionMemory.vhd file. Example, from:
```
signal mem: mem_type(0 to 1023) := (
    	others=> (others => '0'));
```
to
```
signal mem: mem_type(0 to 1023) := (
                0 => "00100001",
                1 => "01000001",
                2 => "00000000",
                3 => "00010100",
                (...)
		        others=> (others => '0'));
```
5) Simulate with ModelSim

---
###Resources:
- [Instruction format](http://en.wikibooks.org/wiki/MIPS_Assembly/Instruction_Formats)
- [Numeric_Std library conversions](http://www.lothar-miller.de/s9y/categories/16-Numeric_Std)
