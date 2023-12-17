
;CodeVisionAVR C Compiler V3.52 
;(C) Copyright 1998-2023 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

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
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.EQU __FLASH_PAGE_SIZE=0x40

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
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
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
	CALL __GETW1Z
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETD1Z
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
	CALL __GETW2X
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETD2X
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
	.DEF __lcd_x=R5
	.DEF __lcd_y=R4
	.DEF __lcd_maxx=R7

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext1
	JMP  _SetPC
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _Reset
	JMP  0x00
	JMP  0x00

_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x3:
	.DB  0x50,0x72,0x6F,0x66,0x0,0x0,0x31,0x31
	.DB  0x31,0x0,0x32,0x30,0x33,0x0,0x41,0x68
	.DB  0x6D,0x65,0x64,0x0,0x31,0x32,0x36,0x0
	.DB  0x31,0x32,0x39,0x0,0x41,0x6D,0x72,0x0
	.DB  0x0,0x0,0x31,0x32,0x38,0x0,0x33,0x32
	.DB  0x35,0x0,0x41,0x64,0x65,0x6C,0x0,0x0
	.DB  0x31,0x33,0x30,0x0,0x34,0x32,0x36,0x0
	.DB  0x4F,0x6D,0x65,0x72,0x0,0x0,0x31,0x33
	.DB  0x32,0x0,0x30,0x37,0x39
_0x0:
	.DB  0x45,0x6E,0x74,0x65,0x72,0x20,0x79,0x6F
	.DB  0x75,0x72,0x20,0x49,0x44,0x3A,0x0,0x45
	.DB  0x6E,0x74,0x65,0x72,0x20,0x6F,0x6C,0x64
	.DB  0x20,0x50,0x43,0x3A,0x0,0x45,0x6E,0x74
	.DB  0x65,0x72,0x20,0x6E,0x65,0x77,0x20,0x50
	.DB  0x43,0x3A,0x0,0x52,0x65,0x2D,0x65,0x6E
	.DB  0x74,0x65,0x72,0x20,0x6E,0x65,0x77,0x20
	.DB  0x50,0x43,0x3A,0x0,0x4E,0x65,0x77,0x20
	.DB  0x50,0x43,0x20,0x73,0x74,0x6F,0x72,0x65
	.DB  0x64,0x0,0x4E,0x65,0x77,0x20,0x50,0x43
	.DB  0x20,0x6D,0x69,0x73,0x6D,0x61,0x74,0x63
	.DB  0x68,0x2C,0x20,0x43,0x6F,0x6E,0x74,0x61
	.DB  0x63,0x74,0x20,0x61,0x64,0x6D,0x69,0x6E
	.DB  0x0,0x57,0x72,0x6F,0x6E,0x67,0x20,0x6F
	.DB  0x6C,0x64,0x20,0x50,0x43,0x2C,0x20,0x20
	.DB  0x20,0x43,0x6F,0x6E,0x74,0x61,0x63,0x74
	.DB  0x20,0x61,0x64,0x6D,0x69,0x6E,0x0,0x57
	.DB  0x72,0x6F,0x6E,0x67,0x20,0x49,0x44,0x0
	.DB  0x45,0x6E,0x74,0x65,0x72,0x20,0x79,0x6F
	.DB  0x75,0x72,0x20,0x49,0x44,0x3A,0x20,0x0
	.DB  0x45,0x6E,0x74,0x65,0x72,0x20,0x79,0x6F
	.DB  0x75,0x72,0x20,0x50,0x43,0x3A,0x20,0x0
	.DB  0x57,0x65,0x6C,0x63,0x6F,0x6D,0x65,0x2C
	.DB  0x20,0x0,0x53,0x6F,0x72,0x72,0x79,0x20
	.DB  0x77,0x72,0x6F,0x6E,0x67,0x20,0x50,0x43
	.DB  0x0,0x50,0x72,0x6F,0x66,0x0,0x45,0x6E
	.DB  0x74,0x65,0x72,0x20,0x41,0x64,0x6D,0x69
	.DB  0x6E,0x20,0x50,0x43,0x3A,0x20,0x0,0x45
	.DB  0x6E,0x74,0x65,0x72,0x20,0x53,0x74,0x75
	.DB  0x64,0x65,0x6E,0x74,0x20,0x49,0x44,0x3A
	.DB  0x20,0x0,0x45,0x6E,0x74,0x65,0x72,0x20
	.DB  0x73,0x74,0x75,0x64,0x65,0x6E,0x74,0x27
	.DB  0x73,0x20,0x6E,0x65,0x77,0x20,0x50,0x43
	.DB  0x3A,0x20,0x0,0x53,0x74,0x75,0x64,0x65
	.DB  0x6E,0x74,0x20,0x50,0x43,0x20,0x69,0x73
	.DB  0x20,0x73,0x74,0x6F,0x72,0x65,0x64,0x0
	.DB  0x45,0x6E,0x74,0x65,0x72,0x20,0x79,0x6F
	.DB  0x75,0x72,0x20,0x6E,0x65,0x77,0x20,0x50
	.DB  0x43,0x3A,0x20,0x0,0x59,0x6F,0x75,0x72
	.DB  0x20,0x50,0x43,0x20,0x69,0x73,0x20,0x73
	.DB  0x74,0x6F,0x72,0x65,0x64,0x0,0x43,0x6F
	.DB  0x6E,0x74,0x61,0x63,0x74,0x20,0x41,0x64
	.DB  0x6D,0x69,0x6E,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x45
	.DW  _users
	.DW  _0x3*2

	.DW  0x0F
	.DW  _0x15
	.DW  _0x0*2

	.DW  0x0E
	.DW  _0x15+15
	.DW  _0x0*2+15

	.DW  0x0E
	.DW  _0x15+29
	.DW  _0x0*2+29

	.DW  0x11
	.DW  _0x15+43
	.DW  _0x0*2+43

	.DW  0x0E
	.DW  _0x15+60
	.DW  _0x0*2+60

	.DW  0x1F
	.DW  _0x15+74
	.DW  _0x0*2+74

	.DW  0x1E
	.DW  _0x15+105
	.DW  _0x0*2+105

	.DW  0x09
	.DW  _0x15+135
	.DW  _0x0*2+135

	.DW  0x10
	.DW  _0x25
	.DW  _0x0*2+144

	.DW  0x10
	.DW  _0x25+16
	.DW  _0x0*2+160

	.DW  0x0A
	.DW  _0x25+32
	.DW  _0x0*2+176

	.DW  0x0F
	.DW  _0x25+42
	.DW  _0x0*2+186

	.DW  0x09
	.DW  _0x25+57
	.DW  _0x0*2+135

	.DW  0x05
	.DW  _0x37
	.DW  _0x0*2+201

	.DW  0x11
	.DW  _0x37+5
	.DW  _0x0*2+206

	.DW  0x13
	.DW  _0x37+22
	.DW  _0x0*2+223

	.DW  0x19
	.DW  _0x37+41
	.DW  _0x0*2+242

	.DW  0x15
	.DW  _0x37+66
	.DW  _0x0*2+267

	.DW  0x14
	.DW  _0x37+87
	.DW  _0x0*2+288

	.DW  0x12
	.DW  _0x37+107
	.DW  _0x0*2+308

	.DW  0x0E
	.DW  _0x37+125
	.DW  _0x0*2+326

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

	JMP  _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0x160

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
;char keypad();
;unsigned char EE_Read(unsigned int address);
;void EE_Write(unsigned int address, unsigned char data);
;void EE_WriteString(unsigned int address, const char *str);
;void EE_ReadString(unsigned int address, char *buffer, unsigned int length);
;void initializeUsers();
;void displayMessage(char *message, int delay_ms_value);
;int enterValueWithKeypad(char *buffer);
;void generateTone();

	.DSEG
