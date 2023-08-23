

sendname macro
local sendnamesize,send
                   PUSHA
sendnamesize:         mov dx,03fdh
                      in  al,dx
                      AND                AL,00100000B
                      JZ                 sendnamesize

                      mov dx,03F8H
                      mov al,myusername +1
                      out dx,al
                      mov cl,myusername+1
                      mov si,2
 send:                  mov dx,03fdh
                      in al,dx
                      AND                AL,00100000B
                      JZ                 send

                      mov al,myusername[si]
                      mov dx,03F8H
                      out dx,al
                      inc si
                      dec cl
                      jnz send
          POPA            
 endm sendname

PRINTKILLEDPIECE MACRO PIECE ,POS
LOCAL PAWNISKILLED,ROOCKISKILLED,BISHOPISKILLED,KNIGHTISKILLED,KINGISKILLED,QUEENISKILLED,SKIPCHANGECURSOR,PRINTLETTER,CHECKMYKING,SKIPENDGAME,CHECK

MOV BH,0D
MOV AH,2D
MOV DX,POS
INT 10h

MOV AL,PIECE
CMP AL,21H
JZ PAWNISKILLED
CMP AL,22H
JZ ROOCKISKILLED
CMP AL,23H
JZ BISHOPISKILLED
CMP AL,24H
JZ KNIGHTISKILLED
CMP AL,26H
JZ KINGISKILLED 
CMP AL,25H
JZ QUEENISKILLED
CMP AL,11H
JZ PAWNISKILLED
CMP AL,12H
JZ ROOCKISKILLED
CMP AL,13H
JZ BISHOPISKILLED
CMP AL,14H
JZ KNIGHTISKILLED
CMP AL,16H
JZ KINGISKILLED 
CMP AL,15H
JZ QUEENISKILLED

PAWNISKILLED: MOV DL,'P'
JMP PRINTLETTER
ROOCKISKILLED: MOV DL,'R'
JMP PRINTLETTER
BISHOPISKILLED: MOV DL,'B'
JMP PRINTLETTER
KNIGHTISKILLED: MOV DL,'N'
JMP PRINTLETTER
KINGISKILLED: MOV DL,'K'
JMP PRINTLETTER
QUEENISKILLED: MOV DL,'Q'


PRINTLETTER:
MOV AH,2D
INT 21H

MOV AH,2D
MOV DL,','
INT 21H

MOV AX,POS
ADD AL,2D
CMP AL,75D
JL SKIPCHANGECURSOR
INC AH
MOV AL,40H

SKIPCHANGECURSOR:
MOV POS ,AX

MOV AL,PIECE
CMP AL,16H
JNZ CHECKMYKING
MOV BH,0D
MOV AH,2D
MOV DX,01440H
INT 10h
MOV AH,9h
MOV DX,OFFSET WIN
INT 21H
INC GAME_ENDED
CHECKMYKING:
CMP AL,26H
JNZ SKIPENDGAME
MOV BH,0D
MOV AH,2D
MOV DX,01440H
INT 10h
MOV AH,9h
MOV DX,OFFSET LOSE
INT 21H
INC GAME_ENDED
SKIPENDGAME:   

ENDM PRINTKILLEDPIECE

getenemyname macro 
local GETNAME,GETLETTER
PUSHA

 GETNAME:               MOV                DX,3FDH
                        IN                 AL,DX
                        AND                AL,1
                        JZ                 GETNAME

                        mov                dx , 03F8H
                        in                 al , dx
                        MOV                CL,AL
                       MOV DI,0D
  GETLETTER:            MOV                DX,3FDH
                        IN                 AL,DX
                        AND                AL,1
                        JZ                 GETLETTER      
                         mov                dx , 03F8H
                        in                 al , dx
                        MOV enemyname[di],al
                        inc di
                        dec cl
                        jnz GETLETTER
POPA
endm getenemyname




DISPLAYCURRTIME MACRO
  LOCAL SKIPTIME2
  MOV AX,0D
  MOV CURRTIME,AX
                      MOV BH,0d
                      MOV AH,2D
                      MOV DX,0042H
                      INT 10h
                      
                      mov                ah,02ch
                      int                21H


                      MOV CURRHOUR,CH
                      MOV CURRmin,CL
                      MOV CURRsec,DH

                      CMP CH,12D
                      JL SKIPTIME2
                      SUB CH,12D
                      MOV CURRHOUR,CH

SKIPTIME2:
                      MOV                AH,0D
                      MOV                AL,CURRHOUR
                      MOV                BX,3600
                      MUL                BX
                      ADD                CURRTIME,AX

                      MOV                AH,0D
                      MOV                AL,CURRmin
                      MOV                BL,60D
                      MUL                BL
                      ADD                CURRTIME,AX

                      MOV AH,0d
                      MOV AL,CURRsec
                      ADD                CURRTIME,AX 
                      MOV AX,CURRTIME
                      
                      SUB AX,STARTTIME
 
                       MOV DX,0000H
                       MOV BX,3600D
                       DIV BX

                      MOV TEMPTIME,DX                         
                      MOV AH,0D
                      MOV BL,10D
                      DIV BL
                      
                      ADD AL,30H
                      ADD AH,30H
                      MOV DIGIT1,AL
                      MOV DIGIT2,AH

                      MOV AH,2
                      MOV DL,DIGIT1
                      INT 21H

                      MOV AH,2
                      MOV DL,DIGIT2
                      INT 21H

                      MOV AH,2
                      MOV DL,':'
                      INT 21H
                     MOV DX,0D
                     MOV AX,TEMPTIME
                     MOV BX,60D
                     DIV BX

                     MOV TEMPTIME, DX ;;;
                      
                      MOV AH,0D
                      MOV BL,10D
                      DIV BL
                      
                      ADD AL,30H
                      ADD AH,30H
                      MOV DIGIT1,AL
                      MOV DIGIT2,AH

                      MOV AH,2
                      MOV DL,DIGIT1
                      INT 21H

                      MOV AH,2
                      MOV DL,DIGIT2
                      INT 21H

                      MOV AH,2
                      MOV DL,':'
                      INT 21H


                      MOV AX,TEMPTIME
                      MOV BL,10D
                      DIV BL
                      
                      ADD AL,30H
                      ADD AH,30H
                      MOV DIGIT1,AL
                      MOV DIGIT2,AH

                  
                      MOV AH,9
                      MOV DX, OFFSET DIGIT1
                      INT 21H
                
                      MOV AH,9
                      MOV DX,OFFSET DIGIT2
                      INT 21H
  ENDM DISPLAYCURRTIME 


ISINCHECK MACRO 
local checkup,skipup,CHECKDOWN,check_down,SKIPDOWN,INCHECK,SKIPTOPRIGHT,SKIPTOPLEFT,INCHECK2,check_LEFT,SKIPBOTTOMRIGHT,INCHECK4,SKIPLEFT,CHECKRIGHT,check_RIGHT,SKIPBOTTOMLEFT,CHECKOTHER,SKIPRIGHT,CHECKIFNIGHT,CHECKLEFT,CHECKPAWNR,CHECKPAWNR2,CHECK_BOTTOM_LEFT,CHECK_BOTTOM_RIGHT,CHECKBOTTOMLEFT,CHECKBOTTOMRIGHT,CHECK_TOP_LEFT,check_TOP_RIGHT,CHECKTOPLEFT,INCHECK3,skiphalf1,skiphalf2,skiphalf3,skiphalf4,skiphalf5,skiphalf6,skiphalf7,skiphalf8,INCHECK_D,INCHECK_L,INCHECK_T,INCHECK_R
mov al,KING_Y
mov ah,0d
mov bl,8D
mul bl
add al,KING_X

mov si,ax
mov ah,KING_Y
mov al,KING_X
dec ah

checkup:
cmp ah,0d
jl CHECKDOWN
sub si,8D
mov dh,Grid[si]
cmp dh,0d
jz skipup
cmp dh,20H
jg CHECKDOWN
cmp dh,11H
jz CHECKDOWN
cmp dh,13H
jz CHECKDOWN
cmp dh,14H
jz CHECKDOWN
CMP DH,16H
JNZ INCHECK_T
MOV AL,KING_Y
SUB AL,AH
CMP AL,1D
JNZ CHECKDOWN

INCHECK_T:
mov KING_INCHECK,1D
jmp CHECKDOWN
skipup:
dec ah
jmp checkup
;;;;;;;;;;;;;;;;;;;;
CHECKDOWN:
mov al,KING_Y
mov ah,0d
mov bl,8D
mul bl
add al,KING_X

mov si,ax
mov ah,KING_Y
mov al,KING_X
INC ah

check_down:
cmp ah,7d
jg CHECKLEFT
add si,8D
mov dh,Grid[si]
cmp dh,0d
jz SKIPDOWN
cmp dh,20H
jg CHECKLEFT
cmp dh,11H
jz CHECKLEFT
cmp dh,13H
jz CHECKLEFT
cmp dh,14H
jz CHECKLEFT
CMP DH,16H
JNZ INCHECK_D
SUB AH,KING_Y
CMP AH,1D
JNZ CHECKLEFT

INCHECK_D:
mov KING_INCHECK,1D
jmp CHECKLEFT
SKIPDOWN:
inc ah
jmp check_down
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHECKLEFT:
mov al,KING_Y
mov ah,0d
mov bl,8D
mul bl
add al,KING_X

mov si,ax
mov ah,KING_Y
mov al,KING_X
dec AL

check_LEFT:
cmp aL,0d
jL CHECKRIGHT
DEC SI
mov dh,Grid[si]
cmp dh,0d
jz SKIPLEFT
cmp dh,20H
jg CHECKRIGHT
cmp dh,11H
jz CHECKRIGHT
cmp dh,13H
jz CHECKRIGHT
cmp dh,14H
jz CHECKRIGHT
CMP DH,16d
JNZ INCHECK_L
MOV AH,KING_X
SUB AH,AL
CMP AH,1D
JNZ CHECKRIGHT
INCHECK_L:
mov KING_INCHECK,1D
jmp CHECKRIGHT
SKIPLEFT:
DEC AL
jmp check_LEFT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHECKRIGHT:
mov al,KING_Y
mov ah,0d
mov bl,8D
mul bl
add al,KING_X

mov si,ax
mov ah,KING_Y
mov al,KING_X
INC  AL

check_RIGHT:
cmp aL,7d
jG CHECKOTHER
INC SI
mov dh,Grid[si]
cmp dh,0d
jz SKIPRIGHT
cmp dh,20H
jg CHECKOTHER
cmp dh,11H
jz CHECKOTHER
cmp dh,13H
jz CHECKOTHER
cmp dh,14H
jz CHECKOTHER
CMP DH,16d
JNZ INCHECK_R
SUB AL,KING_X
CMP AL,1D
JNZ CHECKOTHER
INCHECK_R:
MOV AL,1D
mov KING_INCHECK,AL
jmp CHECKOTHER
SKIPRIGHT:
INC AL
jmp check_RIGHT

CHECKOTHER:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CHECK TOP RIGHT
mov al,KING_Y
mov ah,0d
mov bl,8D
mul bl
add al,KING_X

mov si,ax
mov ah,KING_Y
mov al,KING_X
INC AL
DEC AH

check_TOP_RIGHT:
cmp aL,7d
jG CHECK_TOP_LEFT
CMP AH,0D
JL CHECK_TOP_LEFT
SUB SI,7D
mov dh,Grid[si]
cmp dh,0d
jz SKIPTOPRIGHT
cmp dh,20H
jg CHECK_TOP_LEFT
cmp dh,14H
jz CHECK_TOP_LEFT
cmp dh,12H
jz CHECK_TOP_LEFT
CMP DH,11H
JZ CHECKPAWNR
CMP DH,16H
JNZ INCHECK
CHECKPAWNR:

SUB AL,KING_X
CMP AL,1d
JNZ CHECK_TOP_LEFT

INCHECK:
MOV AL,1D
mov KING_INCHECK,AL
jmp CHECK_TOP_LEFT
SKIPTOPRIGHT:
INC AL
DEC AH
jmp check_TOP_RIGHT

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHECK_TOP_LEFT:
mov al,KING_Y
mov ah,0d
mov bl,8D
mul bl
add al,KING_X

mov si,ax
mov ah,KING_Y
mov al,KING_X
DEC AL
DEC AH

CHECKTOPLEFT:
cmp aL,0d
jL CHECK_BOTTOM_RIGHT
CMP AH,0D
JL CHECK_BOTTOM_RIGHT
SUB SI,9D
mov dh,GRID[si]
cmp dh,0d
jz SKIPTOPLEFT
cmp dh,20H
JG CHECK_BOTTOM_RIGHT
cmp dh , 14H
jz CHECK_BOTTOM_RIGHT
cmp dh,12H
jz CHECK_BOTTOM_RIGHT
CMP DH,11H
JZ CHECKPAWNR2
CMP DH,16H
JNZ INCHECK2
CHECKPAWNR2:

MOV AL,KING_Y
SUB AL,AH
CMP AL,1D
JNZ CHECK_BOTTOM_RIGHT

INCHECK2:
MOV AL,1D
mov KING_INCHECK,AL
jmp CHECK_BOTTOM_RIGHT
SKIPTOPLEFT:
DEC AL
DEC AH
jmp CHECKTOPLEFT

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHECK_BOTTOM_RIGHT:
mov al,KING_Y
mov ah,0d
mov bl,8D
mul bl
add al,KING_X

mov si,ax
mov ah,KING_Y
mov al,KING_X
INC AL
INC AH

