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
    DIV BH                  ; AL = cociente, AH = residuo

    ; ----------------------------
    ; Mostrar resultado
    ; ----------------------------
    LEA DX, msgR
    MOV AH, 09H
    INT 21H

    ; Si el cociente es mayor o igual a 10, mostramos los dos dígitos.
    MOV DL, AL
    CMP DL, 10
    JGE dos_digitos

    ; Si el cociente es menor que 10, solo mostramos un dígito.
    ADD DL, '0'             ; Convertir a ASCII
    MOV AH, 02H
    INT 21H
    JMP fin

dos_digitos:
    ; Si el cociente es mayor o igual a 10, mostramos los dos dígitos.
    MOV AH, 0              ; Limpiar AH (porque vamos a usar AL y AH)
    MOV BL, 10
    DIV BL                  ; AL = decena, AH = unidad

    ADD AL, '0'             ; Convertir decena a ASCII
    MOV DL, AL
    MOV AH, 02H
    INT 21H

    ADD AH, '0'             ; Convertir unidad a ASCII
    MOV DL, AH
    MOV AH, 02H
    INT 21H

fin:
    MOV AH, 4CH
    INT 21H

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