.MODEL SMALL
.STACK 100H

.DATA
    msg1    DB "Ingrese el primer digito: $"
    msg2    DB 13,10, "Ingrese el segundo digito: $"
    msgR    DB 13,10, "La suma es: $"
    result  DB 2 DUP(?)    ; Para guardar decena y unidad

.CODE
MAIN:
    MOV AX, @DATA
    MOV DS, AX

    ; Mostrar mensaje 1
    LEA DX, msg1
    MOV AH, 09H
    INT 21H

    ; Leer primer dígito
    MOV AH, 01H
    INT 21H
    SUB AL, '0'         ; Convertir ASCII a número
    MOV BL, AL          ; Guardar en BL

    ; Mostrar mensaje 2
    LEA DX, msg2
    MOV AH, 09H
    INT 21H

    ; Leer segundo dígito
    MOV AH, 01H
    INT 21H
    SUB AL, '0'         ; Convertir ASCII a número
    ADD AL, BL          ; Sumar

    ; Convertir resultado a ASCII (decena y unidad)
    XOR AH, AH
    MOV BL, 10
    DIV BL              ; AL = cociente (decena), AH = residuo (unidad)

    MOV result[0], AL
    MOV result[1], AH

    ADD result[0], '0'  ; Decena a ASCII
    ADD result[1], '0'  ; Unidad a ASCII

    ; Mostrar mensaje
    LEA DX, msgR
    MOV AH, 09H
    INT 21H

    ; Mostrar decena solo si no es '0'
    MOV DL, result[0]
    CMP DL, '0'
    JE solo_unidad
    MOV AH, 02H
    INT 21H

solo_unidad:
    MOV DL, result[1]
    MOV AH, 02H
    INT 21H

    ; Finalizar programa
    MOV AH, 4CH
    INT 21H

END MAIN