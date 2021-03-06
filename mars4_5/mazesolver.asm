#Christopher Diehl
#CS 447
#Maze Solver 
#8x8

.data 
	directions: .space 100			#straight =0, right=1, left =2
	coordinates: .space 100

.text
	add $t8, $t0, $zero
	add $t9, $t9, $zero


	jal _leftHandRule
	add $a2, $v0, $zero
	la $a0, coordinates
	jal _traceBack
	
	addi $a0, $zero, 3
	addi $a1, $zero, -1
 	jal _backtracking
	addi $v0, $zero, 10
	syscall
	
#Recursision with backtracking
#leaf Function
#goes 0-100 real quick
#$a1 =Row& column
	_backtracking:
		beq $a0, 5, BaseCase
		addi $sp, $sp, -24
		sw $s0, 0($sp)
		sw $ra, 4($sp)
		sw $s1, 8($sp)
		sw $s2, 12($sp)
		sw $s3, 16($sp)
		sw $s4, 20 ($sp)
		add $s0, $a0, $0
		
		
RWBstart:	add $s3, $a1, $zero
		addi $t8, $zero, 4
		nop
		add $a0, $t9, $zero
		jal _checkIfFinished
		beq $v0, 1, BaseCase
		jal _getRowColumn1
		add $s4, $v0, $zero
		
TryNorth:		beq $s0, 2, TryWest

			jal _isNorthWall
			beq $v0, 0, TryWest
			add $s1, $v0, $zero
			add $s2, $v1, $zero

			addi $a0, $zero, 0
			add $a1, $s4, $zero
			jal _backtracking
			add $a0, $s1, $zero
			add $a1, $s2, $zero
			#jal _resetCar
			
TryWest:		beq $s0, 3, TrySouth

			jal _isWestWall
			beq $v0, 0, TrySouth
			add $s1, $zero, $v0
			add $s2, $zero, $v1

			addi $a0, $zero, 1
			add $a1, $s4, $zero
			jal _backtracking
			add $a0, $s1, $zero
			add $a1, $s2, $zero
			#jal _resetCar
			
TrySouth:		beq $s0, 0, TryEast

			jal _isSouthWall
			beq $v0, 0, Temp
			add $s1, $zero, $v0
			add $s2, $zero, $v1

			addi $a0, $zero, 2
			add $a1, $s4, $zero
			jal _backtracking
			add $a0, $s1, $zero
			add $a1, $s2, $zero
			#jal _resetCar
			add $v0, $s0, $v0
			beq $v0, 8, BacktrackingFalse
			
Temp:			beq $s0, 1, BacktrackingFalse	

TryEast:		beq $s0, 1, callRecursive	
			jal _isEastWall
			beq $v0, 0, BacktrackingFalse
			add $s1 $v0, $zero
			add $s2, $v1, $zero
			beq $s1, 0, BacktrackingFalse
			addi $a0, $zero, 3
			add $a1, $s4, $zero
callRecursive:		jal _backtracking
ResetEast:		add $a0, $s1, $zero
			add $a1, $s2, $zero
			#jal _resetCar
			j BacktrackingFalse	
					
BacktrackingFalse: lw $s0, 0($sp)
			add $a0, $s3, $zero
			add $a1, $s4, $zero
			jal _BResetStart
			lw $ra, 4($sp)
			lw $s1, 8($sp)
			lw $s2, 12($sp)
			lw $s3, 16($sp)
			lw $s4, 20($sp)	
			addi $sp, $sp, 24
			addi $v0, $zero, 7
			jr $ra	
		BaseCase:
		addi $v0, $zero, 10
		syscall
#BRESETSTART

#new row = $a0, past row = $a1
_BResetStart:
			addi $sp, $sp, -16
			sw $ra, 0($sp)
			sw $s0, 4($sp)
			sw $s1, 8($sp)
			sw $s2, 12 ($sp)

			
			add $s0, $a0, $zero
			addi $t8, $zero 4
			nop
			add $a0, $t9, $zero
			jal _getRowColumn1
			add $s1, $v0, $zero
			add $a0, $t9, $zero

			sub $t2, $s0, $s1
			beq $t2, 10, BRTS
			beq $t2, -10, BRTN
			beq $t2, 1, BRTE
			beq $t2, -1, BRTW
			
BRTW:	jal _isWestWall
	j BResetEnd
BRTE:	jal _isEastWall
	j BResetEnd
BRTN:	jal _isNorthWall
	j BResetEnd