;void main(void)
; 0000 002D {

	.CSEG
_main:
; .FSTART _main
; 0000 002E 
; 0000 002F // Set keypad ports
; 0000 0030 DDRC = 0b00000111; // 1 unused pin , 4 rows (input) , 3 cloumns (output)
	LDI  R30,LOW(7)
	OUT  0x14,R30
; 0000 0031 PORTC = 0b11111000; // pull up resistance
	LDI  R30,LOW(248)
	OUT  0x15,R30
; 0000 0032 
; 0000 0033 // Initialize the LCD
; 0000 0034 lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0035 
; 0000 0036 
; 0000 0037 // Set the door as input (now by default the door is closed)
; 0000 0038 DDRB .0 = 0;
	CBI  0x17,0
; 0000 0039 PORTB .0 = 1; // turn on pull up resistance
	SBI  0x18,0
; 0000 003A 
; 0000 003B // Set the speaker as a output
; 0000 003C DDRD.7 = 1;
	SBI  0x11,7
; 0000 003D PORTD.7 = 1; // Set it to 1 initially
	SBI  0x12,7
; 0000 003E 
; 0000 003F // Initialize user data in EEPROM
; 0000 0040 initializeUsers();
	RCALL _initializeUsers
; 0000 0041 
; 0000 0042 PORTB.2 = 1; // turn on pull up resistance for INT2 intrrupt
	SBI  0x18,2
; 0000 0043 
; 0000 0044 // actual casue INT2
; 0000 0045 bit_set(MCUCSR, 6);
	IN   R30,0x34
	ORI  R30,0x40
	OUT  0x34,R30
; 0000 0046 
; 0000 0047 PORTD.2 = 1; // turn on pull up resistance for INT0 intrrupt
	SBI  0x12,2
; 0000 0048 
; 0000 0049 // actual casue (The falling edge of INT0)
; 0000 004A bit_set(MCUCR, 1);
	IN   R30,0x35
	ORI  R30,2
	OUT  0x35,R30
; 0000 004B bit_clr(MCUCR, 0);
	IN   R30,0x35
	ANDI R30,0xFE
	OUT  0x35,R30
; 0000 004C 
; 0000 004D DDRD.3=0; //make button SetPC as input
	CBI  0x11,3
; 0000 004E PORTD.3=1; // turn on pull up resistance
	SBI  0x12,3
; 0000 004F 
; 0000 0050 // Enable global interrupts
; 0000 0051 #asm("sei")
	SEI
; 0000 0052 // GICR INT1 (bit no 7) , SetPC spacific enable
; 0000 0053 bit_set(GICR,7);
	IN   R30,0x3B
	ORI  R30,0x80
	OUT  0x3B,R30
; 0000 0054 
; 0000 0055 // GICR INT2 (bit no 5) , EXT2 spacific enable
; 0000 0056 bit_set(GICR, 5);
	IN   R30,0x3B
	ORI  R30,0x20
	OUT  0x3B,R30
; 0000 0057 
; 0000 0058 // GICR INT0 (bit no 6) , EXT0 spacific enable
; 0000 0059 bit_set(GICR, 6);
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 005A 
; 0000 005B 
; 0000 005C 
; 0000 005D }
_0x14:
	RJMP _0x14
