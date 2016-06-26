;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
			mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer
			mov.w 	#0000h,&PM5CTL0			; Disable low-power mode

;			LED init
			bis.b	#00000001b,&P1DIR
			bic.b	#00000001b,&P1OUT
			bis.b	#10000000b,&P9DIR
			bis.b	#10000000b,&P9OUT

;			TIMER init
			mov.w	#(TASSEL_2|ID_2|MC_2|TAIE),&TA0CTL

;			Global Interrupt Enable
			nop
			bis.w	#GIE,SR
			nop

;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------

MAINLOOP	nop
			jmp MAINLOOP

;			LED toggle
TOGGLE		xor.b	#10000000b,&P9OUT
			xor.b	#00000001b,&P1OUT
			ret

;-------------------------------------------------------------------------------
; Timer interrupt handler
ISRTIMER	call 	#TOGGLE
			bic.w	#1b,TA0CTL
			reti

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
            .sect	".int43"				; Timer interrupt vector
            .short 	ISRTIMER