
;CodeVisionAVR C Compiler V3.48b 
;(C) Copyright 1998-2022 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATmega8535
;Program type           : Application
;Clock frequency        : 1.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 128 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8535
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 512
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPMCSR=0x37
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x025F
	.EQU __DSTACK_SIZE=0x0080
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.EQU __FLASH_PAGE_SIZE=0x20

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETW1P
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETD1P_INC
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	.ENDM

	.MACRO __GETD1P_DEC
	LD   R23,-X
	LD   R22,-X
	LD   R31,-X
	LD   R30,-X
	.ENDM

	.MACRO __PUTDP1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTDP1_DEC
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __CPD10
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	.ENDM

	.MACRO __CPD20
	SBIW R26,0
	SBCI R24,0
	SBCI R25,0
	.ENDM

	.MACRO __ADDD12
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	.ENDM

	.MACRO __ADDD21
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	.ENDM

	.MACRO __SUBD12
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	.ENDM

	.MACRO __SUBD21
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	.ENDM

	.MACRO __ANDD12
	AND  R30,R26
	AND  R31,R27
	AND  R22,R24
	AND  R23,R25
	.ENDM

	.MACRO __ORD12
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	.ENDM

	.MACRO __XORD12
	EOR  R30,R26
	EOR  R31,R27
	EOR  R22,R24
	EOR  R23,R25
	.ENDM

	.MACRO __XORD21
	EOR  R26,R30
	EOR  R27,R31
	EOR  R24,R22
	EOR  R25,R23
	.ENDM

	.MACRO __COMD1
	COM  R30
	COM  R31
	COM  R22
	COM  R23
	.ENDM

	.MACRO __MULD2_2
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	.ENDM

	.MACRO __LSRD1
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	.ENDM

	.MACRO __LSLD1
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	.ENDM

	.MACRO __ASRB4
	ASR  R30
	ASR  R30
	ASR  R30
	ASR  R30
	.ENDM

	.MACRO __ASRW8
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	.ENDM

	.MACRO __LSRD16
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	.ENDM

	.MACRO __LSLD16
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
	.ENDM

	.MACRO __CWD1
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	.ENDM

	.MACRO __CWD2
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	.ENDM

	.MACRO __SETMSD1
	SER  R31
	SER  R22
	SER  R23
	.ENDM

	.MACRO __ADDW1R15
	CLR  R0
	ADD  R30,R15
	ADC  R31,R0
	.ENDM

	.MACRO __ADDW2R15
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	.ENDM

	.MACRO __EQB12
	CP   R30,R26
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __NEB12
	CP   R30,R26
	LDI  R30,1
	BRNE PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12
	CP   R30,R26
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12
	CP   R26,R30
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12
	CP   R26,R30
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12
	CP   R30,R26
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12U
	CP   R30,R26
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12U
	CP   R26,R30
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12U
	CP   R26,R30
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12U
	CP   R30,R26
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __CPW01
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	.ENDM

	.MACRO __CPW02
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	.ENDM

	.MACRO __CPD12
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	.ENDM

	.MACRO __CPD21
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	.ENDM

	.MACRO __BSTB1
	CLT
	TST  R30
	BREQ PC+2
	SET
	.ENDM

	.MACRO __LNEGB1
	TST  R30
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __LNEGW1
	OR   R30,R31
	LDI  R30,1
	BREQ PC+2
	LDI  R30,0
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	RCALL __GETW1Z
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	RCALL __GETD1Z
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __GETW2X
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __GETD2X
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _Vin=R5
	.DEF _decimal=R4
	.DEF _unidades=R7
	.DEF _decenas=R6
	.DEF _centi=R8
	.DEF _centi_msb=R9
	.DEF _temp=R10
	.DEF _temp_msb=R11
	.DEF _millarA=R13
	.DEF _centenaA=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_tabla:
	.DB  0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37
	.DB  0x38,0x39
_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x2

_0x6:
	.DB  0x2
_0x7:
	.DB  0x2
_0x8:
	.DB  0x1
_0x9:
	.DB  0x1
_0xA:
	.DB  0x1
_0xB:
	.DB  0x2
