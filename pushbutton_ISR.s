	.include "address_map_nios2.s"
	.include "globals.s"
	.extern	PATTERN					# externally defined variables
	.extern	SHIFT_DIR
	.extern	SHIFT_EN
/*******************************************************************************
 * Pushbutton - Interrupt Service Routine
 *
 * This routine checks which KEY has been pressed and updates the global
 * variables as required.
 ******************************************************************************/

	.global	PUSHBUTTON_ISR

PUSHBUTTON_ISR:
	subi	sp, sp, 24				# reserve space on the stack
	stw		ra, 0(sp)
	stw		r10, 4(sp)
	stw		r11, 8(sp)
	stw		r12, 12(sp)
	stw		r13, 16(sp)
	stw		r23, 20(sp)

	movi 	r23, -2					#Comparison for SPEED_NEGTWO

	movia	r16, TIMER_BASE		# interval timer base address
	movia	r10, KEY_BASE			# base address of pushbutton KEY parallel port
	ldwio	r11, 0xC(r10)			# read edge capture register
	stwio	r11, 0xC(r10)			# clear the interrupt	  

CHECK_KEY0:
	andi	r13, r11, 0b0001		# check KEY0
	beq		r13, zero, CHECK_KEY1
	beq		r1, r17, SPEED_THREE
	addi	r1, r1, 1
	beq		r1, r17, SPEED_THREE
	beq		r1, r18, SPEED_TWO
	beq		r1, r0, SPEED_BASE
	beq		r1, r14, SPEED_ONE
	beq		r1, r3, SPEED_NEGONE
	beq		r1, r23, SPEED_NEGTWO
	beq		r1, r19, SPEED_NEGTHREE


CHECK_KEY1:
	andi	r13, r11, 0b0010		# check KEY1
	beq		r13, zero, END_PUSHBUTTON_ISR
	beq 	r1, r19, SPEED_NEGTHREE
	subi	r1, r1, 1
	beq		r1, r19, SPEED_NEGTHREE
	beq		r1, r18, SPEED_TWO
	beq		r1, r14, SPEED_ONE
	beq		r1, r0, SPEED_BASE
	beq		r1, r3, SPEED_NEGONE
	beq		r1, r23, SPEED_NEGTWO
	beq		r1, r17, SPEED_THREE

END_PUSHBUTTON_ISR:
	ldw		ra,  0(sp)				# Restore all used register to previous
	ldw		r10, 4(sp)
	ldw		r11, 8(sp)
	ldw		r12, 12(sp)
	ldw		r13, 16(sp)
	ldw		r23, 20(sp)
	addi	sp,  sp, 24

	ret


SPEED_BASE:
	movia	r5, 50000000		# .5 second timer count
	sthio	r5, 8(r16)			# store the low half word of counter start value
	srli	r5, r5, 16
	sthio	r5, 0xC(r16)		# high half word of counter start value
	movi	r15, 0b0111			# START = 1, CONT = 1, ITO = 1
	sthio	r15, 4(r16)
	br END_PUSHBUTTON_ISR

SPEED_ONE:
	movia	r5, 30000000		# .3 second timer count
	sthio	r5, 8(r16)			# store the low half word of counter start value
	srli	r5, r5, 16
	sthio	r5, 0xC(r16)		# high half word of counter start value
	movi	r15, 0b0111			# START = 1, CONT = 1, ITO = 1
	sthio	r15, 4(r16)
	br END_PUSHBUTTON_ISR


SPEED_TWO:
	movia	r5, 20000000		# .2 second timer count
	sthio	r5, 8(r16)			# store the low half word of counter start value
	srli	r5, r5, 16
	sthio	r5, 0xC(r16)		# high half word of counter start value
	movi	r15, 0b0111			# START = 1, CONT = 1, ITO = 1
	sthio	r15, 4(r16)
	br END_PUSHBUTTON_ISR

SPEED_THREE:
	movia	r5, 10000000			# .1 second timer count
	sthio	r5, 8(r16)			# store the low half word of counter start value
	srli	r5, r5, 16
	sthio	r5, 0xC(r16)		# high half word of counter start value
	movi	r15, 0b0111			# START = 1, CONT = 1, ITO = 1
	sthio	r15, 4(r16)
	br END_PUSHBUTTON_ISR

SPEED_NEGONE:
	movia	r5, 60000000		# .6 second timer count
	sthio	r5, 8(r16)			# store the low half word of counter start value
	srli	r5, r5, 16
	sthio	r5, 0xC(r16)		# high half word of counter start value
	movi	r15, 0b0111			# START = 1, CONT = 1, ITO = 1
	sthio	r15, 4(r16)
	br END_PUSHBUTTON_ISR

SPEED_NEGTWO:
	movia	r5, 70000000		# .7 second timer count
	sthio	r5, 8(r16)			# store the low half word of counter start value
	srli	r5, r5, 16
	sthio	r5, 0xC(r16)		# high half word of counter start value
	movi	r15, 0b0111			# START = 1, CONT = 1, ITO = 1
	sthio	r15, 4(r16)
	br END_PUSHBUTTON_ISR

SPEED_NEGTHREE:
	movia	r5, 80000000		# .8 second timer count
	sthio	r5, 8(r16)			# store the low half word of counter start value
	srli	r5, r5, 16
	sthio	r5, 0xC(r16)		# high half word of counter start value
	movi	r15, 0b0111			# START = 1, CONT = 1, ITO = 1
	sthio	r15, 4(r16)
	br END_PUSHBUTTON_ISR

	.end

# Registers to use for moving speed into: r5
# Registers to use for last 4 speeds counters: r9, r14, 