; .FEND
;interrupt [3] void SetPC (void)
; 0000 0060 {
_SetPC:
; .FSTART _SetPC
	RCALL SUBOPT_0x0
; 0000 0061 char enteredID[5];  // Change data type to string
; 0000 0062 User currentUser;
; 0000 0063 unsigned int address = 0;
; 0000 0064 int userFound = 0;
; 0000 0065 int i;
; 0000 0066 char enteredNewPC[5]; // define enteredNewPC array to hold the new PC
; 0000 0067 char reenteredNewPC[5]; // define reenteredNewPC array to hold the Re-entered new PC
; 0000 0068 
; 0000 0069 lcd_clear();
	SBIW R28,29
	RCALL SUBOPT_0x1
;	enteredID -> Y+30
;	currentUser -> Y+16
;	address -> R16,R17
;	userFound -> R18,R19
;	i -> R20,R21
;	enteredNewPC -> Y+11
;	reenteredNewPC -> Y+6
	RCALL _lcd_clear
; 0000 006A displayMessage("Enter your ID:", 1000);
	__POINTW1MN _0x15,0
	RCALL SUBOPT_0x2
; 0000 006B lcd_gotoxy(0,1);
; 0000 006C if (enterValueWithKeypad(enteredID)) {
	MOVW R26,R28
	ADIW R26,30
	RCALL _enterValueWithKeypad
	SBIW R30,0
	BRNE PC+2
	RJMP _0x16
; 0000 006D char enteredPC[4];
; 0000 006E char enteredOldPC[5];
; 0000 006F // search for the entered ID in the user data
; 0000 0070 for (i = 0; i < sizeof(users) / sizeof(users[0]); ++i) {
	SBIW R28,9
;	enteredID -> Y+39
;	currentUser -> Y+25
;	enteredNewPC -> Y+20
;	reenteredNewPC -> Y+15
;	enteredPC -> Y+5
;	enteredOldPC -> Y+0
	__GETWRN 20,21,0
_0x18:
	__CPWRN 20,21,5
	BRLT PC+2
	RJMP _0x19
; 0000 0071 address += sizeof(users[i].name);
	RCALL SUBOPT_0x3
; 0000 0072 EE_ReadString(address, currentUser.id, sizeof(currentUser.id));  // Read ID as a string
	MOVW R30,R28
	ADIW R30,33
	RCALL SUBOPT_0x4
; 0000 0073 
; 0000 0074 if (strcmp(currentUser.id, enteredID) == 0) {
	MOVW R30,R28
	ADIW R30,31
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,41
	RCALL _strcmp
	CPI  R30,0
	BRNE _0x1A
; 0000 0075 // ID found, verify the old PC
; 0000 0076 address += sizeof(currentUser.id);
	RCALL SUBOPT_0x5
; 0000 0077 EE_ReadString(address, currentUser.pc, sizeof(currentUser.pc));  // Read PC as a string
	MOVW R30,R28
	ADIW R30,37
	RCALL SUBOPT_0x4
; 0000 0078 displayMessage("Enter old PC:", 1000);
	__POINTW1MN _0x15,15
	RCALL SUBOPT_0x2
; 0000 0079 lcd_gotoxy(0,1);
; 0000 007A 
; 0000 007B if (enterValueWithKeypad(enteredOldPC)) {
	RCALL SUBOPT_0x6
	BREQ _0x1B
; 0000 007C if (strcmp(currentUser.pc, enteredOldPC) == 0) {
	MOVW R30,R28
	ADIW R30,35
	RCALL SUBOPT_0x7
	BRNE _0x1C
; 0000 007D // Old PC verified
; 0000 007E displayMessage("Enter new PC:", 1000);
	__POINTW1MN _0x15,29
	RCALL SUBOPT_0x2
; 0000 007F lcd_gotoxy(0,1);
; 0000 0080 enterValueWithKeypad(enteredNewPC);
	MOVW R26,R28
	ADIW R26,20
	RCALL _enterValueWithKeypad
; 0000 0081 
; 0000 0082 lcd_clear();
	RCALL _lcd_clear
; 0000 0083 displayMessage("Re-enter new PC:", 1000);
	__POINTW1MN _0x15,43
	RCALL SUBOPT_0x2
; 0000 0084 lcd_gotoxy(0,1);
; 0000 0085 enterValueWithKeypad(reenteredNewPC);
	MOVW R26,R28
	ADIW R26,15
	RCALL _enterValueWithKeypad
; 0000 0086 
; 0000 0087 if (strcmp(enteredNewPC, reenteredNewPC) == 0) {
	MOVW R30,R28
	ADIW R30,20
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,17
	RCALL _strcmp
	CPI  R30,0
	BRNE _0x1D
; 0000 0088 // If new PC entered correctly, store it
; 0000 0089 EE_WriteString(address,enteredNewPC);
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,22
	RCALL _EE_WriteString
; 0000 008A displayMessage("New PC stored", 1000);
	__POINTW1MN _0x15,60
	RCALL SUBOPT_0x8
; 0000 008B generateTone();
; 0000 008C DDRB.0 = 1;
	SBI  0x17,0
; 0000 008D } else {
	RJMP _0x20
_0x1D:
; 0000 008E displayMessage("New PC mismatch, Contact admin", 1000);
	__POINTW1MN _0x15,74
	RCALL SUBOPT_0x8
; 0000 008F generateTone();
; 0000 0090 generateTone();
	RCALL _generateTone
; 0000 0091 }
_0x20:
; 0000 0092 } else {
	RJMP _0x21
_0x1C:
; 0000 0093 displayMessage("Wrong old PC,   Contact admin", 1000);
	__POINTW1MN _0x15,105
	RCALL SUBOPT_0x8
; 0000 0094 
; 0000 0095 generateTone();
; 0000 0096 generateTone();
	RCALL _generateTone
; 0000 0097 }
_0x21:
; 0000 0098 }
; 0000 0099 
; 0000 009A userFound = 1;
_0x1B:
	__GETWRN 18,19,1
; 0000 009B break;
	RJMP _0x19
; 0000 009C }
; 0000 009D 
; 0000 009E address += sizeof(users[i].id);
_0x1A:
	RCALL SUBOPT_0x9
; 0000 009F address += sizeof(users[i].pc);
; 0000 00A0 
; 0000 00A1 }
	__ADDWRN 20,21,1
	RJMP _0x18
_0x19:
; 0000 00A2 
; 0000 00A3 if (!userFound)
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x22
; 0000 00A4 {
; 0000 00A5 displayMessage("Wrong ID", 1000);
	__POINTW1MN _0x15,135
	RCALL SUBOPT_0x8
; 0000 00A6 generateTone();
; 0000 00A7 generateTone();
	RCALL _generateTone
; 0000 00A8 }
; 0000 00A9 delay_ms(5000);
_0x22:
	RCALL SUBOPT_0xA
; 0000 00AA // close the door and clear lcd
; 0000 00AB DDRB .0 = 0;
; 0000 00AC lcd_clear();
; 0000 00AD }
	ADIW R28,9
; 0000 00AE }
_0x16:
	RCALL __LOADLOCR6
	ADIW R28,35
	RJMP _0xAE
; .FEND

	.DSEG
