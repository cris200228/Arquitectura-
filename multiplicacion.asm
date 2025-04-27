.MODEL SMALL
.STACK 100H

.DATA
    msg1    DB "Ingrese el primer digito: $"
    msg2    DB 13,10, "Ingrese el segundo digito: $"
    msgR    DB 13,10, "El resultado de la multiplicacion es: $"

.CODE
MAIN:
    MOV AX, @DATA
    MOV DS, AX

    ; Mostrar mensaje para el primer dígito
    LEA DX, msg1
    MOV AH, 09H
    INT 21H

    CALL leer_digito
    MOV BL, AL          ; Guardar primer número (0-9)

    ; Mostrar mensaje para el segundo dígito
    LEA DX, msg2
    MOV AH, 09H
    INT 21H

    CALL leer_digito
    MOV BH, AL          ; Guardar segundo número (0-9)

    ; ==============================================
    ; SECCIÓN CORREGIDA: Multiplicación y manejo del resultado
    ; Error original: XOR AH, AH después de MUL (borraba parte del resultado)
    ; Corrección: Usar AX completo para la multiplicación
    MOV AL, BL
    MUL BH              ; AX = AL * BH (resultado de 8x8 bits en AX)
    ; ==============================================

    ; Convertir el resultado (AX) a dígitos ASCII
    MOV BL, 10
    DIV BL              ; AH = residuo (unidades), AL = cociente (decenas)
    
    ADD AH, '0'         ; Convertir unidades a ASCII
    MOV CL, AH          ; Guardar unidades en CL
    
    ADD AL, '0'         ; Convertir decenas a ASCII
    MOV CH, AL          ; Guardar decenas en CH

    ; Mostrar mensaje del resultado
    LEA DX, msgR
    MOV AH, 09H
    INT 21H

    ; ==============================================
    ; SECCIÓN CORREGIDA: Mostrar dígitos en orden correcto
    ; Error original: Mostraba unidades primero y decenas después
    ; Error original: La comparación estaba con AL (decenas) pero el JE saltaba a mostrar unidades
    ; Corrección: Mostrar decenas primero (si no son cero) y luego unidades
    CMP CH, '0'         ; Comparar decenas con '0'
    JE mostrar_unidad    ; Si es cero, saltar a mostrar solo unidades
    MOV DL, CH           ; Mostrar decenas
    MOV AH, 02H
    INT 21H

mostrar_unidad:
    MOV DL, CL           ; Mostrar unidades
    MOV AH, 02H
    INT 21H
    ; ==============================================

    ; Terminar programa (esto faltaba en el original)
    MOV AH, 4CH
    INT 21H

; --------------------------------------------------
; Rutina para leer solo dígitos válidos (0-9)
leer_digito:
    MOV AH, 01H
    INT 21H
    CMP AL, '0'
    JB leer_digito      ; Si es menor que '0', volver a leer
    CMP AL, '9'
    JA leer_digito      ; Si es mayor que '9', volver a leer
    SUB AL, '0'         ; Convertir ASCII a valor numérico
    RET

END MAIN