.data
	bemvindo	:	.asciiz "Bem vindo ao Boteco Simulator!\nEscolha uma das opções abaixo:\n1 - Listar Produtos"
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
	

#Função para imprimir um menu de opções na tela
#a mensagem deve ser definida anteriormente 
#no registrador $a0 a opção escolhida
#a opção escolhida é salva em $a0
#o status da opção é salva em $a1
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
