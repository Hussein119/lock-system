
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
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x4:
	.DB  LOW(_0x3),HIGH(_0x3),0x31,0x31,0x31,0x0,0x32,0x30
	.DB  0x33,0x0,LOW(_0x3+5),HIGH(_0x3+5),0x31,0x32,0x36,0x0
	.DB  0x31,0x32,0x39,0x0,LOW(_0x3+11),HIGH(_0x3+11),0x31,0x32
	.DB  0x38,0x0,0x33,0x32,0x35,0x0,LOW(_0x3+15),HIGH(_0x3+15)
	.DB  0x31,0x33,0x30,0x0,0x34,0x32,0x36,0x0
	.DB  LOW(_0x3+20),HIGH(_0x3+20),0x31,0x33,0x32,0x0,0x30,0x37
	.DB  0x39
_0x0:
	.DB  0x50,0x72,0x6F,0x66,0x0,0x41,0x68,0x6D
	.DB  0x65,0x64,0x0,0x41,0x6D,0x72,0x0,0x41
	.DB  0x64,0x65,0x6C,0x0,0x4F,0x6D,0x65,0x72
	.DB  0x0,0x45,0x6E,0x74,0x65,0x72,0x20,0x79
	.DB  0x6F,0x75,0x72,0x20,0x49,0x44,0x3A,0x20
	.DB  0x0,0x45,0x6E,0x74,0x65,0x72,0x20,0x79
	.DB  0x6F,0x75,0x72,0x20,0x50,0x43,0x3A,0x20
	.DB  0x0,0x57,0x65,0x6C,0x63,0x6F,0x6D,0x65
	.DB  0x0,0x53,0x6F,0x72,0x72,0x79,0x20,0x77
	.DB  0x72,0x6F,0x6E,0x67,0x20,0x50,0x43,0x0
	.DB  0x57,0x72,0x6F,0x6E,0x67,0x20,0x49,0x44
	.DB  0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x05
	.DW  _0x3
	.DW  _0x0*2

	.DW  0x06
	.DW  _0x3+5
	.DW  _0x0*2+5

	.DW  0x04
	.DW  _0x3+11
	.DW  _0x0*2+11

	.DW  0x05
	.DW  _0x3+15
	.DW  _0x0*2+15

	.DW  0x05
	.DW  _0x3+20
	.DW  _0x0*2+20

	.DW  0x31
	.DW  _users
	.DW  _0x4*2

	.DW  0x10
	.DW  _0x10
	.DW  _0x0*2+25

	.DW  0x10
	.DW  _0x10+16
	.DW  _0x0*2+41

	.DW  0x08
	.DW  _0x10+32
	.DW  _0x0*2+57

	.DW  0x0F
	.DW  _0x10+40
	.DW  _0x0*2+65

	.DW  0x09
	.DW  _0x10+55
	.DW  _0x0*2+80

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
_0x3:
	.BYTE 0x19