_0x0:
	.DB  0x45,0x53,0x43,0x4F,0x4D,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x02
	.DW  0x0C
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _decenaA
	.DW  _0x6*2

	.DW  0x01
	.DW  _unidadA
	.DW  _0x7*2

	.DW  0x01
	.DW  _unidadM
	.DW  _0x8*2

	.DW  0x01
	.DW  _unidadD
	.DW  _0x9*2

	.DW  0x01
	.DW  _decenaH
	.DW  _0xA*2

	.DW  0x01
	.DW  _unidadH
	.DW  _0xB*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0xE0

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;unsigned char read_adc(unsigned char adc_input)
; 0000 0029 {

	.CSEG
_read_adc:
; .FSTART _read_adc
; 0000 002A ADMUX=adc_input | ADC_VREF_TYPE;
	RCALL SUBOPT_0x0
;	adc_input -> R17
	MOV  R30,R17
	ORI  R30,LOW(0x60)
	OUT  0x7,R30
; 0000 002B // Delay needed for the stabilization of the ADC input voltage
; 0000 002C delay_us(10);
	__DELAY_USB 3
; 0000 002D // Start the AD conversion
; 0000 002E ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 002F // Wait for the AD conversion to complete
; 0000 0030 while ((ADCSRA & (1<<ADIF))==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 0031 ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 0032 return ADCH;
	IN   R30,0x5
	RJMP _0x2080001
; 0000 0033 }
; .FEND

	.DSEG
;void checaBoton(){
; 0000 0042 void checaBoton(){

	.CSEG
_checaBoton:
; .FSTART _checaBoton
; 0000 0043 if(botonC==0)
	SBIC 0x10,0
	RJMP _0xC
; 0000 0044 botona = 0;
	CLT
	RJMP _0x4B
; 0000 0045 else
_0xC:
; 0000 0046 botona = 1;
	SET
_0x4B:
	BLD  R2,0
; 0000 0047 if((botonp==1)&&(botona==0)){ //hubo cambio de flanco de 1 a 0
	SBRS R2,1
	RJMP _0xF
	SBRS R2,0
	RJMP _0x10
_0xF:
	RJMP _0xE
_0x10:
; 0000 0048 if(fecHor==0){
	LDS  R30,_fecHor
	CPI  R30,0
	BRNE _0x11
; 0000 0049 fecHor=1;
	LDI  R30,LOW(1)
	STS  _fecHor,R30
; 0000 004A lcd_gotoxy(10,0); lcd_putchar('.');
	LDI  R30,LOW(10)
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2
; 0000 004B lcd_gotoxy(9,1); lcd_putchar(0x20);
	LDI  R30,LOW(9)
	RCALL SUBOPT_0x3
	RJMP _0x4C
; 0000 004C }
; 0000 004D else{
_0x11:
; 0000 004E fecHor=0;
	LDI  R30,LOW(0)
	STS  _fecHor,R30
; 0000 004F lcd_gotoxy(9,1); lcd_putchar('.');
	LDI  R30,LOW(9)
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x2
; 0000 0050 lcd_gotoxy(10,0); lcd_putchar(0x20);
	LDI  R30,LOW(10)
	RCALL SUBOPT_0x1
_0x4C:
	RCALL _lcd_gotoxy
	LDI  R26,LOW(32)
	RCALL _lcd_putchar
; 0000 0051 }
; 0000 0052 delay_ms(40); //Se coloca retardo de 40mS para eliminar rebotes
	RCALL SUBOPT_0x4
; 0000 0053 }
; 0000 0054 if((botonp==0)&&(botona==1)) //hubo cambio de flanco de 0 a 1
_0xE:
	SBRC R2,1
	RJMP _0x14
	SBRC R2,0
	RJMP _0x15
_0x14:
	RJMP _0x13
_0x15:
; 0000 0055 delay_ms(40); //Se coloca retardo de 40mS para eliminar rebotes
	RCALL SUBOPT_0x4
; 0000 0056 botonp=botona;
_0x13:
	RJMP _0x2080002
; 0000 0057 }
; .FEND
;void checaPrim(){
; 0000 0059 void checaPrim(){
_checaPrim:
; .FSTART _checaPrim
; 0000 005A if(botonPr==0)
	SBIC 0x10,1
	RJMP _0x16
; 0000 005B botona=0;
	CLT
	RJMP _0x4D
; 0000 005C else
_0x16:
; 0000 005D botona=1;
	SET
_0x4D:
	BLD  R2,0
; 0000 005E if((botonp==1)&&(botona==0)){ //hubo cambio de flanco de 1 a 0
	SBRS R2,1
	RJMP _0x19
	SBRS R2,0
	RJMP _0x1A
_0x19:
	RJMP _0x18
_0x1A:
; 0000 005F if(fecHor==1){ //fecha
	RCALL SUBOPT_0x5
	BRNE _0x1B
; 0000 0060 unidadA+=1;
	RCALL SUBOPT_0x6
; 0000 0061 if(unidadA==10){
	LDS  R26,_unidadA
	CPI  R26,LOW(0xA)
	BRNE _0x1C
; 0000 0062 unidadA=0;
	RCALL SUBOPT_0x7
; 0000 0063 decenaA+=1;
; 0000 0064 if(decenaA==10){
	LDS  R26,_decenaA
	CPI  R26,LOW(0xA)
	BRNE _0x1D
; 0000 0065 decenaA=1;
	LDI  R30,LOW(1)
	STS  _decenaA,R30
; 0000 0066 unidadA=9;
	LDI  R30,LOW(9)
	STS  _unidadA,R30
; 0000 0067 }
; 0000 0068 }
_0x1D:
; 0000 0069 }
_0x1C:
; 0000 006A else{ //hora
	RJMP _0x1E
_0x1B:
; 0000 006B unidadH+=1;
	RCALL SUBOPT_0x8
; 0000 006C if(unidadH==10){
	LDS  R26,_unidadH
	CPI  R26,LOW(0xA)
	BRNE _0x1F
; 0000 006D unidadH=0;
	RCALL SUBOPT_0x9
; 0000 006E decenaH+=1;
	RCALL SUBOPT_0xA
; 0000 006F }
; 0000 0070 if(decenaH==2 && unidadH==4){
_0x1F:
	LDS  R26,_decenaH
	CPI  R26,LOW(0x2)
	BRNE _0x21
	LDS  R26,_unidadH
	CPI  R26,LOW(0x4)
	BREQ _0x22
_0x21:
	RJMP _0x20
_0x22:
; 0000 0071 decenaH=0;
	LDI  R30,LOW(0)
	STS  _decenaH,R30
; 0000 0072 unidadH=0;
	RCALL SUBOPT_0x9
; 0000 0073 //aumentar dia
; 0000 0074 unidadD+=1;
	RCALL SUBOPT_0xB
; 0000 0075 }
; 0000 0076 }
_0x20:
_0x1E:
; 0000 0077 delay_ms(40); //Se coloca retardo de 40mS para eliminar rebotes
	RCALL SUBOPT_0x4
; 0000 0078 }
; 0000 0079 if((botonp==0)&&(botona==1)) //hubo cambio de flanco de 0 a 1
_0x18:
	SBRC R2,1
	RJMP _0x24
	SBRC R2,0
	RJMP _0x25
_0x24:
	RJMP _0x23
_0x25:
; 0000 007A delay_ms(40); //Se coloca retardo de 40mS para eliminar rebotes
	RCALL SUBOPT_0x4
; 0000 007B botonp=botona;
_0x23:
	RJMP _0x2080002
; 0000 007C }
; .FEND
;void checaSeg(){
; 0000 007E void checaSeg(){
_checaSeg:
; .FSTART _checaSeg
; 0000 007F if(botonSe==0)
	SBIC 0x10,2
	RJMP _0x26
; 0000 0080 botona=0;
	CLT
	RJMP _0x4E
; 0000 0081 else
_0x26:
; 0000 0082 botona=1;
	SET
_0x4E:
	BLD  R2,0
; 0000 0083 if((botonp==1) && (botona==0)){ //hubo cambio de flanco de 1 a 0
	SBRS R2,1
	RJMP _0x29
	SBRS R2,0
	RJMP _0x2A
_0x29:
	RJMP _0x28
_0x2A:
; 0000 0084 if(fecHor==1){ //fecha
	RCALL SUBOPT_0x5
	BRNE _0x2B
; 0000 0085 unidadM+=1;
	RCALL SUBOPT_0xC
; 0000 0086 if(unidadM==10){
	LDS  R26,_unidadM
	CPI  R26,LOW(0xA)
	BRNE _0x2C
; 0000 0087 unidadM=0;
	LDI  R30,LOW(0)
	STS  _unidadM,R30
; 0000 0088 decenaM+=1;
	LDS  R30,_decenaM
	SUBI R30,-LOW(1)
	STS  _decenaM,R30
; 0000 0089 }
; 0000 008A if(decenaM==1 && unidadM==2){
_0x2C:
	LDS  R26,_decenaM
	CPI  R26,LOW(0x1)
	BRNE _0x2E
	LDS  R26,_unidadM
	CPI  R26,LOW(0x2)
	BREQ _0x2F
_0x2E:
	RJMP _0x2D
_0x2F:
; 0000 008B unidadM=0;
	LDI  R30,LOW(0)
	STS  _unidadM,R30
; 0000 008C decenaM=0;
	STS  _decenaM,R30
; 0000 008D //aumenta año
; 0000 008E unidadA+=1;
	RCALL SUBOPT_0x6
; 0000 008F }
; 0000 0090 }
_0x2D:
; 0000 0091 else{ //hora
	RJMP _0x30
_0x2B:
; 0000 0092 unidadMin+=1;
	RCALL SUBOPT_0xD
; 0000 0093 if(unidadMin==10){
	LDS  R26,_unidadMin
	CPI  R26,LOW(0xA)
	BRNE _0x31
; 0000 0094 unidadMin=0;
	LDI  R30,LOW(0)
	STS  _unidadMin,R30
; 0000 0095 decenaMin+=1;
	LDS  R30,_decenaMin
	SUBI R30,-LOW(1)
	STS  _decenaMin,R30
; 0000 0096 if(decenaMin==6){
	LDS  R26,_decenaMin
	CPI  R26,LOW(0x6)
	BRNE _0x32
; 0000 0097 decenaMin=0;
	LDI  R30,LOW(0)
	STS  _decenaMin,R30
; 0000 0098 unidadMin=0;
	STS  _unidadMin,R30
; 0000 0099 unidadH+=1;
	RCALL SUBOPT_0x8
; 0000 009A }
; 0000 009B }
_0x32:
; 0000 009C }
_0x31:
_0x30:
; 0000 009D delay_ms(40); //Se coloca retardo de 40mS para eliminar rebotes
	RCALL SUBOPT_0x4
; 0000 009E }
; 0000 009F if((botonp==0)&&(botona==1)) //hubo cambio de flanco de 0 a 1
_0x28:
	SBRC R2,1
	RJMP _0x34
	SBRC R2,0
	RJMP _0x35
_0x34:
	RJMP _0x33
_0x35:
; 0000 00A0 delay_ms(40); //Se coloca retardo de 40mS para eliminar rebotes
	RCALL SUBOPT_0x4
; 0000 00A1 botonp=botona;
_0x33:
	RJMP _0x2080002
; 0000 00A2 }
; .FEND
;void checaTer(){
; 0000 00A4 void checaTer(){
_checaTer:
; .FSTART _checaTer
; 0000 00A5 if(botonTe==0)
	SBIC 0x10,3
	RJMP _0x36
; 0000 00A6 botona=0;
	CLT
	RJMP _0x4F
; 0000 00A7 else
_0x36:
; 0000 00A8 botona=1;
	SET
_0x4F:
	BLD  R2,0
; 0000 00A9 if((botonp==1)&&(botona==0)){ //hubo cambio de flanco de 1 a 0
	SBRS R2,1
	RJMP _0x39
	SBRS R2,0
	RJMP _0x3A
_0x39:
	RJMP _0x38
_0x3A:
; 0000 00AA if(fecHor==1){ //fecha
	RCALL SUBOPT_0x5
	BRNE _0x3B
; 0000 00AB unidadD+=1;
	RCALL SUBOPT_0xB
; 0000 00AC if(unidadD==9){
	LDS  R26,_unidadD
	CPI  R26,LOW(0x9)
	BRNE _0x3C
; 0000 00AD unidadD=0;
	LDI  R30,LOW(0)
	STS  _unidadD,R30
; 0000 00AE decenaD+=1;
	LDS  R30,_decenaD
	SUBI R30,-LOW(1)
	STS  _decenaD,R30
; 0000 00AF }
; 0000 00B0 if(decenaD==3 && unidadD==1){
_0x3C:
	LDS  R26,_decenaD
	CPI  R26,LOW(0x3)
	BRNE _0x3E
	LDS  R26,_unidadD
	CPI  R26,LOW(0x1)
	BREQ _0x3F
_0x3E:
	RJMP _0x3D
_0x3F:
; 0000 00B1 decenaD=0;
	LDI  R30,LOW(0)
	STS  _decenaD,R30
; 0000 00B2 unidadD=0;
	STS  _unidadD,R30
; 0000 00B3 //aumenta mes
; 0000 00B4 unidadM+=1;
	RCALL SUBOPT_0xC
; 0000 00B5 }
; 0000 00B6 }
_0x3D:
; 0000 00B7 delay_ms(40); //Se coloca retardo de 40mS para eliminar rebotes
_0x3B:
	RCALL SUBOPT_0x4
; 0000 00B8 }
; 0000 00B9 if((botonp==0)&&(botona==1)) //hubo cambio de flanco de 0 a 1
_0x38:
	SBRC R2,1
	RJMP _0x41
	SBRC R2,0
	RJMP _0x42
_0x41:
	RJMP _0x40
_0x42:
; 0000 00BA delay_ms(40); //Se coloca retardo de 40mS para eliminar rebotes
	RCALL SUBOPT_0x4
; 0000 00BB botonp=botona;
_0x40:
_0x2080002:
	BST  R2,0
	BLD  R2,1
; 0000 00BC }
	RET
; .FEND
;void main(void)
; 0000 00BF {
_main:
; .FSTART _main
; 0000 00C0 // Declare your local variables here
; 0000 00C1 
; 0000 00C2 // Input/Output Ports initialization
; 0000 00C3 // Port A initialization
; 0000 00C4 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00C5 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 00C6 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00C7 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 00C8 
; 0000 00C9 // Port B initialization
; 0000 00CA // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 00CB DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 00CC // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 00CD PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00CE 
; 0000 00CF // Port C initialization
; 0000 00D0 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00D1 DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 00D2 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00D3 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 00D4 
; 0000 00D5 // Port D initialization
; 0000 00D6 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00D7 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 00D8 // State: Bit7=P Bit6=P Bit5=P Bit4=P Bit3=P Bit2=P Bit1=P Bit0=P
; 0000 00D9 PORTD=(1<<PORTD7) | (1<<PORTD6) | (1<<PORTD5) | (1<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (1<<PORTD1) | (1<<PORTD0);
	LDI  R30,LOW(255)
	OUT  0x12,R30
; 0000 00DA 
; 0000 00DB // Timer/Counter 0 initialization
; 0000 00DC // Clock source: System Clock
; 0000 00DD // Clock value: Timer 0 Stopped
; 0000 00DE // Mode: Normal top=0xFF
; 0000 00DF // OC0 output: Disconnected
; 0000 00E0 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 00E1 TCNT0=0x00;
	OUT  0x32,R30
; 0000 00E2 OCR0=0x00;
	OUT  0x3C,R30
; 0000 00E3 
; 0000 00E4 // Timer/Counter 1 initialization
; 0000 00E5 // Clock source: System Clock
; 0000 00E6 // Clock value: Timer1 Stopped
; 0000 00E7 // Mode: Normal top=0xFFFF
; 0000 00E8 // OC1A output: Disconnected
; 0000 00E9 // OC1B output: Disconnected
; 0000 00EA // Noise Canceler: Off
; 0000 00EB // Input Capture on Falling Edge
; 0000 00EC // Timer1 Overflow Interrupt: Off
; 0000 00ED // Input Capture Interrupt: Off
; 0000 00EE // Compare A Match Interrupt: Off
; 0000 00EF // Compare B Match Interrupt: Off
; 0000 00F0 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 00F1 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 00F2 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00F3 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00F4 ICR1H=0x00;
	OUT  0x27,R30
; 0000 00F5 ICR1L=0x00;
	OUT  0x26,R30
; 0000 00F6 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00F7 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00F8 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00F9 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00FA 
; 0000 00FB // Timer/Counter 2 initialization
; 0000 00FC // Clock source: System Clock
; 0000 00FD // Clock value: Timer2 Stopped
; 0000 00FE // Mode: Normal top=0xFF
; 0000 00FF // OC2 output: Disconnected
; 0000 0100 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0101 TCCR2=(0<<WGM20) | (0<<COM21) | (0<<COM20) | (0<<WGM21) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0102 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0103 OCR2=0x00;
	OUT  0x23,R30
; 0000 0104 
; 0000 0105 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0106 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 0107 
; 0000 0108 // External Interrupt(s) initialization
; 0000 0109 // INT0: Off
; 0000 010A // INT1: Off
; 0000 010B // INT2: Off
; 0000 010C MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 010D MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 010E 
; 0000 010F // USART initialization
; 0000 0110 // USART disabled
; 0000 0111 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 0112 
; 0000 0113 // Analog Comparator initialization
; 0000 0114 // Analog Comparator: Off
; 0000 0115 // The Analog Comparator's positive input is
; 0000 0116 // connected to the AIN0 pin
; 0000 0117 // The Analog Comparator's negative input is
; 0000 0118 // connected to the AIN1 pin
; 0000 0119 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 011A 
; 0000 011B // ADC initialization
; 0000 011C // ADC Clock frequency: 500.000 kHz
; 0000 011D // ADC Voltage Reference: AVCC pin
; 0000 011E // ADC High Speed Mode: Off
; 0000 011F // ADC Auto Trigger Source: ADC Stopped
; 0000 0120 // Only the 8 most significant bits of
; 0000 0121 // the AD conversion result are used
; 0000 0122 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(96)
	OUT  0x7,R30
; 0000 0123 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(129)
	OUT  0x6,R30
; 0000 0124 SFIOR=(1<<ADHSM) | (0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(16)
	OUT  0x30,R30
; 0000 0125 
; 0000 0126 // SPI initialization
; 0000 0127 // SPI disabled
; 0000 0128 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	LDI  R30,LOW(0)
	OUT  0xD,R30
; 0000 0129 
; 0000 012A // TWI initialization
; 0000 012B // TWI disabled
; 0000 012C TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 012D 
; 0000 012E // Alphanumeric LCD initialization
; 0000 012F // Connections are specified in the
; 0000 0130 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0131 // RS: PORTB Bit 0
; 0000 0132 // RD: PORTB Bit 1
; 0000 0133 // EN: PORTB Bit 2
; 0000 0134 // D4: PORTB Bit 4
; 0000 0135 // D5: PORTB Bit 5
; 0000 0136 // D6: PORTB Bit 6
; 0000 0137 // D7: PORTB Bit 7
; 0000 0138 // Characters/line: 16
; 0000 0139 lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 013A 
; 0000 013B while (1)
_0x43:
; 0000 013C {
; 0000 013D //temperatura
; 0000 013E Vin=read_adc(0);
	LDI  R26,LOW(0)
	RCALL _read_adc
	MOV  R5,R30
; 0000 013F centi=(Vin*50)/255;
	MOV  R26,R5
	LDI  R30,LOW(50)
	MUL  R30,R26
	MOVW R30,R0
	MOVW R26,R30
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	RCALL __DIVW21
	MOVW R8,R30
; 0000 0140 if(centi>99) centi=99;
	LDI  R30,LOW(99)
	LDI  R31,HIGH(99)
	CP   R30,R8
	CPC  R31,R9
	BRGE _0x46
	MOVW R8,R30
; 0000 0141 
; 0000 0142 temp=centi*10;
_0x46:
	MOVW R30,R8
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	RCALL __MULW12
	MOVW R10,R30
; 0000 0143 decenas=temp/100;
	MOVW R26,R10
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21
	MOV  R6,R30
; 0000 0144 temp%=100;
	MOVW R26,R10
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __MODW21
	MOVW R10,R30
; 0000 0145 decimal=temp%10;
	MOVW R26,R10
	RCALL SUBOPT_0xE
	RCALL __MODW21
	MOV  R4,R30
; 0000 0146 unidades=temp/10;
	MOVW R26,R10
	RCALL SUBOPT_0xE
	RCALL __DIVW21
	MOV  R7,R30
; 0000 0147 
; 0000 0148 checaBoton();
	RCALL _checaBoton
; 0000 0149 checaPrim();
	RCALL _checaPrim
; 0000 014A checaSeg();
	RCALL _checaSeg
; 0000 014B checaTer();
	RCALL _checaTer
; 0000 014C 
; 0000 014D //segundos
; 0000 014E segundos+=1;
	LDS  R30,_segundos
	SUBI R30,-LOW(1)
	STS  _segundos,R30
; 0000 014F delay_ms(750);
	LDI  R26,LOW(750)
	LDI  R27,HIGH(750)
	RCALL _delay_ms
; 0000 0150 if(segundos==60){
	LDS  R26,_segundos
	CPI  R26,LOW(0x3C)
	BRNE _0x47
; 0000 0151 segundos=0;
	LDI  R30,LOW(0)
	STS  _segundos,R30
; 0000 0152 unidadMin+=1;
	RCALL SUBOPT_0xD
; 0000 0153 }
; 0000 0154 decenaSec=segundos/10;
_0x47:
	LDS  R26,_segundos
	LDI  R27,0
	RCALL SUBOPT_0xE
	RCALL __DIVW21
	STS  _decenaSec,R30
; 0000 0155 unidadSec=segundos%10;
	LDS  R26,_segundos
	CLR  R27
	RCALL SUBOPT_0xE
	RCALL __MODW21
	STS  _unidadSec,R30
; 0000 0156 
; 0000 0157 if(unidadH==10){
	LDS  R26,_unidadH
	CPI  R26,LOW(0xA)
	BRNE _0x48
; 0000 0158 unidadH=0;
	RCALL SUBOPT_0x9
; 0000 0159 decenaH+=1;
	RCALL SUBOPT_0xA
; 0000 015A }
; 0000 015B 
; 0000 015C if(unidadA==10){
_0x48:
	LDS  R26,_unidadA
	CPI  R26,LOW(0xA)
	BRNE _0x49
; 0000 015D unidadA=0;
	RCALL SUBOPT_0x7
; 0000 015E decenaA+=1;
; 0000 015F }
; 0000 0160 
; 0000 0161 lcd_gotoxy(0,0); lcd_putchar(tabla[millarA]);
_0x49:
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x1
	RCALL _lcd_gotoxy
	MOV  R30,R13
	RCALL SUBOPT_0xF
; 0000 0162 lcd_gotoxy(1,0); lcd_putchar(tabla[centenaA]);
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x1
	RCALL _lcd_gotoxy
	MOV  R30,R12
	RCALL SUBOPT_0xF
; 0000 0163 lcd_gotoxy(2,0); lcd_putchar(tabla[decenaA]);
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x1
	RCALL _lcd_gotoxy
	LDS  R30,_decenaA
	RCALL SUBOPT_0xF
; 0000 0164 lcd_gotoxy(3,0); lcd_putchar(tabla[unidadA]);
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x1
	RCALL _lcd_gotoxy
	LDS  R30,_unidadA
	RCALL SUBOPT_0xF
; 0000 0165 lcd_gotoxy(4,0); lcd_putchar('-');
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x1
	RCALL _lcd_gotoxy
	LDI  R26,LOW(45)
	RCALL _lcd_putchar
; 0000 0166 lcd_gotoxy(5,0); lcd_putchar(tabla[decenaM]);
	LDI  R30,LOW(5)
	RCALL SUBOPT_0x1
	RCALL _lcd_gotoxy
	LDS  R30,_decenaM
	RCALL SUBOPT_0xF
; 0000 0167 lcd_gotoxy(6,0); lcd_putchar(tabla[unidadM]);
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x1
	RCALL _lcd_gotoxy
	LDS  R30,_unidadM
	RCALL SUBOPT_0xF
; 0000 0168 lcd_gotoxy(7,0); lcd_putchar('-');
	LDI  R30,LOW(7)
	RCALL SUBOPT_0x1
	RCALL _lcd_gotoxy
	LDI  R26,LOW(45)
	RCALL _lcd_putchar
; 0000 0169 lcd_gotoxy(8,0); lcd_putchar(tabla[decenaD]);
	LDI  R30,LOW(8)
	RCALL SUBOPT_0x1
	RCALL _lcd_gotoxy
	LDS  R30,_decenaD
	RCALL SUBOPT_0xF
; 0000 016A lcd_gotoxy(9,0); lcd_putchar(tabla[unidadD]);
	LDI  R30,LOW(9)
	RCALL SUBOPT_0x1
	RCALL _lcd_gotoxy
	LDS  R30,_unidadD
	RCALL SUBOPT_0xF
; 0000 016B lcd_gotoxy(11,0);
	LDI  R30,LOW(11)
	RCALL SUBOPT_0x1
	RCALL _lcd_gotoxy
; 0000 016C lcd_putsf("ESCOM");
	__POINTW2FN _0x0,0
	RCALL _lcd_putsf
; 0000 016D lcd_gotoxy(0,1); lcd_putchar(tabla[decenaH]);
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x3
	RCALL _lcd_gotoxy
	LDS  R30,_decenaH
	RCALL SUBOPT_0xF
; 0000 016E lcd_gotoxy(1,1); lcd_putchar(tabla[unidadH]);
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x3
	RCALL _lcd_gotoxy
	LDS  R30,_unidadH
	RCALL SUBOPT_0xF
; 0000 016F lcd_gotoxy(2,1); lcd_putchar(':');
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x3
	RCALL _lcd_gotoxy
	LDI  R26,LOW(58)
	RCALL _lcd_putchar
; 0000 0170 lcd_gotoxy(3,1); lcd_putchar(tabla[decenaMin]);
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x3
	RCALL _lcd_gotoxy
	LDS  R30,_decenaMin
	RCALL SUBOPT_0xF
; 0000 0171 lcd_gotoxy(4,1); lcd_putchar(tabla[unidadMin]);
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x3
	RCALL _lcd_gotoxy
	LDS  R30,_unidadMin
	RCALL SUBOPT_0xF
; 0000 0172 lcd_gotoxy(5,1); lcd_putchar(':');
	LDI  R30,LOW(5)
	RCALL SUBOPT_0x3
	RCALL _lcd_gotoxy
	LDI  R26,LOW(58)
	RCALL _lcd_putchar
; 0000 0173 lcd_gotoxy(6,1); lcd_putchar(tabla[decenaSec]);
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x3
	RCALL _lcd_gotoxy
	LDS  R30,_decenaSec
	RCALL SUBOPT_0xF
; 0000 0174 lcd_gotoxy(7,1); lcd_putchar(tabla[unidadSec]);
	LDI  R30,LOW(7)
	RCALL SUBOPT_0x3
	RCALL _lcd_gotoxy
	LDS  R30,_unidadSec
	RCALL SUBOPT_0xF
; 0000 0175 lcd_gotoxy(10,1); lcd_putchar(tabla[decenas]);
	LDI  R30,LOW(10)
	RCALL SUBOPT_0x3
	RCALL _lcd_gotoxy
	MOV  R30,R6
	RCALL SUBOPT_0xF
; 0000 0176 lcd_gotoxy(11,1); lcd_putchar(tabla[unidades]);
	LDI  R30,LOW(11)
	RCALL SUBOPT_0x3
	RCALL _lcd_gotoxy
	MOV  R30,R7
	RCALL SUBOPT_0xF
; 0000 0177 lcd_gotoxy(12,1); lcd_putchar('.');
	LDI  R30,LOW(12)
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x2
; 0000 0178 lcd_gotoxy(13,1); lcd_putchar(tabla[decimal]);
	LDI  R30,LOW(13)
	RCALL SUBOPT_0x3
	RCALL _lcd_gotoxy
	MOV  R30,R4
	RCALL SUBOPT_0xF
; 0000 0179 lcd_gotoxy(14,1); lcd_putchar(0xDF);
	LDI  R30,LOW(14)
	RCALL SUBOPT_0x3
	RCALL _lcd_gotoxy
	LDI  R26,LOW(223)
	RCALL _lcd_putchar
; 0000 017A lcd_gotoxy(15,1); lcd_putchar('C');
	LDI  R30,LOW(15)
	RCALL SUBOPT_0x3
	RCALL _lcd_gotoxy
	LDI  R26,LOW(67)
	RCALL _lcd_putchar
; 0000 017B }
	RJMP _0x43
; 0000 017C }
_0x4A:
	RJMP _0x4A
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	RCALL SUBOPT_0x0
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	MOV  R30,R17
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x18,R30
	RCALL SUBOPT_0x10
	SBI  0x18,2
	RCALL SUBOPT_0x10
	CBI  0x18,2
	RCALL SUBOPT_0x10
	RJMP _0x2080001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 17
	ADIW R28,1
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	RCALL __SAVELOCR2
	MOV  R17,R26
	LDD  R16,Y+2
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	ADD  R30,R16
	MOV  R26,R30
	RCALL __lcd_write_data
	STS  __lcd_x,R16
	STS  __lcd_y,R17
	RCALL __LOADLOCR2
	ADIW R28,3
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x11
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x11
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	RCALL SUBOPT_0x0
	CPI  R17,10
	BREQ _0x2000005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	CPI  R17,10
	BRNE _0x2000007
	RJMP _0x2080001
_0x2000007:
_0x2000004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x18,0
	MOV  R26,R17
	RCALL __lcd_write_data
	CBI  0x18,0
	RJMP _0x2080001
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	RCALL __SAVELOCR4
	MOVW R18,R26
_0x200000B:
	MOVW R30,R18
	__ADDWRN 18,19,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000D
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x200000B
_0x200000D:
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	RCALL SUBOPT_0x0
	IN   R30,0x17
	ORI  R30,LOW(0xF0)
	OUT  0x17,R30
	SBI  0x17,2
	SBI  0x17,0
	SBI  0x17,1
	CBI  0x18,2
	CBI  0x18,0
	CBI  0x18,1
	STS  __lcd_maxx,R17
	MOV  R30,R17
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	MOV  R30,R17
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _delay_ms
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x12
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 33
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2080001:
	LD   R17,Y+
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_decenaA:
	.BYTE 0x1
_unidadA:
	.BYTE 0x1
_decenaM:
	.BYTE 0x1
_unidadM:
	.BYTE 0x1
_decenaD:
	.BYTE 0x1
_unidadD:
	.BYTE 0x1
_decenaH:
	.BYTE 0x1
_unidadH:
	.BYTE 0x1
_decenaMin:
	.BYTE 0x1
_unidadMin:
	.BYTE 0x1
_decenaSec:
	.BYTE 0x1
_unidadSec:
	.BYTE 0x1
_segundos:
	.BYTE 0x1
_fecHor:
	.BYTE 0x1
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	ST   -Y,R17
	MOV  R17,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1:
	ST   -Y,R30
	LDI  R26,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	RCALL _lcd_gotoxy
	LDI  R26,LOW(46)
	RJMP _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3:
	ST   -Y,R30
	LDI  R26,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(40)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	LDS  R26,_fecHor
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	LDS  R30,_unidadA
	SUBI R30,-LOW(1)
	STS  _unidadA,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(0)
	STS  _unidadA,R30
	LDS  R30,_decenaA
	SUBI R30,-LOW(1)
	STS  _decenaA,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	LDS  R30,_unidadH
	SUBI R30,-LOW(1)
	STS  _unidadH,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(0)
	STS  _unidadH,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	LDS  R30,_decenaH
	SUBI R30,-LOW(1)
	STS  _decenaH,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	LDS  R30,_unidadD
	SUBI R30,-LOW(1)
	STS  _unidadD,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	LDS  R30,_unidadM
	SUBI R30,-LOW(1)
	STS  _unidadM,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	LDS  R30,_unidadMin
	SUBI R30,-LOW(1)
	STS  _unidadMin,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:62 WORDS
SUBOPT_0xF:
	LDI  R31,0
	SUBI R30,LOW(-_tabla*2)
	SBCI R31,HIGH(-_tabla*2)
	LPM  R26,Z
	RJMP _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	__DELAY_USB 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x12:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 33
	RET

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	NEG  R27
	NEG  R26
	SBCI R27,0
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	NEG  R27
	NEG  R26
	SBCI R27,0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0xFA
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
