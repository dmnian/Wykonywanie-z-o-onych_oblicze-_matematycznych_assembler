
JMP start

DB 3
;DB 00


ORG 3; prodecdura wyliczajaca symbol newtona AL to n a BL to k, wynik w CL
MOV CL, 1 ; wynik

MOV DL, 1 ; iterator

for:
	CMP BL, DL ; i<=k zamieniam na k>=i, i skacze dopiero jesli jest ujemna flaga
	JS za_for
	PUSH AL
	SUB AL, DL ; n - i
	ADD AL, 1 ; n- i +1
	MUL CL, AL ; wynik *= n- i + 1
	DIV CL, DL ; wynik *= (n- i + 1)/i
	POP AL
	INC DL ;i++

JMP for
za_for:

;wynik w CL;
IRET


;MOV CL, 4
IRET

;ORG 22
ORG 24 ; procedura do wprowadzania liczb - do BL
	MOV BL, 0
	wprowadz_cyfre:
	IN 00 ; podaje liczbe
	CMP AL, 0D ; sprawdzam czy wprowadzona liczba jest eneterem
	JZ wyjdz_cyfra
	SUB AL, 30 ; przetwarzam znak ASCII na cyfre
	MUL BL, A ; mnoze poprzednia cyfre tak aby znalaza sie rzad wyzej
	ADD BL, AL ; dodaje cyfre do liczby

JMP wprowadz_cyfre

wyjdz_cyfra:
RET

;ORG 38
ORG 3A
	JNO nie_przepelnione	;sprawdzam czy nie wprowadzono zbyt wielkiej liczby
	MOV AL, 10
	OUT 01
	HALT
	nie_przepelnione:
;	MOV AL, 20
;	OUT 01
	RET

start:

OUT  01

CALL 24 ; wywolanie procedury do wprowadzania liczby b
CALL 3A ; sprawdzanie czy nie ma przepelnienia


PUSH BL
POP AL
MUL BL, AL ;podnosze b do 3 
MUL BL, AL

CALL 3A ; sprawdzanie czy nie przepelnione

PUSH BL

CALL 24 ; wywolanie procedury do wprowadzania liczby a
CALL 3A

PUSH BL
POP CL
POP AL
PUSH CL ; wrzucam a na stos w celu pozniejszego wykrzystania
MUL CL,CL

ADD AL, CL ; dodaje b^3 + a^2
PUSH AL

MOV AL, 4 ; wprowadzanie danych do obliczenia symbolu newtona
MOV BL, 3
INT 02 ; przerwanie

PUSH CL; wrzucam wynik symbolu na stos 


CALL 24 ; wywolanie procedury do wprowadzania liczby c

PUSH BL 
CMP BL, 0 ; sprwadzam czy nie ma dzielenia przez 0
;MOV AL, 20  ; zielone
JNZ swiatla
MOV AL, 80 ;czerwone
OUT 01
HALT
swiatla:


POP AL

MOV BL, 2

PUSH AL
DIV BL, AL ; 2/c
POP CL
MUL AL, AL
MUL AL, CL ; c^3

PUSH AL

CALL 3A ; sprawdzam czy nie przepelnione

POP AL

ADD AL, BL; 2/c + c^3
MUL AL, 3; (2/c + c^3)*3 ; wynik

POP BL ;zdejmuje symbol
DIV BL, AL ; symbol /wynik

POP AL ; zdejmuje b^3 + a^2 ; 
POP DL; zdejmuje a ze stosu

MUL BL, DL; od symbolu do *a
DIV BL, 4 ; wynik/4

MOV CL, 17

SUB AL, BL ;  b^3 + a^2  minus dwumian do a/4

SUB AL, CL

END