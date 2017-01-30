.data
	bemvindo	:	.asciiz "Bem vindo ao Boteco Simulator!\nEscolha uma das opções abaixo:\n1 - Listar Produtos\n2 - Histórico de Transações\n3 - Caixa\n0 - Sair"
	acoesBebidas	:	.asciiz "Escolha uma ação:\n1 - Vender\n2 - Comprar\n3 - Checar Estoque\n4 - Tipo\n5 - Valor\n0 - Sair"
	listaDeProdutos	:	.asciiz "[10] Polar 355ml \n[11] Polar 1000ml\n [0] Voltar"
	msgVender	:	.asciiz "Insira a quantidade que deseja vender (0 - Voltar):"
	msgSemEstoque	:	.asciiz "Quantidade em estoque insuficiente!\n   Quantidade Atual: "
	msgVendaSucc	:	.asciiz "Venda completa!\nTotal: R$"
	
	msgCaixa	:	.asciiz "Valor em caixa:\n    R$ "
	
	msgCompra	:	.asciiz "Valor atual de compra\n   R$"
	msgQtdCompra	:	.asciiz "Quantidade que deseja comprar:\n"
	msgCompraSucc	:	.asciiz "Compra bem sucedida!\n  Valor Total: R$"
	
	msgEstoque	:	.asciiz "Quantidade em estoque: "
	
	msgTipo		:	.asciiz	"Esta bebida é um tipo de "
	tipoCerveja	:	.asciiz "Cerveja"
	tipoUisque	:	.asciiz "Uísque"
	tipoAgua	:	.asciiz "Água"
	tipoSuco	:	.asciiz "Suco"
	
	msgValor	:	.asciiz "1 - Ver valor\n2 - Alterar valor"
	msgValorAtual	:	.asciiz "O valor atual da bebida é de R$ "
	msgNovoValor	:	.asciiz "Insira o novo valor para a bebida: "
	
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
	polar355	:	.word 10, 1, 5, 3
	polar1000	:	.word 11, 1, 10, 4

.text
li $t1, 0	#	Codigo da bebida
li $t2, 0	#	Auxiliar na busca do codigo
li $s0, 0	#	Valor em caixa


main:
	la $a0, bemvindo
	jal printMenuSelect
	nop
	beq $a0, 1, listar
	nop
	beq $a0, 0, exit
	nop
	beq $a0, 3, caixa
	nop
	
	
#-------------------------------------------------------------------------
#	Função para imprimir um menu de opções na tela
#	a mensagem deve ser definida anteriormente 
#	no registrador $a0 a opção escolhida
#	a opção escolhida é salva em $a0
#	o status da opção é salva em $a1
#-------------------------------------------------------------------------
# Inicio MENU-------------------------------------------------------------

printMenuSelect:
	li $v0, 51
	syscall
	jr $ra
	nop
	
# Fim MENU---------------------------------------------------------------------------
# Inicio LISTAR PRODUTOS-------------------------------------------------------------

listar:
	la $a0, listaDeProdutos
	jal printMenuSelect
	nop
	bne $a0, 0, selecionaBebida
	nop
	j main
	nop
	
# Fim LISTAR PORODUTOS-----------------------------------------------------------------
# Inicio SELECIONAR BEBIDA-------------------------------------------------------------

selecionaBebida:
	or $t1, $zero, $a0		# Armazena o código da bebida em T1
	jal procuraBebida
	nop
	j opcoesBebida
	nop

opcoesBebida:				# Ações possiveis para cada bebida
	la $a0, acoesBebidas
	jal printMenuSelect
	nop
	beq $a0, 0, listar
	nop
	beq $a0, 1, vender
	nop
	beq $a0, 2, comprar
	nop
	beq $a0, 3, estoque
	nop
	beq $a0, 4, tipo
	nop
	beq $a0, 5, valor
	nop

