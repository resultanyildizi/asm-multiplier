; multi-segment executable file template.

data segment
    ; genel program mesajari
    progrmend db "Program basariyla sonlandirildi...$"
    
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
    oprnderr1msg db "Gecersiz bir operand girdiniz. Operand H karakteri ile sonlanmalidir.$"
    oprnderr2msg db "Gecersiz bir operand girdiniz. Operand maksimum 16 hane olmalidir.$"
    oprnderr3msg db "Gecersiz bir operand girdiniz. Operand hex formationda olmalidir.$"
    
   
    ; secim degerinin saklandigi degisken
    selected  dw 'X'
    tempslct  dw 'X'
    
    ; operand 1
    first  dw   0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh  ; 0011 2233 4455 6677 8899 AABB CCDD EEFF
    second dw   0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh  ; FFEE DDCC BBAA 9988 7766 5544 3322 1100
    third  dw   0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh
    currlw db   0
    currhg db   0
    count  dw   0
    
    ; first   dw 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh  ;0x1234567812345678
    ; second  dw 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh  ;0x9ABCDEF09ABCDEF0
    
    result_1 dw 16 dup(0)         ;0B 00 EA 4E 24 2D 20 80
    result_2 dw 24 dup(0)  
    
    ; input karsilastirmak icin kullanilan sabitler
    opte dw 'E' ; Option - Exit
    opth dw 'H' ; Optipn - Help
    opt2 dw '2' ; Option - 2
    opt3 dw '3' ; Optipn - 3
  
ends

stack segment
    dw   128  dup(0)
ends

code segment
    
macros:
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
;                   READOPR                    ;
;-----------------------------------------------    
; TODO. 
 
READOPR macro opr
LOCAL read_opr, end_opr
                                                                   
read_opr: 
    cmp [count], 16
    je end_opr
                                
    mov ah, 1               ; Standart inputtan echo ile bir karakter okur ve sonucu AL icine yaz.
    int 21h                 ; Standart inputtan echo ile bir karakter okur ve sonucu AL icine yaz. (Devam)
      
    cmp al, 0Dh             ; Girilen tus Enter'mi diye kontrol et
    je end_opr
    
    mov bx, [count]
    mov byte [opr+bx], al
    
    
    inc [count]
    jmp read_opr
end_opr:      
        NEWLN                   ; Yeni satira gec ve imleci yeni satirin basina tasi.
endm



procedures: 


;-----------------------------------------------
;                   COMPARE                    ;
;-----------------------------------------------    
; TODO

COMPARE proc
    push bp                 ; BP'nin degerini yigina kaydet.
    mov bp, sp              ; SP'nin degerini (yani yigin pozisyonunu) BP'ye kaydet.
    
    ; Normal sartlar altinda, yigindaki bir degiskene erismek icin
    ; [sp + 2] referansini kullanmaliydik (2 byte offset) ancak
    ; BP'yi yigina ekledigimiz icin referanslar bir birim kaydi.
    
    mov ax, [bp + 4]        ; Yigindan prosedurun ilk parametresini oku.
    mov bx, [bp + 6]        ; Yigindan prosedurun ikinci parametresini oku.
    sub ax, bx              ; Parametrelerin farkini hesapla.

    mov [bp + 6], ax        ; Sonucu yigina ekle.   

compare_end:                ;    
    mov sp, bp              ; Yigin pozisyonunu geri yukle.
    pop bp                  ; BP'nin degerini geri yukle.
    ret 2     
endp



;-----------------------------------------------
;                MULTIPLY_2_NUM                ;
;-----------------------------------------------    
; TODO

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
; Standart inputtan echo ile bir karakter okur 
; ve bu karakteri verilen @output parametresi i-
; cerisine yazar. 

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
; Standart inputtan echo ile bir karakter okur 
; ve bu karakteri verilen @output parametresi i-
; cerisine yazar. 

MULTIPLY3 macro off1, off2, offr
    mov ax, [result_1 + off1]
    mov bx, [third+ off2]
    mul bx
    add [result_2+offr]  , ax
    adc [result_2+offr+2], dx
    adc [result_2+offr+4], 0 
endm



    
;-----------------------------------------------
;                    PROGRAM                   ;
;-----------------------------------------------    
; TODO: Program aciklamasi
 
start:
    ; Segment registerlarini ayarla  
    mov ax, data           ; Data segmentinin adresini DS registerina aktarmak icin AX icine yaz.
    mov ds, ax             ; Bu adresi DS segment registeri icinde sakla. (Dogrudan aktarim gecersiz.)
            
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
                           
option_2:
    PRINTLN oprnd1msg
    
    READOPR first

    PRINTLN oprnd2msg   
    
    READOPR second
    ; TODO get the second operand
    
    ; TODO calculate result
    ; TODO print result
     
    
    CALL MULTIPLY_2_NUM
    
    jmp option_e

option_3:
    PRINTLN oprnd1msg
    ; TODO get the first operand
    PRINTLN oprnd2msg
    ; TODO get the second operand
    PRINTLN oprnd3msg
    ; TODO get the second operand
    
    ; TODO calculate result
    ; TODO print result
    
    CALL MULTIPLY_2_NUM
    CALL MULTIPLY_3_NUM
    
    jmp option_e

option_h:


option_e:
    PRINTLN progrmend
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends
   
end start ; set entry point and stop the assembler.


                    
    