_0x15:
	.BYTE 0x90
;interrupt [19] void Reset (void)
; 0000 00B1 {

	.CSEG
_Reset:
; .FSTART _Reset
	RCALL SUBOPT_0x0
; 0000 00B2 // action on click on a button
; 0000 00B3 
; 0000 00B4 char enteredID[4];  // Change data type to string
; 0000 00B5 User currentUser;
; 0000 00B6 unsigned int address = 0;
; 0000 00B7 int userFound = 0;
; 0000 00B8 int i;
; 0000 00B9 
; 0000 00BA displayMessage("Enter your ID: ", 1000);
	SBIW R28,18
	RCALL SUBOPT_0x1
;	enteredID -> Y+20
;	currentUser -> Y+6
;	address -> R16,R17
;	userFound -> R18,R19
;	i -> R20,R21
	__POINTW1MN _0x25,0
	RCALL SUBOPT_0xB
; 0000 00BB 
; 0000 00BC if (enterValueWithKeypad(enteredID))
	MOVW R26,R28
	ADIW R26,20
	RCALL _enterValueWithKeypad
	SBIW R30,0
	BREQ _0x26
; 0000 00BD {
; 0000 00BE char enteredPC[4];
; 0000 00BF for (i = 0; i < sizeof(users) / sizeof(users[0]); ++i)
	SBIW R28,4
;	enteredID -> Y+24
;	currentUser -> Y+10
;	enteredPC -> Y+0
	__GETWRN 20,21,0
_0x28:
	__CPWRN 20,21,5
	BRGE _0x29
; 0000 00C0 {
; 0000 00C1 EE_ReadString(address, currentUser.name, sizeof(users[i].name));
	ST   -Y,R17
	ST   -Y,R16
	MOVW R30,R28
	ADIW R30,12
	RCALL SUBOPT_0xC
; 0000 00C2 address += sizeof(users[i].name);
	RCALL SUBOPT_0x3
; 0000 00C3 EE_ReadString(address, currentUser.id, sizeof(currentUser.id));  // Read ID as a string
	MOVW R30,R28
	ADIW R30,18
	RCALL SUBOPT_0x4
; 0000 00C4 
; 0000 00C5 if (strcmp(currentUser.id, enteredID) == 0)
	RCALL SUBOPT_0xD
	MOVW R26,R28
	ADIW R26,26
	RCALL _strcmp
	CPI  R30,0
	BRNE _0x2A
; 0000 00C6 {
; 0000 00C7 
; 0000 00C8 address += sizeof(users[i].id);
	RCALL SUBOPT_0x5
; 0000 00C9 EE_ReadString(address, currentUser.pc, sizeof(currentUser.pc));  // Read PC as a string
	MOVW R30,R28
	ADIW R30,22
	RCALL SUBOPT_0x4
; 0000 00CA 
; 0000 00CB displayMessage("Enter your PC: ", 1000);
	__POINTW1MN _0x25,16
	RCALL SUBOPT_0xB
; 0000 00CC 
; 0000 00CD if (enterValueWithKeypad(enteredPC))
	RCALL SUBOPT_0x6
	BREQ _0x2B
; 0000 00CE {
; 0000 00CF if (strcmp(currentUser.pc, enteredPC) == 0)
	MOVW R30,R28
	ADIW R30,20
	RCALL SUBOPT_0x7
	BRNE _0x2C
; 0000 00D0 {
; 0000 00D1 lcd_clear();
	RCALL _lcd_clear
; 0000 00D2 lcd_puts("Welcome, ");
	__POINTW2MN _0x25,32
	RCALL _lcd_puts
; 0000 00D3 lcd_puts(currentUser.name);
	MOVW R26,R28
	ADIW R26,10
	RCALL _lcd_puts
; 0000 00D4 // Open the door
; 0000 00D5 DDRB .0 = 1;
	SBI  0x17,0
; 0000 00D6 }
; 0000 00D7 else
	RJMP _0x2F
_0x2C:
; 0000 00D8 {
; 0000 00D9 displayMessage("Sorry wrong PC", 1000);
	__POINTW1MN _0x25,42
	RCALL SUBOPT_0x8
; 0000 00DA // one peep alarm
; 0000 00DB generateTone();
; 0000 00DC }
_0x2F:
; 0000 00DD }
; 0000 00DE userFound = 1;
_0x2B:
	__GETWRN 18,19,1
; 0000 00DF break;
	RJMP _0x29
; 0000 00E0 }
; 0000 00E1 
; 0000 00E2 address += sizeof(users[i].id);
_0x2A:
	RCALL SUBOPT_0x9
; 0000 00E3 address += sizeof(users[i].pc);
; 0000 00E4 }
	__ADDWRN 20,21,1
	RJMP _0x28
_0x29:
; 0000 00E5 }
	ADIW R28,4
; 0000 00E6 
; 0000 00E7 if (!userFound)
_0x26:
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x30
; 0000 00E8 {
; 0000 00E9 displayMessage("Wrong ID", 1000);
	__POINTW1MN _0x25,57
	RCALL SUBOPT_0x8
; 0000 00EA // Two peeps alarm
; 0000 00EB generateTone();
; 0000 00EC generateTone();
	RCALL _generateTone
; 0000 00ED }
; 0000 00EE delay_ms(5000);
_0x30:
	RCALL SUBOPT_0xA
; 0000 00EF // close the door and clear lcd
; 0000 00F0 DDRB .0 = 0;
; 0000 00F1 lcd_clear();
; 0000 00F2 }
	RCALL __LOADLOCR6
	ADIW R28,24
	RJMP _0xAE
; .FEND

	.DSEG
_0x25:
	.BYTE 0x42