;void main(void)
; 0000 002C {

	.CSEG
_main:
; .FSTART _main
; 0000 002D // Set keypad ports
; 0000 002E DDRC = 0b00000111;
	LDI  R30,LOW(7)
	OUT  0x14,R30
; 0000 002F PORTC = 0b11111000;
	LDI  R30,LOW(248)
	OUT  0x15,R30
; 0000 0030 
; 0000 0031 // Initialize the LCD
; 0000 0032 lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0033 
; 0000 0034 // Set the door as input (now by default the door is closed)
; 0000 0035 DDRB .0 = 0;
	CBI  0x17,0
; 0000 0036 PORTB .0 = 1; // turn on pull up resistance
	SBI  0x18,0
; 0000 0037 
; 0000 0038 // Set the speaker as a output
; 0000 0039 DDRD.7 = 1;
	SBI  0x11,7
; 0000 003A PORTD.7 = 1; // Set it to 0 initially
	SBI  0x12,7
; 0000 003B 
; 0000 003C // Initialize user data in EEPROM
; 0000 003D initializeUsers();
	RCALL _initializeUsers
; 0000 003E 
; 0000 003F while (1)
_0xD:
; 0000 0040 {
; 0000 0041 char enteredID[4];  // Change data type to string
; 0000 0042 User currentUser;
; 0000 0043 unsigned int address = 0;
; 0000 0044 int userFound = 0;
; 0000 0045 int i;
; 0000 0046 
; 0000 0047 displayMessage("Enter your ID: ", 1000);
	SBIW R28,20
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+3,R30
	STD  Y+4,R30
	STD  Y+5,R30
;	enteredID -> Y+16
;	currentUser -> Y+6
;	address -> Y+4
;	userFound -> Y+2
;	i -> Y+0
	__POINTW1MN _0x10,0
	RCALL SUBOPT_0x0
; 0000 0048 
; 0000 0049 if (enterValueWithKeypad(enteredID))
	MOVW R26,R28
	ADIW R26,16
	RCALL _enterValueWithKeypad
	SBIW R30,0
	BRNE PC+2
	RJMP _0x11
; 0000 004A {
; 0000 004B char enteredPC[4];
; 0000 004C for (i = 0; i < sizeof(users) / sizeof(users[0]); ++i)
	SBIW R28,4
;	enteredID -> Y+20
;	currentUser -> Y+10
;	address -> Y+8
;	userFound -> Y+6
;	i -> Y+4
;	enteredPC -> Y+0
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
_0x13:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SBIW R26,5
	BRGE _0x14
; 0000 004D {
; 0000 004E address += sizeof(users[i].name);
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,2
	RCALL SUBOPT_0x1
; 0000 004F EE_ReadString(address, currentUser.id, sizeof(currentUser.id));  // Read ID as a string
	MOVW R30,R28
	ADIW R30,14
	RCALL SUBOPT_0x2
; 0000 0050 
; 0000 0051 if (strcmp(currentUser.id, enteredID) == 0)
	MOVW R30,R28
	ADIW R30,12
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,22
	RCALL _strcmp
	CPI  R30,0
	BRNE _0x15
; 0000 0052 {
; 0000 0053 
; 0000 0054 address += sizeof(users[i].id);
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,4
	RCALL SUBOPT_0x1
; 0000 0055 EE_ReadString(address, currentUser.pc, sizeof(currentUser.pc));  // Read PC as a string
	MOVW R30,R28
	ADIW R30,18
	RCALL SUBOPT_0x2
; 0000 0056 
; 0000 0057 displayMessage("Enter your PC: ", 1000);
	__POINTW1MN _0x10,16
	RCALL SUBOPT_0x0
; 0000 0058 
; 0000 0059 if (enterValueWithKeypad(enteredPC))
	MOVW R26,R28
	RCALL _enterValueWithKeypad
	SBIW R30,0
	BREQ _0x16
; 0000 005A {
; 0000 005B if (strcmp(currentUser.pc, enteredPC) == 0)
	MOVW R30,R28
	ADIW R30,16
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,2
	RCALL _strcmp
	CPI  R30,0
	BRNE _0x17
; 0000 005C {
; 0000 005D displayMessage("Welcome", 1000);
	__POINTW1MN _0x10,32
	RCALL SUBOPT_0x0
; 0000 005E // Open the door
; 0000 005F DDRB .0 = 1;
	SBI  0x17,0
; 0000 0060 }
; 0000 0061 else
	RJMP _0x1A
_0x17:
; 0000 0062 displayMessage("Sorry wrong PC", 1000);
	__POINTW1MN _0x10,40
	RCALL SUBOPT_0x0
; 0000 0063 // one peep alarm
; 0000 0064 generateTone();
_0x1A:
	RCALL _generateTone
; 0000 0065 }
; 0000 0066 
; 0000 0067 userFound = 1;
_0x16:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 0068 break;
	RJMP _0x14
; 0000 0069 }
; 0000 006A 
; 0000 006B address += sizeof(users[i].id);
_0x15:
	RCALL SUBOPT_0x3
; 0000 006C address += sizeof(users[i].pc);
	RCALL SUBOPT_0x3
; 0000 006D }
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
	RJMP _0x13
_0x14:
; 0000 006E }
	ADIW R28,4
; 0000 006F 
; 0000 0070 if (!userFound)
_0x11:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,0
	BRNE _0x1B
; 0000 0071 {
; 0000 0072 displayMessage("Wrong ID", 1000);
	__POINTW1MN _0x10,55
	RCALL SUBOPT_0x0
; 0000 0073 // Two peeps alarm
; 0000 0074 generateTone();
	RCALL _generateTone
; 0000 0075 generateTone();
	RCALL _generateTone
; 0000 0076 }
; 0000 0077 
; 0000 0078 delay_ms(2000);
_0x1B:
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RCALL _delay_ms
; 0000 0079 }
	ADIW R28,20
	RJMP _0xD
; 0000 007A }
_0x1C:
	RJMP _0x1C
