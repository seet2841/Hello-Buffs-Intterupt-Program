	.include "address_map_nios2.s"
	.include "globals.s"

/*******************************************************************************
 * This program demonstrates use of interrupts. It
 * first starts an interval timer with 50 msec timeouts, and then enables 
 * Nios II interrupts from the interval timer and pushbutton KEYs
 *
 * The interrupt service routine for the interval timer displays a pattern
 * on the HEX3-0 displays, and rotates this pattern either left or right:
 *		KEY[0]: loads a new pattern from the SW switches
 *		KEY[1]: toggles rotation direction
 ******************************************************************************/

	.text						# executable code follows
	.global _start
_start:
	/* set up the stack */
	movia 	sp, SDRAM_END - 3	# stack starts from largest memory address
	mov r23, r0 # Pattern Counter
	movi r4, 60 # Max Pattern count
	movi r1, 0 # Count for button interrupts


	movi r17, 3 # Comparison for SPEED_THREE
	movi r18, 2 # Comparison for SPEED_TWO
	movi r14, 1 # Comparison for SPEED_ONE
	movi r3, -1 # Comparison for SPEED_NEGONE
	movi r19, -3 # Comparison for SPEED_NEGTHREE
	


	movia	r16, TIMER_BASE		# interval timer base address
	/* set the interval timer period for scrolling the HEX displays */
	movia	r12, 50000000		# .5 second timer count
	sthio	r12, 8(r16)			# store the low half word of counter start value
	srli	r12, r12, 16
	sthio	r12, 0xC(r16)		# high half word of counter start value

	/* start interval timer, enable its interrupts */
	movi	r15, 0b0111			# START = 1, CONT = 1, ITO = 1
	sthio	r15, 4(r16)

	/* write to the pushbutton port interrupt mask register */
	movia	r15, KEY_BASE		# pushbutton key base address
	movi	r7, 0b11			# set interrupt mask bits
	stwio	r7, 8(r15)			# interrupt mask register is (base + 8)

	/* enable Nios II processor interrupts */
	movia	r7, 0x00000001		# get interrupt mask bit for interval timer
	movia	r8, 0x00000002		# get interrupt mask bit for pushbuttons
	or		r7, r7, r8
	wrctl	ienable, r7			# enable interrupts for the given mask bits
	movi	r7, 1
	wrctl	status, r7			# turn on Nios II interrupt processing

IDLE:
	br 		IDLE				# main program simply idles

	.data
/*******************************************************************************
 * The global variables used by the interrupt service routines for the interval
 * timer and the pushbutton keys are declared below
 ******************************************************************************/
	.global	PATTERN
PATTERN:
	.word   0x00000000, 0x00000076, 0x00007679, 0x00767906, 0x76790606, 0x7906065C, 0x06065C00, 0x065C007C, 0x5C007C3E,  0x007C3E71,  0x7C3E7171, 0x3E71716D,0x71716D00,0x716D0000, 0x6D000000, 0x00000000   


