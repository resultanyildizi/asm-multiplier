; multi-segment executable file template.
; Nurettin Resul Tanyildizi - 030117056
data segment   
    
    ; operands
    first  dw   0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh  ; 0011 2233 4455 6677 8899 AABB CCDD EEFF
    second dw   0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh  ; FFEE DDCC BBAA 9988 7766 5544 3322 1100
    third  dw   0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh  
    
    ; results
    result_1 dw 16 dup(0)         ;0B 00 EA 4E 24 2D 20 80
    result_2 dw 24 dup(0)  
    
    ; common-purpose variables
    count  dw   16
    tmpch  db   'X'
    
    ; genel program mesajari
    progrmend db "Program basariyla sonlandirildi...$"
    resultmsg db "Sonuc (hex formatinda): $"
    
    ; secim icin kullanilan mesajlar
    selectmsg db "Lutfen seciminizi yapiniz:$"
    selectop2 db "2 - 128 bitlik iki sayi carpma$"
    selectop3 db "3 - 128 bitlik  uc sayi carpma$"
    selectoph db "H - Yardim:$"
    selectope db "E - Cikis:$"
    selectinv db "Gecersiz bir secim yaptiniz. Tekrar deneyiniz: $"
    
    ; operand almak icin kullanilan mesajlar
    oprnd1msg db "Lutfen operand1  i hex formatinda ve sonunda H ile giriniz. (Maks 16 hane)$"
    oprnd2msg db "Lutfen operand2 yi hex formatinda ve sonunda H ile giriniz. (Maks 16 hane)$"
    oprnd3msg db "Lutfen operand3  u hex formatinda ve sonunda H ile giriniz. (Maks 16 hane)$" 
    
    ; operand hatalari icin kullanilan mesajlar
    oprnderr1msg db "Gecersiz bir operand girdiniz. Operand h karakteri ile sonlanmalidir.$"
    oprnderr2msg db "Gecersiz bir operand girdiniz. Operand minimum bir hane olmalidir.$"
    oprnderr3msg db "Gecersiz bir operand girdiniz. Operand maksimum 16 hane olmalidir.$"
    oprnderr4msg db "Gecersiz bir operand girdiniz. Operand hex formationda olmalidir.$"  
    
   
   
    ; secim degerinin saklandigi degisken
    selected  dw 'X'
    tempslct  dw 'X'
    
   
    
    ; input karsilastirmak icin kullanilan sabitler
    opte dw 'E' ; Option - Exit
    opth dw 'H' ; Optipn - Help
    opt2 dw '2' ; Option - 2
    opt3 dw '3' ; Option - 3
    
    oprh db 'H' ; Operand Control - H
    oprx db 'X' ; Operand Control - X
    opre db 0Dh ; Operand Control - Enter
   
ends

extra segment
    ; operands
    shifter dw 8 dup(0)
    
    

stack segment
    dw   128  dup(0)
ends

code segment
    
macros:

;-----------------------------------------------
;                MULTIPLY_2_NUM                ;
;-----------------------------------------------    
; @first ve @second operandlari icerisindeki 128
; bitlik sayilari kelime kelime carpar ve sonucu
; @result_1 operandi icerisine yazar.

MULTIPLY_2_NUM proc
     ; A_0 * B_0 >> 0
    MULTIPLY2 0, 0, 0
    
    ;----------------------
    ; A_1 * B_0 >> 16
    MULTIPLY2 2, 0, 2                          
    
    ; A_0 * B_1 >> 16
    MULTIPLY2 0, 2, 2
                
    ;----------------------               
    ; A_2 * B_0 >> 32
    MULTIPLY2 4, 0, 4
    
    ; A_1 * B_1 >> 32
    MULTIPLY2 2, 2, 4
  
    ; A_0 * B_2 >> 32
    MULTIPLY2 0, 4, 4
    
    ;----------------------  
    ; A_3 * B_0 >> 48
    MULTIPLY2 6, 0, 6
    
    ; A_2 * B_1 >> 48
    MULTIPLY2 4, 2, 6
    
    ; A_1 * B_2 >> 48
    MULTIPLY2 2, 4, 6
    
    ; A_0 * B_3 >> 48
    MULTIPLY2 0, 6, 6
    
    ;----------------------
    ; A_4 * B_0
    MULTIPLY2 8, 0, 8
    
    ; A_3 * B_1
    MULTIPLY2 6, 2, 8
    
    ; A_2 * B_2
    MULTIPLY2 4, 4, 8
    
    ; A_1 * B_3
    MULTIPLY2 2, 6, 8
  
    ; A_0 * B_4
    MULTIPLY2 0, 8, 8
    
    ;----------------------
    
    ; A_5 * B_0
    MULTIPLY2 10, 0, 10
    
    ; A_4 * B_1
    MULTIPLY2 8, 2, 10
    
    ; A_3 * B_2
    MULTIPLY2 6, 4, 10 
    
    ; A_2 * B_3
    MULTIPLY2 4, 6, 10 
    
    ; A_1 * B_4
    MULTIPLY2 2, 8, 10 
    
    ; A_0 * B_5
    MULTIPLY2 0, 10, 10 
    
    ;----------------------
    ; A_6 * B_0
    MULTIPLY2 12, 0, 12
    
    ; A_5 * B_1
    MULTIPLY2 10, 2, 12
    
    ; A_4 * B_2
    MULTIPLY2 8, 4, 12 
    
    ; A_3 * B_3
    MULTIPLY2 6, 6, 12 
    
    ; A_2 * B_4
    MULTIPLY2 4, 8, 12 
    
    ; A_1 * B_5
    MULTIPLY2 2, 10, 12
    
    ; A_0 * B_6
    MULTIPLY2 0, 12, 12
    
    
    ;----------------------   
    ; A_7 * B_0
    MULTIPLY2 14, 0, 14
    
    ; A_6 * B_1
    MULTIPLY2 12, 2, 14
    
    ; A_5 * B_2
    MULTIPLY2 10, 4, 14 
                    
    ; A_4 * B_3
    MULTIPLY2 8, 6, 14 
    
    ; A_3 * B_4
    MULTIPLY2 6, 8, 14 
    
    ; A_2 * B_5
    MULTIPLY2 4, 10, 14
    
    ; A_1 * B_6
    MULTIPLY2 2, 12, 14
    
    ; A_0 * B_7
    MULTIPLY2 0, 14, 14
    
    ;----------------------
    ; A_7 * B_1
    MULTIPLY2 14, 2, 16
    
    ; A_6 * B_2
    MULTIPLY2 12, 4, 16
    
    ; A_5 * B_3
    MULTIPLY2 10, 6, 16 
                    
    ; A_4 * B_4
    MULTIPLY2 8, 8, 16 
    
    ; A_3 * B_5
    MULTIPLY2 6, 10, 16 
    
    ; A_2 * B_6
    MULTIPLY2 4, 12, 16
    
    ; A_1 * B_7
    MULTIPLY2 2, 14, 16 
    
    ;----------------------
    ; A_7 * B_2
    MULTIPLY2 14, 4, 18
    
    ; A_6 * B_3
    MULTIPLY2 12, 6, 18
    
    ; A_5 * B_4
    MULTIPLY2 10, 8, 18 
                    
    ; A_4 * B_5
    MULTIPLY2 8, 10, 18 
    
    ; A_3 * B_6
    MULTIPLY2 6, 12, 18 
    
    ; A_2 * B_7
    MULTIPLY2 4, 14, 18
    
    ;----------------------
    ; A_7 * B_3
    MULTIPLY2 14, 6, 20
    
    ; A_6 * B_4
    MULTIPLY2 12, 8, 20
    
    ; A_5 * B_5
    MULTIPLY2 10, 10, 20 
                    
    ; A_4 * B_6
    MULTIPLY2 8, 12, 20 
    
    ; A_3 * B_7
    MULTIPLY2 6, 14, 20 
     
    ;----------------------
    ; A_7 * B_4
    MULTIPLY2 14, 8, 22
    
    ; A_6 * B_5
    MULTIPLY2 12, 10, 22
    
    ; A_5 * B_6
    MULTIPLY2 10, 12, 22 
                    
    ; A_4 * B_7
    MULTIPLY2 8, 14, 22  
    
    ;----------------------
    ; A_7 * B_5
    MULTIPLY2 14, 10, 24
    
    ; A_6 * B_6
    MULTIPLY2 12, 12, 24
    
    ; A_5 * B_7
    MULTIPLY2 10, 14, 24

    ;----------------------
    ; A_7 * B_6
    MULTIPLY2 14, 12, 26
    
    ; A_6 * B_7
    MULTIPLY2 12, 14, 26
    
    ;----------------------
    ; A_7 * B_7
    MULTIPLY2 14, 14, 28

    ret