;interrupt [2] void ext1 (void)
; 0000 00F5 {

	.CSEG
_ext1:
; .FSTART _ext1
	RCALL SUBOPT_0x0
; 0000 00F6 // action on interrupt
; 0000 00F7 char enteredPC[4];
; 0000 00F8 char enteredStudentID[4];
; 0000 00F9 char enteredNewPC[4];
; 0000 00FA User student;
; 0000 00FB User admin;
; 0000 00FC unsigned int adminPCAddress = 0;
; 0000 00FD unsigned int address = 0;
; 0000 00FE int userFound = 0;
; 0000 00FF int i;
; 0000 0100 
; 0000 0101 for (i = 0; i < sizeof(users) / sizeof(users[0]); ++i)
	SBIW R28,42
	RCALL SUBOPT_0x1
;	enteredPC -> Y+44
;	enteredStudentID -> Y+40
;	enteredNewPC -> Y+36
;	student -> Y+22
;	admin -> Y+8
;	adminPCAddress -> R16,R17
;	address -> R18,R19
;	userFound -> R20,R21
;	i -> Y+6
	__GETWRN 20,21,0
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x34:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,5
	BRGE _0x35
; 0000 0102 {
; 0000 0103 EE_ReadString(address, admin.name, sizeof(users[i].name));
	ST   -Y,R19
	ST   -Y,R18
	MOVW R30,R28
	ADIW R30,10
	RCALL SUBOPT_0xC
; 0000 0104 if (strcmp(admin.name, "Prof") == 0)
	MOVW R30,R28
	ADIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0x37,0
	RCALL _strcmp
	CPI  R30,0
	BRNE _0x36
; 0000 0105 {
; 0000 0106 address += sizeof(users[i].name);
	RCALL SUBOPT_0xE
; 0000 0107 EE_ReadString(address, admin.id, sizeof(admin.id));
	MOVW R30,R28
	ADIW R30,16
	RCALL SUBOPT_0x4
; 0000 0108 address += sizeof(users[i].id);
	__ADDWRN 18,19,4
; 0000 0109 EE_ReadString(address, admin.pc, sizeof(admin.pc));
	ST   -Y,R19
	ST   -Y,R18
	MOVW R30,R28
	ADIW R30,20
	RCALL SUBOPT_0x4
; 0000 010A adminPCAddress = address;
	MOVW R16,R18
; 0000 010B break;
	RJMP _0x35
; 0000 010C }
; 0000 010D address += sizeof(users[i].pc);
_0x36:
	__ADDWRN 18,19,4
; 0000 010E }
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x34
_0x35:
; 0000 010F 
; 0000 0110 address = 0; // reset the address
	__GETWRN 18,19,0
; 0000 0111 
; 0000 0112 displayMessage("Enter Admin PC: ", 1000);
	__POINTW1MN _0x37,5
	RCALL SUBOPT_0xB
; 0000 0113 
; 0000 0114 if (enterValueWithKeypad(enteredPC))
	MOVW R26,R28
	ADIW R26,44
	RCALL _enterValueWithKeypad
	SBIW R30,0
	BRNE PC+2
	RJMP _0x38
; 0000 0115 {
; 0000 0116 
; 0000 0117 if (strcmp(admin.pc, enteredPC) == 0)
	MOVW R30,R28
	ADIW R30,18
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,46
	RCALL _strcmp
	CPI  R30,0
	BREQ PC+2
	RJMP _0x39
; 0000 0118 {
; 0000 0119 displayMessage("Enter Student ID: ", 1000);
	__POINTW1MN _0x37,22
	RCALL SUBOPT_0xB
; 0000 011A 
; 0000 011B if (enterValueWithKeypad(enteredStudentID))
	MOVW R26,R28
	ADIW R26,40
	RCALL _enterValueWithKeypad
	SBIW R30,0
	BREQ _0x3A
; 0000 011C {
; 0000 011D int j;
; 0000 011E for (j = 0; j < sizeof(users) / sizeof(users[0]); ++j)
	SBIW R28,2
;	enteredPC -> Y+46
;	enteredStudentID -> Y+42
;	enteredNewPC -> Y+38
;	student -> Y+24
;	admin -> Y+10
;	i -> Y+8
;	j -> Y+0
	LDI  R30,LOW(0)
	STD  Y+0,R30
	STD  Y+0+1,R30
_0x3C:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,5
	BRGE _0x3D
; 0000 011F {
; 0000 0120 address += sizeof(users[j].name);
	RCALL SUBOPT_0xE
; 0000 0121 EE_ReadString(address, student.id, sizeof(student.id));
	MOVW R30,R28
	ADIW R30,32
	RCALL SUBOPT_0x4
; 0000 0122 address += sizeof(users[j].id);
	__ADDWRN 18,19,4
; 0000 0123 if (strcmp(student.id, enteredStudentID) == 0)
	MOVW R30,R28
	ADIW R30,30
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0xF
	BRNE _0x3E
; 0000 0124 {
; 0000 0125 displayMessage("Enter student's new PC: ", 1000);
	__POINTW1MN _0x37,41
	RCALL SUBOPT_0xB
; 0000 0126 if (enterValueWithKeypad(enteredNewPC))
	RCALL SUBOPT_0x10
	BREQ _0x3F
; 0000 0127 {
; 0000 0128 // Set the new pc for this student, address is for student PC
; 0000 0129 EE_WriteString(address, enteredNewPC);
	ST   -Y,R19
	ST   -Y,R18
	MOVW R26,R28
	ADIW R26,40
	RCALL _EE_WriteString
; 0000 012A displayMessage("Student PC is stored", 3000);
	__POINTW1MN _0x37,66
	RCALL SUBOPT_0x11
; 0000 012B userFound = 1;
; 0000 012C break;
	RJMP _0x3D
; 0000 012D }
; 0000 012E }
_0x3F:
; 0000 012F else if (strcmp(admin.id, enteredStudentID) == 0)
	RJMP _0x40
_0x3E:
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xF
	BRNE _0x41
; 0000 0130 {
; 0000 0131 displayMessage("Enter your new PC: ", 1000);
	__POINTW1MN _0x37,87
	RCALL SUBOPT_0xB
; 0000 0132 if (enterValueWithKeypad(enteredNewPC))
	RCALL SUBOPT_0x10
	BREQ _0x42
; 0000 0133 {
; 0000 0134 // Set the new pc for this user (Admin),  address is for admin PC
; 0000 0135 EE_WriteString(adminPCAddress, enteredNewPC);
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,40
	RCALL _EE_WriteString
; 0000 0136 displayMessage("Your PC is stored", 3000);
	__POINTW1MN _0x37,107
	RCALL SUBOPT_0x11
; 0000 0137 userFound = 1;
; 0000 0138 break;
	RJMP _0x3D
; 0000 0139 }
; 0000 013A }
_0x42:
; 0000 013B address += sizeof(users[i].pc);
_0x41:
_0x40:
	__ADDWRN 18,19,4
; 0000 013C }
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	RJMP _0x3C
_0x3D:
; 0000 013D }
	ADIW R28,2
; 0000 013E }
_0x3A:
; 0000 013F }
_0x39:
; 0000 0140 
; 0000 0141 if (!userFound)
_0x38:
	MOV  R0,R20
	OR   R0,R21
	BRNE _0x43
; 0000 0142 {
; 0000 0143 displayMessage("Contact Admin", 3000);
	__POINTW1MN _0x37,125
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	RCALL _displayMessage
; 0000 0144 // Two peeps alarm
; 0000 0145 generateTone();
	RCALL _generateTone
; 0000 0146 generateTone();
	RCALL _generateTone
; 0000 0147 }
; 0000 0148 delay_ms(5000);
_0x43:
	LDI  R26,LOW(5000)
	LDI  R27,HIGH(5000)
	RCALL _delay_ms
; 0000 0149 lcd_clear();
	RCALL _lcd_clear
; 0000 014A }
	RCALL __LOADLOCR6
	ADIW R28,48