CHECKBOTTOMRIGHT:
cmp aL,7d
JG CHECK_BOTTOM_LEFT
CMP AH,7D
JG CHECK_BOTTOM_LEFT
ADD SI,9d
mov dh,Grid[si]
cmp dh,0d
jz SKIPBOTTOMRIGHT
cmp dh,20H
jg CHECK_BOTTOM_LEFT
cmp dh,14H
jz CHECK_BOTTOM_LEFT
cmp dh,12H
jz CHECK_BOTTOM_LEFT
CMP DH,11H
JZ CHECK_BOTTOM_LEFT
CMP DH,16H
JNZ INCHECK3
SUB AL,KING_X
CMP AL,1d
JNZ CHECK_BOTTOM_LEFT

INCHECK3:
MOV AL,1D
mov KING_INCHECK,AL
jmp CHECK_BOTTOM_LEFT
SKIPBOTTOMRIGHT:
INC AL
INC AH
jmp CHECKBOTTOMRIGHT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHECK_BOTTOM_LEFT:
mov al,KING_Y
mov ah,0d
mov bl,8D
mul bl
add al,KING_X

mov si,ax
mov ah,KING_Y
mov al,KING_X
DEC AL
INC AH

CHECKBOTTOMLEFT:
cmp aL,0d
JL CHECKIFNIGHT
CMP AH,7D
JG CHECKIFNIGHT
ADD SI,7d
mov dh,Grid[si]
cmp dh,0d
jz SKIPBOTTOMLEFT
cmp dh,20H
jg CHECKIFNIGHT
cmp dh,14H
jz CHECKIFNIGHT
cmp dh,12H
jz CHECKIFNIGHT
CMP DH,11H
JZ CHECKIFNIGHT
CMP DH,16H
JNZ INCHECK4
SUB AH,KING_Y
CMP AH,1d
JNZ CHECKIFNIGHT

INCHECK4:
MOV AL,1D
mov KING_INCHECK,AL
jmp CHECKIFNIGHT
SKIPBOTTOMLEFT:
DEC AL
INC AH
jmp CHECKBOTTOMLEFT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHECKIFNIGHT:
mov al,KING_Y
mov ah,0d
mov bl,8D
mul bl
add al,KING_X
mov si,ax
mov ah,KING_Y
mov al,KING_X
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sub si,10D
sub al,2d
dec ah
cmp ah,0d
jl skiphalf2
cmp al,0d
jl skiphalf1
mov dl,grid[si]
cmp dl,14H
jnz skiphalf1
mov dl,1D
mov KING_INCHECK,dl
skiphalf1:
add al,4d
add si,4
cmp al,7d
jg skiphalf2
mov dl,grid[si]
cmp dl,14H
jnz skiphalf2
mov dl,1D
mov KING_INCHECK,dl
skiphalf2:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov al,KING_Y
mov ah,0d
mov bl,8D
mul bl
add al,KING_X
mov si,ax
mov ah,KING_Y
mov al,KING_X

sub ah,2d
dec aL
sub si,17D
cmp ah,0d
jl skiphalf4
cmp al,0d
jl skiphalf3
mov dl,grid[si]
cmp dl,14H
jnz skiphalf3
mov dl,1D
mov KING_INCHECK,dl
skiphalf3:
add al,2d
add si,2D
cmp al,7d
jg skiphalf4
mov dl,Grid[si]
cmp dl,14H
jnz skiphalf4
mov dl,1D
mov KING_INCHECK,dl
skiphalf4:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov al,KING_Y
mov ah,0d
mov bl,8D
mul bl
add al,KING_X
mov si,ax
mov ah,KING_Y
mov al,KING_X

inc ah
add al,2d
add si,10D
cmp ah,7d
jg skiphalf6
cmp al,7d
jg skiphalf5
mov dl,Grid[si]
cmp dl,14H
jnz skiphalf5
mov dl,1D
mov KING_INCHECK,dl
skiphalf5:
sub al,4D
sub si,4D
cmp al,0d
jl skiphalf6
mov dl,grid[si]
cmp dl,14H
jnz skiphalf6
mov dl,1d
mov KING_INCHECK,dl
skiphalf6:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov al,KING_Y
mov ah,0d
mov bl,8D
mul bl
add al,KING_X
mov si,ax
mov ah,KING_Y
mov al,KING_X

add ah,2d
inc al
add si,17D
cmp ah,7d
jg skiphalf7
cmp al,7d
jg skiphalf7
mov dl,grid[si]
cmp dl,14H
jnz skiphalf7
mov dl,1d
mov KING_INCHECK,dl
skiphalf7:
sub al,2D
sub si,2D
cmp al,0d
jl skiphalf8
mov dl,grid[si]
cmp dl,14H
jnz skiphalf8
mov dl,1d
mov KING_INCHECK,dl
skiphalf8:


ENDM  ISINCHECK

ROTATE MACRO   EGRID ,  MYGRID 
LOCAL  LOOP1,LOOP2,LOOP3,LOOP4,LOOP5,LOOP6,LOOPROW,SKIP,SUBTRACT,SKIPPRINT
MOV SI,7D
MOV DI,0D
MOV CL,8D
LOOP2:

MOV CH,8D
LOOP1:          ;MIROR ONE ROW AROUND THE Y AXIS
MOV AL,EGRID[SI]
MOV MYGRID[DI],AL
DEC SI
INC DI
DEC CH
JNZ LOOP1

ADD SI,16
DEC CL
JNZ LOOP2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOV CH,64
MOV SI,0D
LOOP3:        ;CHANGING THE CODES
MOV AL,MYGRID[SI]
cmp al,00h
jz skip
CMP AL,20H
JG SUBTRACT
ADD AL,10h
MOV MYGRID[SI],al
JMP SKIP

SUBTRACT:
SUB AL,10h
MOV MYGRID[SI],AL
SKIP:
INC SI
DEC CH
JNZ LOOP3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MIRIOR THE GRID AROUND THE X AXIS
MOV SI,56D
MOV DI,0D

MOV CH,8D
LOOP4:
MOV CL,8D
LOOP5:
MOV AL,MYGRID[SI]
MOV GRID[DI],AL
INC DI
INC SI
DEC CL
JNZ LOOP5

SUB SI,16D
DEC CH
JNZ LOOP4
;;;;;;;;;HERE WE SHOUD READ THE GRID


ENDM ROTATE
PRINTTHEGRID MACRO 
LOCAL LOOPROW,LOOP6,SKIPPRINT,ME,enemy,e_black,me_white,b_bishop,b_king,b_knight,b_pawn,b_queen,b_rock,w_bishop,w_king,w_knight,w_pawn,w_queen,w_rock
MOV BP,0D
MOV DI, 0D
MOV DL,8D
LOOPROW:
MOV DH,8d
LOOP6:
MOV AL,GRID[DI]
CMP AL,00H
JZ SKIPPRINT
;;;;;HERE EACH PIECE SHOULD BE PRINTED
CMP AL,20H
JG ME
enemy:
cmp MYCOLOR,2H
jnz e_black
cmp al,11H
jz w_pawn
cmp al,12H
jz w_rock
cmp al,13H
jz w_bishop
cmp al,14H
jz w_knight
cmp al,15H
jz w_queen
jmp w_king
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
e_black:
cmp al,11H
jz b_pawn
cmp al,12H
jz b_rock
cmp al,13H
jz b_bishop
cmp al,14H
jz b_knight
cmp al,15H
jz b_queen
jmp b_king
;jmp SKIPPRINT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ME:
CMP MYCOLOR,2
JNZ  me_white
cmp al,21H
jz b_pawn
cmp al,22H
jz b_rock
cmp al,23H
jz b_bishop
cmp al,24H
jz b_knight
cmp al,25H
jz b_queen
jmp b_king
;;;;;;;;;;;;;;;;;;;;;;;;;;
me_white:
cmp al,21H
jz w_pawn
cmp al,22H
jz w_rock
cmp al,23H
jz w_bishop
cmp al,24H
jz w_knight
cmp al,25H
jz w_queen
jmp w_king

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
b_pawn: lea si,black_pawn 
printchar bp
jmp SKIPPRINT
b_rock:lea si,black_rock
printchar bp
jmp SKIPPRINT
b_bishop:lea si,black_bishop
printchar bp
jmp SKIPPRINT
b_knight:lea si,black_knight
printchar bp
jmp SKIPPRINT
b_queen:lea si,black_queen
printchar bp
jmp SKIPPRINT
b_king:lea si,black_king
printchar bp
jmp SKIPPRINT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
w_pawn: lea si,white_pawn 
printchar bp
jmp SKIPPRINT
w_rock:lea si,white_rock
printchar bp
jmp SKIPPRINT
w_bishop:lea si,white_bishop
printchar bp
jmp SKIPPRINT
w_knight:lea si,white_knight
printchar bp
jmp SKIPPRINT
w_queen:lea si,white_queen
printchar bp
jmp SKIPPRINT
w_king:lea si,white_king
printchar bp
jmp SKIPPRINT
;;;;;;;

SKIPPRINT:

INC DI
ADD bp,20D
DEC DH
JNZ LOOP6
SUB bp,160d
ADD bp,6400D
DEC DL
JNZ LOOPROW



  ENDM PRINTTHEGRID

 UPDATETHEGRID MACRO  INDEX1 , INDEX2
 LOCAL SKIPPRINT,e_black,b_bishop,b_king,b_knight,b_pawn,b_queen,b_rock,w_bishop,w_king,w_knight,w_pawn,w_queen,w_rock,SKIPPRINTLETTER
 MOV AL,63D
 SUB AL, INDEX1
 MOV INDEX1,AL

 MOV AL,63D
 SUB AL,INDEX2
 MOV INDEX2,AL
 
;;;;;;;GETTING X_POS AND Y_POS OF THE PIECE 
 MOV AL,INDEX1
 MOV AH,0D
 MOV BL,8D
 DIV BL

 MOV TEMP_X,AH
 MOV TEMP_Y,AL
 CONVERT TEMP_X,TEMP_Y,DI
PRINTSQUARE COLOR1,DI,LEN

 MOV AL,INDEX2
 MOV AH,0D
 MOV BL,8D
 DIV BL

 MOV TEMP_X,AH
 MOV TEMP_Y,AL
 CONVERT TEMP_X,TEMP_Y,DI
PRINTSQUARE COLOR1,DI,LEN


MOV AL,INDEX1
MOV AH,0d
MOV SI,AX
mov dl,GRID[si]
MOV GRID[SI] ,00H

MOV AL,INDEX2
MOV AH,0d
MOV SI,AX
CMP GRID[SI],0d
JZ SKIPPRINTLETTER
PUSHA
PRINTKILLEDPIECE GRID[SI] , MY_KILLED_POS
POPA
SKIPPRINTLETTER:
MOV GRID[SI] ,DL

CONVERT TEMP_X,TEMP_Y,BP

cmp MYCOLOR,2H
jnz e_black
cmp DL,11H
jz w_pawn
cmp DL,12H
jz w_rock
cmp DL,13H
jz w_bishop
cmp DL,14H
jz w_knight
cmp DL,15H
jz w_queen
jmp w_king
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
e_black:
cmp DL,11H
jz b_pawn
cmp DL,12H
jz b_rock
cmp DL,13H
jz b_bishop
cmp DL,14H
jz b_knight
cmp DL,15H
jz b_queen
jmp b_king


b_pawn: lea si,black_pawn 
printchar bp
jmp SKIPPRINT
b_rock:lea si,black_rock
printchar bp
jmp SKIPPRINT
b_bishop:lea si,black_bishop
printchar bp
jmp SKIPPRINT
b_knight:lea si,black_knight
printchar bp
jmp SKIPPRINT
b_queen:lea si,black_queen
printchar bp
jmp SKIPPRINT
b_king:lea si,black_king
printchar bp
jmp SKIPPRINT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
w_pawn: lea si,white_pawn 
printchar bp
jmp SKIPPRINT
w_rock:lea si,white_rock
printchar bp
jmp SKIPPRINT
w_bishop:lea si,white_bishop
printchar bp
jmp SKIPPRINT
w_knight:lea si,white_knight
printchar bp
jmp SKIPPRINT
w_queen:lea si,white_queen
printchar bp
jmp SKIPPRINT
w_king:lea si,white_king
printchar bp


SKIPPRINT:

  ENDM UPDATETHEGRID


MOVE   MACRO Q_x,Q_y,X_POS,Y_POS
LOCAL SKIPPRINTLETTER,PAWN,ROCK,BISHOP,QUEEN,king,KNIGHT,SKIPUPDATE
MOV AL,Q_y
MOV BL,8D
MUL BL
ADD AL,Q_X
MOV SI,AX
MOV DH ,GRID[SI]   ;;;;;;;GET THE CODE OF THE PIECE YOU WANT TO MOVE 
MOV AL,Y_POS
MOV BL,8D
MUL BL
ADD AL,X_POS
MOV DI ,AX
CMP GRID[DI],0d
JZ SKIPPRINTLETTER
PUSHA
PRINTKILLEDPIECE GRID[DI] ,ENEMY_KILLED_POS
POPA
SKIPPRINTLETTER:
CMP DH,26H
JNZ SKIPUPDATE
MOV AL,X_POS
MOV AH,Y_POS
MOV KING_X,AL
MOV KING_Y,AH
SKIPUPDATE:

MOV GRID[SI],00h  
MOV GRID[DI],DH ;;;;;;;;;;   PUT THE CODE IM THE DESTINATION
    ;;;;;;;;  EMPTY THE OLD CELL