endp   




;-----------------------------------------------
;                MULTIPLY_3_NUM                ;
;-----------------------------------------------    
; @result_1 ve @third operandlari icerisindeki
; 128 ve 256 bitlik sayilari kelime kelime carpar 
; ve sonucu @result_2 operandi icerisine yazar.

MULTIPLY_3_NUM proc
      ; A_0 * B_0 >> 0
    MULTIPLY3 0, 0, 0
    
    ;----------------------
    ; A_1 * B_0 >> 16
    MULTIPLY3 2, 0, 2                          
    
    ; A_0 * B_1 >> 16
    MULTIPLY3 0, 2, 2
                
    ;----------------------               
    ; A_2 * B_0 >> 32
    MULTIPLY3 4, 0, 4
    
    ; A_1 * B_1 >> 32
    MULTIPLY3 2, 2, 4
  
    ; A_0 * B_2 >> 32
    MULTIPLY3 0, 4, 4
    
    ;----------------------  
    ; A_3 * B_0 >> 48
    MULTIPLY3 6, 0, 6
    
    ; A_2 * B_1 >> 48
    MULTIPLY3 4, 2, 6
    
    ; A_1 * B_2 >> 48
    MULTIPLY3 2, 4, 6
    
    ; A_0 * B_3 >> 48
    MULTIPLY3 0, 6, 6
    
    ;----------------------
    ; A_4 * B_0
    MULTIPLY3 8, 0, 8
    
    ; A_3 * B_1
    MULTIPLY3 6, 2, 8
    
    ; A_2 * B_2
    MULTIPLY3 4, 4, 8
    
    ; A_1 * B_3
    MULTIPLY3 2, 6, 8
  
    ; A_0 * B_4
    MULTIPLY3 0, 8, 8
    
    ;----------------------
    
    ; A_5 * B_0
    MULTIPLY3 10, 0, 10
    
    ; A_4 * B_1
    MULTIPLY3 8, 2, 10
    
    ; A_3 * B_2
    MULTIPLY3 6, 4, 10 
    
    ; A_2 * B_3
    MULTIPLY3 4, 6, 10 
    
    ; A_1 * B_4
    MULTIPLY3 2, 8, 10 
    
    ; A_0 * B_5
    MULTIPLY3 0, 10, 10 
    
    ;----------------------
    ; A_6 * B_0
    MULTIPLY3 12, 0, 12
    
    ; A_5 * B_1
    MULTIPLY3 10, 2, 12
    
    ; A_4 * B_2
    MULTIPLY3 8, 4, 12 
    
    ; A_3 * B_3
    MULTIPLY3 6, 6, 12 
    
    ; A_2 * B_4
    MULTIPLY3 4, 8, 12 
    
    ; A_1 * B_5
    MULTIPLY3 2, 10, 12
    
    ; A_0 * B_6
    MULTIPLY3 0, 12, 12
    
    
    ;----------------------   
    ; A_7 * B_0
    MULTIPLY3 14, 0, 14
    
    ; A_6 * B_1
    MULTIPLY3 12, 2, 14
    
    ; A_5 * B_2
    MULTIPLY3 10, 4, 14 
                    
    ; A_4 * B_3
    MULTIPLY3 8, 6, 14 
    
    ; A_3 * B_4
    MULTIPLY3 6, 8, 14 
    
    ; A_2 * B_5
    MULTIPLY3 4, 10, 14
    
    ; A_1 * B_6
    MULTIPLY3 2, 12, 14
    
    ; A_0 * B_7
    MULTIPLY3 0, 14, 14
    
    ;---------------------- 
    ; A_8 * B_0
    MULTIPLY3 16, 0, 16
    
    ; A_7 * B_1
    MULTIPLY3 14, 2, 16
    
    ; A_6 * B_2
    MULTIPLY3 12, 4, 16 
                    
    ; A_5 * B_3
    MULTIPLY3 10, 6, 16 
    
    ; A_4 * B_4
    MULTIPLY3 8, 8, 16 
    
    ; A_3 * B_5
    MULTIPLY3 6, 10, 16
    
    ; A_2 * B_6
    MULTIPLY3 4, 12, 16
    
    ; A_1 * B_7
    MULTIPLY3 2, 14, 16
    
    ;----------------------
    ; A_9 * B_0
    MULTIPLY3 18, 0, 18
    
    ; A_8 * B_1
    MULTIPLY3 16, 2, 18
    
    ; A_7 * B_2
    MULTIPLY3 14, 4, 18 
                    
    ; A_6 * B_3
    MULTIPLY3 12, 6, 18 
    
    ; A_5 * B_4
    MULTIPLY3 10, 8, 18 
        
    ; A_4 * B_5
    MULTIPLY3 8, 10, 18
    
    ; A_3 * B_6
    MULTIPLY3 6, 12, 18
    
    ; A_2 * B_7
    MULTIPLY3 4, 14, 18
    
    ;----------------------
    ; A_10 * B_0
    MULTIPLY3 20, 0, 20
    
    ; A_9 * B_1
    MULTIPLY3 18, 2, 20
    
    ; A_8 * B_2
    MULTIPLY3 16, 4, 20 
                    
    ; A_7 * B_3
    MULTIPLY3 14, 6, 20 
    
    ; A_6 * B_4
    MULTIPLY3 12, 8, 20 
        
    ; A_5 * B_5
    MULTIPLY3 10, 10, 20
    
    ; A_4 * B_6
    MULTIPLY3 8, 12, 20
    
    ; A_3 * B_7
    MULTIPLY3 6, 14, 20
    
    ;----------------------
    ; A_11 * B_0
    MULTIPLY3 22, 0, 22
    
    ; A_10 * B_1
    MULTIPLY3 20, 2, 22
    
    ; A_9 * B_2
    MULTIPLY3 18, 4, 22 
                    
    ; A_8 * B_3
    MULTIPLY3 16, 6, 22 
    
    ; A_7 * B_4
    MULTIPLY3 14, 8, 22 
        
    ; A_6 * B_5
    MULTIPLY3 12, 10, 22
    
    ; A_5 * B_6
    MULTIPLY3 10, 12, 22
    
    ; A_4 * B_7
    MULTIPLY3 8, 14, 22
    
    ;----------------------
    ; A_12 * B_0
    MULTIPLY3 24, 0, 24
    
    ; A_11 * B_1
    MULTIPLY3 22, 2, 24
    
    ; A_10 * B_2
    MULTIPLY3 20, 4, 24 
                    
    ; A_9 * B_3
    MULTIPLY3 18, 6, 24 
    
    ; A_8 * B_4
    MULTIPLY3 16, 8, 24 
        
    ; A_7 * B_5
    MULTIPLY3 14, 10, 24
    
    ; A_6 * B_6
    MULTIPLY3 12, 12, 24
    
    ; A_5 * B_7
    MULTIPLY3 10, 14, 24 
     
    ;----------------------
    ; A_13 * B_0
    MULTIPLY3 26, 0, 26
    
    ; A_12 * B_1
    MULTIPLY3 24, 2, 26
    
    ; A_11 * B_2
    MULTIPLY3 22, 4, 26 
                    
    ; A_10 * B_3
    MULTIPLY3 20, 6, 26 
    
    ; A_9 * B_4
    MULTIPLY3 18, 8, 26 
        
    ; A_8 * B_5
    MULTIPLY3 16, 10, 26
    
    ; A_7 * B_6
    MULTIPLY3 14, 12, 26
    
    ; A_6 * B_7
    MULTIPLY3 12, 14, 26
    
    ;----------------------
    ; A_14 * B_0
    MULTIPLY3 28, 0, 28
    
    ; A_13 * B_1
    MULTIPLY3 26, 2, 28
    
    ; A_12 * B_2
    MULTIPLY3 24, 4, 28 
                    
    ; A_11 * B_3
    MULTIPLY3 22, 6, 28 
    
    ; A_10 * B_4
    MULTIPLY3 20, 8, 28 
        
    ; A_9 * B_5
    MULTIPLY3 18, 10, 28
    
    ; A_8 * B_6
    MULTIPLY3 16, 12, 28
    
    ; A_7 * B_7
    MULTIPLY3 14, 14, 28
    
    ;----------------------
    ; A_15 * B_0
    MULTIPLY3 30, 0, 30
    
    ; A_14 * B_1
    MULTIPLY3 28, 2, 30
    
    ; A_13 * B_2
    MULTIPLY3 26, 4, 30 
                    
    ; A_12 * B_3
    MULTIPLY3 24, 6, 30 
    
    ; A_11 * B_4
    MULTIPLY3 22, 8, 30 
        
    ; A_10 * B_5
    MULTIPLY3 20, 10, 30
    
    ; A_9 * B_6
    MULTIPLY3 18, 12, 30
    
    ; A_8 * B_7
    MULTIPLY3 16, 14, 30
    
    ;----------------------
    ; A_15 * B_1
    MULTIPLY3 30, 2, 32
    
    ; A_14 * B_2
    MULTIPLY3 28, 4, 32
    
    ; A_13 * B_3
    MULTIPLY3 26, 6, 32 
                    
    ; A_12 * B_4
    MULTIPLY3 24, 8, 32 
    
    ; A_11 * B_5
    MULTIPLY3 22, 10, 32 
        
    ; A_10 * B_6
    MULTIPLY3 20, 12, 32
    
    ; A_9 * B_7
    MULTIPLY3 18, 14, 32
    
    ;----------------------
    ; A_15 * B_2
    MULTIPLY3 30, 4, 34
    
    ; A_14 * B_3
    MULTIPLY3 28, 6, 34
    
    ; A_13 * B_4
    MULTIPLY3 26, 8, 34 
                    
    ; A_12 * B_5
    MULTIPLY3 24, 10, 34 
    
    ; A_11 * B_6
    MULTIPLY3 22, 12, 34 
        
    ; A_10 * B_7
    MULTIPLY3 20, 14, 34
    
    ;----------------------
    ; A_15 * B_3
    MULTIPLY3 30, 6, 36
    
    ; A_14 * B_4
    MULTIPLY3 28, 8, 36
    
    ; A_13 * B_5
    MULTIPLY3 26, 10, 36 
                    
    ; A_12 * B_6
    MULTIPLY3 24, 12, 36 
    
    ; A_11 * B_7
    MULTIPLY3 22, 14, 36
    
    ;----------------------
    ; A_15 * B_4
    MULTIPLY3 30, 8, 38
    
    ; A_14 * B_5
    MULTIPLY3 28, 10, 38
    
    ; A_13 * B_6
    MULTIPLY3 26, 12, 38 
                    
    ; A_12 * B_7
    MULTIPLY3 24, 14, 38
    
    ;----------------------
    ; A_15 * B_5
    MULTIPLY3 30, 10, 40
    
    ; A_14 * B_6
    MULTIPLY3 28, 12, 40
    
    ; A_13 * B_8
    MULTIPLY3 26, 14, 40
    
    ;----------------------
    ; A_15 * B_6
    MULTIPLY3 30, 12, 42
    
    ; A_14 * B_7
    MULTIPLY3 28, 14, 42
    
      ;----------------------
    ; A_15 * B_7
    MULTIPLY3 30, 14, 44                           
    
    ret