; .FEND

	.DSEG
_0x10:
	.BYTE 0x40
;char keypad()
; 0000 007D {

	.CSEG
_keypad:
; .FSTART _keypad
; 0000 007E while (1)
_0x1D:
; 0000 007F {
; 0000 0080 PORTC .0 = 0;
	CBI  0x15,0
; 0000 0081 PORTC .1 = 1;
	SBI  0x15,1
; 0000 0082 PORTC .2 = 1;
	SBI  0x15,2
; 0000 0083 
; 0000 0084 switch (PINC)
	IN   R30,0x13
; 0000 0085 {
; 0000 0086 case 0b11110110:
	CPI  R30,LOW(0xF6)
	BRNE _0x29
; 0000 0087 while (PINC .3 == 0);
_0x2A:
	SBIS 0x13,3
	RJMP _0x2A
; 0000 0088 return 1;
	LDI  R30,LOW(1)
	RET
; 0000 0089 case 0b11101110:
_0x29:
	CPI  R30,LOW(0xEE)
	BRNE _0x2D
; 0000 008A while (PINC .4 == 0);
_0x2E:
	SBIS 0x13,4
	RJMP _0x2E
; 0000 008B return 4;
	LDI  R30,LOW(4)
	RET
; 0000 008C case 0b11011110:
_0x2D:
	CPI  R30,LOW(0xDE)
	BRNE _0x31
; 0000 008D while (PINC .5 == 0);
_0x32:
	SBIS 0x13,5
	RJMP _0x32
; 0000 008E return 7;
	LDI  R30,LOW(7)
	RET
; 0000 008F case 0b10111110:
_0x31:
	CPI  R30,LOW(0xBE)
	BRNE _0x28
; 0000 0090 while (PINC .6 == 0);
_0x36:
	SBIS 0x13,6
	RJMP _0x36
; 0000 0091 return 10;
	LDI  R30,LOW(10)
	RET
; 0000 0092 }
_0x28:
; 0000 0093 
; 0000 0094 PORTC .0 = 1;
	SBI  0x15,0
; 0000 0095 PORTC .1 = 0;
	CBI  0x15,1
; 0000 0096 PORTC .2 = 1;
	SBI  0x15,2
; 0000 0097 
; 0000 0098 switch (PINC)
	IN   R30,0x13
; 0000 0099 {
; 0000 009A case 0b11110101:
	CPI  R30,LOW(0xF5)
	BRNE _0x42
; 0000 009B while (PINC .3 == 0);
_0x43:
	SBIS 0x13,3
	RJMP _0x43
; 0000 009C return 2;
	LDI  R30,LOW(2)
	RET
; 0000 009D case 0b11101101:
_0x42:
	CPI  R30,LOW(0xED)
	BRNE _0x46
; 0000 009E while (PINC .4 == 0);
_0x47:
	SBIS 0x13,4
	RJMP _0x47
; 0000 009F return 5;
	LDI  R30,LOW(5)
	RET
; 0000 00A0 case 0b11011101:
_0x46:
	CPI  R30,LOW(0xDD)
	BRNE _0x4A
; 0000 00A1 while (PINC .5 == 0);
_0x4B:
	SBIS 0x13,5
	RJMP _0x4B
; 0000 00A2 return 8;
	LDI  R30,LOW(8)
	RET
; 0000 00A3 case 0b10111101:
_0x4A:
	CPI  R30,LOW(0xBD)
	BRNE _0x41
; 0000 00A4 while (PINC .6 == 0);
_0x4F:
	SBIS 0x13,6
	RJMP _0x4F
; 0000 00A5 return 0;
	LDI  R30,LOW(0)
	RET
; 0000 00A6 }
_0x41:
; 0000 00A7 
; 0000 00A8 PORTC .0 = 1;
	SBI  0x15,0
; 0000 00A9 PORTC .1 = 1;
	SBI  0x15,1
; 0000 00AA PORTC .2 = 0;
	CBI  0x15,2
; 0000 00AB 
; 0000 00AC switch (PINC)
	IN   R30,0x13
; 0000 00AD {
; 0000 00AE case 0b11110011:
	CPI  R30,LOW(0xF3)
	BRNE _0x5B
; 0000 00AF while (PINC .3 == 0);
_0x5C:
	SBIS 0x13,3
	RJMP _0x5C
; 0000 00B0 return 3;
	LDI  R30,LOW(3)
	RET
; 0000 00B1 case 0b11101011:
_0x5B:
	CPI  R30,LOW(0xEB)
	BRNE _0x5F
; 0000 00B2 while (PINC .4 == 0);
_0x60:
	SBIS 0x13,4
	RJMP _0x60
; 0000 00B3 return 6;
	LDI  R30,LOW(6)
	RET
; 0000 00B4 case 0b11011011:
_0x5F:
	CPI  R30,LOW(0xDB)
	BRNE _0x63
; 0000 00B5 while (PINC .5 == 0);
_0x64:
	SBIS 0x13,5
	RJMP _0x64
; 0000 00B6 return 9;
	LDI  R30,LOW(9)
	RET
; 0000 00B7 case 0b10111011:
_0x63:
	CPI  R30,LOW(0xBB)
	BRNE _0x5A
; 0000 00B8 while (PINC .6 == 0);
_0x68:
	SBIS 0x13,6
	RJMP _0x68
; 0000 00B9 return 11;
	LDI  R30,LOW(11)
	RET
; 0000 00BA }
_0x5A:
; 0000 00BB }
	RJMP _0x1D
; 0000 00BC }
; .FEND
;unsigned char EE_Read(unsigned int address)
; 0000 00BF {
_EE_Read:
; .FSTART _EE_Read
; 0000 00C0 while (EECR .1 == 1); // Wait till EEPROM is ready
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	address -> R16,R17
_0x6B:
	SBIC 0x1C,1
	RJMP _0x6B
; 0000 00C1 EEAR = address;       // Prepare the address you want to read from
	__OUTWR 16,17,30
; 0000 00C2 EECR .0 = 1;          // Execute read command
	SBI  0x1C,0
; 0000 00C3 return EEDR;
	IN   R30,0x1D
	RJMP _0x2080003
; 0000 00C4 }
; .FEND
;void EE_Write(unsigned int address, unsigned char data)
; 0000 00C7 {
_EE_Write:
; .FSTART _EE_Write
; 0000 00C8 while (EECR .1 == 1); // Wait till EEPROM is ready
	RCALL __SAVELOCR4
	MOV  R17,R26
	__GETWRS 18,19,4
;	address -> R18,R19
;	data -> R17
_0x70:
	SBIC 0x1C,1
	RJMP _0x70
; 0000 00C9 EEAR = address;       // Prepare the address you want to read from
	__OUTWR 18,19,30
; 0000 00CA EEDR = data;          // Prepare the data you want to write in the address above
	OUT  0x1D,R17
; 0000 00CB EECR .2 = 1;          // Master write enable
	SBI  0x1C,2
; 0000 00CC EECR .1 = 1;          // Write Enable
	SBI  0x1C,1
; 0000 00CD }
	RJMP _0x2080004
