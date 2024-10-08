/*
 * Программа ввода кодов цифровых символов в буфер в ОП
 */

.include "my-macro"
    
.bss
    .lcomm buf, 100 # 100 байтовый буфер для кодов прочитанных символов
    .lcomm c, 1    # однобайтовый буфер для чтения байта из файла stdin

.text
.global _start

_start:
    sub    %esi, %esi     # указатель адреса байта в буфере buf (индексный регистр)

show_prompt:
    Puts "Вводите цифру, друг мой!"     # макровызов вывода строки в
                    # файл stdout (подсказка ввода)

kbd_input:
    Getchar $c          # макровызов ввода байта из stdin в
            # промежуточный буфер c

    cmpl $0, %eax     # наступило событие EOF (конец файла stdin) ?
    je stop        # Да - на завершение программы

    cmpb $'\n', c     # это символ перевода строки ?
    je input     # ДА - на ввод следующего символа
    cmpb $'9', c      # код больше кода символа '9' ?
    ja print_err_msg    # ДА - на вывод сообщения об ошибке
    cmpb $'0', c    # код меньше кода символа '0' ?
    jb print_err_msg    # ДА - на вывод сообщения об ошибке

    movb c, %al         # передать код символа цифры из c в al

    cmpl $100, %esi
    je print_end_buffer
    
    movb %al, buf(%esi) # передать код символаx цифры из al в байт
            # буфера по адресу &buf + esi
    incl %esi        # указать на следующий байт буфера для
            # следующего кода

    Puts "Цифра! Хорошо." # сообщения об успехе вводе

    jmp show_prompt    # на ввод следующего символа

print_err_msg:
    Puts "Не цифровая клавиша. Повторите ввод"    # вывод сообщения об ошибке
    jmp show_prompt     # на ввод следующего символа

input:
    movl %esi,%ebx # копируем %esi в %ebx
    decl %ebx # уменьшаем на один, чтобы в счетчики было верное значение
    cmpl $0, %ebx # сравниваем %ebd c 0
    jl kbd_input # переход на начало
    movb buf(%ebx), %al # копируем buf %ebx в %al
    subb $48, %al # вычитаем 48
    jmp kbd_input # переход на начло

print_end_buffer:
    Puts "Буффер переполене"
    jmp stop

stop:
    Exit $0

.end
