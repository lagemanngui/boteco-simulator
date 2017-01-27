.data
	bemvindo	:	.asciiz "Bem vindo ao Boteco Simulator!\nEscolha uma das opções abaixo:\n1 - Listar Produtos"
	listaDeProdutos	:	.asciiz "[10] Polar 355ml \n[11] Polar 1000ml"
	
	tipoCerveja	:	.asciiz "Cerveja"
	tipoUisque	:	.asciiz "Uisque"
	
	# Cada bebida possui os seguintes atributos
	#	a. Codigo de Busca
	#	b. Tipo de Bebida:
	#		1 - Cerveja
	#		2 - Uisque
	#		3 - Agua
	#		4 - Suco
	#	c. Quantidade em Estoque
	#	d. Valor unitario
	
	# Ponto inicial do registro de bebidas
	ini		:	.word 1		
	# Bebidas		
	polar355	:	.word 10, 1, 5, 2
	polar1000	:	.word 11, 1, 10, 4

.text
li $t1, 0	#Codigo da bebida
li $t2, 0	#Auxiliar na busca do codigo

main:
	la $a0, bemvindo
	jal printMenuSelect
	nop
	beq $a0, 1, listar
	nop
	beq $a0, 0, exit
	nop
	

#	Função para imprimir um menu de opções na tela
#	a mensagem deve ser definida anteriormente 
#	no registrador $a0 a opção escolhida
#	a opção escolhida é salva em $a0
#	o status da opção é salva em $a1

# Inicio MENU-------------------------------------------------------------
printMenuSelect:
	li $v0, 51
	syscall
	jr $ra
	nop
# Fim MENU-------------------------------------------------------------


# Inicio LISTAR PRODUTOS-------------------------------------------------------------
listar:
	la $a0, listaDeProdutos
	jal printMenuSelect
	nop
	beq $a1, 0, selecionaBebida
	nop
	
# Fim LISTAR PORODUTOS-------------------------------------------------------------



# Inicio SELECIONAR BEBIDA-------------------------------------------------------------
selecionaBebida:
	or $t1, $zero, $a0		# Armazena o código da bebida em T1
	jal procuraBebida
	nop
	j exit
	nop

procuraBebida:
	beq $t1, $t2, fimProcuraBebida
	nop
	la $t0, ini
	add $t0, $t0, 4		#inicio da busca
busca:	
	lw $t3, 0($t0)
	bne $t1, $t3, naoAchou
	nop
	or $t2, $zero, $t3
	j fimProcuraBebida
	nop

naoAchou:
	add $t0, $t0, 16	#proximo codigo
	j busca
	nop		

fimProcuraBebida:
	lw $t4, 4($t0)		# Carrega o tipo de Bebida
	lw $t5, 8($t0)		# Carrega a quantidade em estoque
	lw $t6, 12($t0)		# Carrega o preco unitario
	jr $ra
	nop

# Fim SELECAO DE BEBIDAS-----------------------------------------------------------------


# Fim do PROGRAMA-------------------------------------------------------------
exit:
	li $v0, 10
	syscall
