_EXIT = 1
_READ = 3 
_WRITE = 4 
_OPEN = 5 
_CLOSE = 6 
_CREAT = 8 
_PRINTF = 127

.SECT.TEXT
        
        PUSH	0
        PUSH    read_file_name
	PUSH	_OPEN            ! open file for read, file descriptor in AX
	SYS
        ADD 	SP, 6            ! clear stack
        CMP 	AX, -1
	JZ	ERROR	         ! if AX=-1 then error
	MOV	(read_fd), AX    ! descriptor in read_fd
	
	PUSH	0600
        PUSH    write_file_name
	PUSH	_CREAT		 ! create new file, file descriptor in AX
	SYS
	ADD 	SP, 6            ! clear stack
	CMP 	AX, -1
	JZ	ERROR	         ! if AX=-1 then error
	MOV	(write_fd), AX   ! descriptor in write_fd
1:	
        PUSH	2                ! count of bytes for read
	PUSH	elem
	PUSH	(read_fd)        ! descriptor
	PUSH	_READ            ! read first elem
	SYS
	ADD 	SP, 8            ! clear stack
	CMP     AX, 0
	JZ      EXT              ! if AX = 0 then end of file and exit
	NOT     (elem)
	INC     (elem)           ! elem = -elem
        PUSH	2                ! count of bytes for write
	PUSH	elem
	PUSH	(write_fd)
	PUSH	_WRITE           ! Write in new file
	SYS
	ADD 	SP, 8            ! clear stack
	JMP     1b	
EXT:
        PUSH	(read_fd)
	PUSH 	_CLOSE           ! Close first file (read_file_name)
	SYS		
        ADD     SP, 4            ! clear stack
        
        PUSH	(write_fd)       ! Close second file (write_file_name)
	PUSH 	_CLOSE
	SYS		
        ADD     SP, 4            ! clear stack
        
        PUSH    0
        PUSH    _EXIT
        SYS	
ERROR:		 
        PUSH    str_error
        PUSH    _PRINTF          ! AX fmt _PRINTF
        SYS
        ADD     SP, 4            ! clear stack
        
        PUSH    0
        PUSH    _EXIT
        SYS

.SECT.DATA
read_file_name:   .ASCIZ    "./test.dat"
write_file_name:  .ASCIZ    "./new_task.dat"
str_error:        .ASCIZ    "Error.\n"

.SECT.BSS
read_fd:	.SPACE	2   ! descriptor otkrytogo faila
write_fd:	.SPACE	2   ! descriptor sozdavaemogo faila
elem:      	.SPACE	2