CONVERT Q_x,Q_y,DI
PRINTSQUARE COLOR1 ,DI ,LEN   ;;;;;;REMOVEING THE PIECE PICTURE FROM THE OLD CELL
CONVERT X_POS,Y_POS,DI
CMP DH,21H
JZ PAWN
CMP DH,22H
JZ ROCK
CMP DH,23H
JZ BISHOP
CMP DH,25H
JZ QUEEN
cmp dh,26H
jz king
CMP DH,24H
JZ KNIGHT
JMP SKIP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;white pieces need to be checked
KNIGHT:
LEA SI,black_knight
CMP MYCOLOR,2h
JZ PRINTPIECE
LEA SI,white_knight
JMP PRINTPIECE
PAWN:  
 LEA SI,black_pawn
 cmp MYCOLOR,2h
 jz PRINTPIECE
 LEA SI,white_pawn
  JMP PRINTPIECE
ROCK:  LEA SI, black_rock
CMP MYCOLOR,2h
JZ PRINTPIECE
LEA SI,white_rock
  JMP PRINTPIECE
BISHOP:    LEA SI,black_bishop
 CMP MYCOLOR,2H
JZ PRINTPIECE
LEA SI,white_bishop
 JMP PRINTPIECE
QUEEN:    LEA SI,black_queen
 CMP MYCOLOR,2H
JZ PRINTPIECE
LEA SI,white_queen
 JMP PRINTPIECE
king: lea si,black_king
 CMP MYCOLOR,2H
JZ PRINTPIECE
LEA SI,white_king

PRINTPIECE:mov bx ,di
PRINTSQUARE  unhighlightcolor1,bx,LEN

 printchar DI
SKIP:
ENDM   MOVE

PRINTKNIGHT MACRO X,Y
LOCAL SKIPDOWN,SKIPDOWNRIGHT,SKIPUP,SKIPUPRIGHT,SKIPRIGHTUP,SKIPTOP,SKIPBOTRIGHT,SKIPBOT
MOV AL,Y
MOV BL,8D
MUL BL
MOV DH,Y
MOV DL,X
ADD AL,DL
MOV SI,AX
INC DH
CMP DH,7H
JG SKIPDOWN
CMP DL,5D
JG SKIPDOWNRIGHT
MOV AL,GRID[SI+10]
CMP AL,20H
JG SKIPDOWNRIGHT
ADD DL,2D
CONVERT DL,DH,DI
HIGHLIGHT highlightcolor , DI ,LEN
SUB DL,2D
SKIPDOWNRIGHT:
CMP DL,2D
JL SKIPDOWN
MOV AL,GRID[SI+6];
CMP AL,20H
JG SKIPDOWN
SUB DL,2D
CONVERT DL,DH,DI
HIGHLIGHT highlightcolor , DI ,LEN
ADD DL,2D
SKIPDOWN:
DEC DH
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DEC DH
CMP DH,0H
JL SKIPUP
CMP DL,5H
JG SKIPRIGHTUP
MOV AL,GRID[SI-6];
CMP AL,20H
JG SKIPRIGHTUP
ADD DL,2D
CONVERT DL,DH,DI
HIGHLIGHT highlightcolor , DI ,LEN
SUB DL,2D
SKIPRIGHTUP:
CMP DL,2D
JL SKIPUP
MOV AL,GRID[SI-10];
CMP AL,20H
JG SKIPUP
SUB DL,2D
CONVERT DL,DH,DI
HIGHLIGHT highlightcolor , DI ,LEN
ADD DL,2D
SKIPUP:
INC DH

;;;;;;;;;;;;;;;;;;;;;;;;;;
SUB DH,2H
CMP DH,0H
JL SKIPTOP
CMP DL,6H
JG SKIPUPRIGHT
MOV AL,GRID[SI-15];
CMP AL,20H
JG SKIPUPRIGHT
INC DL
CONVERT DL,DH,DI
HIGHLIGHT highlightcolor , DI ,LEN
DEC DL
SKIPUPRIGHT:
CMP DL,1H
JL SKIPTOP
MOV AL,GRID[SI-17];
CMP AL,20H
JG SKIPTOP
DEC DL
CONVERT DL,DH,DI
HIGHLIGHT highlightcolor , DI ,LEN
INC DL
SKIPTOP:
ADD DH,2H

;;;;;;;;;;;;;;;;;;

ADD DH,2H
CMP DH,7H
JG SKIPBOT
CMP DL,6H
JG SKIPBOTRIGHT
MOV AL,GRID[SI+17];
CMP AL,20H
JG SKIPBOTRIGHT
INC DL
CONVERT DL,DH,DI
HIGHLIGHT highlightcolor , DI ,LEN
DEC DL
SKIPBOTRIGHT:
CMP DL,1H
JL SKIPBOT 
MOV AL,GRID[SI+15];
CMP AL,20H
JG SKIPBOT
DEC DL
CONVERT DL,DH,DI
HIGHLIGHT highlightcolor , DI ,LEN
INC DL
SKIPBOT:
SUB DH,2H

 
ENDM PRINTKNIGHT

PRINTROCK MACRO  X ,Y 
LOCAL OUT1,CHECKLEFT ,LOOP1,LOOP2 ,LOOP3,LOOP4, OUT2,OUT3,OUT4,CHECKUP,CHECKDOWN ,SKIP
MOV AL,Y
MOV BL , 8D
MUL BL
ADD AL, X 
MOV SI, ax  ;;;;; SI CONTAIN THE INDEX OF THE ROCK IN THE GRID 
MOV DL,7
SUB DL,X  ; NOW DL CONTAIN TEH NUMBER OF CELLS ON THE RIGHT SIDE OF THE PIECE  DL = 7 - X 
MOV DH,X 
cmp dl,0    ; if there is no cells on the right side
jz CHECKLEFT
LOOP1:      ;;;; HIGHLIGHT THE CELLS TILL YOU FIND  A PIECE IN THE PATH
INC SI
MOV AL , Grid[SI]
 CMP AL,00H
JNZ OUT1
INC DH

CONVERT DH,Y,DI

HIGHLIGHT highlightcolor , DI ,LEN 
DEC dl
JNZ LOOP1
OUT1:
CMP DL,0
JZ  CHECKLEFT
MOV AL,Grid[SI]
CMP AL, 20H
JG CHECKLEFT
INC DH
CONVERT DH,Y,DI
HIGHLIGHT highlightcolor,DI,LEN
CHECKLEFT:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CHECK LEFT
MOV AL,Y
MOV BL , 8D
MUL BL
ADD AL, X 
MOV SI, ax  ;;;;; SI CONTAIN THE INDEX OF THE ROCK IN THE GRID 
MOV DL,X ; NOW DL CONTAIN TEH NUMBER OF CELLS ON THE RIGHT SIDE OF THE PIECE  DL = 7 - X 
MOV DH,X 
cmp dl,0    ; if there is no cells on the right side
jz CHECKUP
LOOP2:      ;;;; HIGHLIGHT THE CELLS TILL YOU FIND  A PIECE IN THE PATH
DEC SI
MOV AL , Grid[SI]
 CMP AL,00H
JNZ OUT2
DEC DH

CONVERT DH,Y,DI

HIGHLIGHT highlightcolor , DI ,LEN 
DEC dl
JNZ LOOP2
OUT2:
CMP DL,0
JZ  CHECKUP
MOV AL,Grid[SI]
CMP AL, 20H
JG CHECKUP
DEC DH
CONVERT DH,Y,DI
HIGHLIGHT highlightcolor,DI,LEN

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   CHECK  UP
 CHECKUP:
MOV AL,Y
MOV BL , 8D
MUL BL
ADD AL, X 
MOV SI, ax  ;;;;; SI CONTAIN THE INDEX OF THE ROCK IN THE GRID 
MOV DL,Y ; NOW DL CONTAIN TEH NUMBER OF CELLS ON THE RIGHT SIDE OF THE PIECE  DL = 7 - X 
MOV DH,Y 
cmp dl,0    ; if there is no cells on the right side
jz CHECKDOWN
LOOP3:      ;;;; HIGHLIGHT THE CELLS TILL YOU FIND  A PIECE IN THE PATH
SUB SI,8D
MOV AL , Grid[SI]
 CMP AL,00H
JNZ OUT3
DEC DH

CONVERT X,DH,DI

HIGHLIGHT highlightcolor , DI ,LEN 
DEC dl
JNZ LOOP3
OUT3:
CMP DL,0
JZ  CHECKDOWN
MOV AL,Grid[SI]
CMP AL, 20H
JG CHECKDOWN
DEC DH
CONVERT X,DH,DI
HIGHLIGHT highlightcolor,DI,LEN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHECKDOWN:
 MOV AL,Y
MOV BL , 8D
MUL BL
ADD AL, X 
MOV SI, ax  ;;;;; SI CONTAIN THE INDEX OF THE ROCK IN THE GRID 
MOV DL,7 ; NOW DL CONTAIN TEH NUMBER OF CELLS ON THE RIGHT SIDE OF THE PIECE  DL = 7 - X 
SUB DL,Y
MOV DH,Y 
cmp dl,0    ; if there is no cells on the right side
jz SKIP
LOOP4:      ;;;; HIGHLIGHT THE CELLS TILL YOU FIND  A PIECE IN THE PATH
ADD SI,8D
MOV AL , Grid[SI]
 CMP AL,00H
JNZ OUT4
INC DH

CONVERT X,DH,DI

HIGHLIGHT highlightcolor , DI ,LEN 
DEC dl
JNZ LOOP4
OUT4:
CMP DL,0
JZ  SKIP
MOV AL,Grid[SI]
CMP AL, 20H
JG SKIP
INC DH
CONVERT X,DH,DI
HIGHLIGHT highlightcolor,DI,LEN

SKIP:

 
ENDM PRINTROCK

PRINTBISHOP MACRO  X ,Y
LOCAL LOOP1 , OUT1 ,LOOP2 ,LOOP3,LOOP4, OUT2 ,OUT3,OUT4,CHECKUPLEFT,CHECKDOWNLEFT,CHECKDOWNRIGHT ,SKIP
MOV AL,Y
MOV BL , 8D
MUL BL
ADD AL, X 
MOV SI, ax
MOV DH ,X
MOV DL ,Y

;CHECK UP RIGHT DIAGONAL
LOOP1:
CMP DH,7D
JZ CHECKUPLEFT
CMP DL ,0D
JZ CHECKUPLEFT
INC DH
DEC DL
SUB SI,7
MOV AL, Grid[SI]
CMP AL,0
JNZ OUT1
CONVERT DH,DL,DI
HIGHLIGHT highlightcolor,DI,LEN
JMP LOOP1
OUT1:
CMP DH,7D
JG CHECKUPLEFT
CMP DL ,0D
JL CHECKUPLEFT
MOV AL, Grid[SI]
CMP AL,20H
JG CHECKUPLEFT
CONVERT DH,DL,DI
HIGHLIGHT highlightcolor,DI,LEN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHECKUPLEFT:
MOV AL,Y
MOV BL , 8D
MUL BL
ADD AL, X 
MOV SI, ax
MOV DH ,X
MOV DL ,Y
LOOP2:
CMP DH,0D
JZ CHECKDOWNLEFT
CMP DL ,0D
JZ CHECKDOWNLEFT
DEC DH
DEC DL
SUB SI,9
MOV AL, Grid[SI]
CMP AL,0
JNZ OUT2
CONVERT DH,DL,DI
HIGHLIGHT highlightcolor,DI,LEN
JMP LOOP2
OUT2:
CMP DH,0D
JL CHECKDOWNLEFT
CMP DL ,0D
JL CHECKDOWNLEFT
MOV AL, Grid[SI]
CMP AL,20H
JG CHECKDOWNLEFT
CONVERT DH,DL,DI
HIGHLIGHT highlightcolor,DI,LEN

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHECKDOWNLEFT:
MOV AL,Y
MOV BL , 8D
MUL BL
ADD AL, X 
MOV SI, ax
MOV DH ,X
MOV DL ,Y
LOOP3:
CMP DH,0D
JZ CHECKDOWNRIGHT
CMP DL ,7D
JZ CHECKDOWNRIGHT
DEC DH
INC DL
ADD SI,7
MOV AL, Grid[SI]
CMP AL,0
JNZ OUT3
CONVERT DH,DL,DI
HIGHLIGHT highlightcolor,DI,LEN
JMP LOOP3
OUT3:
CMP DH,0D
JL CHECKDOWNRIGHT
CMP DL ,7D
JG CHECKDOWNRIGHT
MOV AL, Grid[SI]
CMP AL,20H
JG CHECKDOWNRIGHT
CONVERT DH,DL,DI
HIGHLIGHT highlightcolor,DI,LEN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHECKDOWNRIGHT:
MOV AL,Y
MOV BL , 8D
MUL BL
ADD AL, X 
MOV SI, ax
MOV DH ,X
MOV DL ,Y
LOOP4:
CMP DH,7D
JZ SKIP
CMP DL ,7D
JZ SKIP
INC DH
INC DL
ADD SI,9
MOV AL, Grid[SI]
CMP AL,0
JNZ OUT4
CONVERT DH,DL,DI
HIGHLIGHT highlightcolor,DI,LEN
JMP LOOP4
OUT4:
CMP DH,7D
JG SKIP
CMP DL ,7D
JG SKIP
MOV AL, Grid[SI]
CMP AL,20H
JG SKIP
CONVERT DH,DL,DI
HIGHLIGHT highlightcolor,DI,LEN
SKIP:
ENDM PRINTBISHOP