BRTS:	jal _isSouthWall
	j BResetEnd

BResetEnd: 			
			nop
			addi $t8, $zero, 2
			nop	
			lw $ra, 0($sp)
			lw $s0, 4($sp)
			lw $s1, 8, ($sp)
			lw $s2, 12 ($sp)
			addi $sp, $sp, 16
			jr $ra


#resetsCarDuringBacktracking
#values sent in $a0, $a1
#non leaf
	_resetCar:	beq $a0, 8, RC8
			beq $a0, 9, RC9
			beq $a0, 6, RC6
			beq $a0, 11, RC11

	
	RC3: addi $t8, $zero 3
	     nop
		j RCEnd
	RC9: addi $t8, $zero, 3
	     addi $t8, $zero, 3
	     addi $t8, $zero, 1
	     j RCEnd
	     #addi $t8, $zero, 3
	RC6:addi $t8, $zero, 3
	     addi $t8, $zero, 3
	     addi $t8, $zero, 1
	     #addi $t8, $zero, 2
	     j RCEnd
	RC2: addi $t8, $zero, 2
		nop
		j RCEnd
	RC11: addi $t8, $zero, 1
	RC8: addi $t8, $zero, 3
	     nop
	     addi $t8, $zero, 3
	     nop
	     addi $t8, $zero, 1
	     nop
	     j RCEnd
	RCEnd: jr $ra
# _directBack
#takes robot back through the maze directly
#takes info stored from array
#regurtitates info and moves based on previous left hand rule movements
#goes 0-100 real quick
#ends at 0, -1
#robot is already turned around
#leaf function
#index passed in $a2
#coordinates in $a0
	_traceBack:
#reverse array
		addi $sp $sp, -12
		sw $ra, 0($sp)
		sw $s0, 4($sp)
		sw $s1, 8($sp)
		add $t1, $zero, $zero
		addi $a0, $a0, 1
		lb $t0, 0($a0)
		dbloop: beq $t0, $zero, dbEndLoop
			addi $t1, $t1, 1
			addi $a0, $a0, 1
			lb $t0, 0($a0)
			j dbloop
		dbEndLoop: subi $a0, $a0, 2
			   add $s1, $a0, $zero
			
	DBStart:
			addi $t8, $zero 4
			nop
			add $a0, $t9, $zero
			jal _getRowColumn1
			add $s0, $v0, $zero
			add $a0, $t9, $zero
			beq $s0, 0 , DBFinish
			jal _isFacingWest
			beq $v0, 1, DBWest
			jal _isFacingNorth
			beq $v0, 1, DBNorth
			jal _isFacingEast
			beq $v0, 1, DBEast
			jal _isFacingSouth
			beq $v0, 1, DBSouth
			beq $t0, 0, DBEnd
			add $t8, $zero, $t0
			subi $a0, $a0, 1

			j DBStart
DBRightStraight: 	addi $t8, $zero, 3
			nop
			addi $t8, $zero, 1
			nop
			subi $s1, $s1, 1
			j DBStart

DBLeftStraight:		addi $t8, $zero, 2
			nop
			addi $t8, $zero, 1
			nop
			subi $s1, $s1, 1
			j DBStart
DBStraight:		addi $t8, $zero, 1
			nop
			subi $s1, $s1, 1
			j DBStart
	
DBNorth:		lb $t0, 0($s1)
			sub $t2, $s0, $t0
			beq $t2, 10, DBStraight
			beq $t2, -1, DBRightStraight
			beq $t2, 1, DBLeftStraight		
			
DBWest:			lb $t0, 0($s1)
			sub $t2, $s0, $t0
			beq $t2, 10, DBRightStraight
			beq $t2, -10, DBLeftStraight
			j DBStraight

DBEast:			lb $t0, 0($s1)
			sub $t2, $s0, $t0
			beq $t2, 10, DBLeftStraight
			beq $t2, -10, DBRightStraight
			j DBStraight
DBSouth:		lb $t0, 0 ($s1)
			sub $t2, $s0, $t0
			beq $t2, -10, DBStraight
			beq $t2, 10, DBStraight
			beq $t2, 1, DBRightStraight
			beq $t2, -1, DBLeftStraight

DBFinish:		addi $t8, $zero , 4
			nop
			jal _isFrontWall
			beq $v0, 1, DBFinishLeft
			addi $t8, $zero, 1
			nop
			j DBEnd

DBFinishLeft:		addi $t8, $zero, 2
			nop
			addi $t8, $zero, 1
			nop
			j DBEnd