endp

  



;-----------------------------------------------
;                   MULTIPLY2                  ;
;-----------------------------------------------    
; @off1 ve @off2 offsetleri ile @first ve @second 
; operandlarini offsetler ve ilgili addreslerdeki
; sayilari carparak @result_1 degiskeninin @offr 
; ile offsetlenmis adresine yazar. 

; TODO: satir aciklamalari

MULTIPLY2 macro off1, off2, offr
    mov ax, [first + off1]
    mov bx, [second+ off2]
    mul bx
    add [result_1+offr]  , ax
    adc [result_1+offr+2], dx
    adc [result_1+offr+4], 0 
endm


;-----------------------------------------------
;                   MULTIPLY3                  ;
;-----------------------------------------------    
; @off1 ve @off2 offsetleri ile @result_1 ve 
; @third operandlarini offsetler ve ilgili addr-
; eslerdeki sayilari carparak @result_2 degiske-
; ninin @offr ile offsetlenmis adresine yazar. 

; TODO: satir aciklamalari
MULTIPLY3 macro off1, off2, offr
    mov ax, [result_1 + off1]
    mov bx, [third+ off2]
    mul bx
    add [result_2+offr]  , ax
    adc [result_2+offr+2], dx
    adc [result_2+offr+4], 0 
endm



