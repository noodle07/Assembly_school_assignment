                ;operador
subrotinaA:     MOV R2, R1; copiar para R2
                SHR R2, 4;deslocacao para obter os 2 bits mais significativos
                AND R2, 3d; 3d = 11b mascara para manter apenas os 2 bits menos significativos

                ;numero
                MOV R3, R1; copiar para R3
                SHR R3, 2; deslocacao para perder os 2 bits menos significativos, e os bits intermedios ficam nessas 2 posicoes
                AND R3, 3d; 3d = 11b mascara para manter apenas os 2 bits menos significativos

                ;letra
                MOV R4, R1; copiar para R4
                AND R4, 3d; 3d = 11b mascara para manter apenas os 2 bits menos significativos
                RET ; retornar da subrotina