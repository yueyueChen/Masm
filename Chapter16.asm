
assume cs:code

code segment
    main:

      mov ax,cs
      mov ds,ax

      mov ax,0
      mov es,ax

      mov si,offset setscreen
      mov di,200H

      mov word ptr es:[4*7ch],200H
      mov word ptr es:[4*7ch+2],0H


      mov cx,offset screenend-offset setscreen
      cld
      rep movsb

      mov ax,4c00h
      int 21h

   setscreen:       ;使用table存储地址时会出错
       cmp ah,0
       je do0
       cmp ah,1
       je do1
       cmp ah,2
       je do2
       cmp ah,3
       je do3

       jmp near ptr sret

   do0:call sub1
       iret
   do1:call sub2
       iret
   do2:call sub3
       iret
   do3:call sub4
       iret


   sub1:push bx
        push cx
        push es

        mov bx,0b800h
        mov es,bx
        mov bx,0
        mov cx,2000
  subls:mov byte ptr es:[bx],' '
        add bx,2
        loop subls
        pop es
        pop cx
        pop bx
        ret

  sub2: push bx
        push cx
        push es

        mov bx,0b800h
        mov es,bx
        mov bx,1
        mov cx,2000
 sub2s: and byte ptr es:[bx],11111000b
        or es:[bx],al
        add bx,2
        loop sub2s
        pop es
        pop cx
        pop bx
        ret

  sub3: push bx
        push cx
        push es
        mov cl,4
        shl al,cl
        mov bx,0b800h
        mov es,bx
        mov bx,1
        mov cx,2000
 sub3s: and byte ptr es:[bx],10001111b
        or es:[bx],al
        add bx,2
        loop sub3s
        pop es
        pop cx
        pop bx
        ret
 sub4: push cx
       push si
       push di
       push es
       push ds

       mov si,0b800h
       mov es,si
       mov ds,si
       mov si,160
       mov di,0
       cld
       mov cx,24
   sub4s:push cx
         mov cx,160
         rep movsb
         pop cx
         loop sub4s

         mov cx,80
         mov si,0
  sub4s1:mov byte ptr [160*24+si],' '
         add si,2
         loop sub4s1

         pop ds
         pop es
         pop di
         pop si
         pop cx
         ret
    sret:pop bx
         iret

  screenend:nop
code ends

end  main
