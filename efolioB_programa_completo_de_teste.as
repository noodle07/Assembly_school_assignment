                ; zona de dados
                ORIG 8000h

ResA            TAB 16 ; 8000h, 8008h
FreqOperador    STR 0,0,0,0 ; 8010h,
FreqNumero      STR 0,0,0,0 ; 8014h,
FreqLetra       STR 0,0,0,0 ; 8018h,
ResC            TAB 4 ; 801ch
ResD            TAB 8 ; 8020h

                ; cartas
Lista1          STR 12,48,35,16,3,14,45,11,47,34,15,2,13,44,20,100
Lista2          STR 13,40,31,100
Lista3          STR 41,40,63,16,58,54,39,23,3,53,2,16,39,6,62,39,1,17,21,6,17,0,24,57,43,51,31,100
Lista4          STR 41,56,52,17,12,22,4,8,3,6,57,60,9,37,55,27,62,4,26,20,42,52,11,0,28,6,38,18,10,16,36,61,36,100
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ; zona do código
                ORIG 0000h

                ; inicialização do stack
Inicio:         MOV R1, fd1fh
                MOV SP, R1

                ; teste alínea A
                MOV R1, 23; valor a testar
                CALL subrotinaA; CALL ----- identificador da subrotina solicitada na alínea A
                MOV R1, ResA ;colocar endereço de ResA em R1
                MOV M[R1], R2   ;guardar R2,R3,R4(operador,numero,linha) em ResA
                MOV M[R1+1], R3
                MOV M[R1+2], R4
                ;------------------------------
                ; teste alínea A (2)
                MOV R1, 57
                CALL subrotinaA; CALL ----- identificador da subrotina solicitada na alínea A
                MOV R1, ResA ;colocar endereço de ResA em R1
                MOV M[R1+8], R2 ;guardar R2,R3,R4(operador,numero,linha) em ResA
                MOV M[R1+9], R3
                MOV M[R1+10], R4

                ; teste alínea B
                MOV R1, Lista1
                CALL subrotinaB; CALL ----- identificador da subrotina solicitada na alínea B

                ; teste alínea C
                MOV R1, 13 ;carta
                MOV R2, 40 ;carta
                CALL subrotinaC ;CALL ----- identificador da subrotina solicitada na alínea C
                MOV R1, ResC    ;pegar o endereco de ResC ;apontar para ResC
                MOV M[R1], R3   ;copiar conteudo de R3, colar no endereco em R1

                ; teste alínea C (2)
                MOV R1, 40 ;carta
                MOV R2, 31 ;carta
                CALL subrotinaC ;CALL ----- identificador da subrotina solicitada na alínea C
                MOV R1, ResC ;pegar o endereco de ResC ;apontar para ResC
                MOV M[R1+1], R3 ;copiar conteudo de R3, colar no endereco em R1

                ; teste alínea C (3)
                MOV R1, 13 ;carta
                MOV R2, 31 ;carta
                CALL subrotinaC ;CALL ----- identificador da subrotina solicitada na alínea C
                MOV R1, ResC ;pegar o endereco de ResC ;apontar para ResC
                MOV M[R1+2], R3 ;copiar conteudo de R3, colar no endereco em R1

                ; teste alínea C (4)
                MOV R1, 55 ;carta
                MOV R2, 22 ;carta
                CALL subrotinaC ;CALL ----- identificador da subrotina solicitada na alínea C
                MOV R1, ResC ;pegar o endereco de ResC ;apontar para ResC
                MOV M[R1+3], R3 ;copiar conteudo de R3, colar no endereco em R1

                ; teste alínea D
                MOV R1, Lista1
                CALL subrotinaD ;CALL ----- identificador da subrotina solicitada na alínea D
                MOV R2, ResD
                MOV M[R2], R1

                ; teste alínea D (2)
                MOV R1, Lista2
                CALL subrotinaD ;CALL ----- identificador da subrotina solicitada na alínea D
                MOV R2, ResD
                MOV M[R2+1], R1

                ; teste alínea D (3)
                MOV R1, Lista3
                CALL subrotinaD ;CALL ----- identificador da subrotina solicitada na alínea D
                MOV R2, ResD
                MOV M[R2+2], R1

                ; teste alínea D (4)
                MOV R1, Lista4
                CALL subrotinaD ;CALL ----- identificador da subrotina solicitada na alínea D
                MOV R2, ResD
                MOV M[R2+3], R1

