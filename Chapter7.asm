assume cs:code

data  segment
        db '1975','1976','1977','1978','1979','1980','1981','1982'
        db '1983','1984','1985','1986','1987','1988','1989','1990'
        db '1991','1992','1993','1994','1995'

        dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
        dd 345980,590827,803530,1183000,1843000,2759000,3743000,4649000,5937000

        dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
        dw 11542,14430,15257,17800

data ends
table segment

        db 21 dup ('year summ ne ?? ')

table ends
stack segment
       db 16 dup (0)
stack ends
code segment

start: mov ax,data
       mov ds,ax
       mov ax,table
       mov es,ax
       mov ax,stack
       mov ss,ax
       mov sp,16D

       mov bx,0
       mov cx,21D
       mov si,0
       mov di,0
       mov bp,0

     s:mov ax,ds:[bp]
       mov es:[bx],ax
       add bx,2
       add bp,2
       mov ax,ds:[bp]
       mov es:[bx],ax
       add bx,2
       add bp,2


       mov byte ptr es:[bx],0              
       inc bx

       mov ax,ds:[di+84D]   
       mov es:[bx],ax
       add bx,2
       add di,2
       mov dx,ds:[di+84D]
       mov es:[bx],dx
       add bx,2
       add di,2

       mov byte ptr es:[bx],0              
       inc bx

       push ds:[si+168D]
       pop es:[bx]
       add bx,2
  
       mov byte ptr es:[bx],0              
       inc bx

       div word ptr ds:[si+168D]       

       mov word ptr es:[bx],ax
       add bx,2
       add si,2
       mov byte ptr es:[bx],0
       inc bx

       loop s

       mov ax,4c00H
       int 21H

code ends

end start
