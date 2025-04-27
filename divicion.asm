.MODEL SMALL
.STACK 100H

.DATA
    msg1    DB "Ingrese el dividendo (00-99): $"
    msg2    DB 13,10, "Ingrese el divisor (01-99): $"
    msgR    DB 13,10, "El resultado de la division es: $"
    msgErr  DB 13,10, "Error: division por cero no permitida.$"
    result  DB 2 DUP(?)     ; Para guardar decena y unidad

.CODE
MAIN:
    MOV AX, @DATA
    MOV DS, AX

    ; ----------------------------
    ; Leer primer número (dividendo)
    ; ----------------------------
    LEA DX, msg1
    MOV AH, 09H
    INT 21H

    CALL leer_dos_digitos
    MOV BL, AL              ; Guardar dividendo en BL

    ; ----------------------------
    ; Leer segundo número (divisor)
    ; ----------------------------
    LEA DX, msg2
    MOV AH, 09H
    INT 21H

    CALL leer_dos_digitos
    CMP AL, 0
    JE division_cero        ; Si divisor es cero, error
    MOV BH, AL              ; Guardar divisor en BH

    ; ----------------------------
    ; Realizar división
    ; ----------------------------
    MOV AL, BL              ; AL = dividendo
    XOR AH, AH              ; Preparar AX para DIV
    DIV BH                  ; AL = resultado, AH = residuo

    ; Convertir resultado a ASCII
    XOR AH, AH
    MOV BL, 10
    DIV BL                  ; AL = decena, AH = unidad

    MOV result[0], AL
    MOV result[1], AH
    ADD result[0], '0'
    ADD result[1], '0'

    ; ----------------------------
    ; Mostrar resultado
    ; ----------------------------
    LEA DX, msgR
    MOV AH, 09H
    INT 21H

    MOV DL, result[0]
    CMP DL, '0'
    JE solo_unidad
    MOV AH, 02H
    INT 21H

solo_unidad:
    MOV DL, result[1]
    MOV AH, 02H
    INT 21H

    JMP fin

; ----------------------------
; División por cero
; ----------------------------
division_cero:
    LEA DX, msgErr
    MOV AH, 09H
    INT 21H

fin:
    MOV AH, 4CH
    INT 21H

; --------------------------------------------------
; Leer dos dígitos del teclado (00 a 99)
; Devuelve número en AL
leer_dos_digitos:
    ; Leer primer dígito (decena)
    MOV AH, 01H
    INT 21H
    SUB AL, '0'
    MOV AH, AL

    ; Leer segundo dígito (unidad)
    MOV AH, 01H
    INT 21H
    SUB AL, '0'

    ; Calcular número total: (decena * 10) + unidad
    MOV BL, 10
    MUL BL         ; AX = decena * 10
    ADD AL, AH     ; AL = resultado final
    RET

END MAIN