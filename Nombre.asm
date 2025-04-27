.MODEL SMALL
.STACK 100H

.DATA
    msgNombre    DB "Ingrese su nombre completo: $"
    msgCedula    DB 13,10, "Ingrese su numero de cedula: $"
    saludo       DB 13,10, "Hola, $"
    cedulaText   DB 13,10, "Su numero de cedula es: $"

    ; Buffers para entrada de nombre y cedula (formato función 0Ah)
    nombre      DB 50         ; Longitud máxima de entrada (sin contar CR)
    nombreLen   DB ?          ; Longitud real ingresada
    nombreStr   DB 50 DUP(?)  ; Buffer de caracteres

    cedula      DB 20
    cedulaLen   DB ?
    cedulaStr   DB 20 DUP(?)

.CODE
MAIN:
    MOV AX, @DATA
    MOV DS, AX

    ; -----------------------------
    ; Solicitar nombre
    ; -----------------------------
    LEA DX, msgNombre
    MOV AH, 09H
    INT 21H

    ; Preparar buffer
    MOV nombre, 49
    LEA DX, nombre
    MOV AH, 0AH
    INT 21H

    ; -----------------------------
    ; Solicitar cédula
    ; -----------------------------
    LEA DX, msgCedula
    MOV AH, 09H
    INT 21H

    ; Preparar buffer
    MOV cedula, 19
    LEA DX, cedula
    MOV AH, 0AH
    INT 21H

    ; -----------------------------
    ; Mostrar saludo y nombre
    ; -----------------------------
    LEA DX, saludo
    MOV AH, 09H
    INT 21H

    MOV CX, 0
    MOV CL, nombreLen
    LEA SI, nombreStr

print_nombre:
    MOV DL, [SI]
    MOV AH, 02H
    INT 21H
    INC SI
    LOOP print_nombre

    ; Salto de línea
    MOV DL, 13
    MOV AH, 02H
    INT 21H
    MOV DL, 10
    INT 21H

    ; -----------------------------
    ; Mostrar cédula
    ; -----------------------------
    LEA DX, cedulaText
    MOV AH, 09H
    INT 21H

    MOV CX, 0
    MOV CL, cedulaLen
    LEA SI, cedulaStr

print_cedula:
    MOV DL, [SI]
    MOV AH, 02H
    INT 21H
    INC SI
    LOOP print_cedula

    ; Finalizar
    MOV AH, 4CH
    INT 21H

END MAIN