DBEnd: 			addi $t8, $zero, 2
			nop
			addi $t8, $zero, 2
			nop	
			lw $ra, 0($sp)
			lw $s0, 4($sp)
			addi $sp, $sp, 12
			jr $ra


#isWestWall
#leaf	
	_isWestWall:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	add $t8, $zero, 4
	nop
	add $a0, $t9, $zero
	jal _isFacingNorth
	beq $v0, 1, WWN
	
	jal _isFacingEast
	beq $v0, 1, WWE
	
	jal _isFacingSouth
	beq $v0, 1 WWS
	
	jal _isFacingWest
	beq $v0, 1 WWW
	
	j WWEnd
	
	WWW:
	jal _isFrontWall
	bne $v0, 0, WWEndN
	addi $t8, $zero, 1
	addi $v0, $zero, 8 
	j WWEnd
	
	WWS:
	jal _isRightWall
	bne $v0, 0, WWEndN
	addi $t8, $zero, 3
	addi $t8, $zero, 1
	addi $v0, $zero, 8
	addi $v1, $zero 3
	j WWEnd
	
	WWN:
	jal _isLeftWall
	bne $v0, 0, WWEndN
	addi $t8, $zero, 2
	addi $t8, $zero, 1
	addi $v0, $zero, 8
	addi $v1, $zero, 3
	j WWEnd
	
	WWE:
	jal _isBackWall
	bne $v0, 0, WWEndN
	addi $t8, $zero, 3
	addi $t8, $zero, 3
	addi $t8, $zero, 1
	j WWEnd
	
	WWEndN:
	add $v0, $zero, $zero
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
	WWEnd:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra


#_isSouthWall
#leaf
#_isNorthWall
#leaf	
	_isSouthWall:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	add $t8, $zero, 4
	nop
	add $a0, $t9, $zero
	
	jal _isFacingNorth
	beq $v0, 1, SWN
	
	jal _isFacingEast
	beq $v0, 1, SWE
	
	jal _isFacingSouth
	beq $v0, 1 SWS
	
	jal _isFacingWest
	beq $v0, 1 SWW
	j SWEnd
	
	SWW:
	jal _isLeftWall
	bne $v0, 0, SWEndN
	addi $t8, $zero, 2
	addi $t8, $zero, 1
	addi $v0, $zero, 8
	addi $v1, $zero, 3
	j SWEnd
	
	SWS:
	jal _isFrontWall
	bne $v0, 0, SWEndN
	addi $t8, $zero, 1
	addi $v0, $zero, 8
	j SWEnd
	
	SWN:
	jal _isBackWall
	bne $v0, 0, SWEndN
	addi $t8, $zero, 2
	addi $t8, $zero, 2
	addi $t8, $zero, 1
	j SWEnd
	
	SWE:
	jal _isRightWall
	bne $v0, 0, SWEndN
	addi $t8, $zero, 3
	addi $t8, $zero, 1
	addi $v0, $zero, 8
	addi $v1, $zero, 3
	j SWEnd
	
	SWEndN:
		addi $v0, $zero, 0
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
	SWEnd:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra


#_isNorthWall
#leaf	
	_isNorthWall:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	add $t8, $zero, 4
	nop
	add $a0, $t9, $zero
	jal _isFacingNorth
	beq $v0, 1, NWN
	
	jal _isFacingEast
	beq $v0, 1, NWE
	
	jal _isFacingSouth
	beq $v0, 1 NWS
	
	jal _isFacingWest
	beq $v0, 1 NWW
	
	j NWEnd
	
	NWW:
	jal _isRightWall
	bne $v0, 0, NWEndN
	addi $t8, $zero, 3
	addi $t8, $zero, 1
	addi $v0, $zero, 8
	addi $v1, $zero, 2
	j NWEnd
	
	NWS:
	jal _isBackWall
	bne $v0, 0, NWEndN
	addi $t8, $zero, 3
	addi $t8, $zero, 3
	addi $t8, $zero, 1
	addi $v0, $zero, 11
	j NWEnd

	
	NWN:
	jal _isFrontWall
	bne $v0, 0, NWEndN
	addi $t8, $zero, 1
	addi $v0, $zero, 8
	j NWEnd

	
	NWE:
	jal _isLeftWall
	bne $v0, 0, NWEndN
	addi $t8, $zero, 2
	addi $t8, $zero, 1
	addi $v0, $zero, 9
	j NWEnd

	NWEndN:
	add $v0, $zero, $zero
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
	NWEnd:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
