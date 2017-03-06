
assume cs:code

data segment

      db 10 dup (0)
data ends

code segment
    main: 
        mov ax,data
        mov ds,ax
        
        mov ax,12666
        mov si,0

        call dtoc

        mov dh,13D
        mov dl,20D
        mov cl,4D

        call show_str

        mov ax,4c00H
        int 21h

    show_str:
		  push ax
		  push bx
		  push cx
		  push dx
		  push es
		  push ds
		  push si
		  push di

        mov al,160D
        mul dh
        mov dx,ax
        mov al,2D
        mul dl
        add ax,dx
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
        pop di
        pop si
        pop ds
        pop es
        pop dx
        pop cx
        pop bx
        pop ax

        ret

	;
     dtoc:
      push ax
      push bx
      push cx
      push dx
      push si
      push di
     
       mov di,10
       mov bx,0
     s_dtoc:
       mov dx,0
       div di
       
       add dl,30H
       mov dh,0
       push dx
       inc bx
      
       mov cx,ax

       jcxz ok_dtoc
       add cx,10    ;condition : cx == 0001 the loop will stop
       loop s_dtoc


     ok_dtoc:
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

end  main