;-----------------------------------------------
;                   CONVRTHEX                  ;
;-----------------------------------------------    
; Girilen ASCII karakteri hexadecimal karsiligi-
; na donusturur. Eger karakter bir rakam ise 030h
; bir harf ise 039h cikarir. 


; TODO: satir aciklamalari

CONVRTHEX macro ascii, hex
local end_conv, is_digit
    mov ah, ascii
    cmp ah, 039h
    jbe is_digit
      
    sub ah, 037h

is_digit:
    sub ah, 030h
end_conv:
    mov hex, ah
     
endm

;-----------------------------------------------
;                   ISVALIDHEX                 ;
;-----------------------------------------------    
; Girilen karakter gecerli bir hexadecimal karak-
; ter mi diye kontrol eder.
; Yalnizca uppercase harfler kabul edilmektedir.

; (0123456789ABCDEF)

; TODO: satir aciklamalari 

ISVALIDHEX macro ascii, rslt
local end_conv, below_f, above_a, maybe_digit, below_9, above_0
    mov ah, ascii
    cmp ah, 046h
    jbe below_f
    
    mov ah, 01h
    jmp end_conv 

below_f:
    cmp ah, 041h
    jb maybe_digit 
   
above_a:
    mov ah, 0h
    jmp end_conv

maybe_digit:
    cmp ah, 039h
    jbe below_9
    
    mov ah, 01h
    jmp end_conv

below_9:
    cmp ah, 030h
    jae above_0
    
    mov ah, 01h
    jmp end_conv

above_0:
    mov ah, 0h,

    
end_conv:
    mov rslt, ah
     
endm

;-----------------------------------------------
;                   CLEARSC                    ;
;-----------------------------------------------    
; Konsol ekranini temizler.

CLEARSC macro
    mov ax, 3               ; Bir sayfa kaydirir ve imleci basa alir. 
    int 10h                 ; Bir sayfa kaydirir ve imleci basa alir. (Devam)
endm


;-----------------------------------------------
;                     PRINT                    ;
;-----------------------------------------------    
; Verilen @message parametresini standart output
; a yazdirir. 

PRINT macro message
    mov dx, offset message  ; Degiskenin offset degerini DX icine oku.
    mov ah, 9               ; DS:DX icindeki degeri ekrana bas.
    int 21h                 ; DS:DX icindeki degeri ekrana bas. (Devam)
    
endm


;-----------------------------------------------
;                     NEWLN                    ;
;-----------------------------------------------    
; Imleci bir alt satira ve alt satirin basina tasir.

NEWLN macro
    ; Standart outputa newline (\n) karakteri bas.
    mov dl, 0Dh             ; 0Dh = 13: ASCII newline karakterini DL icine yaz.
    mov ah, 2               ; DL icindeki degeri standart outputa yaz.
    int 21h                 ; DL icindeki degeri standart outputa yaz. (Devam)
    
    ; Standart outputa carriage return (\r) karakteri bas.
    mov dl, 0Ah             ; 0Ah = 10: ASCII carriage return karakterini DL icine yaz.
    mov ah, 2               ; DL icindeki degeri standart outputa yaz.
    int 21h                 ; DL icindeki degeri standart outputa yaz. (Devam)
endm 

;-----------------------------------------------
;                    PRINTLN                   ;
;-----------------------------------------------    
; Verilen @message parametresini standart output
; a yazdirir ve imleci yeni satirin basina tasir
 
PRINTLN macro message
    PRINT message           ; PRINT macrosu ile degiskeni ekrana bastirir.
    NEWLN                   ; Yeni satira gec ve imleci yeni satirin basina tasi.
    
endm


;-----------------------------------------------
;                   CONVASCII                  ;
;-----------------------------------------------    
; Hexadecimal bir degeri ASCII karsiligina donus-
; turmek icin gerekli toplama islemini yapar. Eg-
; er verilen deger bir rakam ise 030h, bir harf  
; ise 037h ekler.

CONVASCII macro
local is_letter, end_conv
    cmp dx, 9               ; DX registeri icindeki degeri 9 ile karsilastir.
    ja is_letter            ; Eger deger 9'dan buyukse bir harftir. (ABCDEF)
                            ; Bu durumda harf bolumune dallan.
    
    add dx, 030h            ; DX registerina 030h ekleyerek rakamin ASCII kar-
                            ; siligini elde et.
    jmp end_conv