#_isEastWall
#leaf function

#_isNorthWall
#leaf	
	_isEastWall:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	add $t8, $zero, 4
	nop
	add $a0, $t9, $zero
	jal _isFacingNorth
	beq $v0, 1, EWN
	
	jal _isFacingEast
	beq $v0, 1, EWE
	
	jal _isFacingSouth
	beq $v0, 1 EWS
	
	jal _isFacingWest
	beq $v0, 1 EWW
	
	j EWEnd
	
	EWW:
	jal _isBackWall
	bne $v0, 0, EWEndN
	addi $t8, $zero, 3
	addi $t8, $zero, 3
	addi $t8, $zero, 1
	addi $v0, $zero, 11
	j EWEnd
	
	EWS:
	jal _isLeftWall
	bne $v0, 0, EWEndN
	addi $t8, $zero, 2
	addi $t8, $zero, 1
	addi $v0, $zero, 9
	addi $v1, $zero 1
	j EWEnd
	
	EWN:
	jal _isRightWall
	bne $v0, 0, EWEndN
	addi $t8, $zero, 3
	addi $t8, $zero, 1
	addi $v0, $zero, 6
	addi $v1, $zero, 2
	j EWEnd
	
	EWE:
	jal _isFrontWall
	bne $v0, 0, EWEndN
	addi $t8, $zero, 1
	addi $v0, $zero, 8
	addi $v1, $zero, 3
	j EWEnd
	EWEndN: lw $ra, 0($sp)
		add $v0, $zero, $zero
		addi $sp, $sp, 4
		jr $ra
	EWEnd:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
# _leftHandRule
#asumed start point is 0, -1
##t8 at beggining to enter maze
#leaf function
#returns index of arrays in $v0
	_leftHandRule:
		addi $sp, $sp, -32
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $s2, 8($sp)
		sw $ra, 12($sp)
		sw $s3, 16($sp)	#counter
		sw $s4, 20($sp)#directions
		sw $s5, 24($sp)#coordinates
		sw $s6, 28($sp)
		la $s4, directions		#string for directions
		la $s5, coordinates
		
		addi $t8, $zero, 1
		addi $t0, $zero, 1
		sb $zero, 0($s5)
		sb $t0, 0($s4)
		addi $s4, $s4, 1
		addi $s5, $s5, 1
LHstart:	addi $t8, $zero, 4
		nop

		add $a0, $t9, $zero
		jal _isFrontWall
		add $s1, $v0, $zero
		
		add $a0, $t9, $zero
		jal _isLeftWall
		add $s0, $v0, $zero
		
		jal _checkIfFinished
		beq $v0, 1, LHFinish
		
		beq $s0, 0, LHturnLeft
		beqz $s1, LHgoStraight
		beq $s1, 1, LHturnRight
		

		
		LHturnRight:
			addi $t8, $zero, 4
			nop
			add $a0, $t9, $zero
			jal _isFacingSouth
			add $s0, $v0, $zero
			add $a0, $t9, $zero
			jal _isFacingNorth
			add $t1, $v0, $zero
			add $t8, $zero, 3
			nop
	
			add $v0, $s0, $s6
			beq $v0, 2, LHReset
			
			add $v0, $t1, $s6
			#beq $v0, 2, LHReset
			
			beq $s6, 1, LHOppR
			
			li $t0, 2
			sb $t0, 0($s4)
			addi $s4, $s4, 1
			
LHReset:		j LHstart
			
		LHOppR: li $t0, 3
			sb $t0, 0($s4)
			addi $s4, $s4, 1
			j LHstart
			
		LHturnLeft:
			addi $t8, $zero, 4
			nop
			add $a0, $t9, $zero
			jal _isFacingSouth
			add $s0, $v0, $zero
			
			add $a0, $t9, $zero
			jal _isFacingNorth
			add $t1, $v0, $zero
			
			add $t8, $zero, 2
			nop
			
			add $v0, $s0, $s6
			#beq $v0, 2, LHLeftEnd
						
			add $v0, $t1, $s6
			beq $v0, 2, LHLeftEnd
			
			beq $s6, 1, LHOppL
			li $t0, 3
			sb $t0, 0($s4)
			addi $s4, $s4, 1
			j LHLeftEnd
			