# 1 - Vender -------------------------------------------------------------
vender:
	la $a0, msgVender
	jal printMenuSelect
	nop
	or $t3, $zero, $a0		# quantidade a ser vendida da bebida
	bgt $t3, $t5, semEstoque	# quantiadade insuficiente no estoque
	nop
	mult $t3, $t6			# calcula o valor a ser recebido (qtd[$t3] * preço[$t6])
	mflo $t7			# salva o valor calculado
	add $s0, $s0, $t7		# adiciona ao caixa
	sub $t5, $t5, $t3		# diminui a quantidade em estoque
	sw $t5, 8($t0)			# salva nova quantidade em memoria
	j vendaSucc
	nop
	
semEstoque:
	la $a0, msgSemEstoque
	or $a1, $t5, $zero
	la $v0, 56
	syscall
	nop
	j vendaFail
	nop
vendaSucc:
	la $a0, msgVendaSucc
	or $a1, $t7, $zero
	la $v0, 56
	syscall
	nop
	j opcoesBebida
	nop
vendaFail:
	li $t3, 0
	j opcoesBebida
	nop

# 2 - Comprar----------------------------------------------------------------------------------------
comprar:
	li $s1, 2
	la $a0, msgCompra
	div $t6, $s1		#	valor de compra 50% do valor de venda
	mflo $t7		#	salva o valor em t7
	or $a1, $t7, $zero
	la $v0, 56
	syscall
	nop
	la $a0, msgQtdCompra
	jal printMenuSelect
	nop
	or $t3, $a0, $zero	# quantidade a comprar
	mult $t3, $t7		# valor da compra
	add $t5, $t5, $t3	# incrementa a quantidade em estoque
	sw $t5, 8($t0)		# salava a nova qtd na memoria
	mflo $t7		# valor total da compra
	sub $s0, $s0, $t7	# subtrai o valor total do caixa (mesmo que fique negativo)
	la $a0, msgCompraSucc
	la $v0, 56
	or $a1, $zero, $t7
	syscall
	nop
	j opcoesBebida
	nop
	
# 3 - Estoque
estoque:
	la $a0, msgEstoque
	or $a1, $zero, $t5
	la $v0, 56
	syscall
	nop
	j opcoesBebida
	nop

# 4 - Tipo Bebida
tipo:
	beq $t4, 1, tipoCer
	nop
	beq $t4, 2, tipoUis
	nop
	beq $t4, 3, tipoAgu
	nop
	beq $t4, 4, tipoSuc
	nop

tipoCer:
	la $a0, msgTipo
	la $a1, tipoCerveja
	la $v0, 59
	syscall
	nop
	j tipoVolta
	nop

tipoUis:
	la $a0, msgTipo
	la $a1, tipoUisque
	la $v0, 59
	syscall
	nop
	j tipoVolta
	nop

tipoAgu:
	la $a0, msgTipo
	la $a1, tipoAgua
	la $v0, 59
	syscall
	nop
	j tipoVolta
	nop

tipoSuc:
	la $a0, msgTipo
	la $a1, tipoSuco
	la $v0, 59
	syscall
	nop
	j tipoVolta
	nop

tipoVolta:
	j opcoesBebida
	nop
	

# 5 - Valor
valor:
	la $a0, msgValor
	jal printMenuSelect
	nop
	beq $a0, 1, verValor
	nop
	beq $a0, 2, alterarValor
	nop
	
verValor:
	la $a0, msgValorAtual
	or $a1, $zero, $t6
	la $v0, 56
	syscall
	nop
	j opcoesBebida
	nop

alterarValor:
# Inicio da BUSCA PELA BEBIDA SELECIONADA-------------------------------------------------------------
procuraBebida:
	beq $t1, $t2, fimProcuraBebida
	nop
	beq $t1, 0, listar
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

#Inicio CAIXA
caixa:
	la $a0, msgCaixa
	or $a1, $s0, $zero
	la $v0, 56
	syscall
	nop
	j main
	nop
#Fim CAIXA

# Fim do PROGRAMA-------------------------------------------------------------
exit:
	li $v0, 10
	syscall
