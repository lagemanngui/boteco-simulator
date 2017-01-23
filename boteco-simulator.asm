.data
	bemvindo	:	.asciiz "Bem vindo ao Boteco Simulator!\nEscolha uma das op��es abaixo:\n1 - Listar Produtos"
	listaDeProdutos:	.asciiz "10 - Polar 355ml \n11 - Polar 1000ml"

.text
main:
	la $a0, bemvindo
	jal printMenu
	nop
	#beq $a0, 1, listar
	#nop
	beq $a0, 0, exit
	nop
	

#Fun��o para imprimir um menu de op��es na tela
#a mensagem deve ser definida anteriormente 
#no registrador $a0 a op��o escolhida
#a op��o escolhida � salva em $a0
#o status da op��o � salva em $a1
printMenu:
	li $v0, 51
	syscall
	nop
	
listar:
	la $a0, listaDeProdutos
	jal printMenu
	nop
	beq $a0, 10, exit
	nop
	
exit:
	la $v0, 10
	syscall
