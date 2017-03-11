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

 main: mov ax,data
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
	   
	   
    ;*******to show them on Screen******

     mov ax,table
     mov ds,ax
     mov cx,21D
     mov si,0
     mov dh,4
     mov dl,0

    year:
     push cx
     mov cl,4D   ; color set
     call show_str
     add dh,1
     add si,10H

     pop cx
     loop year

    mov ax,table
    mov es,ax
    mov ax,data
    mov ds,ax
    mov di,0
    mov si,0
    mov cx,21D

  dataTranslate:  ;后三列的数字转化为字符串格式 存在ds:si 指向的地方 
    mov ax,es:[di+5]
    mov dx,es:[di+7]
    call dtocdw
    add si,8      ;为方便输出，每个数据存储长度为8 最大数据为7bit  

    mov ax,es:[di+10]
    mov dx,0
    call dtocdw
    add si,8

    mov ax,es:[di+13]
    mov dx,0
    call dtocdw
    add si,8

    add di,10H
    loop dataTranslate

     mov cx,21D
     mov si,0
     mov dh,4
     mov dl,10
    
  dataDisplay:
     push cx

     mov cl,7D

     mov dl,26D
     call show_str

     mov dl,50D
     add si,8
     call show_str

     mov dl,70D
     add si,8
     call show_str

     add si,8
     inc dh

     pop cx

   loop dataDisplay

     mov ax,4c00H
     int 21H

    show_str:
      push ax
      push bx
      push cx
      push dx
      push es
      push ds
      push si
      push di

      mov ah,0
      mov al,160D
      mul dh
      mov bx,ax
      mov ah,0
      mov al,2D
      mul dl
	  add ax,bx
      mov dx,0B800H
      mov es,dx
      mov di,ax
      mov al,cl

      s_show:
        mov cl,ds:[si]
        mov ch,0
        jcxz ok_show
        mov ah,ds:[si]
        mov es:[di],ah
        inc di
        mov es:[di],al
        inc di
        add si,1

        loop s_show

      ok_show:
        mov bx,si    ;return bx to count the str's length
        pop di
        pop si
        pop ds
        pop es
        pop dx
        pop cx
        pop ax       ;avoid bx be destroyed
        pop ax

        ret
		
		
    ;double word divide
    divdw:
      push si
      push di


        mov di,dx
        mov dx,0      ;  16bit div ,dx=0  first

        mov si,ax     ;  si: the lower 16bit
        mov ax,di

        div cx        
        mov di,ax     ;  di: the result higher 16bit

        mov ax,si
        div cx

        mov cx,dx
        mov dx,di

        pop di
        pop si

        ret


   ;double word to string  
   dtocdw:
      push ax
      push bx
      push cx
      push dx
      push si
      push di
    
       mov bx,0
    s_dtoc:
       mov cx,10
       call divdw
       
       add cl,30H
       mov ch,0
       push cx
       inc bx
      
       mov cx,0
       add cx,ax
       add cx,dx
       jcxz ok_dtocdw

       
       add cx,10    ;condition : cx == 0001 the loop will stop
       loop s_dtoc


     ok_dtocdw:
      mov cx,bx

     pop_loop:
       pop dx
       mov ds:[si],dl
       inc si
       loop pop_loop

       mov byte ptr ds:[si],0

        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax

        ret

code ends

end main
