section .data
    prompt db "Enter your string: ", 0
    prompt_len equ $ - prompt
    
    result db "Reversed: ", 0
    result_len equ $ - result
    
    newline db 10

section .bss
    buffer resb 256          ; буфер для ввода строки
    reversed resb 256        ; буфер для развернутой строки

section .text
    global _start

_start:
    ; === ВЫВОД ПРИГЛАШЕНИЯ ДЛЯ ВВОДА ===
    mov rax, 1               ; системный вызов write
    mov rdi, 1               ; stdout
    mov rsi, prompt          ; указатель на строку
    mov rdx, prompt_len      ; длина строки
    syscall

    ; === ЧТЕНИЕ СТРОКИ С КЛАВИАТУРЫ ===
    mov rax, 0               ; системный вызов read
    mov rdi, 0               ; stdin
    mov rsi, buffer          ; буфер для ввода
    mov rdx, 256             ; максимальная длина
    syscall

    ; В rax теперь длина введенной строки (включая \n)
    mov r8, rax              ; сохраняем длину строки
    dec r8                   ; уменьшаем на 1 (убираем \n)

    ; === РАЗВОРОТ СТРОКИ ===
    mov rcx, r8              ; счетчик = длина строки
    mov rsi, buffer          ; источник - начало исходной строки
    mov rdi, reversed        ; приемник - буфер для развернутой строки
    add rsi, r8              ; перемещаемся в конец исходной строки
    dec rsi                  ; корректируем позицию (последний символ перед \n)

reverse_loop:
    ; Копируем символ из конца в начало новой строки
    mov al, [rsi]            ; берем символ из конца исходной строки
    mov [rdi], al            ; записываем в начало новой строки
    
    ; Двигаем указатели
    dec rsi                  ; двигаемся к началу исходной строки
    inc rdi                  ; двигаемся к концу новой строки
    
    ; Проверяем конец цикла
    loop reverse_loop

    ; Добавляем символ новой строки в конец развернутой строки
    mov byte [rdi], 10

    ; === ВЫВОД РЕЗУЛЬТАТА ===
    ; Сначала выводим "Reversed: "
    mov rax, 1               ; write
    mov rdi, 1               ; stdout
    mov rsi, result          ; "Reversed: "
    mov rdx, result_len      ; длина
    syscall

    ; Затем выводим развернутую строку
    mov rax, 1               ; write
    mov rdi, 1               ; stdout
    mov rsi, reversed        ; развернутая строка
    mov rdx, r8              ; длина (без \n)
    syscall

    ; И выводим символ новой строки
    mov rax, 1               ; write
    mov rdi, 1               ; stdout
    mov rsi, newline         ; \n
    mov rdx, 1               ; длина
    syscall

    ; === ЗАВЕРШЕНИЕ ПРОГРАММЫ ===
    mov rax, 60              ; системный вызов exit
    xor rdi, rdi             ; код возврата 0
    syscall
