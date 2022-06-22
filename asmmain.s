	PRESERVE8
	AREA LPTMRint, CODE, READONLY
	EXPORT asm_lptmr_irq
LPTMR0_IRQHandler EQU asm_lptmr_irq+1
	EXPORT LPTMR0_IRQHandler
		
asm_lptmr_irq
	PUSH {LR}
	LDR R2, =my_LPTMR0_CSR
	LSL R2, R2, #5
	LDR R3, =ALIASED_base
	ADD R2, R2, R3
	MOV R3, #7
	ADD R2, R2, R3, LSL #2
	MOV R1, #0x1
	STR R1, [R2]
	LDR R1, =lptmr_intcrementor
	LDR R0, [R1]
	ADD R0, #1
	STR R0, [R1]
	POP {PC}


	AREA MyCode, CODE, READONLY
	EXPORT asmmain
	EXPORT init_LPTimer

asmmain
	import print_f

init_LPTimer
	LDR R2, =my_SIM_SCGS5
	LDR R3, =my_LPTMR0_CSR
	MOV R1, #1
	LDR R0, [R2]
	ORR R0, R0, R1
	STR R0, [R2]
	MOV R1,#0x00000040; initialize
	STR R1, [R3]
	LDR R3, =my_LPTMR0_PSR
	MOV R1, #0x5
	STR R1, [R3]

	LDR R2, =my_LPTMR0_CMR
	MOV R1, #10010
	STR R1, [R2]
	
enable
	LDR R2, =my_NVIC_value
	LDR R1, =my_NVIC_addr
	STR R2, [R1, #0x8]
	LDR R2, =my_LPTMR0_CSR
	LDR R0, [R2]
	ORR R0, R0, #1
	STR R0, [R2]

check_interupt
	LDR R7, =incrementor
	LDR R8, =lptmr_intcrementor
	LDR R4, [R7]
	LDR R5, [R8]
	CMP R4, R5
	BNE read_interupt
	B check_interupt

read_interupt
	LDR R7, =incrementor
	ADD R4, R4, #1
	STR R4, [R7]
	MOV R0, R4
	BL print_f
	B check_interupt




ALIGN
	AREA MyData, DATA, READWRITE
lptmr_intcrementor DCD 0
incrementor DCD 0
my_LPTMR0_CSR EQU 0x40040000 ;CSR register address
my_LPTMR0_PSR EQU 0x40040004 ;PSR register address
my_LPTMR0_CMR EQU 0x40040008 ;CMR register address
my_LPTMR0_CNR EQU 0x4004000C ;CNR register address
my_SIM_SCGS5 EQU 0x40048038
my_NVIC_value EQU 0x00200000
my_NVIC_addr EQU 0xE000E100
ALIASED_base EQU 0x42000000
	END