; .FEND
;void EE_WriteString(unsigned int address, const char *str)
; 0000 00D0 {
_EE_WriteString:
; .FSTART _EE_WriteString
; 0000 00D1 // Write each character of the string to EEPROM
; 0000 00D2 while (*str)
	RCALL SUBOPT_0x4
;	address -> R18,R19
;	*str -> R16,R17
_0x77:
	MOVW R26,R16
	LD   R30,X
	CPI  R30,0
	BREQ _0x79
; 0000 00D3 EE_Write(address++, *str++);
	MOVW R30,R18
	__ADDWRN 18,19,1
	ST   -Y,R31
	ST   -Y,R30
	__ADDWRN 16,17,1
	LD   R26,X
	RCALL _EE_Write
	RJMP _0x77
_0x79:
; 0000 00D5 EE_Write(address, '\0');
	ST   -Y,R19
	ST   -Y,R18
	LDI  R26,LOW(0)
	RCALL _EE_Write
; 0000 00D6 }
	RJMP _0x2080004
; .FEND
;void EE_ReadString(unsigned int address, char *buffer, unsigned int length)
; 0000 00D9 {
_EE_ReadString:
; .FSTART _EE_ReadString
; 0000 00DA unsigned int i;
; 0000 00DB for (i = 0; i < length; ++i)
	RCALL __SAVELOCR6
	MOVW R18,R26
	__GETWRS 20,21,6
;	address -> Y+8
;	*buffer -> R20,R21
;	length -> R18,R19
;	i -> R16,R17
	__GETWRN 16,17,0
_0x7B:
	__CPWRR 16,17,18,19
	BRSH _0x7C
; 0000 00DC {
; 0000 00DD buffer[i] = EE_Read(address + i);
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
; 0000 00DE if (buffer[i] == '\0')
	MOVW R30,R16
	ADD  R30,R20
	ADC  R31,R21
	LD   R30,Z
	CPI  R30,0
	BREQ _0x7C
; 0000 00DF break;
; 0000 00E0 }
	__ADDWRN 16,17,1
	RJMP _0x7B
_0x7C:
; 0000 00E1 }
	RCALL __LOADLOCR6
	ADIW R28,10
	RET
