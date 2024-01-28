
uppercase.bin:     file format elf32-littleriscv


Disassembly of section .text:

00010074 <_start>:
   10074:	ffff2517          	auipc	a0,0xffff2
   10078:	f8c50513          	addi	a0,a0,-116 # 2000 <__DATA_BEGIN__>
   1007c:	06000613          	li	a2,96
   10080:	07a00693          	li	a3,122

00010084 <loop>:
   10084:	00050583          	lb	a1,0(a0)
   10088:	00058e63          	beqz	a1,100a4 <end_program>
   1008c:	00b67863          	bgeu	a2,a1,1009c <increment>
   10090:	00b6e663          	bltu	a3,a1,1009c <increment>
   10094:	fe058593          	addi	a1,a1,-32
   10098:	00b50023          	sb	a1,0(a0)

0001009c <increment>:
   1009c:	00150513          	addi	a0,a0,1
   100a0:	fe5ff06f          	j	10084 <loop>

000100a4 <end_program>:
   100a4:	0000006f          	j	100a4 <end_program>
