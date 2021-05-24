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
            # R/M ENABLE
            {'Instruction' => 'mov', 'Opcode' => 0x89, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'add', 'Opcode' => 0x01, 'r_mod' => 0x1}, # MOD R/M enable
            # R/M DISABLE
                # [ OTHER ]
            {'Instruction' => 'mov eax', 'Opcode' => 0xb8, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'add eax', 'Opcode' => 0x05, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'adc eax', 'Opcode' => 0x14, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'or eax', 'Opcode' => 0x0d, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'and eax', 'Opcode' => 0x25, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'xor eax', 'Opcode' => 0x35, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'sbb eax', 'Opcode' => 0x1d, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'sub eax', 'Opcode' => 0x2d, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'cmp eax', 'Opcode' => 0x3d, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'push', 'Opcode' => 0x68, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'push', 'Opcode' => 0x6a, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'jo', 'Opcode' => 0x70, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'jno', 'Opcode' => 0x71, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'jb', 'Opcode' => 0x72, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'jnb', 'Opcode' => 0x73, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'jz', 'Opcode' => 0x74, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'jnz', 'Opcode' => 0x75, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'jbe', 'Opcode' => 0x76, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'ja', 'Opcode' => 0x77, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'js', 'Opcode' => 0x78, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'jns', 'Opcode' => 0x79, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'jp', 'Opcode' => 0x7a, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'jnp', 'Opcode' => 0x7b, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'jl', 'Opcode' => 0x7c, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'jnl', 'Opcode' => 0x7d, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'jle', 'Opcode' => 0x7e, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'jnle', 'Opcode' => 0x7f, 'r_mod' => 0x0}, # MOD R/M disable
                # [ LENGTH 1 ]
            {'Instruction' => 'push ebp', 'Opcode' => 0x55, 'r_mod' => 0x0}, # MOD R/M disable
        ]
        
        @@opcode_x86_rm = {'MOD' => [
            # 11 (register addressing mode)
            0b11 => [
                {0xe5 => {'REG' => "esp", "R/M" => "ebp"}},
                {0xd0 => {'REG' => "edx", "R/M" => "eax"}},
                # EAX
                {0xc0 => {'REG' => "eax", "R/M" => "eax"}},
                {0xc1 => {'REG' => "eax", "R/M" => "ecx"}},
                {0xc2 => {'REG' => "eax", "R/M" => "edx"}},
                {0xc3 => {'REG' => "eax", "R/M" => "ebx"}},
                {0xc4 => {'REG' => "eax", "R/M" => "esp"}},
                {0xc5 => {'REG' => "eax", "R/M" => "ebp"}},
                {0xc6 => {'REG' => "eax", "R/M" => "esi"}},
                {0xc7 => {'REG' => "eax", "R/M" => "edi"}},
                # ECX
                {0xc8 => {'REG' => "ecx", "R/M" => "eax"}},
                {0xc9 => {'REG' => "ecx", "R/M" => "ecx"}},
                {0xca => {'REG' => "ecx", "R/M" => "edx"}},
                {0xcb => {'REG' => "ecx", "R/M" => "ebx"}},
                {0xcc => {'REG' => "ecx", "R/M" => "esp"}},
                {0xcd => {'REG' => "ecx", "R/M" => "ebp"}},
                {0xce => {'REG' => "ecx", "R/M" => "esi"}},
                {0xcf => {'REG' => "eax", "R/M" => "edi"}},
                # EDX
                {0xd0 => {'REG' => "edx", "R/M" => "eax"}},
                {0xd1 => {'REG' => "edx", "R/M" => "ecx"}},
                {0xd2 => {'REG' => "edx", "R/M" => "edx"}},
                {0xd3 => {'REG' => "edx", "R/M" => "ebx"}},
                {0xd4 => {'REG' => "edx", "R/M" => "esp"}},
                {0xd5 => {'REG' => "edx", "R/M" => "ebp"}},
                {0xd6 => {'REG' => "edx", "R/M" => "esi"}},
                {0xd7 => {'REG' => "edx", "R/M" => "edi"}},
                # EBX
                {0xd8 => {'REG' => "ebx", "R/M" => "eax"}},
                {0xd9 => {'REG' => "ebx", "R/M" => "ecx"}},
                {0xda => {'REG' => "ebx", "R/M" => "edx"}},
                {0xdb => {'REG' => "ebx", "R/M" => "ebx"}},
                {0xdc => {'REG' => "ebx", "R/M" => "esp"}},
                {0xdd => {'REG' => "ebx", "R/M" => "ebp"}},
                {0xde => {'REG' => "ebx", "R/M" => "esi"}},
                {0xdf => {'REG' => "ebx", "R/M" => "edi"}},
                # ESP
                {0xe0 => {'REG' => "esp", "R/M" => "eax"}},
                {0xe1 => {'REG' => "esp", "R/M" => "ecx"}},
                {0xe2 => {'REG' => "esp", "R/M" => "edx"}},
                {0xe3 => {'REG' => "esp", "R/M" => "ebx"}},
                {0xe4 => {'REG' => "esp", "R/M" => "esp"}},
                {0xe5 => {'REG' => "esp", "R/M" => "ebp"}},
                {0xe6 => {'REG' => "esp", "R/M" => "esi"}},
                {0xe7 => {'REG' => "esp", "R/M" => "edi"}},
                # EBP
                {0xe8 => {'REG' => "ebp", "R/M" => "eax"}},
                {0xe9 => {'REG' => "ebp", "R/M" => "ecx"}},
                {0xea => {'REG' => "ebp", "R/M" => "edx"}},
                {0xeb => {'REG' => "ebp", "R/M" => "ebx"}},
                {0xec => {'REG' => "ebp", "R/M" => "esp"}},
                {0xed => {'REG' => "ebp", "R/M" => "ebp"}},
                {0xee => {'REG' => "ebp", "R/M" => "esi"}},
                {0xef => {'REG' => "ebp", "R/M" => "edi"}},
                # ESI
                {0xf0 => {'REG' => "esi", "R/M" => "eax"}},
                {0xf1 => {'REG' => "esi", "R/M" => "ecx"}},
                {0xf2 => {'REG' => "esi", "R/M" => "edx"}},
                {0xf3 => {'REG' => "esi", "R/M" => "ebx"}},
                {0xf4 => {'REG' => "esi", "R/M" => "esp"}},
                {0xf5 => {'REG' => "esi", "R/M" => "ebp"}},
                {0xf6 => {'REG' => "esi", "R/M" => "esi"}},
                {0xf7 => {'REG' => "esi", "R/M" => "edi"}},
                # EDI
                {0xf8 => {'REG' => "edi", "R/M" => "eax"}},
                {0xf9 => {'REG' => "edi", "R/M" => "ecx"}},
                {0xfa => {'REG' => "edi", "R/M" => "edx"}},
                {0xfb => {'REG' => "edi", "R/M" => "ebx"}},
                {0xfc => {'REG' => "edi", "R/M" => "esp"}},
                {0xfd => {'REG' => "edi", "R/M" => "ebp"}},
                {0xfe => {'REG' => "edi", "R/M" => "esi"}},
                {0xff => {'REG' => "edi", "R/M" => "edi"}},
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
                if @opcode_array.length == 1
                    return column_opcode_instruction['Instruction']
                else
                    return "#{column_opcode_instruction['Instruction']}, %x" % @opcode_array[1]
                end
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

