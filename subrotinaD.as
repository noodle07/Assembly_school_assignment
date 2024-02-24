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