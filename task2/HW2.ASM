format PE console
entry start

include 'win32a.inc'

;условие Разработать программу, которая вводит одномерный массив A[N],
;формирует из элементов массива А, массив В по правилам из таблицы.
;Память под массивы может выделиться статически или динамически.
;Разбить решение на функции следующим образом:
;Ввод и вывод массивов оформить как подпрограммы
;Выполнение задания по вариант оформить как процедуру
;Организовать вывод исходного и полученного массивов
;Вариант номер 9 - массив В из нечетных элементов.

;test1: любой текст
;test2: 1
;test3: 13
;test4: 210
;test5: 3 {1, 3, 4}
;test6: 5 {1, 1, 1, 1, 1}
;test7: 6 {44, 19, 54, 33,235, 132}
;test8: массив на 100 чисел
;test9: массив на 400 чисел (превышает допустимое)

;--------------------------------------------------------------------------------------

section '.data' data readable writable

        strArrSize     db 'Input size of array (300 >= x > 0): ', 0
        strIncorSize   db 'Incorrect size of array = %d', 10, 0
        strArrElemI    db 'arr[%d]: ', 0
        strScanInt     db '%d', 0
        strArrElemOut db 'arr[%d] = %d', 10, 0
        strArrNewElemOut db 'new_arr[%d] = %d', 10, 0
        strPrevOutArr  db 'Old_Array:', 10, 0
        strPrevNewOutArr  db 'New_Array:', 10, 0
        strNewLine     db 10, 0
        strNANSize     db 'The size of the array must be a positive integer', 0
        strNANElem     db 'The element of array must be a integer', 10, 0

        arr_size     dd 0
        sep          db 2
        i            dd ?
        tmpb         dd ?
        tmpd         dd ?
        tmpStack     dd ?                     ы
        arr          rd 300
        new_arr      rd 300
        new_arr_size dd 0
;--------------------------------------------------------------------------------------

section '.code' code readable executable
start:
; 1) array input
        call ArrayInput
; 2) crete new array
        call GetNewArray
; 3) arrays output
        push strNewLine
        call [printf]
        push strPrevOutArr
        call [printf]
        call FirstArrayOutput
         push strNewLine
        call [printf]
        push strPrevNewOutArr
        call [printf]
        call SecondArrayOutput

finish:
        call [getch]

        push 0
        call [ExitProcess]

;--------------------------------------------------------------------------------------
ArrayInput:
        mov [tmpStack], esp
        push strArrSize
        call [printf]

        push arr_size
        push strScanInt
        call [scanf]
        cmp eax , 0
        je failGetNumberToSize

        push strNewLine
        call [printf]


        mov eax, [arr_size]
        cmp eax, 0
        jle  failSize
        cmp eax, 300
        jle getArray

failSize:
        push [arr_size]
        push strIncorSize
        call [printf]

        call [getch]

        push 0
        call [ExitProcess]
failGetNumberToSize:
        push strNANSize
        call [printf]

        call [getch]
        
        push 0
        call [ExitProcess]

getArray:
        xor ecx, ecx            
        mov ebx, arr         
getArrLoop:
        mov [tmpb], ebx
        cmp ecx, [arr_size]
        jge endInputArray       

        mov [i], ecx
        push ecx
        push strArrElemI
        call [printf]

        push ebx
        push strScanInt
        call [scanf]
        cmp eax , 0
        je failGetNumberToSize


        mov ecx, [i]
        inc ecx
        mov ebx, [tmpb]
        add ebx, 4
        jmp getArrLoop
failGetNumberToArr:
        push strNANElem
        call [printf]

        call [getch]
        
        push 0
        call [ExitProcess]

endInputArray:
        mov esp, [tmpStack]
        ret
;--------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------
;intialize new array
GetNewArray:
        xor ecx, ecx
        mov ebx, arr
        mov edx, new_arr
newArrayLoop:
        cmp ecx, [arr_size]       
        je endGetNewArray

        mov eax, [ebx] 
        div [sep]
        cmp ah, 0 
        jz nextStep

        mov eax, [ebx]
        mov [edx], eax
        add edx, 4
        add [new_arr_size], 1

nextStep:
        add ebx, 4
        inc ecx
        jmp newArrayLoop
endGetNewArray:
        ret
;--------------------------------------------------------------------------------------
;output arrays
FirstArrayOutput:
        mov [tmpStack], esp
        xor ecx, ecx            
        mov ebx, arr
putFArrLoop:
        mov [tmpb], ebx
        cmp ecx, [arr_size]
        je endOutputFArray
        mov [i], ecx
   
        push dword [ebx]
        push ecx
        push strArrElemOut
        call [printf]

        mov ecx, [i]
        inc ecx
        mov ebx, [tmpb]
        add ebx, 4

        jmp putFArrLoop
endOutputFArray:
        mov esp, [tmpStack]
        ret

 SecondArrayOutput:
        mov [tmpStack], esp
        xor ecx, ecx            
        mov ebx, new_arr
putArrLoop:
        mov [tmpb], ebx
        cmp ecx, [new_arr_size]
        je endOutputArray
        mov [i], ecx
   
        push dword [ebx]
        push ecx
        push strArrNewElemOut
        call [printf]

        mov ecx, [i]
        inc ecx
        mov ebx, [tmpb]
        add ebx, 4

        jmp putArrLoop
endOutputArray:
        mov esp, [tmpStack]
        ret
;--------------------------------------------------------------------------------------
                                                 
section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll',\
            user32,'USER32.DLL'

include 'api\user32.inc'
include 'api\kernel32.inc'
    import kernel,\
           ExitProcess, 'ExitProcess',\
           HeapCreate,'HeapCreate',\
           HeapAlloc,'HeapAlloc'
  include 'api\kernel32.inc'
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'