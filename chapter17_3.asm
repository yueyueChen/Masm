
assume cs:code,ds:data
data segment
db 128 dup (0)
data ends

code segment
    main:
            mov ax,data
            mov ds,ax
            mov si,0
            mov dh,14
            mov dl,10
            call getstr
            mov ax,4c00h
            int 21h

   getstr:  push ax

   getstrs: mov ah,0
            int 16h
            cmp al,20h
            jb nochar
            mov ah,0
            call charstart
            mov ah,2
            call charstart
            jmp getstrs

   nochar:  cmp ah,0eh
            je backspace
            cmp ah,1ch
            je enter
            jmp getstrs

   backspace:mov ah,1
             call charstart
             mov ah,2
             call charstart
             jmp getstrs

      enter: mov ah,0
             mov al,0
             call charstart
             pop ax
             ret


   charstart:
             jmp charset
             table dw charpush,charpop,charshow
             top dw 0          ;top[0] = 0 the char stack's count

    charset:
             push bx
             push dx
             push di
             push es

             cmp ah,2
             ja sret
             mov bl,ah
             mov bh,0
             add bx,bx
             jmp word ptr table[bx]
      charpush:
             inc top
             mov bx,top
             mov [si][bx],al
             
             jmp sret

      charpop:cmp top,0
              je sret
              mov bx,top
              mov al,[si][bx]
              dec top
             
              jmp sret
      charshow:
              mov bx,0b800h
              mov es,bx
              mov al,160
              mov ah,0
              mul dh
              mov di,ax
              add dl,dl
              mov dh,0
              add di,dx
              mov bx,0
      charshows:
              cmp bx,top  ;when equal the pnt bx has arrived top
              jne noempty
              mov byte ptr es:[di],' '
              jmp sret
      noempty:
              mov al,[si][bx]
              mov es:[di],al
              mov byte ptr es:[di+2],' '
              inc bx
              add di,2

              jmp charshows

       sret:  pop es
              pop di
              pop dx
              pop bx
              ret

code ends

end  main
