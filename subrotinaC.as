subrotinaC: PUSH R2;MOV R5, R2 ;backup 2ª carta pra usar depois na subtorinaA
            CALL subrotinaA ;R1 ainda tem o valor da carta
                            ;r2, r3 e r4 tem o operador,numero e letra da carta respetivamente
            POP R1;MOV R1, R5 ;obter backup, segunda carta

            ;GUARDAR VALORES DA 1 CARTA
            ;vao ser usados para comparar com a outra carta
            ;precisamos que os registos r2,r3 e r4 se encontrem livre para uso,
            ;que vao sem reescritos pela subrotinaA
            PUSH R2 ;guardar valor da carta (operador)
            PUSH R3 ;guardar valor da carta (numero)
            PUSH R4 ;guardar valor da carta (LETRA)

            CALL subrotinaA

            ; Compara operadores, números e letras
            CMP M[SP+3], R2
            BR.Z ExisteIgualdade ; Se operadores iguais, então há igualdade
            CMP M[SP+2], R3
            BR.Z ExisteIgualdade ; Se números iguais, então há igualdade
            CMP M[SP+1], R4
            BR.Z ExisteIgualdade ; Se letras iguais, então há igualdade
            MOV  R3, 0 ;Armazenar resultado 0
            POP R0;reposicionar o stack pointer no endereco para retornar
            POP R0;reposicionar o stack pointer no endereco para retornar
            POP R0;reposicionar o stack pointer no endereco para retornar
            RET; retornar da chamda à subrotina