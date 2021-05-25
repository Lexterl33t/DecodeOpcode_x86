require_relative '../lib/opcode_to_instruction'

opcodes = [[0x55], [0x89, 0xe5], [0x01, 0xd0], [0xc9]]
opcodes.each do |opcode|
    opcode_decode = OpcodeDecode.new(opcode, iarch=32)
    puts opcode_decode.convert_opcode_to_instruction    
end
