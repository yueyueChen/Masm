assume cs:code,ds:data,es:display,ss:stack  
data segment   
    db 'welcome to masm!'  
    db 02H,24H,71H  
data ends  
stack segment  
     db 16 dup(0)  
stack ends  
display segment   
    db 1024 dup(0)  
display ends   
code segment  start:  
    mov ax,data   
    mov ds,ax  
    mov si,0  
    mov ax,0b872H               ;定义12行中间的起始位置   
    mov es,ax  

    mov cx,3  
    mov di,0  
;*****************************  
;做三次外循环,每次显示一种颜色  
;******************************   
s0:  
    push cx  
    push ax  
    mov cx,16  
    mov bx,0  
;*********************************************  
;做上六次内循环,将数据段定义的字符串写入内存中  
;*********************************************    
s:        
    mov al,[bx]  
    mov es:[si],al  
    mov al,[di+10h]  
    mov es:[si+1],al  
    add si,2  
    inc bx  
  loop s  