LHOppL:			li $t0, 2
			sb $t0, 0($s4)
			addi $s4, $s4, 1
			j LHLeftEnd
			#end
	LHLeftEnd:	add $a0, $t9, $zero
			jal _isFrontWall
			add $t0, $zero, $v0
			beqz $t0, LHgoStraight
			j LHstart
			
		LHgoStraight:

			add $t8, $zero, 1
			nop
			add $a1, $s5, $zero
			jal _getRowColumn
			add $s6, $v0, $zero
			add $s3, $v1, $zero
			la $a0, coordinates
			la $a1, directions
			jal _resetArray
			add $s4, $v1, $zero
			add $s5, $v0, $zero
			li $t0, 1
			sb $t0, 0($s4)
			sb $s3, 0($s5)
			addi $s4, $s4, 1
			addi $s5, $s5, 1
			j LHstart
			
		LHFinish : 
			   add $v0, $s3, $zero
			   lw $s2, 8($sp)
			   lw $s1, 4($sp)
			   lw $s0, 0($sp)
			   lw $ra, 12($sp)
			   lw $s3, 16($sp)
			   lw $s4, 20($sp)
			   lw $s5, 24($sp)
			   lw $s6, 28($sp)
			   addi $sp, $sp, 32
			   addi $t8, $zero, 2
			   addi $t8, $zero, 2
				jr $ra
		
		
#check if finished
#if done then return 0 in V0
#t9 is passes in a0

	_checkIfFinished:
		addi $sp, $sp, -12
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $ra, 8($sp)
		add $s0, $a0, $zero
		jal _getRow
		add $s1, $v0, $zero
		bne $s1, 7, CIFNotFin
		
		add $s0, $a0, $zero
		jal _getColumn
		bne $v0, 8, CIFNotFin
		j CIFFin
		
		CIFFin:
		
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $ra, 8($sp)
		addi $sp, $sp, 12
		addi $v0, $zero, 1
		jr $ra		
		
		CIFNotFin:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $ra, 8($sp)
		addi $sp, $sp, 12
		add $v0, $zero, $zero
		jr $ra
		
#getRowColumn
#gets rid of everything after duplicate coordinates
#returns the index
#index goes in $a0, put in $s0
#row column is returned in $v1
#index returned in $v0
	_getRowColumn:
		addi $sp, $sp, -8
		sw $s0, 0($sp)
		sw $ra, 4($sp)

		addi $t8, $zero, 4
		add $a0, $t9, $zero
		
		jal _getRow
		
		li $t0, 10
		mult $v0, $t0
		mflo $v0
		add $s0, $v0, $zero
		addi $t8, $zero, 4	
		add $a0, $t9, $zero
		
		jal _getColumn
		
		add $v0, $v0, $s0
		add $v1, $v0, $zero
		add $a0, $v0, $zero
		la $a1, coordinates
		la $a2, directions
BK:		jal _findDuplicatesInArray
		lw $s0, 0($sp)
		lw $ra, 4($sp)
		addi $sp, $sp, 8
		
		
		jr $ra	
		
#row column returned in $v0
	_getRowColumn1:
		addi $sp, $sp, -8
		sw $s0, 0($sp)
		sw $ra, 4($sp)

		addi $t8, $zero, 4
		add $a0, $t9, $zero
		
		jal _getRow
		
		li $t0, 10
		mult $v0, $t0
		mflo $v0
		add $s0, $v0, $zero
		addi $t8, $zero, 4	
		add $a0, $t9, $zero
		
		jal _getColumn
		
		add $v0, $v0, $s0
		lw $s0, 0($sp)
		lw $ra, 4($sp)
		addi $sp, $sp, 8
		
		
		jr $ra	
#reset array
#$a0 is coordinates
#$a1 is directions
#non leaf
#resets the array back to new end spot
#$v0 is coordinates  $v1 is directions
_resetArray:
	lb $t1, 0($a1)
	li $t0, 0
	addi $a0, $a0, 1
	lb $t2, 0($a0)
	RALOOP: beq $t1, $t0, RALOOP2
	addi $a1, $a1, 1
	lb $t1, 0($a1)
	j RALOOP
	
	RALOOP2:beq $t2, $t0, RADone
		addi $a0, $a0, 1
		lb $t2, 0($a0)
	j RALOOP2
	RADone: 
		add $v0, $a0, $zero
		add $v1, $a1, $zero
		jr $ra
	
	
	
	
		