is_letter:
    add dx, 037h            ; DX registerina 037h ekleyerek harfin ASCII  kar-
                            ; siligini elde et.
end_conv:
endm

;-----------------------------------------------
;                   PRINTSPC                   ;
;-----------------------------------------------    
; Standart output'a SPACE karakteri basar.
 
PRINTSPC macro
    ; Standart outputa carriage return ( ) karakteri bas.
    mov dx, 20h             ; 020h = 32: ASCII bosluk karakterini DL icine yaz.
    mov ah, 2h              ; DX icindeki degeri standart outputa yaz.
    int 21h                 ; DX icindeki degeri standart outputa yaz. (Devam)
endm

;-----------------------------------------------
;                    PRINTCH                   ;
;-----------------------------------------------    
; DX Registerinda bulunan 16 bit sayiyi, dorder
; byte olarak ASCII'ye donusturur ve ekrana basar.
 
PRINTCH macro
    mov bx, dx              ; DX registerindaki orijinal degeri korumak icin BX registerina yaz.
    
    shr dx, 12              ; Sayinin en yuksek anlamli 4 bitini almak icin kaydirma ve maskeleme yap.
    and dx, 000Fh           ; Sayinin en yuksek anlamli 4 bitini almak icin kaydirma ve maskeleme yap.
    CONVASCII               ; En yuksek anlamli 4 biti ASCII karsiligina donustur.
    mov ah, 2h              ; DX icindeki degeri standart outputa yaz.
    int 21h                 ; DX icindeki degeri standart outputa yaz. (Devam)
    
    mov dx, bx              ; BX registerindaki sayinin orijinal halini DX registerina yaz.
                            
    shr dx, 8               ; Sayinin ikinci en yuksek anlamli 4 bitini almak icin kaydirma ve maskeleme yap.
    and dx, 000Fh           ; Sayinin ikinci en yuksek anlamli 4 bitini almak icin kaydirma ve maskeleme yap.
    CONVASCII               ; Ikinci en yuksek anlamli 4 biti ASCII karsiligina donustur.
    mov ah, 2h              ; DX icindeki degeri standart outputa yaz.
    int 21h                 ; DX icindeki degeri standart outputa yaz. (Devam)
    
    mov dx, bx              ; BX registerindaki sayinin orijinal halini DX registerina yaz.
    
    shr dx, 4               ; Sayinin ucuncu en yuksek anlamli 4 bitini almak icin kaydirma ve maskeleme yap.
    and dx, 000Fh           ; Sayinin ucuncu en yuksek anlamli 4 bitini almak icin kaydirma ve maskeleme yap.
    CONVASCII               ; Ucuncu en yuksek anlamli 4 biti ASCII karsiligina donustur.
    mov ah, 2h              ; DX icindeki degeri standart outputa yaz.
    int 21h                 ; DX icindeki degeri standart outputa yaz. (Devam)
       
    mov dx, bx              ; BX registerindaki sayinin orijinal halini DX registerina yaz.
    
    and dx, 000Fh           ; Sayinin en dusuk anlamli 4 bitini almak icin maskeleme yap.
    CONVASCII               ; En dusuk anlamli 4 biti ASCII karsiligina donustur.
    mov ah, 2h              ; DX icindeki degeri standart outputa yaz.
    int 21h                 ; DX icindeki degeri standart outputa yaz. (Devam)
endm



;-----------------------------------------------
;                    READCH                    ;
;-----------------------------------------------    
; Standart inputtan echo ile bir karakter okur 
; ve bu karakteri verilen @output parametresi i-
; cerisine yazar. 
 
READCH macro output
    mov ah, 1               ; Standart inputtan echo ile bir karakter okur ve sonucu AL icine yaz.
    int 21h                 ; Standart inputtan echo ile bir karakter okur ve sonucu AL icine yaz. (Devam)
    
    xor ah, ah              ; AH registerinin icindeki degeri sifirla.
    mov tempslct, ax        ; AX icindeki karakteri verilen @tempslct degiskenine yaz.
    jmp read_ch                ; Kodun gecerli okuma bolumune atla.
    
    ; Eger bir sonraki karakter Enter olursa, bunu @output de-
    ; giskeine yaz. Eger Enter'dan farkli bir karakter gelirse
    ; @tempslct degiskenini gecersiz bir hale getir ve kullanici 
    ; Enter'a basana dek input girmesine izin ver.
    ; Sonuc her turlu gecersiz olacak.
                                                              
read_inv:
    mov tempslct, 'X'
read_ch:                            
    mov ah, 1               ; Standart inputtan echo ile bir karakter okur ve sonucu AL icine yaz.
    int 21h                 ; Standart inputtan echo ile bir karakter okur ve sonucu AL icine yaz. (Devam)
      
    cmp al, 0Dh             ; Girilen tus Enter'mi diye kontrol et
    je end_ch
    jmp read_inv
    
end_ch:
    mov ax, tempslct        ; @tempslct degiskendeki degeri AX registerine ata.
    mov output, ax          ; AX registerindeki degeri @outputs degiskenine ata.
        
    NEWLN                   ; Yeni satira gec ve imleci yeni satirin basina tasi.
endm

;-----------------------------------------------
;                   COMPARE                    ;
;-----------------------------------------------    
; Yigin araciligiyla verilen iki degiskenin far-
; kini hesaplar ve sonucu yeniden yigin aracili-
; giyla dondurur. 

COMPARE proc
    push bp                 ; BP'nin degerini yigina kaydet.
    mov bp, sp              ; SP'nin degerini (yani yigin pozisyonunu) BP'ye kaydet.
    
    ; Normal sartlar altinda, yigindaki bir degiskene erismek icin
    ; [sp + 2] referansini kullanmaliydik (2 byte offset) ancak
    ; BP'yi yigina ekledigimiz icin referanslar bir birim kaydi.
    
    mov ax, [bp + 4]        ; Yigindan prosedurun ilk parametresini oku.
    mov bx, [bp + 6]        ; Yigindan prosedurun ikinci parametresini oku.
    sub ax, bx              ; Parametrelerin farkini hesapla.

    mov [bp + 6], ax        ; Sonucu yigina ekle. Burada dogrudan push islemi 
                            ; yapmak return esnasinda bilgi kaybina yol acacagindan 
                            ; ilk yiginin bilinen guvenli kismina tasima yapilir.   

