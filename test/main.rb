require_relative '../lib/opcode_to_instruction'

opcode_decode = OpcodeDecode.new([0x89, 0xe5], iarch=32)

puts opcode_decode.convert_opcode_to_instruction