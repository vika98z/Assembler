_PRINTF = 127
_EXIT = 1
.SECT .TEXT
        PUSH    arr
        MOV 	CX, end
	SHR	CX, 1          
	PUSH	CX            ! size of arr
	CALL    SUM_MOD_5
        ADD	SP, 4         ! clear stack
	PUSH    BX            ! result
        PUSH    fmt
        PUSH    _PRINTF
        SYS
        ADD	SP, 6         ! clear stack
        PUSH    0
        PUSH    _EXIT
        SYS
SUM_MOD_5:
	PUSH    BP
        MOV     BP, SP
        MOV	CX, 4(BP)     ! size of arr
        MOV     SI, 6(BP)
        XOR     BX, BX
1:        
        
        MOV     AX, (SI)      ! elem of arr
        CWD
        DIV     (dv)          ! AX = (SI)/5
        ADD     BX, DX
        ADD     SI, 2         ! next elem
        LOOP    1b
        MOV     SP, BP
        POP     BP
        RET

.SECT .DATA	
arr:	.WORD	9, 10, 11, 12
end:	.BYTE	0
dv:    .WORD   5
fmt:   .ASCIZ   "%d "

.SECT .BSS