compare_end:                ;    
    mov sp, bp              ; Yigin pozisyonunu geri yukle.
    pop bp                  ; BP'nin degerini geri yukle.
    ret 2                   ; Yigin isaretcisini iki birim azalt.
endp




;-----------------------------------------------
;                    PRINTOPR                  ;
;-----------------------------------------------    
; Verilen @opr operandinin adresini @cnt offseti 
; ile offsetler ve yuksek adresten dusuk adrese 
; dogru kelime kelime ekrana yazdirir.   

PRINTOPR macro opr, cnt
LOCAL read_loop, end_opr
    mov [count], cnt        ; Verilen offset degerini @count degiskenine yaz.
read_loop:
    cmp [count], 0          ; @count degiskenini 0 ile karsilastir.
    je end_opr              ; Eger sifirsa islemi sonlandirma kismina dallan.
    
    ; Eger sifir degilse, yani dongu halen devam ediyorsa
    mov bx, [count]         ; @count degiskenini BX registerina yaz. 
    mov dx, [opr+bx-2]      ; Verilen operandin @count degiskeninin o anki degeri
                            ; ile offsetlenmis halini DX registerina yaz.  
    
    PRINTCH                 ; DX registeri icerisindeki karakterleri ekrana yazdir.
    PRINTSPC                ; Ekrana bosluk karakteri yazdir.
    
    ; @count degiskeni ikiser ikiser azaltiliyor cunku
    ; kelime kelime (16 bitlik) okuma yapmak istiyoruz.
    
    dec [count]             ; @count degiskenini azalt.
    dec [count]             ; @count degiskenini azalt.
    jmp read_loop           ; Donguye devam et.
end_opr:    
    NEWLN                   ; Yeni satira gec ve imleci yeni satirin basina tasi.
endm


;-----------------------------------------------
;                   RESETOPR                   ;
;-----------------------------------------------    
; Verilen @opr operandinin sifirlar.
; Bu macro offset degerini parametre olarak al-
; madigindan yalnizca 128 bit operandlar icin
; kullanilabilir.

RESETOPR macro opr
LOCAL write_opr, end_opr,init

init:
    mov [count], 15         ; 128 bit operand icin 15 offseti ile baslat
write_opr:
    cmp [count], 0          ; @count degiskenini 0 ile karsilastir.
    je end_opr              ; Eger sifirsa islemi sonlandirma kismina dallan.
    
    ; Eger sifir degilse, yani dongu halen devam ediyorsa
    mov bx, [count]         ; @count degiskenini BX registerina yaz. 
    and [opr+bx-1], 0h      ; Verilen operandin @count degiskeninin o anki degeri
                            ; ile offsetlenmis halini sifir ile maskele.  
                 
    dec [count]             ; @count degiskenini azalt.
    jmp write_opr           ; Donguye devam et.

end_opr:

endm

;-----------------------------------------------
;                   SHIFTOPR                   ;
;-----------------------------------------------    
; Verilen @src operandini 010h - @cnt kadar saga
; kaydirir. Boylece verilen operandin bitlerinin
; pozisyonu dogrulanmis olur.
   
SHIFTOPR macro src, cnt
LOCAL write_opr, end_opr
                            
                            
    cld                     ; MOVSB komutunda kullanilan D bayragini 0'a esitler.
    
    ; Cunku MOVSB komutu, dokumana gore asagidaki sekilde calismaktadir.
    ; ES:[DI] = DS:[SI]
    ;   if DF = 0 then
    ;       SI = SI + 1
    ;       DI = DI + 1
    ;   else
    ;       SI = SI - 1
    ;       DI = DI - 1
  
    lea si, src             ; @src'nin efektif adresini tasinacak veri olarak SI registerina aktarir.
    add si, [cnt]           ; Bu adresi @cnt kadar offsetler.
    lea di, shifter         ; @shifter degiskenini hedef olarak DI registerina aktarir. 
                            
    mov cx, 010h            ; Tasinacak bytelarin sayisini belirler CX = [010 - @cnt] 
    sub cx, [cnt]           ; Tasinacak bytelarin sayisini belirler CX = [010 - @cnt] 
    rep movsb               ; Tasima islemini baslatir.
    
    
    RESETOPR src            ; @src operandini sifirlar. Cunku dogrulanarak @shifter operandina
                            ; tasinan @src operandi, yeniden @src yazilacaktir.
    
    ; Ekstra segmentten Data segmente veri tasimak icin, segment registerlarinin 
    ; degistirilmesi gerekmektedir. Bu sebeple @data segmenti ES'ye, @ekstra segment
    ; DS'ye yazilarak swap islemi gerceklestirilir. 
    mov ax, data            ; Data segmentinin adresini ES registerina aktarmak icin AX icine yazar.  
    mov es, ax              ; Bu adresi ES segment registeri icinde saklar. (Dogrudan aktarim gecersiz.)
    
    mov ax, extra           ; Ekstra segmentinin adresini DS registerina aktarmak icin AX icine yazar.
    mov ds, ax              ; Bu adresi DS segment registeri icinde saklar. (Dogrudan aktarim gecersiz.)
    
    lea si, shifter         ; @shifter'in efektif adresini tasinacak veri olarak SI registerina aktarir.
    lea di, src             ; @src'in efektif adresini hedef olarak DI registerina aktarir.
    
    mov cx, 010h            ; Tasinacak bytelarin sayisini belirler CX = [010 - @cnt] 
    sub cx, [cnt]           ; Tasinacak bytelarin sayisini belirler CX = [010 - @cnt] 
    rep movsb               ; Tasima islemini baslatir.
    
       
    RESETOPR shifter        ; @shifter operandini daha sonraki kaydirmalar icin sifirlar.
    
    ; Segment registerlarinin icerigini eski hallerine geri dondurur.
    mov ax, extra           ; Ekstra segmentinin adresini ES registerina aktarmak icin AX icine yazar.
    mov es, ax              ; Bu adresi ES segment registeri icinde saklar. (Dogrudan aktarim gecersiz.) 
    
    mov ax, data            ; Data segmentinin adresini DS registerina aktarmak icin AX icine yazar.
    mov ds, ax              ; Bu adresi DS segment registeri icinde saklar. (Dogrudan aktarim gecersiz.)

endm

