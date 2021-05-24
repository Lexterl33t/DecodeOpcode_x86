=begin


===========[ TEST OPCODES ]===========
55           PUSH EBP
89 e5        MOV  EBP, ESP // 11 100 101
83 ec 10     SUB  ESP, 0x10  
8b 45 08     MOV  EAX, DWORD [EBP + 0x8]
8b 55 0c     MOV  EDX, DWORD [EBP + 0xC]
01 d0        ADD  EAX, EDX
c9           LEAVE
c3           RET
======================================

=end

class OpcodeDecode

    attr_accessor :opcode_array, :iarch

    private
        @@opcode_table = [
            {'Instruction' => 'push ebp', 'Opcode' => 0x55, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'mov', 'Opcode' => 0x89, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'add', 'Opcode' => 0x01, 'r_mod' => 0x1}, # MOD R/M enable
        ]
        
        @@opcode_x86_rm = {'MOD' => [
            0b11 => [
                {0xe5 => {'REG' => "esp", "R/M" => "ebp"}},
                {0xd0 => {'REG' => "edx", "R/M" => "eax"}}
            ]
=begin
            00 => [

            ],
            01 => [

            ],
            10 => [

            ]
=end
        ]}

    public

    def initialize(opcode_array, iarch=32)
        @opcode_array = opcode_array
        @iarch = iarch
    end

    def get_column_opcode(opcode)
        @@opcode_table.each do |byte|
            if byte['Opcode'] == opcode
                return byte
            end
        end
    end

    def get_column_mode(mod_value, opcode_value)
        @@opcode_x86_rm['MOD'].each do |byte|
            byte[mod_value].each.with_index do |b, i|
                if b.key(b[opcode_value]) == opcode_value
                    return b[opcode_value]
                end
            end
        end
    end

    def convert_opcode_to_instruction
        if iarch == 32
            column_opcode_instruction = get_column_opcode(@opcode_array[0])
            opcode = column_opcode_instruction['Instruction']
            if column_opcode_instruction['r_mod'] == 0x1
                dbit = get_d_bit(@opcode_array[0])
                regex_field_rm = get_field_rm(dbit)
                mod_value = get_mod(@opcode_array[1])
                regex_field_rm["%MOD%"] = opcode
                regex_field_rm["%R/M%"] = get_column_mode(mod_value, @opcode_array[1])['R/M']
                regex_field_rm["%REG%"] = get_column_mode(mod_value, @opcode_array[1])['REG']
                return regex_field_rm
            else
                return column_opcode_instruction['Instruction']
            end
        end
    end

    def get_mod(opcode_r_mod)
        (opcode_r_mod >> 6)
    end

    def get_d_bit(opcode)
        ((opcode << 6) & 0xFF) >> 7
    end

    def get_field_rm(dbit)
        dbit == 0 ? "%MOD% %R/M%, %REG%" : dbit == 1 ? "%MOD% %REG%, %R/M%" : "INVALID OPCODE"
    end
end 

