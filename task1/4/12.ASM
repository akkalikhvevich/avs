;В этом примере не понял почему возникла ошибка в файле kernel32.dll
format PE console
entry start
include         'C:\Users\Андрей\Desktop\fasm\INCLUDE\win32a.inc'
include 'C:\Users\Андрей\Desktop\fasm\INCLUDE\equates\kernel32.inc'
include 'C:\Users\Андрей\Desktop\fasm\INCLUDE\MACRO\import32.inc'
;include 'include\macro\import.inc'
section '.data' data readable writeable
  h4    db Консоль'
  w1 dd 0
  output dd 0
  input dd 0
  _class db 'FCAPTION',0
  podskazka db 'Консоль',0
section '.code' code readable executable
  start:
        invoke    GetStdHandle,STD_OUTPUT_HANDLE
        mov       [output],eax
        invoke    GetStdHandle,STD_INPUT_HANDLE
        mov       [input],eax
        invoke    WriteConsole,[output],h4,7,w1,0
        invoke    ReadConsole,[input],_class,2,w1,0
        invoke  ExitProcess,0
section '.idata' import data readable

  _library kernel32,'KERNEL32.DLL',\
             user32,'USER32.DLL',\
             gdi32,'GDI32.DLL',\
             advapi32,'ADVAPI32.DLL',\
             comctl32,'COMCTL32.DLL',\
             comdlg32,'COMDLG32.DLL',\
             shell32,'SHELL32.DLL',\
             wsock32,'WSOCK32.DLL';,\
     include 'C:\Users\Андрей\Desktop\fasm\INCLUDE\API\kernel32.inc'
     include 'C:\Users\Андрей\Desktop\fasm\INCLUDE\API\user32.inc'
     include 'C:\Users\Андрей\Desktop\fasm\INCLUDE\API\gdi32.inc'
     include 'C:\Users\Андрей\Desktop\fasm\INCLUDE\API\advapi32.inc'
     include 'C:\Users\Андрей\Desktop\fasm\INCLUDE\API\comctl32.inc'
     include 'C:\Users\Андрей\Desktop\fasm\INCLUDE\API\comdlg32.inc'
     include 'C:\Users\Андрей\Desktop\fasm\INCLUDE\API\shell32.inc'
     include 'C:\Users\Андрей\Desktop\fasm\INCLUDE\API\wsock32.inc'