; .FEND
;void initializeUsers()
; 0000 00E4 {
_initializeUsers:
; .FSTART _initializeUsers
; 0000 00E5 unsigned int address = 0;
; 0000 00E6 int i;
; 0000 00E7 for (i = 0; i < sizeof(users) / sizeof(users[0]); ++i)
	RCALL __SAVELOCR4
;	address -> R16,R17
;	i -> R18,R19
	__GETWRN 16,17,0
	__GETWRN 18,19,0
_0x7F:
	__CPWRN 18,19,5
	BRGE _0x80
; 0000 00E8 {
; 0000 00E9 EE_WriteString(address, users[i].name);
	RCALL SUBOPT_0x5
	SUBI R30,LOW(-_users)
	SBCI R31,HIGH(-_users)
	MOVW R26,R30
	LD   R30,X+
	LD   R31,X+
	MOVW R26,R30
	RCALL _EE_WriteString
; 0000 00EA address += sizeof(users[i].name);
	__ADDWRN 16,17,2
; 0000 00EB 
; 0000 00EC EE_WriteString(address, users[i].id);
	RCALL SUBOPT_0x5
	__ADDW1MN _users,2
	RCALL SUBOPT_0x6
; 0000 00ED address += sizeof(users[i].id);
; 0000 00EE 
; 0000 00EF EE_WriteString(address, users[i].pc);
	RCALL SUBOPT_0x5
	__ADDW1MN _users,6
	RCALL SUBOPT_0x6
; 0000 00F0 address += sizeof(users[i].pc);
; 0000 00F1 }
	__ADDWRN 18,19,1
	RJMP _0x7F
_0x80:
; 0000 00F2 }
	RJMP _0x2080002