DRAWTHEBACKGROUND MACRO
LOCAL LOOP4,LOOP3
  ;;STARTING POSITION
                        MOV                BP,0d
                        MOV                SI,8D
  LOOP4:                
                        MOV                DI,4D
  LOOP3:                
                        PRINTSQUARE        COLOR1 , BP , LEN
                        ADD                BP,WORD PTR LEN
                        PRINTSQUARE        COLOR2 , BP , LEN
                        ADD                BP,WORD PTR  LEN
                        DEC                DI
                        JNZ                LOOP3

          
                        MOV                AX, WORD PTR LEN
                        MOV                BX,320D
                        MUL                BX


                        MOV                CX,AX
                        MOV                BX ,8D
                        MOV                AX, WORD PTR LEN
                        MUL                BX
                        SUB                CX,AX
           


                        ADD                BP, CX
  ; FLIPING THE COLORS
                        MOV                AL,COLOR1
                        MOV                AH,COLOR2
                        MOV                COLOR1, AH
                        MOV                COLOR2 ,AL
                        DEC                SI
                        JNZ                LOOP4



ENDM DRAWTHEBACKGROUND

PRINTPAWN MACRO X , Y  
LOCAL SKIP,SKIP1,SKIP2,UNSKIP1,UNSKIP2,CHECKLD,CHECKRD,SKIP3,UNSKIP3

MOV AL,Y
MOV BL , 8D
MUL BL
ADD AL, X 
MOV SI, ax
SUB SI , 8
MOV AL, Grid[SI]
ADD SI,8
CMP AL,0
JNZ  SKIP1
MOV AL, Y
DEC AL
CMP AL,0
JL SKIP1
CONVERT X,AL,DI
HIGHLIGHT highlightcolor , DI, LEN
JMP  UNSKIP1
SKIP1:
JMP  CHECKRD
UNSKIP1:
MOV AL ,Y
CMP AL,6
JNZ  CHECKRD
SUB SI ,16
MOV AH,Grid[SI]
ADD SI,16
CMP AH,0
JNZ  CHECKRD
SUB AL ,2
CONVERT X ,AL ,DI
JMP UNSKIP2
SKIP2:
JMP SKIP3
UNSKIP2:
HIGHLIGHT highlightcolor , DI, LEN
CHECKRD:
;;CHECK IF THERE IS AN OPPONENT PIECE IN RIGHT DIAGONAL
MOV AL,Y
DEC AL
CMP AL,0
JL CHECKLD
MOV AH,X
INC AH
CMP AH,7
JA CHECKLD
SUB SI,7
MOV AH,Grid[SI]
ADD SI,7
CMP AH,0
JE CHECKLD
CMP AH,20H
JA CHECKLD
INC X
CONVERT  X ,AL ,DI
DEC X
HIGHLIGHT highlightcolor , DI, LEN
JMP UNSKIP3
SKIP3:
JMP SKIP
UNSKIP3:
;;CHECK IF THERE IS AN OPPONENT PIECE IN LEFT DIAGONAL
CHECKLD:
MOV AL,Y
DEC AL
CMP AL,0
JL SKIP
MOV AH,X
DEC AH
CMP AH,0
JL SKIP
SUB SI,9
MOV AH,Grid[SI]
ADD SI,9
CMP AH,0
JE SKIP
CMP AH,20H
JA SKIP
DEC X
CONVERT  X ,AL ,DI
INC X
HIGHLIGHT highlightcolor , DI, LEN


SKIP:
ENDM PRINTPAWN

PRINTKING MACRO X,Y
LOCAL CHECKENEMY,SKIP,CHECKENEMY1,SKIP1,CHECKENEMY2,SKIP2,CHECKENEMY3,SKIP3,CHECKENEMY4,SKIP4,CHECKENEMY5,SKIP5,CHECKENEMY6,SKIP6,CHECKENEMY7,SKIP7

MOV AL,Y
MOV BL , 8D
MUL BL
ADD AL, X 
MOV SI, ax 
INC SI ;right
MOV AL, GRID[SI]
dec si ;return
CMP AL,0D
JNZ CHECKENEMY
MOV DH,X
INC DH
cmp DH,7
Jg skip
CONVERT  DH,Y,DI
HIGHLIGHT highlightcolor,DI,LEN
jmp skip
CHECKENEMY:
CMP AL,20H
JG SKIP
; can eat
MOV DH,X
INC DH
cmp DH,7
Jg skip
CONVERT  DH,Y,DI
HIGHLIGHT highlightcolor,DI,LEN
SKIP:

sub si,8 ; up
mov dl, grid[si]
add si,8 ;return
cmp dl,0D
jnz CHECKENEMY1
MOV DH,Y
dec DH
cmp DH,0
jl skip1
CONVERT  X,DH,DI
HIGHLIGHT highlightcolor,DI,LEN
jmp skip1
CHECKENEMY1:
CMP dl,20H
JG SKIP1
; can eat
MOV DH,Y
dec DH
cmp DH,0
jl skip1
CONVERT  X,DH,DI
HIGHLIGHT highlightcolor,DI,LEN
SKIP1:

sub si,1 ; left
mov dl, grid[si]
add si,1 ;return
cmp dl,0D
jnz CHECKENEMY2
MOV DH,x
dec DH
cmp dh,0
jl skip2
CONVERT  DH,Y,DI
HIGHLIGHT highlightcolor,DI,LEN
jmp skip2
CHECKENEMY2:
CMP dl,20H
JG SKIP2
; can eat
MOV DH,x
dec DH
cmp dh,0
jl skip2
CONVERT  DH,Y,DI
HIGHLIGHT highlightcolor,DI,LEN
SKIP2:

add si,8 ; down
mov dl, grid[si]
sub si,8 ;return
cmp dl,0D
jnz CHECKENEMY3
MOV DH,Y
inc DH
cmp dh,7
jg skip3
CONVERT  X,DH,DI
HIGHLIGHT highlightcolor,DI,LEN
jmp skip3
CHECKENEMY3:
CMP dl,20H
JG SKIP3
; can eat
MOV DH,Y
inc DH
cmp dh,7
jg skip3
CONVERT  X,DH,DI
HIGHLIGHT highlightcolor,DI,LEN
SKIP3:

sub si,7 ; up right
mov dl, grid[si]
add si,7 ;return
cmp dl,0D
jnz CHECKENEMY4
MOV DH,Y
dec DH
cmp dh,0
jl skip4
mov dl,x
inc dl
cmp dl,7
jg skip4
CONVERT  dl,DH,DI
HIGHLIGHT highlightcolor,DI,LEN
jmp skip4
CHECKENEMY4:
CMP dl,20H
JG SKIP4
; can eat
MOV DH,Y
dec DH
cmp dh,0
jl skip4
mov dl,x
inc dl
cmp dl,7
jg skip4
CONVERT  dl,DH,DI
HIGHLIGHT highlightcolor,DI,LEN
SKIP4:

sub si,9 ; up left
mov dl, grid[si]
add si,9 ;return
cmp dl,0D
jnz CHECKENEMY5
MOV DH,Y
dec DH
cmp dh,0
jl skip5
mov dl,x
dec dl
cmp dl,0
jl skip5
CONVERT  dl,DH,DI
HIGHLIGHT highlightcolor,DI,LEN
jmp skip5
CHECKENEMY5:
CMP dl,20H
JG SKIP5
; can eat
MOV DH,Y
dec DH
cmp dh,0
jl skip5
mov dl,x
dec dl
cmp dl,0
jl skip5
CONVERT  dl,DH,DI
HIGHLIGHT highlightcolor,DI,LEN
SKIP5:

add si,9 ; down right
mov dl, grid[si]
sub si,9 ;return
cmp dl,0D
jnz CHECKENEMY6
MOV DH,Y
inc DH
cmp dh,7
jg skip6
mov dl,x
inc dl
cmp dl,7
jg skip6
CONVERT  dl,DH,DI
HIGHLIGHT highlightcolor,DI,LEN
jmp skip6
CHECKENEMY6:
CMP dl,20H
JG SKIP6
; can eat
MOV DH,Y
inc DH
cmp dh,7
jg skip6
mov dl,x
inc dl
cmp dl,7
jg skip6
CONVERT  dl,DH,DI
HIGHLIGHT highlightcolor,DI,LEN
SKIP6:

add si,7 ; down left
mov dl, grid[si]
sub si,7 ;return
cmp dl,0D
jnz CHECKENEMY7
MOV DH,Y
inc DH
cmp dh,7
jg skip7
mov dl,x
dec dl
cmp dl,0
jl skip7
CONVERT  dl,DH,DI
HIGHLIGHT highlightcolor,DI,LEN
jmp skip7
CHECKENEMY7:
CMP dl,20H
JG SKIP7
; can eat
MOV DH,Y
inc DH
cmp dh,7
jg skip7
mov dl,x
dec dl
cmp dl,0
jl skip7
CONVERT  dl,DH,DI
HIGHLIGHT highlightcolor,DI,LEN
SKIP7:


ENDM PRINTKING


CONVERT MACRO X ,Y , POS  ; by7wl x,y l location fel mem
LOCAL LOOP1
MOV CL,Y
MOV AX, 6400d
MOV BX,0
LOOP1: ADD BX , AX
DEC CL
JNZ LOOP1
MOV DI,BX
MOV AL,X
MOV BL,20D
MUL BL
ADD DI, AX
MOV POS,DI
  ENDM CONVERT

PRINTSQUARE MACRO COLOR ,POS , LENGTH  ;
  LOCAL LOOP1,LOOP2


MOV BX,POS
MOV CH,LENGTH
LOOP2:
MOV CL,LENGTH
LOOP1:
MOV AL,COLOR
MOV ES:[BX],AL
INC BX
DEC CL
JNZ LOOP1
SUB BX, WORD PTR LENGTH
ADD BX,320D
DEC CH
JNZ LOOP2

ENDM PRINTSQUARE 

HIGHLIGHT MACRO  COLOR ,POS , LENGTH       ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   LOCAL LOOP1,LOOP2 ,SKIP


MOV BX,POS
MOV CH,LENGTH
LOOP2:
MOV CL,LENGTH
LOOP1:
MOV AL,COLOR
MOV ah , ES:[BX]
CMP AH,89h
JZ SKIP
CMP AH,0bah
JZ SKIP
CMP AH,72h
JZ SKIP
CMP AH,71h
JZ SKIP
CMP AH,06h
JZ SKIP
CMP AH,0b9h
JZ SKIP
CMP AH,42h
JZ SKIP
CMP AH,59h
JZ SKIP
MOV ES:[BX],AL
SKIP:
INC BX
DEC CL
JNZ LOOP1
SUB BX, WORD PTR LENGTH
ADD BX,320D
DEC CH
JNZ LOOP2

       ENDM HIGHLIGHT

; PRINT ARRAY OF COLORS FOR 20*20 IMAGE  put the array offset in si then use it and position contain the first pixel offset( the top left )
printchar MACRO   POSISTION  
  LOCAL LOOP1,LOOP2 ,skip


MOV BX,POSISTION
MOV CH,20D
LOOP2:
MOV CL,20D
LOOP1:
MOV AL,[SI]
 cmp AL, 0ffh  ;ignore the background of the piece
jz skip
MOV ES:[BX],AL
 skip:
;  PUSHA
; MOV AH,86H
; MOV CX,0000H
; MOV DX,0001H
; INT 15H
; POPA
INC SI
INC BX
DEC CL
JNZ LOOP1
SUB BX, 20D
ADD BX,320D   
DEC CH
JNZ LOOP2
 ENDM printchar
; highlighting the  perimeter of the cell
HIGHLIGHTQ MACRO  COLOR , POS , LENGTH
LOCAL LOOP1,LOOP2 ,LOOP3
MOV BX,POS
MOV CH,LENGTH
LOOP1:
MOV AL,COLOR
MOV ES:[BX],AL
INC BX
DEC CH
JNZ LOOP1
SUB BX,word ptr LENGTH
MOV CH,LENGTH
LOOP2:
MOV AL,COLOR
MOV ES:[BX],AL
ADD BX, 19D       ; THE LENGTH -1
MOV ES:[BX],AL
SUB BX, 19D      ;THE LENGTH -1
ADD BX,320D
DEC CH
JNZ LOOP2

SUB BX, 320
MOV CH , LENGTH
LOOP3:
MOV AL,COLOR
MOV ES:[BX],AL
INC BX
DEC CH
JNZ LOOP3

  ENDM HIGHLIGHT_Q


unhighlightthegrid  MACRO 
  local     skip  ,loop1,loop2 ,skip2 , step , skipstep
  mov di,0    
  mov dh,8d
loop2:
  mov dl,4d
loop1:
  mov al , es:[di+322]
  cmp al,unhighlightcolor1
  jz skip
  HIGHLIGHT unhighlightcolor1 , di , LEN
  skip:  
  add di ,20d
  mov al , es:[di+322]
  jmp skipstep
  step: jmp loop2
  skipstep: 
   cmp al,unhighlightcolor2
  jz skip2
  HIGHLIGHT unhighlightcolor2 , di , LEN
  skip2:
  add di,20d
  dec dl
  jnz loop1
  mov bl,unhighlightcolor1
  mov bh, unhighlightcolor2
  mov unhighlightcolor1,bh
  mov unhighlightcolor2,bl
  sub di, 160d  
  add di, 6400d
  dec dh
  JNZ step