;-----------------------------------------------
;                   READOPR                    ;
;-----------------------------------------------    
; @opr ile verilen adrese, 128 bitlik bir operand
; okur. Okunan bu operand hexadecimal formatinda
; olmalidir ve minimum 1 maksimum 16 haneye sahip
; olmalidir. Ayrica sayi 'H' sembolu ile sonlan-
; malidir. Kullanici Enter tusuna bastiginda yazma
; islmei sonlanmalidir. Kullanici X tusuna basarsa
; menuye donulmelidir. 

; Bu macro, gerekli tum kontrolleri saglar ve 
; 128 bitlik bir sayiyi byte byte okuma islemi yapar. 
 
READOPR macro opr
LOCAL read_opr, end_opr, req_enter_first, req_enter_second, req_h, init, end_err, hex_err, max_err, is_input_x, end_of_check
       
init:
    RESETOPR opr
    mov [count], 16
    
                                                                       
read_opr:
     
    cmp [count], 0
    je req_h
    
    ; read first higher 4 bits                             
    mov ah, 1               ; Standart inputtan echo ile bir karakter okur ve sonucu AL icine yaz.
    int 21h                 ; Standart inputtan echo ile bir karakter okur ve sonucu AL icine yaz. (Devam)
      
    cmp al, oprh            ; Girilen karakter h'mi diye kontrol eder
    je req_enter_first      ; Enter gerektiren kisma dallanir
    
    jmp is_input_x          ; Girilen karakter x'mi diye kontrol eden kisma dallanir
    
end_of_check:
    ISVALIDHEX al, dl       ; Gecerli bir hexadecimal mi diye kontrol et.
    cmp dl, 01h             ; Gecerli bir hexadecimal mi diye kontrol et.
    je hex_err
    
    CONVRTHEX al, dl

    
    mov bx, [count]
    and dl, 0Fh
    mov byte [opr+bx-1], dl
    
    
    
    ; read first lower 4 bits    
    mov ah, 1               ; Standart inputtan echo ile bir karakter okur ve sonucu AL icine yaz.
    int 21h                 ; Standart inputtan echo ile bir karakter okur ve sonucu AL icine yaz. (Devam)
    
    cmp al, oprh            ; Girilen tus h'mi diye kontrol et
    je req_enter_second
     
    
    ISVALIDHEX al, dl
    
    cmp dl, 01h
    je hex_err
    
    shl byte [opr+bx-1], 4
    
    CONVRTHEX al, dl
    
    mov bx, [count]
    and dl, 0Fh
    xor byte [opr+bx-1], dl
    
    
    ; move next iteration
    dec [count]
    jmp read_opr


req_h:
    mov ah, 1               ; Standart inputtan echo ile bir karakter okur ve sonucu AL icine yaz.
    int 21h                 ; Standart inputtan echo ile bir karakter okur ve sonucu AL icine yaz. (Devam)
    
    cmp al, oprh            ; Girilen tus h'mi diye kontrol et
    je req_enter_first     
    
    cmp al, opre             ; Girilen tus Enter'mi diye kontrol et
    je end_err
    
    ISVALIDHEX al, dl
    
    cmp dl, 0h
    je max_err
    
    jmp hex_err
    


req_enter_first:
    mov ah, 1               ; Standart inputtan echo ile bir karakter okur ve sonucu AL icine yaz.
    int 21h                 ; Standart inputtan echo ile bir karakter okur ve sonucu AL icine yaz. (Devam)
      
    cmp al, opre             ; Girilen tus Enter'mi diye kontrol et
    je end_opr

    jmp hex_err                                                    
    


req_enter_second:
    mov ah, 1               ; Standart inputtan echo ile bir karakter okur ve sonucu AL icine yaz.
    int 21h                 ; Standart inputtan echo ile bir karakter okur ve sonucu AL icine yaz. (Devam)
      
    cmp al, opre             ; Girilen tus Enter'mi diye kontrol et
    jne hex_err 

    dec [count]
    jmp end_opr                                                     
      

end_err:
    NEWLN
    PRINTLN oprnderr1msg
    jmp init    


hex_err:
    NEWLN
    PRINTLN oprnderr4msg    ; gecersiz hex formati
    jmp init
    

max_err:
    NEWLN
    PRINTLN oprnderr3msg    ; gecersiz hex formati
    jmp init


is_input_x:
    cmp [count], 16
    jne end_of_check
    
    cmp al, oprx
    jne end_of_check    
    
    NEWLN
    CLEARSC
    jmp start
    
end_opr:
        SHIFTOPR opr, [count]      
        NEWLN                   ; Yeni satira gec ve imleci yeni satirin basina tasi.
endm



procedures: 



    
;-----------------------------------------------
;                    PROGRAM                   ;
;-----------------------------------------------    
; Bu program 8086 mimarisinde 128 bitlik 2 veya 3
; farkli sayinin carpimini yapmaktadir.  Kac adet 
; sayinin carpilacagi ve sayilarin degerleri kul-
; lanici tarafindan girilmektedir. Sayilar hex ve
; sonuc hex formatindadir.   Program kullanicinin  
; girdigi yanlis sayi  formatlarina karsi detayli
; uyarilarda bulunur. 
 
start:
    ; Segment registerlarini ayarla  
    mov ax, data           ; Data segmentinin adresini DS registerina aktarmak icin AX icine yaz.
    mov ds, ax             ; Bu adresi DS segment registeri icinde sakla. (Dogrudan aktarim gecersiz.)
    
    mov ax, extra          ; Ekstra segmentinin adresini ES registerina aktarmak icin AX icine yaz.
    mov es, ax             ; Bu adresi ES segment registeri icinde sakla. (Dogrudan aktarim gecersiz.)
            
    ; Kullanicinin uygulamada yapabileceklerini listele ve bir secim yapmasini bekle
    PRINTLN selectmsg      ; @selectmsg string degiskenini ekrana yazdir. 
    PRINTLN selectop2      ; @selectop2 string degiskenini ekrana yazdir.
    PRINTLN selectop3      ; @selectop3 string degiskenini ekrana yazdir.
    PRINTLN selectoph      ; @selectoph string degiskenini ekrana yazdir.
    PRINTLN selectope      ; @selectope string degiskenini ekrana yazdir.
    
    ; Kullanicinin secimini al.
get_selection:    
    READCH selected        ; @sexlected degiskeni icerisine kullanicinin girdigi karakteri okur.
         
    
    ; Kullanicinin secimine gore uygulamanin dallanmasi gereken bolumu sec. Eger kullanici, ken-
    ; disine sunulan opsiyonlarin disinda bir deger girerse, dogru bir secim yapincaya programi
    ; yurutmeye devam etme.
