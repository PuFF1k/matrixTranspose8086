.MODEL SMALL
.stack 100h
 
.data 
Data1 db 00h
Data2 db 00h
Datanorm1 dw 00h
Datanorm2 dw 00h
Data41 db 00h 
Databx dw 00h 
Databx2 dw 00h
rows		dw ?
cols		dw ? 
cof		dw ?
array		db 10*10 dup (?)	;rows * cols   
array2		db 10*10 dup (?)
crlf		db 13,10,'$'
buf		db 3,0,3 dup ('$'),'$'
msgPress	db 'Press any key... $'
msgRows		db 'Input count of rows (<=10): $'
msgCols		db 'Input count of columns (<=10): $'
msgtrans	db 'Transponovana matryzia: $'
msgmul  	db 'Matryzia pomnozhena na cof: $'
msgCof		db 'Input mul cof (<=10): $'
msgEl		db 13,10,'Input elements: ',13,10,'$'
msgMax		db 13,10,'MAX = $'
msgCountMax	db 13,10,'Count of MAX = $'
 
.code
write macro  str
	push 	ax
	push 	dx
 
	lea 	dx,str	
	mov 	ah,09h	
	int 	21h
 
	pop 	dx
	pop 	ax
endm
 
putdigit macro
	local lput1
	local lput2
	local exx
 
	push 	ax
	push	cx
	push 	-1	
	mov 	cx,10	
lput1:	xor 	dx,dx	
	mov 	ah,0                   
	idiv 	cl	 
	mov 	dl,ah	
	push 	dx	
	cmp	al,0	 
	jne	lput1	
	mov	ah,2h
lput2:	pop	dx	
	cmp	dx,-1	 
	je	exx
	add	dl,'0'	
	int	21h	
	jmp	lput2	;И 
exx:
	mov	dl,' ' 
	int	21h
	pop	cx
	pop 	ax
endm
 
indigit macro
	local	lin
	push 	bx
	push 	cx
	push	dx
 
	mov 	ah,0Ah	
	lea 	dx,buf
	int 	21h
 
	xor 	ax,ax
	xor 	cx,cx
	
	mov 	cl,[buf+1]	
	xor 	di,di
lin:
	mov 	dl,10
	mul 	dl
	mov 	bl,[buf+di+2]
	sub 	bl,30h	
	add 	al,bl
	inc 	di
	loop 	lin
 
	pop	dx	
	pop 	cx
	pop 	bx
endm
 
start:
	mov 	ax,@data
	mov 	ds,ax
 
	write msgRows
	indigit
	mov	rows,ax
	write crlf	
 
	write msgCols
	indigit
	mov	cols,ax
	write crlf
    
    write msgCof
	indigit
	mov	cof,ax
	write crlf
    
	write msgEl
;ввод массива
	lea 	bx,array
	mov 	cx,rows
in1:	
   	push 	cx
	mov 	cx,cols
	mov 	si,0
in2:	
	indigit	
	mov 	[bx][si],al
	inc 	si
 
	write crlf	
	loop 	in2
 
	add 	bx,cols
	pop 	cx
	loop 	in1
 
jmp vyvod
vyvodb:
        
     write crlf
     write crlf
     write msgTrans
     write crlf


jmp vyvod3
vyvod3b:
     write crlf
     write crlf
     write msgmul
     write crlf
     
    vyvodmul:
	lea 	bx,array
	mov 	cx,rows
outmul1:	
   	push 	cx
	mov 	cx,cols
	mov 	si,0
 
	write crlf	
outmul2:	
	xor 	ax,ax
	mov	al,[bx][si]	 
	mov dx,cof
	mul dx
	putdigit	
	inc 	si
	loop 	outmul2
 
	add 	bx,cols
	pop 	cx
	loop 	outmul1  
	
	lea 	bx,array2
	mov     databx2,bx
    
    write crlf
         
	lea 	bx,array
	xor 	ax,ax
	mov 	al,[bx][0]
	mov 	cx,rows
r1:	
   	push 	cx
	mov 	cx,cols
	mov 	si,0
r2:	
	cmp 	al,[bx][si]
	ja 	lmax
	mov 	al,[bx][si]
lmax:
	add 	si,1
	loop 	r2
 
	add 	bx,cols
	pop 	cx
	loop 	r1

	write msgMax
	putdigit
 

	lea 	bx,array
	xor 	dx,dx
	mov 	cx,rows
rr1:	;цикл по строкам
   	push 	cx
	mov 	cx,cols
	mov 	si,0
rr2:	;цикл по колонкам
	cmp 	al,[bx][si]	
	jne 	lcount
	inc 	dx	
lcount:
	inc  	si
	loop 	rr2
 
	add 	bx,cols
	pop 	cx
	loop 	rr1

      mov 	ax,dx
	write msgCountMax
	putdigit
 

    
     xor ax,ax
     xor dx,dx

	mov ah,04ch
	int 	21h 

vyvod:
	lea 	bx,array
	mov 	cx,rows
out1:	
   	push 	cx
	mov 	cx,cols
	mov 	si,0
 
	write crlf	
out2:	
	xor 	ax,ax
	mov	al,[bx][si]	
	putdigit	
	inc 	si
	loop 	out2
 
	add 	bx,cols
	pop 	cx
	loop 	out1  
	
	lea 	bx,array2
	mov     databx2,bx
jmp vyvodb

 vyvod3:
	lea 	bx,array
	mov     databx,bx
	mov 	cx,rows
out17:	
   	push 	cx
	mov 	cx,cols
	mov 	si,0
 
out27:	
	xor 	ax,ax
	
	mov al,[bx][si]
    mov data41,al
    
	mov datanorm2,bx
	mov ax,bx
	sub ax,databx
	mov dx,cols
	idiv dl
	mov dx,ax
	
	mov datanorm1,si	
	mov ax,si
	mov bx,cols
	mul bl
	add ax,databx
	   
    mov si,dx
    mov bx,ax

    mov ax,bx
	sub ax,databx
	mov dx,cols
	idiv dl
	mov dx,ax

    mov ax,dx
	mov bx,rows
	mul bl
	add ax,databx2
    
    mov bx,ax
    
    mov dl,data41
     
    mov array2[bx][si],dl 
	 	
	mov si,datanorm1
	mov bx,datanorm2
	 		
	inc 	si
	loop 	out27
 
	add 	bx,cols
	pop 	cx
	loop 	out17 
 
 vyvod15:
	lea 	bx,array2
	mov 	cx,cols
out115:	
   	push 	cx
	mov 	cx,rows
	mov 	si,0
 
	write crlf	
out215:	
	xor 	ax,ax
	mov	al,array2[bx][si]	
	putdigit	
	inc 	si
	loop 	out215
 
	add 	bx,rows
	pop 	cx
	loop 	out115
jmp vyvod3b


end start 