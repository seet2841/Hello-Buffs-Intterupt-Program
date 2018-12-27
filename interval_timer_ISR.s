	.include "address_map_nios2.s"
	.include "globals.s"
	.extern	PATTERN					# externally defined variables
	.extern	SHIFT_DIR
	.extern	SHIFT_EN
/*******************************************************************************
 * Interval timer - Interrupt Service Routine
 *
 * Shifts a PATTERN being displayed. The shift direction is determined by the 
 * external variable SHIFT_DIR. Whether the shifting occurs or not is determined
 * by the external variable SHIFT_ON.
 ******************************************************************************/
	.global INTERVAL_TIMER_ISR
INTERVAL_TIMER_ISR:					
	subi	sp,  sp, 40				# reserve space on the stack
	stw		ra, 0(sp)
#	stw		r4, 4(sp)
#	stw		r5, 8(sp)
	stw		r6, 12(sp)
	stw		r8, 16(sp)
	stw		r10, 20(sp)
	stw		r20, 24(sp)
	stw		r21, 28(sp)
	stw		r22, 32(sp)
#	stw		r23, 36(sp)

	movia	r10, TIMER_BASE			# interval timer base address
	sthio	r0,  0(r10)				# clear the interrupt

	movia	r20, HEX3_HEX0_BASE		# HEX3_HEX0 base address
	movia	r21, PATTERN			# set up a pointer to the display pattern

	add     r21, r21, r23			# Updates the Pattern address
	ldw		r6, 0(r21)				# load the pattern
	stwio	r6, 0(r20)				# store to HEX3 ... HEX0
	addi    r23, r23, 4				# Adds 4 to the Pattern counter
	beq     r23, r4, RESET			# If Pattern counter = Max Pattern count, reset the counter so the scrolling will start over

END_INTERVAL_TIMER_ISR:
	ldw		ra, 0(sp)				# restore registers
#	ldw		r4, 4(sp)
#  	ldw		r5, 8(sp)
#	ldw		r6, 12(sp)
	ldw		r8, 16(sp)
	ldw		r10, 20(sp)
	ldw		r20, 24(sp)
	ldw		r21, 28(sp)
	ldw		r22, 32(sp)
#	ldw		r23, 36(sp)	
	addi	sp,  sp, 40				# release the reserved space on the stack

	ret

RESET:
	mov r23, r0 					#Resets the Pattern counter
	br END_INTERVAL_TIMER_ISR		
	.end	
