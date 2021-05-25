require_relative '../lib/opcode_to_instruction'


opcodes = [[0x55], [0x89, 0xe5], [0x8b, 0x45, 0x8], [0x8b, 0x55, 0x0c], [0x01, 0xd0], [0xc9]]
assembly_instruction = []
opcodes.each do |opcode|
    opcode_decode = OpcodeDecode.new(opcode, iarch=32)
    assembly_instruction << opcode_decode.convert_opcode_to_instruction    
end

puts assembly_instruction.join("\n")