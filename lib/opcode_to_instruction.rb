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
            {'Instruction' => 'add', 'Opcode' => 0x00, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'add', 'Opcode' => 0x02, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'add', 'Opcode' => 0x03, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'adc', 'Opcode' => 0x10, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'adc', 'Opcode' => 0x11, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'adc', 'Opcode' => 0x12, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'adc', 'Opcode' => 0x13, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'and', 'Opcode' => 0x20, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'and', 'Opcode' => 0x21, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'and', 'Opcode' => 0x22, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'and', 'Opcode' => 0x23, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'xor', 'Opcode' => 0x30, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'xor', 'Opcode' => 0x31, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'xor', 'Opcode' => 0x32, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'xor', 'Opcode' => 0x33, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'or', 'Opcode' => 0x08, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'or', 'Opcode' => 0x09, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'or', 'Opcode' => 0x0a, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'or', 'Opcode' => 0x0b, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'sbb', 'Opcode' => 0x18, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'sbb', 'Opcode' => 0x19, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'sbb', 'Opcode' => 0x1a, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'sbb', 'Opcode' => 0x1b, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'sub', 'Opcode' => 0x28, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'sub', 'Opcode' => 0x29, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'sub', 'Opcode' => 0x2a, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'sub', 'Opcode' => 0x2b, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'cmp', 'Opcode' => 0x38, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'cmp', 'Opcode' => 0x39, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'cmp', 'Opcode' => 0x3a, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'cmp', 'Opcode' => 0x3b, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'arpl', 'Opcode' => 0x63, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'imul', 'Opcode' => 0x69, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'imul', 'Opcode' => 0x6b, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'add', 'Opcode' => 0x80, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'add', 'Opcode' => 0x81, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'sub', 'Opcode' => 0x82, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'sub', 'Opcode' => 0x83, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'test', 'Opcode' => 0x84, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'test', 'Opcode' => 0x85, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'xchg', 'Opcode' => 0x86, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'xchg', 'Opcode' => 0x87, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'mov', 'Opcode' => 0x88, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'mov', 'Opcode' => 0x8a, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'mov', 'Opcode' => 0x8b, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'mov', 'Opcode' => 0x8c, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'mov', 'Opcode' => 0x8e, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'pop', 'Opcode' => 0x8f, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'mov', 'Opcode' => 0xc6, 'r_mod' => 0x1}, # MOD R/M enable
            {'Instruction' => 'mov', 'Opcode' => 0xc7, 'r_mod' => 0x1}, # MOD R/M enable
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
            {'Instruction' => 'mov eax', 'Opcode' => 0xa1, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'mov eax', 'Opcode' => 0xa3, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'mov eax', 'Opcode' => 0xb8, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'mov ecx', 'Opcode' => 0xb9, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'mov edx', 'Opcode' => 0xba, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'mov ebx', 'Opcode' => 0xbb, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'mov esp', 'Opcode' => 0xbc, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'mov ebp', 'Opcode' => 0xbd, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'mov esi', 'Opcode' => 0xbe, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'mov edi', 'Opcode' => 0xbf, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'retn', 'Opcode' => 0xc2, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'retf', 'Opcode' => 0xca, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'int', 'Opcode' => 0xcd, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'aam', 'Opcode' => 0xd4, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'aad', 'Opcode' => 0xd5, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'loopnz', 'Opcode' => 0xe0, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'loopz', 'Opcode' => 0xe1, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'loop', 'Opcode' => 0xe2, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'jcxz', 'Opcode' => 0xe3, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'in eax', 'Opcode' => 0xe5, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'out eax', 'Opcode' => 0xe7, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'call', 'Opcode' => 0xe8, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'jmp', 'Opcode' => 0xe9, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'jmp', 'Opcode' => 0xea, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'jmp', 'Opcode' => 0xeb, 'r_mod' => 0x0}, # MOD R/M disable
                # [ LENGTH 1 ]
            {'Instruction' => 'push ebp', 'Opcode' => 0x55, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'retn', 'Opcode' => 0xc3, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'leave', 'Opcode' => 0xc9, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'push es', 'Opcode' => 0x06, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'push ss', 'Opcode' => 0x16, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'pop es', 'Opcode' => 0x07, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'pop ss', 'Opcode' => 0x17, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'push cs', 'Opcode' => 0x0e, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'push ds', 'Opcode' => 0x1e, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'pop ds', 'Opcode' => 0x1f, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'inc eax', 'Opcode' => 0x40, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'inc ecx', 'Opcode' => 0x41, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'inc edx', 'Opcode' => 0x42, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'inc ebx', 'Opcode' => 0x43, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'inc esp', 'Opcode' => 0x44, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'inc ebp', 'Opcode' => 0x45, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'inc esi', 'Opcode' => 0x46, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'inc edi', 'Opcode' => 0x47, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'dec eax', 'Opcode' => 0x48, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'dec ecx', 'Opcode' => 0x49, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'dec edx', 'Opcode' => 0x4a, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'dec ebx', 'Opcode' => 0x4b, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'dec esp', 'Opcode' => 0x4c, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'dec ebp', 'Opcode' => 0x4d, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'dec esi', 'Opcode' => 0x4e, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'dec edi', 'Opcode' => 0x4f, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'push eax', 'Opcode' => 0x50, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'push ecx', 'Opcode' => 0x51, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'push edx', 'Opcode' => 0x52, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'push ebx', 'Opcode' => 0x53, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'push esp', 'Opcode' => 0x54, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'push ebp', 'Opcode' => 0x55, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'push esi', 'Opcode' => 0x56, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'push edi', 'Opcode' => 0x57, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'pop eax', 'Opcode' => 0x58, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'pop ecx', 'Opcode' => 0x59, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'pop edx', 'Opcode' => 0x5a, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'pop ebx', 'Opcode' => 0x5b, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'pop esp', 'Opcode' => 0x5c, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'pop ebp', 'Opcode' => 0x5d, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'pop esi', 'Opcode' => 0x5e, 'r_mod' => 0x0}, # MOD R/M disable
            {'Instruction' => 'pop edi', 'Opcode' => 0x5f, 'r_mod' => 0x0}, # MOD R/M disable

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
            ],
            0b01 => [
                # EAX
                {0x40 => {'REG' => 'eax', "R/M" => "eax"}},
                {0x41 => {'REG' => 'eax', "R/M" => "ecx"}},
                {0x42 => {'REG' => 'eax', "R/M" => "edx"}},
                {0x43 => {'REG' => 'eax', "R/M" => "ebx"}},
                {0x45 => {'REG' => 'eax', "R/M" => "ebp"}},
                {0x46 => {'REG' => 'eax', "R/M" => "esi"}},
                {0x47 => {'REG' => 'eax', "R/M" => "edi"}},
                # ECX
                {0x48 => {'REG' => 'ecx', "R/M" => "eax"}},
                {0x49 => {'REG' => 'ecx', "R/M" => "ecx"}},
                {0x4a => {'REG' => 'ecx', "R/M" => "edx"}},
                {0x4b => {'REG' => 'ecx', "R/M" => "ebx"}},
                {0x4d => {'REG' => 'ecx', "R/M" => "ebp"}},
                {0x4e => {'REG' => 'ecx', "R/M" => "esi"}},
                {0x4f => {'REG' => 'ecx', "R/M" => "edi"}},
                # EDX
                {0x50 => {'REG' => 'edx', "R/M" => "eax"}},
                {0x51 => {'REG' => 'edx', "R/M" => "ecx"}},
                {0x52 => {'REG' => 'edx', "R/M" => "edx"}},
                {0x53 => {'REG' => 'edx', "R/M" => "ebx"}},
                {0x55 => {'REG' => 'edx', "R/M" => "ebp"}},
                {0x56 => {'REG' => 'edx', "R/M" => "esi"}},
                {0x57 => {'REG' => 'edx', "R/M" => "edi"}},
                # EBX
                {0x58 => {'REG' => 'ebx', "R/M" => "eax"}},
                {0x59 => {'REG' => 'ebx', "R/M" => "ecx"}},
                {0x5a => {'REG' => 'ebx', "R/M" => "edx"}},
                {0x5b => {'REG' => 'ebx', "R/M" => "ebx"}},
                {0x5d => {'REG' => 'ebx', "R/M" => "ebp"}},
                {0x5e => {'REG' => 'ebx', "R/M" => "esi"}},
                {0x5f => {'REG' => 'ebx', "R/M" => "edi"}},
                # ESP
                {0x60 => {'REG' => 'esp', "R/M" => "eax"}},
                {0x61 => {'REG' => 'esp', "R/M" => "ecx"}},
                {0x62 => {'REG' => 'esp', "R/M" => "edx"}},
                {0x63 => {'REG' => 'esp', "R/M" => "ebx"}},
                {0x65 => {'REG' => 'esp', "R/M" => "ebp"}},
                {0x66 => {'REG' => 'esp', "R/M" => "esi"}},
                {0x67 => {'REG' => 'esp', "R/M" => "edi"}},
                # ESP
                {0x68 => {'REG' => 'ebp', "R/M" => "eax"}},
                {0x69 => {'REG' => 'ebp', "R/M" => "ecx"}},
                {0x6a => {'REG' => 'ebp', "R/M" => "edx"}},
                {0x6b => {'REG' => 'ebp', "R/M" => "ebx"}},
                {0x6d => {'REG' => 'ebp', "R/M" => "ebp"}},
                {0x6e => {'REG' => 'ebp', "R/M" => "esi"}},
                {0x6f => {'REG' => 'ebp', "R/M" => "edi"}},
                # ESI
                {0x70 => {'REG' => 'esi', "R/M" => "eax"}},
                {0x71 => {'REG' => 'esi', "R/M" => "ecx"}},
                {0x72 => {'REG' => 'esi', "R/M" => "edx"}},
                {0x73 => {'REG' => 'esi', "R/M" => "ebx"}},
                {0x75 => {'REG' => 'esi', "R/M" => "ebp"}},
                {0x76 => {'REG' => 'esi', "R/M" => "esi"}},
                {0x77 => {'REG' => 'esi', "R/M" => "edi"}},
                # EDI
                {0x78 => {'REG' => 'edi', "R/M" => "eax"}},
                {0x79 => {'REG' => 'edi', "R/M" => "ecx"}},
                {0x7a => {'REG' => 'edi', "R/M" => "edx"}},
                {0x7b => {'REG' => 'edi', "R/M" => "ebx"}},
                {0x7d => {'REG' => 'edi', "R/M" => "ebp"}},
                {0x7e => {'REG' => 'edi', "R/M" => "esi"}},
                {0x7f => {'REG' => 'edi', "R/M" => "edi"}},
                


            ]
=begin
            00 => [

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
                mod_value = get_mod(@opcode_array[1])
                regex_field_rm = get_field_rm(dbit, mod_value)
                
                regex_field_rm["%MOD%"] = opcode
                regex_field_rm["%R/M%"] = get_column_mode(mod_value, @opcode_array[1])['R/M']
                regex_field_rm["%REG%"] = get_column_mode(mod_value, @opcode_array[1])['REG']
                if mod_value == 0b01
                    regex_field_rm["%BYTE%"] = "%x" % @opcode_array[2]
                end
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

    def get_field_rm(dbit, mod_value)
        if mod_value == 0b11
            dbit == 0 ? "%MOD% %R/M%, %REG%" : dbit == 1 ? "%MOD% %REG%, %R/M%" : "INVALID OPCODE"
        elsif mod_value == 0b01
            dbit == 0 ? "%MOD% %R/M%, [%REG%+%BYTE%]" : dbit == 1 ? "%MOD% %REG%, [%R/M%+%BYTE%]" : "INVALID OPCODE"
        end 
    end
end 

