subrotinaB:     PUSH R1 ;BACKUP ENDERECO DA LISTA
                MOV  R1, M[R1] ;primera carta da lista fica em R1(subrotinaA tem R1 como input)

    SUBB_LOOP:  CALL subrotinaA;r2 r3 e r4 ficaram com os codigos da carta

                ;   CONTADORES: _,_,_,_,(+,-,*,/) (M[R1],M[R1+1],M[R1+2],M[R1+3])
                ;se Operador = 0, _,_,_,_,(+,-,*,/) (M[R1],M[R1+1],M[R1+2],M[R1+3])

;O algoritmo funciona igual para cada componente da carta, por isso não vale a pena comentar tudo
    ;FREQ OPERADOR
        R2_0:   CMP R2, 0  ;CONDICAO, se r2 representa "+"
                JMP.Z R2_0_1 ;comparacao retorna TRUE/verdade
                JMP ELSER2_1  ;se nao for verdade a condicao, pular para a outra verificacao
        R2_0_1: MOV R1, FreqOperador;colocar endereco em R1
                INC M[R1] ;incrementar contador de "+"
                JMP R3_0 ; comparar o seguinte componente da carta que é "numero"

    ELSER2_1:   CMP R2, 1 ;verificar se R2 representa "-"
                JMP.Z ELSER2_1_1 ;comparacao retorna TRUE/verdade
                JMP ELSE2R2_2 ;se nao for verdade a condicao
    ELSER2_1_1: MOV R1, FreqOperador ;colocar endereco em R1
                INC M[R1+1] ;incrementar contador "-"
                JMP R3_0 ; comparar o seguinte componente da carta que é "numero"

    ELSE2R2_2:  CMP R2, 2 ;verificar se R2 representa "*"
                JMP.Z ELSE2R2_2_1 ;comparacao retorna TRUE/verdade
                JMP ELSE2R2_3 ;se nao for verdade a condicao
    ELSE2R2_2_1:MOV R1, FreqOperador ;colocar endereco em R1
                INC M[R1+2] ;incrementar contador "*"
                JMP R3_0 ; comparar o seguinte componente da carta que é "numero"

    ELSE2R2_3:  CMP R2, 3 ;verificar se R2 representa "/"
                MOV R1, FreqOperador  ;como o componente nao correspondeu com os outros 3, só pode ser este
                INC M[R1+3]
                JMP R3_0

    ;FREQ NUMERADOR
        R3_0:   CMP R3, R0  ;verificar se R3 representa "1"
                JMP.Z R3_0_1
                JMP ELSER3_1
        R3_0_1: MOV R1, FreqNumero
                INC M[R1]
                JMP R4_0

    ELSER3_1:   CMP R3, 1 ;verificar se R3 representa "2"
                JMP.Z ELSER3_1_1
                JMP ELSE2R3_2
    ELSER3_1_1: MOV R1, FreqNumero
                INC M[R1+1]
                JMP R4_0

    ELSE2R3_2:  CMP R3, 2 ;verificar se R3 representa "3"
                JMP.Z ELSE2R3_2_1
                JMP ELSE2R3_3
    ELSE2R3_2_1:MOV R1, FreqNumero
                INC M[R1+2]
                JMP R4_0

    ELSE2R3_3:  CMP R3, 3 ;verificar se R3 representa "4"
                MOV R1, FreqNumero
                INC M[R1+3]
                JMP R4_0

    ;FREQ LETRA
        R4_0:   CMP R4, R0  ;verificar se R4 representa "A"
                JMP.Z R4_0_1
                JMP ELSER4_1
        R4_0_1: MOV R1, FreqLetra
                INC M[R1]
                JMP FIM_FREQ_CALC

    ELSER4_1:   CMP R4, 1 ;verificar se R4 representa "B"
                JMP.Z ELSER4_1_1
                JMP ELSE2R4_2
    ELSER4_1_1: MOV R1, FreqLetra
                INC M[R1+1]
                JMP FIM_FREQ_CALC

    ELSE2R4_2:  CMP R4, 2 ;verificar se R4 representa "C"
                JMP.Z ELSE2R4_2_1
                JMP ELSE2R4_3
    ELSE2R4_2_1:MOV R1, FreqLetra
                INC M[R1+2]
                JMP FIM_FREQ_CALC

    ELSE2R4_3:  CMP R4, 3 ;verificar se R4 representa "D"
                MOV R1, FreqLetra
                INC M[R1+3]
                JMP FIM_FREQ_CALC

FIM_FREQ_CALC:  POP R1 ;MOV R1, R5 ;obter o endereco backup da Lista
                INC R1     ;avancar um endereco para ir para a proxima carta
                PUSH R1 ;MOV R5, R1 ;backup do novo endereco para usar mais tarde
                MOV  R1, M[R1];obter carta no novo endereco
                CMP  R1, 100d ;veficar se estamos no fim da lista
                JMP.Z FIM_LISTA ;chegamos ao fim da lista
                JMP SUBB_LOOP; voltar ao loop

    FIM_LISTA:  POP R0;reposicionar o stack pointer no endereco para retornar
                RET ;RETORNAR PORQUE CHEGAMOS AO FIM DA LISTA