_0xAE:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND

	.DSEG
_0x37:
	.BYTE 0x8B
;char keypad()
; 0000 014D {

	.CSEG
_keypad:
; .FSTART _keypad
; 0000 014E while (1)
_0x44:
; 0000 014F {
; 0000 0150 PORTC .0 = 0;
	CBI  0x15,0
; 0000 0151 PORTC .1 = 1;
	SBI  0x15,1
; 0000 0152 PORTC .2 = 1;
	SBI  0x15,2
; 0000 0153 
; 0000 0154 
; 0000 0155 switch (PINC)
	IN   R30,0x13
; 0000 0156 {
; 0000 0157 case 0b11110110:
	CPI  R30,LOW(0xF6)
	BRNE _0x50
; 0000 0158 while (PINC .3 == 0);
_0x51:
	SBIS 0x13,3
	RJMP _0x51
; 0000 0159 return 1;
	LDI  R30,LOW(1)
	RET
; 0000 015A case 0b11101110:
_0x50:
	CPI  R30,LOW(0xEE)
	BRNE _0x54
; 0000 015B while (PINC .4 == 0);
_0x55:
	SBIS 0x13,4
	RJMP _0x55
; 0000 015C return 4;
	LDI  R30,LOW(4)
	RET
; 0000 015D case 0b11011110:
_0x54:
	CPI  R30,LOW(0xDE)
	BRNE _0x58
; 0000 015E while (PINC .5 == 0);
_0x59:
	SBIS 0x13,5
	RJMP _0x59
; 0000 015F return 7;
	LDI  R30,LOW(7)
	RET
; 0000 0160 case 0b10111110:
_0x58:
	CPI  R30,LOW(0xBE)
	BRNE _0x4F
; 0000 0161 while (PINC .6 == 0);
_0x5D:
	SBIS 0x13,6
	RJMP _0x5D
; 0000 0162 return '*';
	LDI  R30,LOW(42)
	RET
; 0000 0163 }
_0x4F:
; 0000 0164 
; 0000 0165 PORTC .0 = 1;
	SBI  0x15,0
; 0000 0166 PORTC .1 = 0;
	CBI  0x15,1
; 0000 0167 PORTC .2 = 1;
	SBI  0x15,2
; 0000 0168 
; 0000 0169 switch (PINC)
	IN   R30,0x13
; 0000 016A {
; 0000 016B case 0b11110101:
	CPI  R30,LOW(0xF5)
	BRNE _0x69
; 0000 016C while (PINC .3 == 0);
_0x6A:
	SBIS 0x13,3
	RJMP _0x6A
; 0000 016D return 2;
	LDI  R30,LOW(2)
	RET
; 0000 016E case 0b11101101:
_0x69:
	CPI  R30,LOW(0xED)
	BRNE _0x6D
; 0000 016F while (PINC .4 == 0);
_0x6E:
	SBIS 0x13,4
	RJMP _0x6E
; 0000 0170 return 5;
	LDI  R30,LOW(5)
	RET
; 0000 0171 case 0b11011101:
_0x6D:
	CPI  R30,LOW(0xDD)
	BRNE _0x71
; 0000 0172 while (PINC .5 == 0);
_0x72:
	SBIS 0x13,5
	RJMP _0x72
; 0000 0173 return 8;
	LDI  R30,LOW(8)
	RET
; 0000 0174 case 0b10111101:
_0x71:
	CPI  R30,LOW(0xBD)
	BRNE _0x68
; 0000 0175 while (PINC .6 == 0);
_0x76:
	SBIS 0x13,6
	RJMP _0x76
; 0000 0176 return 0;
	LDI  R30,LOW(0)
	RET
; 0000 0177 }
_0x68:
; 0000 0178 
; 0000 0179 PORTC .0 = 1;
	SBI  0x15,0
; 0000 017A PORTC .1 = 1;
	SBI  0x15,1
; 0000 017B PORTC .2 = 0;
	CBI  0x15,2
; 0000 017C 
; 0000 017D switch (PINC)
	IN   R30,0x13
; 0000 017E {
; 0000 017F case 0b11110011:
	CPI  R30,LOW(0xF3)
	BRNE _0x82
; 0000 0180 while (PINC .3 == 0);
_0x83:
	SBIS 0x13,3
	RJMP _0x83
; 0000 0181 return 3;
	LDI  R30,LOW(3)
	RET
; 0000 0182 case 0b11101011:
_0x82:
	CPI  R30,LOW(0xEB)
	BRNE _0x86
; 0000 0183 while (PINC .4 == 0);
_0x87:
	SBIS 0x13,4
	RJMP _0x87
; 0000 0184 return 6;
	LDI  R30,LOW(6)
	RET
; 0000 0185 case 0b11011011:
_0x86:
	CPI  R30,LOW(0xDB)
	BRNE _0x8A
; 0000 0186 while (PINC .5 == 0);
_0x8B:
	SBIS 0x13,5
	RJMP _0x8B
; 0000 0187 return 9;
	LDI  R30,LOW(9)
	RET
; 0000 0188 case 0b10111011:
_0x8A:
	CPI  R30,LOW(0xBB)
	BRNE _0x81
; 0000 0189 while (PINC .6 == 0);
_0x8F:
	SBIS 0x13,6
	RJMP _0x8F
; 0000 018A return 11;
	LDI  R30,LOW(11)
	RET
; 0000 018B }
_0x81:
; 0000 018C }
	RJMP _0x44
; 0000 018D }
; .FEND
;unsigned char EE_Read(unsigned int address)
; 0000 0190 {
_EE_Read:
; .FSTART _EE_Read
; 0000 0191 while (EECR .1 == 1); // Wait till EEPROM is ready
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	address -> R16,R17
_0x92:
	SBIC 0x1C,1
	RJMP _0x92
; 0000 0192 EEAR = address;       // Prepare the address you want to read from
	__OUTWR 16,17,30
; 0000 0193 EECR .0 = 1;          // Execute read command
	SBI  0x1C,0
; 0000 0194 return EEDR;
	IN   R30,0x1D
	RJMP _0x2080003
; 0000 0195 }
; .FEND
;void EE_Write(unsigned int address, unsigned char data)
; 0000 0198 {
_EE_Write:
; .FSTART _EE_Write
; 0000 0199 while (EECR .1 == 1); // Wait till EEPROM is ready
	RCALL __SAVELOCR4
	MOV  R17,R26
	__GETWRS 18,19,4
;	address -> R18,R19
;	data -> R17
_0x97:
	SBIC 0x1C,1
	RJMP _0x97
; 0000 019A EEAR = address;       // Prepare the address you want to read from
	__OUTWR 18,19,30
; 0000 019B EEDR = data;          // Prepare the data you want to write in the address above
	OUT  0x1D,R17
; 0000 019C EECR .2 = 1;          // Master write enable
	SBI  0x1C,2
; 0000 019D EECR .1 = 1;          // Write Enable
	SBI  0x1C,1
; 0000 019E }
	RJMP _0x2080004
