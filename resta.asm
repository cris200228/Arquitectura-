.MODEL SMALL
.STACK 100H

.DATA
    msg1    DB "Ingrese el primer digito: $"
    msg2    DB 13,10, "Ingrese el segundo digito: $"
    msgR    DB 13,10, "La resta es: $"
    signo   DB '-'
    result  DB 2 DUP(?)    ; Decena y unidad

.CODE
MAIN:
    MOV AX, @DATA
    MOV DS, AX

    ; Mostrar mensaje 1
    LEA DX, msg1
    MOV AH, 09H
    INT 21H

    CALL leer_digito
    MOV BL, AL          ; Guardar primer número

    ; Mostrar mensaje 2
    LEA DX, msg2
    MOV AH, 09H
    INT 21H

    CALL leer_digito
    MOV BH, AL          ; Guardar segundo número

    ; Realizar la resta
    MOV AL, BL
    SUB AL, BH          ; AL = BL - BH

    ; Verificar signo negativo
    MOV CX, 0
    JNS continuar
    NEG AL              ; Si es negativo, hacerlo positivo
    MOV CX, 1           ; CX = 1 si fue negativo

continuar:
    ; Convertir número a decenas y unidades
    XOR AH, AH          ; Preparar para división de 8 bits
    MOV BL, 10
    DIV BL              ; AL = cociente (decena), AH = residuo (unidad)

    MOV result[0], AL
    MOV result[1], AH

    ADD result[0], '0'  ; Convertir a ASCII
    ADD result[1], '0'

    ; Mostrar mensaje
    LEA DX, msgR
    MOV AH, 09H
    INT 21H

    ; Mostrar signo si negativo
    CMP CX, 1
    JNE sin_signo
    MOV DL, signo
    MOV AH, 02H
    INT 21H

sin_signo:
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

    ; Finalizar
    MOV AH, 4CH
    INT 21H

; --------------------------------------------------
; Rutina para leer solo dígitos válidos (0–9)
; Devuelve valor numérico (0–9) en AL
leer_digito:
    MOV AH, 01H
    INT 21H
    CMP AL, '0'
    JB leer_digito      ; Si es menor que '0', repetir
    CMP AL, '9'
    JA leer_digito      ; Si es mayor que '9', repetir
    SUB AL, '0'         ; Convertir a número
    RET

END MAIN