Fim:            BR Fim

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
            RET ;bug o programa tava a retornar para o INIcio, stack indexado erradp---

ExisteIgualdade:    MOV R3, 1 ;armazenar resultado 1
                    POP R0;reposicionar o stack pointer no endereco para retornar
                    POP R0;reposicionar o stack pointer no endereco para retornar
                    POP R0;reposicionar o stack pointer no endereco para retornar
                    RET ; voltar ao endereco onde foi chamada a subrotina
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                ;inicializacoes
subrotinaD:     MOV R5, R0 ; INICIAR CONTADOR de elementos da lista
                MOV R3, R1; ENDERECO INICIAL DA LISTA
                MOV R6, R0;I inicializar variavel I
                MOV R7, R6;J inicializar variavel J (j = i...)
                INC R7; J = I + 1 ; inicializar

                ;contar numero de elementos/cartas da lista
contarLoop:     MOV R4, M[R3];obter a carta atual da lista
                CMP R4, 100d; VERIFICAR SE ATINGIU O FIM DA LISTA
                BR.Z SUBD_LOOP; se sim sair e prosseguir com a subrotina
                INC R5; incrementar contador
                INC R3; avancar para o proximo elemento
                JMP contarLoop ;R5 = contagem

                ;loop da subrotina
                ;obter cartas
     SUBD_LOOP: PUSH R1;MOV  M[801ch], R1 ;BACKUP ENDERECO DA LISTA, vou ter os registos todos em uso, por isso guardo na memoria
                MOV  R1, M[SP+1] ; r1 fica com o endereco
                ADD  R1, R6; adiciona index I
                MOV  R1, M[R1]; PRIMEIRA CARTA
                MOV  R2, M[SP+1]; R2 fica como endereco
                ADD  R2, R7;adicionar index j
                MOV  R2, M[R2]; SEGUNDA CARTA
                CMP  R2, 100d; verificar se a segunda carta nao é o fim da lista
                JMP.Z CHECKSUBD;chegamos ao fim, j iterou ate ao fim da lista

                ;comparar cartas
                CALL subrotinaC; verificar se duas cartas têm o mesmo código num dos tipos, operador, número ou letra
                ADD M[f120h], R3 ;GUARDAR RESULTADO à frente do stack; 0 = nao semelhantes; 1 = semelhantes (semelhantes se tem o mesmo codigo num dos componentes)
                POP R1 ;obter o endereco backup da Lista
                INC R7 ;icrementar J
                CMP R7, R5 ;verificar se J atingiu o limite
                JMP.Z CHECKSUBD ;chegamos ao fim da lista
                JMP SUBD_LOOP

     CHECKSUBD: INC R6; incrementa I
                CMP R6, R5 ;SE JA CHEGOU AO FIM DA LISTA (I) R5 = num_cartas, se I = num_cartas
                JMP.Z FIM_SUBD; acabou o loop, I iterou até chegar ao fim da lista
                MOV R7, R6;j = i; atualiza J (porque I atualizou)
                INC R7; J = I + 1
                JMP SUBD_LOOP;vamos continuar a iterar pela lista, I ainda nao chegou ao limite(fim da lista)

FIM_SUBD:       MOV R1, M[f120h] ;passar o resultado da subrotinaD para R1
                POP R0;retirar endereco (incrementar SP)
                MOV M[f120h], R0 ;resetar contador/limpar esta posicao de memoria
                ;POP R0; retirar contador(incrementar SP para retornarmos, onde tem o endereco para o PC)
                RET  ;RETORNAR PORQUE CHEGAMOS AO FIM DA LISTA

;Traduzindo em linguagem C ficaria assim:
;for (int i = 0; i < num_cartas; i++) {
;        for (int j = i + 1; j < num_cartas; j++) {  // Evitar comparação da mesma carta
;            if (cartas_sao_iguais(baralho[i], baralho[j])) {
;                pares_iguais++; #tem o mesmo codigo
;            } #cartas_sao_iguais = subrotinaC
;        }
;    }