ENDM unhighlightthegrid

.model large
.386
.stack 64
.data
   
  ;Size: 20 x 20
  black_bishop         db 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,89h,89h,0bah,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,89h,0bah,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,89h,0bah,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,0bah,0bah,0bah,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
                       db 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,89h,89h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,89h,89h,89h,89h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,89h,89h,89h,89h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,89h,89h,89h,89h,89h,0bah,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
                       db 0ffh,0ffh,0ffh,0ffh,0ffh,0bah,89h,89h,89h,89h,0bah,0bah,0bah,0bah,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,0bah,0bah,0bah,0bah,0bah,0bah,89h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

  ;Size: 20 x 20
  black_king           db 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,72h,72h,72h,72h,72h,06h,72h,72h,72h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,72h,71h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,72h,72h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,71h,0bah,72h,72h,72h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,72h,89h,06h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0b9h,0bah,72h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,72h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
                       db 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,72h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,72h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,72h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,72h,06h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0b9h,0bah,72h,06h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,72h,89h,89h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,72h,89h,06h,89h,89h,06h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,72h,06h,06h,06h,06h,06h,72h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
                       db 0ffh,0ffh,0ffh,0ffh,0b9h,0b9h,72h,06h,72h,0bah,0bah,0bah,0bah,0bah,72h,72h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,0bah,71h,72h,71h,0bah,0bah,0bah,0bah,72h,89h,89h,06h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,72h,72h,06h,06h,06h,06h,06h,06h,06h,72h,72h,72h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
  ;Size: 20 x 20
  black_knight         db 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,89h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,06h,72h,0bah,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,06h,72h,72h,72h,72h,06h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,89h,06h,72h,72h,72h,72h,72h,71h,06h,0ffh,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,89h,0ffh,89h,72h,72h,06h,06h,72h,0bah,0bah,72h,06h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,89h,89h,72h,72h,72h,72h,06h,72h,71h,0bah,06h,0ffh,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,89h,89h,06h,72h,0bah,72h,06h,06h,72h,0bah,06h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,06h,06h,72h,0bah,0b9h,72h,06h,06h,72h,0bah,06h,89h,0ffh,0ffh,0ffh,0ffh
                       db 0ffh,0ffh,0ffh,0ffh,0bah,0bah,0bah,0ffh,0b9h,72h,06h,06h,72h,0bah,06h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,0bah,0ffh,0b9h,72h,06h,06h,72h,0bah,06h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0b9h,72h,06h,06h,72h,0bah,06h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,00h,0bah,72h,06h,06h,72h,0bah,72h,0b9h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0b9h,72h,06h,89h,89h,72h,0bah,0b9h,0ffh,0bah,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0ffh,0b9h,0bah,72h,89h,06h,72h,71h,06h,0ffh,0bah,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0ffh,0b9h,71h,72h,06h,06h,72h,0bah,72h,06h,0ffh,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,72h,06h,72h,72h,0bah,0bah,0bah,72h,06h,0ffh,0ffh,0ffh,0ffh,0ffh
                       db 0ffh,0ffh,0ffh,0ffh,0bah,0bah,0bah,71h,0bah,0b9h,0bah,0bah,0bah,72h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,72h,72h,72h,72h,72h,0bah,72h,06h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,72h,06h,06h,06h,72h,0b9h,72h,06h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

  ;Size: 20 x 20
  black_pawn           db 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,72h,72h,72h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,72h,72h,72h,72h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,0bah,72h,72h,72h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,0bah,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,72h,72h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,72h,72h,72h,72h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,0bah,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
                       db 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,89h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,89h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,89h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,89h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,89h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,89h,89h,89h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,89h,89h,89h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,89h,89h,89h,89h,89h,89h,89h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
                       db 0ffh,0ffh,0ffh,0bah,0bah,89h,89h,89h,89h,89h,89h,89h,89h,89h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,0bah,0bah,0bah,0bah,0bah,0bah,0bah,0bah,0bah,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,89h,89h,89h,89h,89h,89h,89h,89h,89h,0bah,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

  ;Size: 20 x 20
  black_queen          db 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,89h,89h,89h,0bah,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,89h,89h,89h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,89h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
                       db 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,89h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,0bah,89h,89h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,89h,89h,89h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,0bah,89h,89h,89h,89h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,89h,89h,89h,89h,89h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,89h,89h,89h,89h,89h,89h,0bah,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
                       db 0ffh,0ffh,0ffh,0ffh,0bah,0bah,0bah,89h,89h,0bah,0bah,0bah,0bah,0bah,89h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,89h,89h,89h,89h,89h,89h,89h,0bah,89h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

  ;Size: 20 x 20
  black_rock           db 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,89h,0ffh,0bah,89h,0ffh,0bah,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,89h,0bah,0bah,89h,0bah,0bah,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,89h,89h,89h,89h,89h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,0bah,0bah,0bah,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,0bah,0bah,0bah,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,0bah,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,89h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
                       db 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,89h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,89h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,89h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,89h,89h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,89h,89h,89h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,89h,89h,89h,89h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,89h,89h,89h,89h,89h,0bah,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,89h,89h,89h,89h,89h,0bah,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
                       db 0ffh,0ffh,0ffh,0ffh,0bah,0bah,0bah,89h,89h,0bah,0bah,0bah,0bah,0bah,89h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,0bah,0bah,0bah,0bah,0bah,0bah,0bah,89h,89h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0bah,0bah,89h,89h,89h,89h,89h,89h,89h,0bah,89h,89h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
  
  ;Size: 20 x 20
  white_bishop         db 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,42h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,42h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,42h,42h,42h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
                       db 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,59h,59h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,59h,59h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,59h,59h,59h,59h,42h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
                       db 0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,59h,59h,59h,42h,42h,42h,42h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,59h,59h,59h,59h,59h,59h,42h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

  ;Size: 20 x 20
  white_king           DB 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,42h,42h,59h,42h,42h,42h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,42h,59h,59h,59h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,42h,59h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,42h,42h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
                       db 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,42h,59h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,42h,59h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,42h,59h,59h,59h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,42h,42h,59h,59h,59h,59h,59h,59h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,59h,59h,59h,59h,59h,59h,59h,59h,59h,59h,0ffh,0ffh,0ffh,0ffh
                       db 0ffh,0ffh,0ffh,42h,42h,42h,59h,59h,59h,42h,42h,42h,42h,42h,42h,42h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,42h,42h,42h,42h,42h,42h,42h,42h,42h,59h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,59h,59h,59h,59h,59h,59h,59h,59h,59h,59h,42h,42h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
  ;Size: 20 x 20
  white_knight         db 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,59h,42h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,59h,42h,59h,42h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,59h,59h,59h,59h,59h,42h,42h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,59h,42h,59h,59h,59h,59h,42h,42h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,59h,59h,59h,59h,42h,59h,59h,59h,42h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,59h,59h,59h,42h,42h,59h,59h,59h,42h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh
                       db 0ffh,0ffh,0ffh,0ffh,42h,42h,0ffh,0ffh,42h,59h,59h,59h,42h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,59h,59h,42h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,59h,59h,42h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,59h,59h,42h,59h,42h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,59h,59h,59h,42h,42h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,59h,59h,59h,42h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,59h,59h,59h,42h,42h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,59h,59h,42h,42h,42h,42h,42h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
                       db 0ffh,0ffh,0ffh,0ffh,42h,42h,42h,42h,42h,42h,42h,42h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,59h,59h,59h,59h,42h,42h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

  ;Size: 20 x 20
  white_pawn           db 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,59h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,59h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,59h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,42h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,59h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,42h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
                       db 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,59h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,59h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,59h,59h,59h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,59h,59h,59h,59h,59h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
                       db 0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,42h,42h,42h,42h,42h,42h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,59h,59h,59h,59h,59h,59h,42h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh

  ;Size: 20 x 20
  white_queen          db 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,42h,42h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,59h,59h,42h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,59h,59h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
                       db 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,42h,59h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,59h,59h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
                       db 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,42h,59h,59h,59h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,59h,59h,59h,59h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,59h,59h,59h,59h,59h,42h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,42h,59h,59h,42h,42h,42h,42h,42h,59h,59h,0ffh,0ffh,0ffh,0ffh

  ;Size: 20 x 20
  white_rock           db 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,0ffh,42h,59h,0ffh,42h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,42h,42h,59h,42h,42h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,59h,59h,59h,59h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,42h,42h,42h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,42h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
                       db 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,59h,59h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,59h,59h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,59h,59h,59h,59h,59h,42h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,42h,59h,59h,42h,42h,42h,42h,42h,59h,59h,0ffh,0ffh,0ffh,0ffh
                       db 0ffh,0ffh,0ffh,0ffh,42h,42h,42h,42h,42h,42h,42h,42h,42h,59h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,42h,42h,59h,59h,59h,59h,59h,59h,59h,42h,59h,59h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh



  COLOR1               DB 0FH
  COLOR2               DB 00H
  highlightcolor       db 0Bh
  highlightcolor2      db 94h
  unhighlightcolor1    db 0FH
  unhighlightcolor2    db 00H
  LEN                  DB 20D
                       DB 00H
  STARTDRAWING         DW 0D
  X_POS                DB 0D
  Y_POS                DB 7D

  ;FOR WHITE FIRST NIBBLE 1 ,PAWN 2ND NIBBLE 1S
  Grid                 DB 12H,14H,13H,16H,15H,13H,14H,12H
                       DB 11H,11H,11H,11H,11H,11H,11H,11H
                       DB 0,0,0,0,0H,0,0,0
                       DB 0,0,0,0,0,0,0,0
                       DB 0H,00H,0H,0H,0H,0,0,0H
                       DB 00H,0H,00H,0H,0H,0H,00H,0H
                       DB 21H,21H,21H,21H,21H,21H,21H,21H
                       DB 22H,24H,23H,26H,25H,23H,24H,22H
  GRID2                DB 64 DUP(00h)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ;temp grid to store the grid from the other player
  GRID3                DB 12H,14H,13H,16H,15H,13H,14H,12H
                       DB 11H,11H,11H,11H,11H,11H,11H,11H
                       DB 0,0,0,0,0H,0,0,0
                       DB 0,0,0,0,0,0,0,0
                       DB 0H,00H,0H,0H,0H,0,0,0H
                       DB 00H,0H,00H,0H,0H,0H,00H,0H
                       DB 21H,21H,21H,21H,21H,21H,21H,21H
                       DB 22H,24H,23H,26H,25H,23H,24H,22H

  TIME                 DW 64 DUP(0000H)
  ;time                                                                                                                                                                                                                                                                                                                                                                                                                      ;temp grid to rotate the grid in it
  Q_x                  DB ?
  Q_y                  DB ?
  MAP_X                DW 00h,20D,40D,60D,80D,100D,120D,140D
  MAP_Y                DW 00H,6400D,12800D,19200D,25600D,32000D,38400D,44800D
  Q_IS_SET             DB 0D
  Q_highlight          db 04h
  MYCOLOR              DB 2h
  ;;;;;;1=white        2 =black
  TEMP_X               DB ?
  TEMP_Y               DB ?
  FIRST_INDEX          DB ?
  SECOND_INDEX         DB ?
  KING_INCHECK         DB 0D
  KING_X               DB 3D
  KING_Y               DB 7D
  mes1                 db 'Please enter your name : ',10,13,'   ','$'
  mes2                 db 'Press Enter Key to continue$'
  myusername           DB 15,?,15 DUP('$')
  enemyname            db 15 dup('$')
  mes3                 db 'To start chating press F1 $'
  mes4                 db 'To start the game press F2 $'
  mes5                 db 'To end the program press ESC $'
  keypressed           db 00h
  keyrecieved          db 00h
  mes6                 db 'You sent a chat invitation to $'
  mes7                 db 'You sent a game invitation to $'
  mes8                 db ' sent you  a chat invitation to accept press F1 $'
  mes9                 db ' sent you  a game invitation to accept press F2 $'
  line                 db 80 DUP('-'),'$'
  KING_IS_IN_CHECK     DB 'IN CHECK    $'
  KING_IS_NOT_IN_CHECK DB 'OUT OF CHECK$'
  STARTHOUR            DB 00H
  startmin             DB 00h
  startsec             DB 00H
  CURRHOUR             DB 00H
  CURRmin              DB 00h
  CURRsec              DB 00H
  STARTTIME            DW 00H
  CURRTIME             DW 00H
  DIGIT1               DB 00H,'$'
  DIGIT2               DB 00H,'$'
  TEMPTIME             DW 00H
  ENEMY_KILLED_POS     DW 0340H
  MY_KILLED_POS        DW 0D40H
  MYK                  DB 'MY KILLED PIECES:$'
  EYK                  DB 'ENEMY PIECES:$'
  TEMPTIMEBYTE         DB 00H
  WIN                  DB 'YOU WIN$'
  LOSE                 DB 'YOU LOSE$'
  GAME_ENDED           DB 0H
  str1                 db 'ME:$'
  str2                 db 'YOU:$'
  ME_X                 DB 0D
  ME_y                 DB 1D
  YOU_X                DB 0D
  YOU_Y                DB 12D
  VALUE                DB ?
  letter               DB ?
  me_inline_x          db 0d
  me_inline_y          db 21d
  you_inline_x         db 0d
  you_inline_y         db 23d
  spaces               db 40 dup(' '),'$'
  charpressed          db ?
