assume cs:code
data segment

data ends
code segment
  start:   
           mov ax,cs
           mov es,ax
           mov bx,offset boot

           mov al,1
           mov ch,0
           mov cl,1
           mov dl,0
           mov dh,0
           mov ah,3
           int 13h

           mov ax,4c00h
           int 21h

      boot:jmp bootOption
      str: db '1)reset pc',0
           db '2)start system',0
           db '3)clock',0
           db '4)set clock',1


     bootOption:
           mov ax,0b800h
           mov es,ax
           mov di,160
           mov bx,1
           mov ax,cs
           mov ds,ax

           mov si,offset str-offset boot
           add si,7c00h         ;relative addr + base addr 0:7c00


         s:mov al,ds:[si]
           cmp al,0
           je nextline
           cmp al,1
           je choose

           
           mov es:[di],al
           add si,1
           add di,2
           jmp s

       nextline:
           inc si
           inc bx
           mov ax,160
           mul bl
           mov di,ax
           jmp s

      choose:
           mov ah,0
           int 16h

           cmp al,31h
           je reboot
           cmp al,32h
           je loadsystem
           jmp bootOption



      reboot:
          mov word ptr ds:[si],0
          mov word ptr ds:[si+2],0ffffh
          jmp dword ptr ds:[si]


    loadsystem:
          mov ax,0
          mov es,ax
          mov bx,7c00h

          mov al,1
          mov ch,0
          mov cl,1
          mov dl,80h
          mov dh,0
          mov ah,2
          int 13h

          mov word ptr [si],7c00h
          mov word ptr [si+2],0h
          jmp dword ptr [si]


code ends

end start
