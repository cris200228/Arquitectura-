.MODEL SMALL
.STACK 100H

.DATA
    msg1    DB "Ingrese el dividendo (00-99): $"
    msg2    DB 13,10, "Ingrese el divisor (01-99): $"
    msgR    DB 13,10, "El cociente es: $"
    msgRes  DB 13,10, "El residuo es: $"
    msgErr  DB 13,10, "Error: division por cero o entrada invalida.$"
    newline DB 13,10,"$"
    
    dividendo DB ?
    divisor   DB ?
    cociente  DB ?
    residuo   DB ?

.CODE
MAIN:
    MOV AX, @DATA
    MOV DS, AX

    ; --- Pedir dividendo ---
    LEA DX, msg1
    CALL mostrar_mensaje
    CALL leer_numero
    CMP AL, 0FFH      ; Si hay error (AL=0FFH)
    JE error_input
    MOV dividendo, AL

    ; --- Pedir divisor ---
    LEA DX, msg2
    CALL mostrar_mensaje
    CALL leer_numero
    CMP AL, 0FFH      ; Si hay error (AL=0FFH)
    JE error_input
    CMP AL, 0         ; Divisor = 0?
    JE error_input
    MOV divisor, AL

    ; --- Realizar división ---
    MOV AL, dividendo
    XOR AH, AH        ; Limpia AH (AX = AL)
    DIV divisor       ; AX / divisor → AL=cociente, AH=residuo
    MOV cociente, AL
    MOV residuo, AH

    ; --- Mostrar resultados ---
    LEA DX, msgR
    CALL mostrar_mensaje
    MOV AL, cociente
    CALL imprimir_numero

    LEA DX, msgRes
    CALL mostrar_mensaje
    MOV AL, residuo
    CALL imprimir_numero

    JMP fin

error_input:
    LEA DX, msgErr
    CALL mostrar_mensaje

fin:
    MOV AH, 4CH
    INT 21H

; ====== Funciones ======

mostrar_mensaje PROC
    MOV AH, 09H
    INT 21H
    RET
mostrar_mensaje ENDP

leer_numero PROC
    ; Retorna en AL el número leído (0-99) o 0FFH si hay error

    ; Leer primer carácter
    MOV AH, 01H
    INT 21H
    CMP AL, 13          ; Enter directamente = error
    JE invalido
    CMP AL, '0'
    JB invalido
    CMP AL, '9'
    JA invalido
    SUB AL, '0'
    MOV BL, AL          ; BL = primer dígito

    ; Leer siguiente carácter
    MOV AH, 01H
    INT 21H
    CMP AL, 13          ; Si es Enter, solo un dígito
    JE solo_uno
    CMP AL, '0'
    JB invalido
    CMP AL, '9'
    JA invalido
    SUB AL, '0'         ; AL = segundo dígito
    MOV BH, AL          ; BH = segundo dígito
    MOV AL, BL
    MOV BL, 10
    MUL BL              ; AL = primer_digito * 10
    ADD AL, BH          ; AL = número final
    RET

solo_uno:
    MOV AL, BL          ; Solo un dígito ingresado
    RET

invalido:
    MOV AL, 0FFH        ; Valor de error
    RET
leer_numero ENDP

imprimir_numero PROC
    ; Imprime AL (00-99) sin ceros a la izquierda
    XOR AH, AH
    MOV BL, 10
    DIV BL           ; AL = decena, AH = unidad

    CMP AL, 0
    JE solo_unidad
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02H
    INT 21H

solo_unidad:
    MOV AL, AH
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    RET
imprimir_numero ENDP

END MAIN