.code
main proc far
                        mov                ax,@data
                        mov                ds,ax

                        MOV                DX,3FBH
                        MOV                AL,10000000B
                        OUT                DX,AL
     
     
     
                        MOV                DX,3F8H
                        MOV                AL,0CH
                        OUT                DX,AL
     
                        MOV                DX,3F9H
                        MOV                AL,00H
                        OUT                DX,AL
     
     
     
                        MOV                DX,3FBH                         ;Line Control Register Address
                        MOV                AL,00011011B                    ;Ready To Set Divisor Value
                        OUT                DX,AL
                        
                        mov                ax,3d
                        int                10h

                        mov                ah,9
                        mov                dx , offset mes1
                        int                21H

                        mov                ah,0Ah
                        mov                dx,offset myusername
                        int                21H


                        mov                ah,2d
                        mov                dx,1400h
                        int                10h

                        mov                ah,9
                        mov                dx , offset mes2
                        int                21H

  pressenter:           mov                ah,0H
                        int                16H
                        cmp                al,13d
                        jnz                pressenter
  ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                   
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  exchange the names
                        mov                al,myusername+1
                        mov                ah,0d
                        mov                si,ax
                        mov                al,'$'
                        mov                myusername[si+2],'$'
  ; recievefirst:
  ;                       mov                dx,03fdh
  ;                       IN                 AL,DX
  ;                       AND                AL,1D
  ;                       jz                 sendfirst
                         
  ;                       getenemyname
  ;                       sendname
  ;                       jmp                MAIN_MENU
  ; sendfirst:
  ; ; mov                dx,03fdh
  ; ; IN                 AL,DX
  ; ; AND                AL,00100000B
  ; ; jz                 recievefirst
  ;                       sendname
  ;                       getenemyname
             
  
 


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  MAIN_MENU:            
                        MOV                AL,0D
                        MOV                keypressed,AL
                        MOV                keyrecieved,AL
                        mov                al,2h
                        mov                MYCOLOR,al
                        mov                al,0d
                        mov                me_inline_x,0D
                        mov                you_inline_x,0D


                        mov                ax,3d

                        int                10h
                        MOV                BH,0D
                        mov                ah,2D
                        mov                dx,0515h
                        int                10h
 
                        mov                ah,9
                        mov                dx , offset mes3
                        int                21H

                        mov                ah,2d
                        mov                dx,0815h
                        int                10h
 
                        mov                ah,9
                        mov                dx , offset mes4
                        int                21H

                        mov                ah,2d
                        mov                dx,0b15h
                        int                10h
 
                        mov                ah,9
                        mov                dx , offset mes5
                        int                21H

                        mov                ah,2d
                        mov                dx,1500h
                        int                10h

                        mov                ah , 9
                        mov                dx ,offset line
                        int                21H
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; colors of the player must be chosen
  reciecveINVITAION:    
                        MOV                DX,3FDH
                        IN                 AL,DX
                        AND                AL,1
                        JZ                 SKIPRECIEVE

                        mov                dx , 03F8H
                        in                 al , dx

                        CMP                AL,1D
                        JZ                 ESCEND
                        PUSHA
                        sendname
                        getenemyname
                        POPA

                        MOV                keyrecieved,AL

                        
                         
                        cmp                al,3ch
                        jnz                checkchatinvitation
  gameinvitation:       
                         
                        mov                ah,2d
                        mov                dx,1700h
                        int                10h


                        mov                ah,9
                        mov                dx,offset enemyname
                        int                21h

                        mov                ah,9d
                        mov                dx,offset mes9
                        int                21H
                        jmp                SKIPRECIEVE
  checkchatinvitation:  
                        
                        mov                ah,2d
                        mov                dx,1700h
                        int                10h


                        mov                ah,9
                        mov                dx,offset enemyname
                        int                21h

                        mov                ah,9
                        mov                dx,offset mes8
                        int                21h
  ;;;;;;;HERH A MESSAGE SHOULD BE DISPLAYED TO THE USER

  SKIPRECIEVE:          
                        MOV                AH,1D
                        INT                16H
                        JZ                 reciecveINVITAION
         
                        MOV                keypressed,AH
                        
                       
                        
                        MOV                AH,0d
                        INT                16H

                        MOV                AH,keypressed

                        CMP                AH,1d                           ;;;;;; ESC BUTTON IS PRESSED
                        jz                 ESCBUTTONISPRESSED

                        
                        CMP                AH,3cH
                        JZ                 IFGAMEINVITAION

                        cmp                ah,3BH
                        jnz                SKIPRECIEVE
                        
                        MOV                AL,keyrecieved
                        CMP                AL,00
                        JZ                 SENDCHATINVITAION
  ; jnz                TRYSENDINGCHATACCEPT
                        jmp                TRYSENDINGCHATACCEPT
  ESCBUTTONISPRESSED:   
                        MOV                AL,keyrecieved
                        CMP                AL,1d
                        JZ                 SENDESC
                   
                   
  SENDESC:              
                        mov                dx,03fdh
                        IN                 AL,DX
                        AND                AL,00100000B
                        JZ                 SENDESC

                        MOV                AL,keypressed
                        MOV                DX,3F8H
                        OUT                DX,AL

                        JMP                ESCEND

  ;;;;;;SEND THE ACCEPT AND GO TO THE CHATIGN MODULE
  TRYSENDINGCHATACCEPT: 

                         
                        mov                dx,03fdh
                        IN                 AL,DX
                        AND                AL,00100000B
                        JZ                 TRYSENDINGCHATACCEPT
                          
                        MOV                DX,3F8H
                        MOV                AL,keypressed
                        OUT                DX,AL

                        mov                al,keyrecieved
                        CMP                AL,keypressed
                        jnz                MAIN_MENU


                        JMP                CHATING
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  IFGAMEINVITAION:      
  ;  cmp                AH,3ch
  ;                       jnz                SKIPRECIEVE

                     

                        MOV                AL,keyrecieved
                        CMP                AL,00H
                        JZ                 SENDGAMEINVITATION


                       

  ; MOV                AH,2
  ; MOV                DL,'6'
  ; INT                21H
  ;;;SEND THE ACCEPT AND START THE GAME
  TRYSENDING:           
                        mov                dx,03fdh
                        IN                 AL,DX
                        AND                AL,00100000B
                        JZ                 TRYSENDING
                          
                        MOV                DX,3F8H
                        MOV                AL,keypressed
                        OUT                DX,AL

                        mov                al,keyrecieved
                        CMP                AL,keypressed
                        jnz                MAIN_MENU

                        JMP                STARTTHEGAME




  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  SENDCHATINVITAION:    
  TRYSENDINGCHAT:       mov                dx,03fdh
                        IN                 AL,DX
                        AND                AL,00100000B
                        JZ                 TRYSENDINGCHAT
                          
                        MOV                DX,3F8H
                        MOV                AL,keypressed
                        OUT                DX,AL

                        getenemyname
                        sendname


                        mov                ah,2d
                        mov                dx,1700h
                        int                10H
                        mov                ah,9h
                        mov                dx,offset mes6
                        int                21h
                        mov                ah,9d
                        mov                dx, offset enemyname
                        int                21h



  WAITFORACCEPTFORCHAT: MOV                DX,3FDH
                        IN                 AL,DX
                        AND                AL,1
                        JZ                 WAITFORACCEPTFORCHAT

                        mov                dx , 03F8H
                        in                 al , dx
                        MOV                keyrecieved,AL
                        
                        
                        mov                al, keyrecieved
                        CMP                AL,keypressed
                        JZ                 CHATING

                        jmp                MAIN_MENU
  ;;;SEND AN INVITAION AND WAIT FOR THE ACCEPTION
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  SENDGAMEINVITATION:   
  ;;;
                        
                        MOV                AL,1D
                        MOV                MYCOLOR,1D
  ;; SEND AN INVITAION AND WAIT FOR THE ACCEPTION
  TRYSENDINGDI:         mov                dx,03fdh
                        IN                 AL,DX
                        AND                AL,00100000B
                        JZ                 TRYSENDINGDI
                          
                        MOV                DX,3F8H
                        MOV                AL,keypressed
                        OUT                DX,AL

                        getenemyname
                        sendname
                        
                        mov                ah,2d
                        mov                dx,1700h
                        int                10H
                        mov                ah,9h
                        mov                dx,offset mes7
                        int                21h
                        mov                ah,9d
                        mov                dx, offset enemyname
                        int                21h

  WAITFORACCEPT:        MOV                DX,3FDH
                        IN                 AL,DX
                        AND                AL,1
                        JZ                 WAITFORACCEPT

                        mov                dx , 03F8H
                        in                 al , dx
                        MOV                keyrecieved,AL
                        

                        
                        mov                al,keyrecieved
                        CMP                AL,keypressed
                        JZ                 STARTTHEGAME
                        jmp                MAIN_MENU
                       

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  CHATING:              
                        mov                ax,3D
                        int                10h
  ;;;;;;
                        mov                al,0D
                        mov                ME_X ,al
                        mov                YOU_X,AL
                        mov                al,1d
                        mov                ME_Y,al
                        mov                al,12D
                        mov                YOU_Y,al


                        MOV                AH,9
                        MOV                DX ,OFFSET myusername + 2
                        INT                21H
                       
                        mov                ah,2D
                        mov                dl,':'
                        int                21h
                       
                        mov                ah,2D
                        mov                dx,0B00h
                        int                10h
                        mov                ah,9d
                        mov                dx,offset line
                        INT                21H

                        MOV                DL,YOU_X
                        MOV                DH,YOU_Y
                        MOV                AH,2
                        INT                10H

                        MOV                DX ,OFFSET enemyname
                        MOV                AH,9
                        INT                21H

                        mov                ah,2
                        mov                dl,':'
                        int                21h
                        mov                al,0
                        add                YOU_X,0

                        inc                YOU_Y



  CheckBuffer:          
     
      
                        MOV                DX,3FDH
                        IN                 AL,DX
                        AND                AL,1
                        JNZ                RecieveMessage
     
                         
     
     
                        MOV                AH,1
                        INT                16H
                        JZ                 CheckBuffer

                        MOV                AH,0
                        INT                16H
                        mov                keypressed , AH
                        mov                VALUE,AL

                        MOV                DL,ME_X
                        MOV                DH,ME_y
                        MOV                AH,2
                        INT                10H

                        INC                ME_X
                        mov                dl,ME_X
                        cmp                dl,80d
                        jnz                skipednline
                        inc                ME_Y
                        mov                dl,0d
                        mov                ME_X,dl
  skipednline:          

                        
                        MOV                VALUE,AL
                        CMP                AL,13
                        JNZ                skipenter
                        INC                ME_y
                        MOV                AL,0D
                        MOV                ME_X,AL
  skipenter:            
                        mov                al,ME_Y
                        cmp                al,11D
                        jl                 SKIP123
                        PUSHA
                        mov                ah,6                            ; function 6
                        mov                al,1                            ; scroll by 1 line
                        mov                bh,7                            ; normal video attribute
  ;mov                bl,0d
                        mov                ch,1d                           ; upper left Y
                        mov                cl,0                            ; upper left X
                        mov                dh,10                           ; lower right Y
                        mov                dl,79                           ; lower right X
                        int                10h
                        POPA
                        mov                al,10D
                        mov                ME_Y,al

  SKIP123:              
                        MOV                AH,2
                        MOV                DL,VALUE
                        INT                21H



                        MOV                DX,3FDH                         ;Line Status Register Address

  CHECKSENDdd:          
                        IN                 AL,DX                           ;Get Line Status Byte In AL
                        AND                AL,00100000B                    ;Check IF THR Is Empty
                        JZ                 CHECKSENDdd                     ; Breaks When THR Is Empty
     
  ; When THR Is Empty You Are CLear To Send The Data
                        mov                al,keypressed
                        cmp                keypressed,3DH
                        jnz                skipreturn
                        mov                al,0FFh
                        mov                VALUE,al

  skipreturn:           MOV                DX,3F8H                         ;Line Control Register Address
                        MOV                AL,VALUE                        ;AL Holds The Value To Be Transmitted
                        OUT                DX,AL                           ;Send The Value Stored In AL

                        mov                al,keypressed
                        cmp                keypressed,3DH
                        jz                 MAIN_MENU

                        JMP                CheckBuffer


   

    
  RecieveMessage:       
    
  

                        mov                dx , 03F8H
                        in                 al , dx
                        MOV                VALUE,AL

                        cmp                al,0ffh
                        jz                 MAIN_MENU

                        MOV                DL,YOU_X
                        MOV                DH,YOU_Y
                        MOV                AH,2
                        INT                10H

                        INC                YOU_X

                        mov                dl,YOU_X
                        cmp                dl,80d
                        jnz                skipednlineyou
                        inc                YOU_Y
                        mov                dl,0d
                        mov                YOU_X,dl
  skipednlineyou:       

                        MOV                AL,VALUE
                        CMP                AL,13
                        JNZ                skipenteryou
                      
                        INC                YOU_Y
                        MOV                AL,0
                        MOV                YOU_X,AL
  skipenteryou:         
  ;;;;;;;;;;;;;;;;;;;;;;;;;;
                        mov                al,YOU_Y
                        cmp                al,25D
                        jl                 skip111
                        PUSHA
                        mov                ah,6                            ; function 6
                        mov                al,1                            ; scroll by 1 line
                        mov                bh,7                            ; normal video attribute
  ; mov                bl,0d
                        mov                ch,13d                          ; upper left Y
                        mov                cl,0                            ; upper left X
                        mov                dh,24                           ; lower right Y
                        mov                dl,79                           ; lower right X
                        int                10h
                        POPA
                        mov                al,24d
                        mov                YOU_Y,al
  SKIP111:              


                        mov                DL , VALUE
                        MOV                AH,2
                        INT                21H
     
                        JMP                CheckBuffer

  

                        JMP                CHATING


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  STARTTHEGAME:         
                        
                        MOV                AX,0D
                        MOV                STARTTIME,AX
                        MOV                CURRTIME,AX
                        mov                ah,0
                        mov                al,13h
                        int                10h
                         
                        mov                bh,0d
                        mov                ah,2D
                        mov                dx,1400h
                        int                10h
                        mov                ah,9
                        mov                dx,offset myusername + 2
                        int                21h
                       
                       
                        mov                ah,2
                        mov                dl,':'
                        int                21h

                        mov                bh,0d
                        mov                ah,2D
                        mov                dx,1600h
                        int                10h
                        mov                ah,9
                        mov                dx,offset enemyname
                        int                21h
                        mov                ah,2
                        mov                dl,':'
                        int                21h
                        
  ;;;;;;;;hrer we should choose which player has the white pieces
                        MOV                SI,0d
                        MOV                AL,0D
                        MOV                GAME_ENDED,AL
  BUILDTHEGRID:         
                        MOV                AL,GRID3[SI]
                        MOV                GRID[SI],AL
                        INC                SI
                        CMP                SI,64D
                        JNZ                BUILDTHEGRID
                        
                        mov                al,unhighlightcolor1
                        mov                COLOR1,al
                        mov                al,unhighlightcolor2
                        mov                COLOR2,al

                        MOV                AL,0D
                        MOV                X_POS,AL
                        MOV                AL,7D
                        MOV                Y_POS,AL

                        MOV                AL,MYCOLOR
                        CMP                AL,1H
                        JNZ                SKIPROTATE
                        ROTATE             GRID,GRID2
                        MOV                KING_X,4D
  SKIPROTATE:           
  
                        mov                ah,02ch
                        int                21H

                        MOV                STARTHOUR,CH
                        MOV                startmin,CL
                        MOV                startsec,DH
                        
                        CMP                CH,12
                        JL                 SKIPTIME
                        SUB                CH,12D
                        MOV                STARTHOUR,CH

  SKIPTIME:             MOV                AH,0D
                        MOV                AL,STARTHOUR
                        MOV                BX,3600
                        MUL                BX
                        ADD                STARTTIME,AX

                        MOV                AH,0D
                        MOV                AL,startmin
                        MOV                BL,60D
                        MUL                BL
                        ADD                STARTTIME,AX

                        MOV                AH,0D
                        MOV                AL,startsec
                        ADD                STARTTIME,AX


                        MOV                BH,0D
                        MOV                AH,2D
                        MOV                DX,0240H
                        INT                10h
                        MOV                AH,9h
                        MOV                DX,OFFSET EYK
                        INT                21H

                        MOV                BH,0D
                        MOV                AH,2D
                        MOV                DX,0C3EH
                        INT                10h
                        MOV                AH,9h
                        MOV                DX,OFFSET MYK
                        INT                21H

                        mov                bx,0A000H
                        MOV                ES,bx
                        DISPLAYCURRTIME

                        DRAWTHEBACKGROUND
                        PRINTTHEGRID

  ; mov                ah,6                             ; function 6
  ; mov                al,1                             ; scroll by 1 line
  ; mov                bh,7                             ; normal video attribute
  ; mov                ch,20                            ; upper left Y
  ; mov                cl,0                             ; upper left X
  ; mov                dh,20                            ; lower right Y
  ; mov                dl,79                            ; lower right X
  ; int                10h

                        DISPLAYCURRTIME

  ; ;;;;;  HIGHLIGHTING

                        MOV                BP,44800D
  highlightfirst:       HIGHLIGHT          highlightcolor,BP,LEN



                          
  CHECK:                DISPLAYCURRTIME
                        
  ;;;;;;;;HREE WE SHOULD CHECK IF DATA IS IN BUFFER
  CHECKDATAIN:          MOV                DX,3FDH
                        IN                 AL,DX
                        AND                AL,1
                        JZ                 CHEEKKEYPRESSED

                    
  GETDATA:              mov                dx , 03F8H
                        in                 al , dx
                        MOV                FIRST_INDEX,AL
 
                        cmp                al,0F4h
                        jz                 MAIN_MENU

                        cmp                al,0FFh
                        jnz                CHECKDATAIN2

  checkcharin:          MOV                DX,3FDH
                        IN                 AL,DX
                        AND                AL,1
                        JZ                 checkcharin

                        mov                dx , 03F8H
                        in                 al , dx
                        mov                bl,al
                        mov                bh,0
                        mov                ah,2D
                        mov                dl,you_inline_x
                        mov                dh,you_inline_y
                        int                10h

                        cmp                bl,13d
                        jz                 skipprintingyou
                        mov                ah,2D
                        mov                dl,bl
                        int                21h

                        inc                you_inline_x
                        mov                al,you_inline_x
                        cmp                al,40D
                        jz                 skipprintingyou
                        jmp                check
                                
  skipprintingyou:      
                        mov                bh,0d
                        mov                ah,2D
                        mov                dh,you_inline_y
                        mov                dl,0d
                        mov                you_inline_x,dl
                        int                10h

                        mov                ah,9h
                        mov                dx,OFFSET spaces
                        int                21h
                        jmp                CHECK

  CHECKDATAIN2:         MOV                DX,3FDH
                        IN                 AL,DX
                        AND                AL,1
                        JZ                 CHECKDATAIN2

                        mov                dx , 03F8H
                        in                 al , dx
                        MOV                SECOND_INDEX,AL
                        PUSH               BP

                        UPDATETHEGRID      FIRST_INDEX,SECOND_INDEX
                        unhighlightthegrid

                        ISINCHECK
                        mov                al,KING_INCHECK
                        cmp                al,1d
                        jnz                kingoutofcheck

                        mov                bh,00H
                        mov                ah,2D
                        mov                dx,1340h
                        int                10h

                        mov                ah,9
                        mov                DX,OFFSET KING_IS_IN_CHECK
                        int                21h
                        jmp                kingincheck
  kingoutofcheck:       
                        mov                bh,00H
                        mov                ah,2D
                        mov                dx,1340h
                        int                10h

                        mov                ah,9
                        mov                dX,OFFSET KING_IS_NOT_IN_CHECK
                        int                21h
  kingincheck:          pop                bp
                        mov                al,0d
                        mov                KING_INCHECK,al
                        CMP                AL,GAME_ENDED
                        JNZ                ENDPROGRAM
                        jmp                highlightfirst

                        
  CHEEKKEYPRESSED:      MOV                AL,0
                        MOV                AH,1
                        INT                16H
                        
                        JZ                 CHECK
 

  ; unhighlight the current cell
  ;       HIGHLIGHT   color2 ,BP, LEN
  ;swap color1 and color2
         
  
  ; EMPTY THE BUFFER
                        MOV                AH,00H
                        INT                16H
  CHECKD:               
                        CMP                AH,4dh                          ;check if d then check x_pos
                        JNZ                CHECKA
  ;;check if out of range or not
                        mov                ah,X_POS
                        cmp                ah,7D
                        jz                 CHECK
                        inc                X_POS
                        HIGHLIGHT          color2 ,BP, LEN
                        ADD                BP , word ptr len
                        jmp                skipcheck
  CHECKA:               
                        cmp                ah, 4bh
                        jnz                CHECKW
                        mov                ah,X_POS
                        cmp                ah,0D
                        jz                 CHECK
                        dec                X_POS
                        HIGHLIGHT          color2 ,BP, LEN
                        SUB                BP,WORD PTR LEN
                        jmp                skipcheck
  step2:                jmp                CHECK
  CHECKW:               
                        CMP                AH, 48h
                        JNZ                CHECKS
                        mov                ah,Y_POS
                        cmp                ah,0D
                        jz                 step2
                        dec                Y_POS
                        HIGHLIGHT          color2 ,BP, LEN
                        SUB                BP,6400D                        ; 320 * 20(LENGTH)
                        jmp                skipcheck
  
            
  
 
  
  CHECKS:               CMP                AH,50h
                        JNZ                checkF4
                        mov                ah,Y_POS
                        cmp                ah,7D
                        jz                 STEP
                        inc                Y_POS
                        HIGHLIGHT          color2 ,BP, LEN
                        ADD                BP ,6400d                       ;;320 * 20
                        jmp                skipcheck                       ;;;;;;;;;;;
  STEP:                 JMP                step2

  checkF4:              cmp                ah,3EH
                        jnz                CHECKQ

  CHECKSENDF4:          
                        mov                dx,03fdh
                        IN                 AL,DX                           ;Get Line Status Byte In AL
                        AND                AL,00100000B                    ;Check IF THR Is Empty
                        JZ                 CHECKSENDF4                     ; Breaks When THR Is Empty
  
                        MOV                DX,3F8H
                        mov                al,0F4h
                        OUT                DX,AL

                        jmp                MAIN_MENU

  CHECKQ:               
                        CMP                AH,35h
                        JNZ                checkword
                        MOV                AH, X_POS
                        MOV                Q_x,AH
                        MOV                AH,Y_POS
                        MOV                Q_y,AH
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        MOV                AL,Q_y
                        MOV                BL , 8D
                        MUL                BL
                        ADD                AL,Q_x
                        MOV                BL,2D
                        MUL                BL
                        MOV                SI, ax

                        mov                ah,02ch                         ;;;;;;;;;;
                        int                21H
                        MOV                TEMPTIMEBYTE,DH
                        CMP                CH,12D

                        JL                 SKIPSUB2
                        SUB                CH,12D
                       

  SKIPSUB2:             
                        MOV                BX,3600D
                        MOV                AL,CH
                        MOV                AH,0D
                        MOV                DX,0D
                        MUL                BX
                        MOV                TEMPTIME,AX

                        MOV                AL,CL
                        MOV                AH,0D
                        MOV                BL,60D
                        MUL                BL
                        ADD                TEMPTIME,AX

                        MOV                DL,TEMPTIMEBYTE
                        MOV                DH,0D
                        ADD                TEMPTIME,DX
                        MOV                AX,TEMPTIME


                        CMP                AX,TIME[SI]
                        JGE                SET_CHECKQ
                        HIGHLIGHT          04H,BP,LEN
                        JMP                STEP
  SET_CHECKQ:           INC                Q_IS_SET

  ;;;;;;;;;;;;;;;;; all avilable moves should be highlighted how i don't know
  CHECKQ_IS_SET:        
                        CMP                Q_IS_SET,0D
                        JZ                 STEP
                        jmp                printavailablemoves
           
  STEP4:                JMP                STEP

  checkword:            mov                bl,al
                        mov                charpressed,bl
                        mov                bh,0
                        mov                ah,2D
                        mov                dl,me_inline_x
                        mov                dh,me_inline_y
                        int                10h

                        cmp                bl,13d
                        jz                 skipprinting
                        mov                ah,2D
                        mov                dl,bl
                        int                21h

                        inc                me_inline_x
                        mov                al,me_inline_x
                        cmp                al,40D
                        jz                 skipprinting
                        jmp                sendletter
  skipprinting:         
                        mov                bh,0d
                        mov                ah,2D
                        mov                dh,me_inline_y
                        mov                dl,0d
                        mov                me_inline_x,dl
                        int                10h

                        mov                ah,9h
                        mov                dx,OFFSET spaces
                        int                21h
  sendletter:           
  ;;;;;;
  CHECKSENDlet:         
                        mov                dx,03fdh
                        IN                 AL,DX                           ;Get Line Status Byte In AL
                        AND                AL,00100000B                    ;Check IF THR Is Empty
                        JZ                 CHECKSENDlet                    ; Breaks When THR Is Empty
  
                        MOV                DX,3F8H
                        mov                al,0FFh
                        OUT                DX,AL

  CHECKSENDlet2:        
                        mov                dx,03fdh
                        IN                 AL,DX                           ;Get Line Status Byte In AL
                        AND                AL,00100000B                    ;Check IF THR Is Empty
                        JZ                 CHECKSENDlet2                   ; Breaks When THR Is Empty
  
                        MOV                DX,3F8H
                        mov                AL,charpressed
                        OUT                DX,AL

                        jmp                CHECK
  skipcheck:            
                        HIGHLIGHT          highlightcolor,BP, LEN

                        MOV                BL,COLOR1
                        MOV                BH,COLOR2
                        MOV                COLOR1, BH
                        MOV                COLOR2 ,BL
   
                        jmp                STEP4
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  printavailablemoves:  
                        MOV                AL,Q_y
                        MOV                BL , 8D
                        MUL                BL
                        ADD                AL,Q_x
                        MOV                AH,0
                        MOV                SI, ax
                
                        MOV                AL, Grid[SI]
                        CMP                AL,0H
                        JZ                 STEP                            ;;;;;;
                        CMP                AL,21H                          ;;;;;;IF THE PIECE PAWN (1)
                        JZ                 PAWNISFOUND
                        CMP                AL,22H                          ;;;;;;;;   IF THE PIECE ROCK (2)
                        JZ                 ROCKISFOUND
                        CMP                AL,23H
                        JZ                 BISHOPISFOUND
                        CMP                AL,24H
                        JZ                 KNIGHTISFOUND
                        CMP                AL,25H
                        JZ                 QUEENISFOUND
                        cmp                AL,26H
                        JZ                 KINGISFOUND
                        JMP                STEP4
  
  KNIGHTISFOUND:        PRINTKNIGHT        Q_X,Q_Y
                        JMP                HIGHLIGHT_CELL
                
  PAWNISFOUND:          PRINTPAWN          Q_x , Q_y
                        JMP                HIGHLIGHT_CELL
  ;;;;;;;; highlighting the cell with different way only the  perimeter is colored\
  ROCKISFOUND:          PRINTROCK          Q_x ,   Q_y
                        JMP                HIGHLIGHT_CELL
  BISHOPISFOUND:        PRINTBISHOP        Q_x,Q_y
                        JMP                HIGHLIGHT_CELL
  KINGISFOUND:          PRINTKING          Q_X,Q_Y
                        JMP                HIGHLIGHT_CELL

  QUEENISFOUND:         PRINTBISHOP        Q_x,Q_y
                        PRINTROCK          Q_x ,   Q_y
  HIGHLIGHT_CELL:       
                        HIGHLIGHTQ         Q_highlight  ,   BP   ,   LEN
  ;;;;HERE AFTER Q IS PRESSED THE PLAYER WILL CHO0SE  ONE OF THE AVAILABLE MOVES
  CHECKKEYPRESSEDAFTERQ:
                        DISPLAYCURRTIME

  CHECKDATAIN_Q:        MOV                DX,3FDH
                        IN                 AL,DX
                        AND                AL,1
                        JZ                 CHEEKKEYPRESSED_Q

                    
  GETDATA_Q:            mov                dx , 03F8H
                        in                 al , dx
                        MOV                FIRST_INDEX,AL

                        cmp                al,0F4h
                        jz                 MAIN_MENU

                        cmp                al,0FFh
                        jnz                CHECKDATAIN2_Q

  checkcharinq:         MOV                DX,3FDH
                        IN                 AL,DX
                        AND                AL,1
                        JZ                 checkcharinq

                        mov                dx , 03F8H
                        in                 al , dx
                        mov                bl,al
                        mov                bh,0
                        mov                ah,2D
                        mov                dl,you_inline_x
                        mov                dh,you_inline_y
                        int                10h

                        cmp                bl,13d
                        jz                 skipprintingyouq
                        mov                ah,2D
                        mov                dl,bl
                        int                21h

                        inc                you_inline_x
                        mov                al,you_inline_x
                        cmp                al,40D
                        jz                 skipprintingyouq
                        jmp                CHECKKEYPRESSEDAFTERQ
                                
  skipprintingyouq:     
                        mov                bh,0d
                        mov                ah,2D
                        mov                dh,you_inline_y
                        mov                dl,0d
                        mov                you_inline_x,dl
                        int                10h

                        mov                ah,9h
                        mov                dx,OFFSET spaces
                        int                21h
                        jmp                CHECKKEYPRESSEDAFTERQ
 
  CHECKDATAIN2_Q:       MOV                DX,3FDH
                        IN                 AL,DX
                        AND                AL,1
                        JZ                 CHECKDATAIN2_Q

                        mov                dx , 03F8H
                        in                 al , dx
                        MOV                SECOND_INDEX,AL
                        PUSH               BP

                        UPDATETHEGRID      FIRST_INDEX,SECOND_INDEX
                        unhighlightthegrid
                        POP                BP
                        HIGHLIGHT          highlightcolor,BP,LEN
                        
                        ISINCHECK
                        mov                al,KING_INCHECK
                        cmp                al,1d
                        jnz                kingoutofcheck_Q

                        mov                bh,00H
                        mov                ah,2D
                        mov                dx,1340h
                        int                10h

                        mov                ah,9
                        mov                DX,OFFSET KING_IS_IN_CHECK
                        int                21h
                        jmp                kingincheck_Q
  kingoutofcheck_Q:     
                        mov                bh,00H
                        mov                ah,2D
                        mov                dx,1340h
                        int                10h

                        mov                ah,9
                        mov                dX,OFFSET KING_IS_NOT_IN_CHECK
                        int                21h
  kingincheck_Q:        
                        mov                al,0d
                        mov                KING_INCHECK,al
                   
                        JMP                printavailablemoves
                        

  CHEEKKEYPRESSED_Q:    MOV                AL,0
                        MOV                AH,1
                        INT                16H

                        JZ                 CHECKKEYPRESSEDAFTERQ
                
 
         
  
  ; EMPTY THE BUFFER
                        MOV                AH,00H
                        INT                16H
  CHECKD_Q:             
                        CMP                AH,4dh                          ;check if d then check x_pos
                        JNZ                CHECKA_Q
  ;;check if out of range or not
                        mov                ah,X_POS
                        cmp                ah,7D
                        jz                 CHECKKEYPRESSEDAFTERQ
                        inc                X_POS
                      
                        HIGHLIGHTQ         es:[BP+321] ,BP, LEN            ;;;; unhighlighting the previous cell
                        ADD                BP , word ptr len
                        jmp                skipcheck_Q
  CHECKA_Q:             
                        cmp                ah, 4bh
                        jnz                CHECKW_Q
                        mov                ah,X_POS
                        cmp                ah,0D
                        jz                 CHECKKEYPRESSEDAFTERQ
                        dec                X_POS
                        HIGHLIGHTQ         es:[BP+321] ,BP, LEN
                        SUB                BP,WORD PTR LEN
                        jmp                skipcheck_Q
  step2_Q:              jmp                CHECKKEYPRESSEDAFTERQ
  CHECKW_Q:             
                        CMP                AH, 48h
                        JNZ                CHECKS_Q
                        mov                ah,Y_POS
                        cmp                ah,0D
                        jz                 step2_Q
                        dec                Y_POS
                        HIGHLIGHTQ         es:[BP+321] ,BP, LEN
                        SUB                BP,6400D                        ; 320 * 20(LENGTH)
                        jmp                skipcheck_Q
  
  

  CHECKS_Q:             CMP                AH,50h
                        JNZ                checkF4Q
                        mov                ah,Y_POS
                        cmp                ah,7D
                        jz                 STEP_Q
                        inc                Y_POS
                        HIGHLIGHTQ         es:[BP+321] ,BP, LEN            ;;; unhighlighting the previous cell
                        ADD                BP ,6400d                       ;;320 * 20
                        jmp                skipcheck_Q                     ;;;;;;;;;;;
  STEP_Q:               JMP                step2_Q

  checkF4Q:             cmp                ah,3EH
                        jnz                checkwordq
  CHECKSENDF4Q:         
                        mov                dx,03fdh
                        IN                 AL,DX                           ;Get Line Status Byte In AL
                        AND                AL,00100000B                    ;Check IF THR Is Empty
                        JZ                 CHECKSENDF4Q                    ; Breaks When THR Is Empty
  
                        MOV                DX,3F8H
                        mov                al,0F4h
                        OUT                DX,AL

                        jmp                MAIN_MENU

  checkwordq:           cmp                ah,35h
                        jz                 checkQ_Q
                        mov                bl,al
                        mov                charpressed,bl
                        mov                bh,0
                        mov                ah,2D
                        mov                dl,me_inline_x
                        mov                dh,me_inline_y
                        int                10h

                        cmp                bl,13d
                        jz                 skipprintingq
                        mov                ah,2D
                        mov                dl,bl
                        int                21h

                        inc                me_inline_x
                        mov                al,me_inline_x
                        cmp                al,40D
                        jz                 skipprintingq
                        jmp                sendletterq
  skipprintingq:        
                        mov                bh,0d
                        mov                ah,2D
                        mov                dh,me_inline_y
                        mov                dl,0d
                        mov                me_inline_x,dl
                        int                10h

                        mov                ah,9h
                        mov                dx,OFFSET spaces
                        int                21h
  sendletterq:          
  ;;;;;;
  CHECKSENDletq:        
                        mov                dx,03fdh
                        IN                 AL,DX                           ;Get Line Status Byte In AL
                        AND                AL,00100000B                    ;Check IF THR Is Empty
                        JZ                 CHECKSENDletq                   ; Breaks When THR Is Empty
  
                        MOV                DX,3F8H
                        mov                al,0FFh
                        OUT                DX,AL

  CHECKSENDlet2q:       
                        mov                dx,03fdh
                        IN                 AL,DX                           ;Get Line Status Byte In AL
                        AND                AL,00100000B                    ;Check IF THR Is Empty
                        JZ                 CHECKSENDlet2q                  ; Breaks When THR Is Empty
  
                        MOV                DX,3F8H
                        mov                AL,charpressed
                        OUT                DX,AL

                        jmp                CHECKKEYPRESSEDAFTERQ
  
  CHECKQ_Q:             
                        CMP                AH,35h
                        JNZ                STEP_Q
  ; HERE WE SHOULD CHECK IF THE CHOSEN CELL IS AN AVAILABLE MOVE
                        MOV                AL , ES:[BP+321]
                        CMP                AL, highlightcolor
                        JNZ                SKIPMOVMENT
                        MOV                AL , X_POS
                        CMP                AL,Q_X
                        JNZ                VALIDCHANGE
                        MOV                AL,Y_POS
                        CMP                AL,Q_Y
                        JZ                 SKIPMOVMENT
  VALIDCHANGE:          MOVE               Q_X,Q_Y,X_POS,Y_POS             ;;the movment code
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        MOV                AL,Q_Y
                        MOV                BL , 8D
                        MUL                BL
                        ADD                AL,Q_X
                        MOV                BL,2D
                        MUL                BL
                        MOV                SI, ax
                        MOV                TIME[SI],0D
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        MOV                AL,Y_POS
                        MOV                BL , 8D
                        MUL                BL
                        ADD                AL,X_POS
                        MOV                BL,2D
                        MUL                BL
                        MOV                SI, ax
                        
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        mov                ah,02ch
                        int                21H
                        MOV                TEMPTIMEBYTE,DH
                        CMP                CH,12D
                        JL                 SKIPSUB
                        SUB                CH,12D
                       

  SKIPSUB:              
                        MOV                BX,3600D
                        MOV                AL,CH
                        MOV                AH,0D
                        MOV                DX,0D
                        MUL                BX
                        MOV                TEMPTIME,AX

                        MOV                AL,CL
                        MOV                AH,0D
                        MOV                BL,60D
                        MUL                BL
                        ADD                TEMPTIME,AX

                        MOV                DL,TEMPTIMEBYTE
                        MOV                DH,0D
                        ADD                TEMPTIME,DX
                        MOV                AX,TEMPTIME
                        ADD                AX,3D
                        MOV                TIME[SI],AX                     ;;;;;;UPDATING THE TIME OF EACH PIECE


                        MOV                SI,0
  CHECKSEND:            
                        mov                dx,03fdh
                        IN                 AL,DX                           ;Get Line Status Byte In AL
                        AND                AL,00100000B                    ;Check IF THR Is Empty
                        JZ                 CHECKSEND                       ; Breaks When THR Is Empty
     
  ; When THR Is Empty You Are CLear To Send The Data
                        

  SENDAGAIN:            
                        MOV                AL,Q_y
                        MOV                AH ,0D
                        MOV                BL,8D
                        MUL                BL
                        ADD                AL,Q_X                          ;AL Holds The Value To Be Transmitted
                          
                        MOV                DX,3F8H                         ;Line Control Register Address
                        OUT                DX,AL                           ;Send The Value Stored In AL
  CHECKSEND2:           
                        mov                dx,03fdh
                        IN                 AL,DX                           ;Get Line Status Byte In AL
                        AND                AL,00100000B                    ;Check IF THR Is Empty
                        JZ                 CHECKSEND2

                        MOV                AL,Y_POS
                        MOV                AH ,0D
                        MOV                BL,8D
                        MUL                BL
                        ADD                AL,X_POS
                        MOV                DX,3F8H                         ;Line Control Register Address
                        OUT                DX,AL

                        ISINCHECK
                        mov                al,KING_INCHECK
                        cmp                al,1d
                        jnz                kingoutofcheck2

                        mov                bh,00H
                        mov                ah,2D
                        mov                dx,1340h
                        int                10h

                        mov                ah,9
                        mov                dX,OFFSET KING_IS_IN_CHECK
                        int                21h
                        JMP                SKIPMOVMENT
  kingoutofcheck2:      
                        mov                bh,00H
                        mov                ah,2D
                        mov                dx,1340h
                        int                10h

                        mov                ah,9
                        mov                dX,OFFSET KING_IS_NOT_IN_CHECK
                        int                21h

                       
                      
  SKIPMOVMENT:          unhighlightthegrid
                        MOV                AL,0D
                        MOV                KING_INCHECK,AL
                        CMP                AL,GAME_ENDED
                        JNZ                ENDPROGRAM
  ; checking every cell on the gred  ;;;;;;;; unhighlighting the highlighted cells
                       
  
  RESET_Q_Q:            DEC                Q_IS_SET
                        jmp                highlightfirst
  STEP4_Q:              JMP                STEP_Q
  skipcheck_Q:          
                        HIGHLIGHTQ         Q_highlight,BP, LEN             ;;;;;;MUST BE CHANEGED

                        MOV                BL,COLOR1
                        MOV                BH,COLOR2
                        MOV                COLOR1, BH
                        MOV                COLOR2 ,BL
                        JMP                STEP4_Q


  ENDPROGRAM:           
                       
                        MOV                AH,0D
                        INT                16H

                        CMP                AH,3EH
                        JNZ                ENDPROGRAM
                        JMP                MAIN_MENU
                        
  ESCEND:               MOV                AX,3H
                        INT                10h
                        

                        HLT
                  
main endp
end main