#findDuplicatesInArray
#hardcoded directions and coordinates
#non leaf function
#coordinates passed in #a0
#coordinates array passed in $a1
#directions passed in $a2
#index returned in $v0
	_findDuplicatesInArray:
		addi $a1, $a1,1
		lb $t4, 0($a1)
		li $t3, 0
		li $t5, 0
		addi $t6, $zero, 0
		
  fdiAStart:	beq $a0, $t3, findDuplicatesFound
  		beq $t3, $t4, findDuplicatesNotFound
  coordinates0:	beq $a0, $t4, findDuplicatesFound
  		addi $t6, $t6, 1   #counter index
  		addi $a1, $a1, 1
  		lb $t4, 0 ($a1)
  		j fdiAStart
  		
  		findDuplicatesFound:
  		add $v0, $t0, $zero
  		sb $zero, 0($a1)
  		addi $a1, $a1, 1
  		lb $t0, 0($a1)
  		
  fdfCClearArray: beqz $t0, fdfDCClearArray
  		sb $zero, 0($a1)
  		addi $a1, $a1, 1
  		addi $t6, $t6, 1
  		lb $t0, 0($a1)
  		j fdfCClearArray
  		
  fdfDCClearArray: li $t4, 1
  		   lb $t3, 0($a2)
  		   addi $a2, $a2, 1
  		   beqz $t3, fdfDone
  		   bne $t3, $t4, fdfDCClearArray
  		   addi $t5, $t5, 1
  		   beq $t5, $t6, fdfDCCLear
  		   j fdfDCClearArray	
  fdfDCCLear: lb $t4, 0($a2)
  	      beq $t4, $zero fdfDone
 	      sb $zero 0($a2)	
  	      addi $a2, $a2, 1
  	      j fdfDCCLear   
  		
  fdfDone:	bnez $t6, fdfjump
  		sb $t4, 0($a2)
  		
  	fdfjump: addi $v0, $zero, 1	
  		jr $ra
 
  		
  		findDuplicatesNotFound: 

  		add $v0, $zero, $zero
   		jr $ra
		
#getRow
#$t9 goes in $a0
#columns returned in $v0
	_getRow:
		srl $t0, $a0, 24
		#li $t1, 127
		add $v0, $t0, $zero
		jr $ra

#getColumn
#$t9 goes in $a0
#columns returned in $v0
	_getColumn:
		sll $t0, $a0, 8
		srl $v0, $t0, 24
		jr $ra

# _isFacingNorth
#$t9 goes in $a0
#if 1 is returned car is facing east
#value returned in $v0
	_isFacingNorth:
		srl $t0, $a0, 11
		li $t1, 1		#puts a 1 in the 4th bit
		and $v0, $t0, $t1
		jr $ra

# _isFacingSouth
#$t9 goes in $a0
#if 1 is returned car is facing east
#value returned in $v0
	_isFacingSouth:
		srl $t0, $a0, 9
		li $t1, 1		#puts a 1 in the 4th bit
		and $v0, $t0, $t1
		jr $ra

# _isFacingWest
#$t9 goes in $a0
#if 1 is returned car is facing east
#value returned in $v0
	_isFacingWest:
		srl $t0, $a0, 8
		li $t1, 1		#puts a 1 in the 4th bit
		and $v0, $t0, $t1
		jr $ra

# _isFacingEast
#$t9 goes in $a0
#if 1 is returned car is facing east
#value returned in $v0
	_isFacingEast:
		srl $t0, $a0, 10
		li $t1, 1		#puts a 1 in the 4th bit
		and $v0, $t0, $t1
		jr $ra

#_isLeftWall
#$t9 goes in $a0
#if 1 is returned left wall is there
#value returned in $v0
	_isLeftWall:
		srl $t0, $a0, 2
		li $t1, 1		#puts a 1 in the 4th bit
		and $v0, $t0, $t1
		jr $ra
	
#_isRightWall
#$t9 goes in $a0
#if 1 is returned right wall is there
#value returned in $v0
	_isRightWall:
		srl $t0, $a0, 1
		li $t1, 1 		#puts a 1 in the 4th bit
		and $v0, $t0, $t1
		jr $ra

#_isFrontWall
#$t9 goes in $a0
#if 1 is returned front wall is there
#value returned in $v0
	_isFrontWall:
		srl $t0, $a0, 3
		li $t1, 1 		#puts a 1 in the 4th bit
		and $v0, $t0, $t1
		jr $ra

#_isBackWall
#$t9 goes in $a0
#if 1 is returned back wall is there
#value returned in $v0
	_isBackWall:
		add $t0, $a0, $zero
		li $t1, 1 		#puts a 1 in the 4th bit
		and $v0, $t0, $t1
		jr $ra