; .FEND
;void EE_WriteString(unsigned int address, const char *str)
; 0000 01A1 {
_EE_WriteString:
; .FSTART _EE_WriteString
; 0000 01A2 // Write each character of the string to EEPROM
; 0000 01A3 while (*str)
	RCALL SUBOPT_0x12
;	address -> R18,R19
;	*str -> R16,R17
_0x9E:
	MOVW R26,R16
	LD   R30,X
	CPI  R30,0
	BREQ _0xA0
; 0000 01A4 EE_Write(address++, *str++);
	MOVW R30,R18
	__ADDWRN 18,19,1
	ST   -Y,R31
	ST   -Y,R30
	__ADDWRN 16,17,1
	LD   R26,X
	RCALL _EE_Write
	RJMP _0x9E
_0xA0:
; 0000 01A6 EE_Write(address, '\0');
	ST   -Y,R19
	ST   -Y,R18
	LDI  R26,LOW(0)
	RCALL _EE_Write
; 0000 01A7 }
	RJMP _0x2080004
; .FEND
;void EE_ReadString(unsigned int address, char *buffer, unsigned int length)
; 0000 01AA {
_EE_ReadString:
; .FSTART _EE_ReadString
; 0000 01AB unsigned int i;
; 0000 01AC for (i = 0; i < length; ++i)
	RCALL __SAVELOCR6
	MOVW R18,R26
	__GETWRS 20,21,6
;	address -> Y+8
;	*buffer -> R20,R21
;	length -> R18,R19
;	i -> R16,R17
	__GETWRN 16,17,0
_0xA2:
	__CPWRR 16,17,18,19
	BRSH _0xA3
; 0000 01AD {
; 0000 01AE buffer[i] = EE_Read(address + i);
	MOVW R30,R16
	ADD  R30,R20
	ADC  R31,R21
	PUSH R31
	PUSH R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADD  R26,R16
	ADC  R27,R17
	RCALL _EE_Read
	POP  R26
	POP  R27
	ST   X,R30
; 0000 01AF if (buffer[i] == '\0')
	MOVW R30,R16
	ADD  R30,R20
	ADC  R31,R21
	LD   R30,Z
	CPI  R30,0
	BREQ _0xA3
; 0000 01B0 break;
; 0000 01B1 }
	__ADDWRN 16,17,1
	RJMP _0xA2
_0xA3:
; 0000 01B2 }
	RCALL __LOADLOCR6
	ADIW R28,10
	RET
; .FEND
;void initializeUsers()
; 0000 01B5 {
_initializeUsers:
; .FSTART _initializeUsers
; 0000 01B6 unsigned int address = 0;
; 0000 01B7 int i;
; 0000 01B8 for (i = 0; i < sizeof(users) / sizeof(users[0]); ++i)
	RCALL __SAVELOCR4
;	address -> R16,R17
;	i -> R18,R19
	__GETWRN 16,17,0
	__GETWRN 18,19,0
_0xA6:
	__CPWRN 18,19,5
	BRGE _0xA7
; 0000 01B9 {
; 0000 01BA EE_WriteString(address, users[i].name);
	ST   -Y,R17
	ST   -Y,R16
	RCALL SUBOPT_0x13
	SUBI R30,LOW(-_users)
	SBCI R31,HIGH(-_users)
	MOVW R26,R30
	RCALL _EE_WriteString
; 0000 01BB address += sizeof(users[i].name);
	RCALL SUBOPT_0x3
; 0000 01BC 
; 0000 01BD EE_WriteString(address, users[i].id);
	RCALL SUBOPT_0x13
	__ADDW1MN _users,6
	MOVW R26,R30
	RCALL _EE_WriteString
; 0000 01BE address += sizeof(users[i].id);
	RCALL SUBOPT_0x5
; 0000 01BF 
; 0000 01C0 EE_WriteString(address, users[i].pc);
	RCALL SUBOPT_0x13
	__ADDW1MN _users,10
	MOVW R26,R30
	RCALL _EE_WriteString
; 0000 01C1 address += sizeof(users[i].pc);
	__ADDWRN 16,17,4
; 0000 01C2 }
	__ADDWRN 18,19,1
	RJMP _0xA6
_0xA7:
; 0000 01C3 }
	RJMP _0x2080002
