# DecodeOpcode_x86
I have developed a small method to decode x86 opcodes I have not implemented all the MODs here is what I have implemented:

d-bit check
Checking the mod
Field RM check

I implemented the MOD register addressing mode (11)
i have just implemented 32 bits table
Here is a table of the different modes

<img src="screenshots/register_mod.png">

Opcode example using register adressing mode

```
0x89 0xe5
0x01 0xd0
```

Example using my class with r_mod enable
```ruby
opcode_decode = OpcodeDecode.new([0x01, 0xd0], iarch=32)

puts opcode_decode.convert_opcode_to_instruction
# => add eax, edx
```

```ruby
opcode_decode = OpcodeDecode.new([0x89, 0xe5], iarch=32)

puts opcode_decode.convert_opcode_to_instruction
# => mov ebp, esp
```

Exemple using my class with r_mod disable 
```ruby
opcode_decode = OpcodeDecode.new([0x55], iarch=32)

puts opcode_decode.convert_opcode_to_instruction
# => push ebp
```

```ruby
opcode_decode = OpcodeDecode.new([0xb8, 0x10], iarch=32)

puts opcode_decode.convert_opcode_to_instruction
# => mov eax, 10
```