; .FEND
;void displayMessage(char *message, int delay_ms_value)
; 0000 00F5 {
_displayMessage:
; .FSTART _displayMessage
; 0000 00F6 lcd_clear();
	RCALL SUBOPT_0x4
;	*message -> R18,R19
;	delay_ms_value -> R16,R17
	RCALL _lcd_clear
; 0000 00F7 lcd_puts(message);
	MOVW R26,R18
	RCALL _lcd_puts
; 0000 00F8 delay_ms(delay_ms_value);
	MOVW R26,R16
	RCALL _delay_ms
; 0000 00F9 }
_0x2080004:
	RCALL __LOADLOCR4
	ADIW R28,6
	RET
; .FEND
;int enterValueWithKeypad(char *buffer)
; 0000 00FC {
_enterValueWithKeypad:
; .FSTART _enterValueWithKeypad
; 0000 00FD buffer[0] = keypad() + '0';
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	*buffer -> R16,R17
	RCALL _keypad
	SUBI R30,-LOW(48)
	MOVW R26,R16
	ST   X,R30
; 0000 00FE lcd_putchar(buffer[0]);
	LD   R26,X
	RCALL _lcd_putchar
; 0000 00FF buffer[1] = keypad() + '0';
	RCALL _keypad
	SUBI R30,-LOW(48)
	__PUTB1RNS 16,1
; 0000 0100 lcd_putchar(buffer[1]);
	MOVW R30,R16
	LDD  R26,Z+1
	RCALL _lcd_putchar
; 0000 0101 buffer[2] = keypad() + '0';
	RCALL _keypad
	SUBI R30,-LOW(48)
	__PUTB1RNS 16,2
; 0000 0102 lcd_putchar(buffer[2]);
	MOVW R30,R16
	LDD  R26,Z+2
	RCALL _lcd_putchar
; 0000 0103 buffer[3] = '\0';  // Null-terminate the string
	MOVW R30,R16
	ADIW R30,3
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0104 
; 0000 0105 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 0106 
; 0000 0107 return 1;  // Return a non-zero value to indicate success
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
_0x2080003:
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 0108 }
; .FEND
;void generateTone()
; 0000 010A {
_generateTone:
; .FSTART _generateTone
; 0000 010B PORTD.7 = 1;  // Set PD7 HIGH
	SBI  0x12,7
; 0000 010C delay_ms(500);  // Adjust duration as needed
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 010D PORTD.7 = 0;  // Set PD7 LOW
	CBI  0x12,7
; 0000 010E delay_ms(500);  // Pause between tones
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 010F PORTD.7 = 1;  // Set PD7 HIGH (optional: restore to high for a brief moment)
	SBI  0x12,7
; 0000 0110 }
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
	RCALL SUBOPT_0x7
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x7
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
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x8
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
	.BYTE 0x32
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x0:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RJMP _displayMessage

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	STD  Y+8,R30
	STD  Y+8+1,R31
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(4)
	LDI  R27,0
	RJMP _EE_ReadString

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,4
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	RCALL __SAVELOCR4
	MOVW R16,R26
	__GETWRS 18,19,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x5:
	ST   -Y,R17
	ST   -Y,R16
	__MULBNWRU 18,19,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	MOVW R26,R30
	RCALL _EE_WriteString
	__ADDWRN 16,17,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x8:
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
