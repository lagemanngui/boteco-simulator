.data
	bemvindo	:	.asciiz "Bem vindo ao Boteco Simulator!\nEscolha uma das opções abaixo:\n1 - Listar Produtos"
	listaDeProdutos	:	.asciiz "[10] Polar 355ml \n[11] Polar 1000ml"
	
	tipoCerveja	:	.asciiz "Cerveja"
	tipoUisque	:	.asciiz "Uisque"
	
	
	polar355	:	.word 10
	polar355Nome	:	.space 16
	polar355Tipo	:	.space 4
	polar355Qtd	:	.word 10
	polar355Preco	:	.word 2

.text
main:
	la $a0, bemvindo
	jal printMenuSelect
	nop
	beq $a0, 1, listar
	nop
	beq $a0, 0, exit
	nop
	

#Função para imprimir um menu de opções na tela
#a mensagem deve ser definida anteriormente 
#no registrador $a0 a opção escolhida
#a opção escolhida é salva em $a0
#o status da opção é salva em $a1
printMenuSelect:
	li $v0, 51
	syscall
	jr $ra
	nop
	
listar:
	la $a0, listaDeProdutos
	jal printMenuSelect
	nop
	beq $a0, 10, exit
	nop
	
exit:
	li $v0, 10
	syscall