compare_selection:    
    push selected          ; COMPARE fonksiyonu icin @selected degiskenini yigina ekle.
    push opt2              ; COMPARE fonksiyonu icin @opt2 ('2') sabitini yigina ekle.
    call COMPARE           ; @selected ile @opt2 degiskenlerini karsilastir.
    pop ax                 ; Karsilastirmanin sonucu AX registerina kaydet.
    cmp ax, 0              ; AX registerinin icerisindeki deger sifir mi diye kontrol et.
    je option_2            ; Eger sifir ise programi ikinci secenekten devam ettir.
    
    ; Degilse kontrol etmeye devam et
    
    push selected          ; COMPARE fonksiyonu icin @selected degiskenini yigina ekle.
    push opt3              ; COMPARE fonksiyonu icin @opt3 ('3') sabitini yigina ekle.
    call COMPARE           ; @selected ile @opt3 degiskenlerini karsilastir.
    pop ax                 ; Karsilastirmanin sonucu AX registerina kaydet.
    cmp ax, 0              ; AX registerinin icerisindeki deger sifir mi diye kontrol et.
    je option_3            ; Eger sifir ise programi ikinci secenekten devam ettir.
    
    ; Degilse kontrol etmeye devam et
    
    push selected          ; COMPARE fonksiyonu icin @selected degiskenini yigina ekle.
    push opth              ; COMPARE fonksiyonu icin @opth ('H') sabitini yigina ekle.
    call COMPARE           ; @selected ile @opth degiskenlerini karsilastir.
    pop ax                 ; Karsilastirmanin sonucu AX registerina kaydet.
    cmp ax, 0              ; AX registerinin icerisindeki deger sifir mi diye kontrol et.
    je option_h            ; Eger sifir ise programi ikinci secenekten devam ettir.
    
    ; Degilse kontrol etmeye devam et            
                
    push selected          ; COMPARE fonksiyonu icin @selected degiskenini yigina ekle.
    push opte              ; COMPARE fonksiyonu icin @opth ('E') sabitini yigina ekle.
    call COMPARE           ; @selected ile @opte degiskenlerini karsilastir.
    pop ax                 ; Karsilastirmanin sonucu AX registerina kaydet.
    cmp ax, 0              ; AX registerinin icerisindeki deger sifir mi diye kontrol et.
    je option_e            ; Eger sifir ise programi ikinci secenekten devam ettir.
    
    ; Degilse girilen input program tarafindan taninmiyordur.
    ; Bu durumda gecersiz input kodunu calistir.
    
option_invalid:
    PRINTLN selectinv      ; @selectinv string degiskenini ekrana yazdir.
    jmp get_selection      ; Yeniden input almak icin, get_selection programi 
                           ; etikenine yonlendir.
                           
    ; Bu secenekte kullanicidan hex formatinda iki adet 128 bit sayi alinir.
    ; Bu iki sayi carpilir ve sonuc yine hex formatinda kullaniciya sunulur.
    ; Tum islemler basarili ise, program basariyla sonlandirilir.                         
option_2:
    PRINTLN oprnd1msg      ; @oprnd1msg string degiskenini ekrana yazdirir.
                           ; ve kullanicidan ilk operandi ister.
    READOPR first          ; Ilk operandi byte-byte okuyarak bellegin @first adresli bolumune yazar.
    
    PRINTLN oprnd2msg      ; @oprnd2msg string degiskenini ekrana yazdirir.
                           ; ve kullanicidan ikinci operandi ister. 
    READOPR second         ; Ikinci operandi byte-byte okuyarak bellegin @second adresli bolumune yazar.
    
    CALL MULTIPLY_2_NUM    ; Iki operand uzerinde carpma islemi gerceklestirir. Carpma isleminin 
                           ; sonucu bellegin @result_1 bolumune yazilir.
    
    PRINTLN resultmsg      ; @resultmsg string degiskenini ekrana yazdirir.
    PRINTOPR result_1, 32  ; Bellegin @result_1 bolumunde bulunan sonucu ekrana yazdirir.
    jmp option_e           ; Programi sonlandirmak icin dallanir.
    
    ; Bu secenekte kullanicidan hex formatinda iki adet 128 bit sayi alinir.
    ; Bu iki sayi carpilir ve sonuc yine hex formatinda kullaniciya sunulur.
    ; Tum islemler basarili ise, program basariyla sonlandirilir.  
option_3:
    PRINTLN oprnd1msg      ; @oprnd1msg string degiskenini ekrana yazdirir.
                           ; ve kullanicidan ilk operandi ister.
    READOPR first          ; Ilk operandi byte-byte okuyarak bellegin @first adresli bolumune yazar.
    
    PRINTLN oprnd2msg      ; @oprnd2msg string degiskenini ekrana yazdirir.
                           ; ve kullanicidan ikinci operandi ister. 
    READOPR second         ; Ikinci operandi byte-byte okuyarak bellegin @second adresli bolumune yazar.
    
    PRINTLN oprnd3msg      ; @oprnd3msg string degiskenini ekrana yazdirir.
                           ; ve kullanicidan ucuncu operandi ister. 
    READOPR third          ; Ucuncu operandi byte-byte okuyarak bellegin @third adresli bolumune yazar.
    
    
    CALL MULTIPLY_2_NUM    ; @first ve @second operandlari uzerinde carpma islemi gerceklestirir. 
                           ; Carpma isleminin sonucu bellegin @result_1 bolumune yazilir. 
    
    CALL MULTIPLY_3_NUM    ; @result_1 ve @third operandlari uzerinde carpma islemi gerceklestirir. 
                           ; Carpma isleminin sonucu bellegin @result_2 bolumune yazilir. 
    
    
    PRINTLN resultmsg      ; @resultmsg string degiskenini ekrana yazdirir.
    PRINTOPR result_2, 48  ; Bellegin @result_2 bolumunde bulunan sonucu ekrana yazdirir.
    jmp option_e           ; Programi sonlandirmak icin dallanir.

option_h:


option_e:
    PRINTLN progrmend      ; @progrmend string degiskenini ekrana yazdirir.
    mov ax, 4c00h          ; Programi basariyla sonlandirir.
    int 21h                ; Programi basariyla sonlandirir. (devam)
ends
   
end start                  ; Entry pointi ayarlar ve assembleri durdurur.


                    
    