; .FEND
;void displayMessage(char *message, int delay_ms_value)
; 0000 01C6 {
_displayMessage:
; .FSTART _displayMessage
; 0000 01C7 lcd_clear();
	RCALL SUBOPT_0x12
;	*message -> R18,R19
;	delay_ms_value -> R16,R17
	RCALL _lcd_clear
; 0000 01C8 lcd_puts(message);
	MOVW R26,R18
	RCALL _lcd_puts
; 0000 01C9 delay_ms(delay_ms_value);
	MOVW R26,R16
	RCALL _delay_ms
; 0000 01CA }
_0x2080004:
	RCALL __LOADLOCR4
	ADIW R28,6
	RET
; .FEND
;int enterValueWithKeypad(char *buffer)
; 0000 01CD {
_enterValueWithKeypad:
; .FSTART _enterValueWithKeypad
; 0000 01CE buffer[0] = keypad() + '0';
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	*buffer -> R16,R17
	RCALL _keypad
	SUBI R30,-LOW(48)
	MOVW R26,R16
	ST   X,R30
; 0000 01CF lcd_putchar(buffer[0]);
	LD   R26,X
	RCALL _lcd_putchar
; 0000 01D0 buffer[1] = keypad() + '0';
	RCALL _keypad
	SUBI R30,-LOW(48)
	__PUTB1RNS 16,1
; 0000 01D1 lcd_putchar(buffer[1]);
	MOVW R30,R16
	LDD  R26,Z+1
	RCALL _lcd_putchar
; 0000 01D2 buffer[2] = keypad() + '0';
	RCALL _keypad
	SUBI R30,-LOW(48)
	__PUTB1RNS 16,2
; 0000 01D3 lcd_putchar(buffer[2]);
	MOVW R30,R16
	LDD  R26,Z+2
	RCALL _lcd_putchar
; 0000 01D4 buffer[3] = '\0';  // Null-terminate the string
	MOVW R30,R16
	ADIW R30,3
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 01D5 
; 0000 01D6 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 01D7 
; 0000 01D8 return 1;  // Return a non-zero value to indicate success
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
_0x2080003:
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 01D9 }
; .FEND
;void generateTone()
; 0000 01DC {
_generateTone:
; .FSTART _generateTone
; 0000 01DD PORTD.7 = 1;  // Set PD7 HIGH
	SBI  0x12,7
; 0000 01DE delay_ms(500);  // Adjust duration as needed
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 01DF PORTD.7 = 0;  // Set PD7 LOW
	CBI  0x12,7
; 0000 01E0 delay_ms(500);  // Pause between tones
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 01E1 PORTD.7 = 1;  // Set PD7 HIGH (optional: restore to high for a brief moment)
	SBI  0x12,7
; 0000 01E2 }
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

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R17
	MOV  R17,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	MOV  R30,R17
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 13
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
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
	__DELAY_USB 133
	ADIW R28,1
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R17
	ST   -Y,R16
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
	MOV  R5,R16
	MOV  R4,R17
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x14
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x14
	LDI  R30,LOW(0)
	MOV  R4,R30
	MOV  R5,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R17
	MOV  R17,R26
	CPI  R17,10
	BREQ _0x2000005
	CP   R5,R7
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R4
	MOV  R26,R4
	RCALL _lcd_gotoxy
	CPI  R17,10
	BREQ _0x2080001
_0x2000004:
	INC  R5
	SBI  0x1B,0
	MOV  R26,R17
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x2080001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	RCALL __SAVELOCR4
	MOVW R18,R26
_0x2000008:
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R30,X
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
_0x2080002:
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R17
	MOV  R17,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	MOV  R7,R17
	MOV  R30,R17
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	MOV  R30,R17
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _delay_ms
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x15
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
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

	.CSEG
_strcmp:
; .FSTART _strcmp
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
strcmp0:
    ld   r22,x+
    ld   r23,z+
    cp   r22,r23
    brne strcmp1
    tst  r22
    brne strcmp0
strcmp3:
    clr  r30
    ret
strcmp1:
    sub  r22,r23
    breq strcmp3
    ldi  r30,1
    brcc strcmp2
    subi r30,2
strcmp2:
    ret
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

	.DSEG
_users:
	.BYTE 0x46
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x0:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1:
	RCALL __SAVELOCR6
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _displayMessage
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3:
	__ADDWRN 16,17,6
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x4:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(4)
	LDI  R27,0
	RJMP _EE_ReadString

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5:
	__ADDWRN 16,17,4
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	MOVW R26,R28
	RCALL _enterValueWithKeypad
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,2
	RCALL _strcmp
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x8:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _displayMessage
	RJMP _generateTone

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	__ADDWRN 16,17,4
	__ADDWRN 16,17,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(5000)
	LDI  R27,HIGH(5000)
	RCALL _delay_ms
	CBI  0x17,0
	RJMP _lcd_clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xB:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RJMP _displayMessage

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(6)
	LDI  R27,0
	RJMP _EE_ReadString

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	MOVW R30,R28
	ADIW R30,16
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	__ADDWRN 18,19,6
	ST   -Y,R19
	ST   -Y,R18
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	MOVW R26,R28
	ADIW R26,44
	RCALL _strcmp
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	MOVW R26,R28
	ADIW R26,38
	RCALL _enterValueWithKeypad
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x11:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	RCALL _displayMessage
	__GETWRN 20,21,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	RCALL __SAVELOCR4
	MOVW R16,R26
	__GETWRS 18,19,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x13:
	__MULBNWRU 18,19,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x15:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x7D0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
