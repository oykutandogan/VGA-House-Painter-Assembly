.model small
.stack 2000h ; Stack boyutunu art�rd�m (2000h = 8KB), Flood Fill i�in daha g�venli
.data
    selected_color db 4 ; ba�lang�� rengi k�rm�z� (4)
    stack_start_value dw 0 ; Flood fill'e girerken SP'nin de�eri burada saklanacak
    
.code
start:
    mov ax, @data
    mov ds, ax

    mov ax, 0013h      ; 320x200 256 renk modu
    int 10h

    mov ax, 02h
    int 33h

    ; Evin d�� hatlar�n� �iz (a��k gri)
    mov al, 7h ; �izgi rengi: a��k gri (7)

    ; -------------------------
    ; Evin d�� hatlar� (�er�eve)
    ; -------------------------

    ; �st yatay �izgi
    mov cx, 130
    mov dx, 75
hseT:
    mov ah, 0Ch
    int 10h
    inc cx
    cmp cx, 216
    jne hseT

    ; Alt yatay �izgi
    mov cx, 130
    mov dx, 125
hseB:
    mov ah, 0Ch
    int 10h
    inc cx
    cmp cx, 216
    jne hseB

    ; Sol dikey �izgi
    mov cx, 130
    mov dx, 75
hseL:
    mov ah, 0Ch
    int 10h
    inc dx
    cmp dx, 125
    jne hseL

    ; Sa� dikey �izgi
    mov cx, 216
    mov dx, 75
hseR:
    mov ah, 0Ch
    int 10h
    inc dx
    cmp dx, 125
    jne hseR

    ; Sol �at� �izgisi (yukar� �apraz)
    mov cx, 130
    mov dx, 75
hseLR:
    mov ah, 0Ch
    int 10h
    inc cx
    dec dx
    cmp cx, 173
    jne hseLR

    ; Sa� �at� �izgisi (a�a�� �apraz)
    mov cx, 173
    mov dx, 32
hseRR:
    mov ah, 0Ch
    int 10h
    inc cx
    inc dx
    cmp cx, 216
    jne hseRR

    ; -------------------------
    ; Kap� �izimi
    ; -------------------------

    ; Sol kap� �izgisi
    mov cx, 164
    mov dx, 125
hseLD:
    mov ah, 0Ch
    int 10h
    dec dx
    cmp dx, 100
    jne hseLD

    ; Sa� kap� �izgisi
    mov cx, 182
    mov dx, 125
hseRD:
    mov ah, 0Ch
    int 10h
    dec dx
    cmp dx, 100
    jne hseRD

    ; Kap� �st �izgisi
    mov cx, 164
    mov dx, 100
hseTD:
    mov ah, 0Ch
    int 10h
    inc cx
    cmp cx, 183
    jne hseTD

    ; -------------------------
    ; Sol pencere (d�rtgen)
    ; -------------------------

    ; Sol pencere �st �izgi
    mov cx, 136
    mov dx, 85
win1_top:
    mov ah, 0Ch
    int 10h
    inc cx
    cmp cx, 157
    jne win1_top

    ; Sol pencere alt �izgi
    mov cx, 136
    mov dx, 105
win1_bottom:
    mov ah, 0Ch
    int 10h
    inc cx
    cmp cx, 157
    jne win1_bottom

    ; Sol pencere sol �izgi
    mov cx, 136
    mov dx, 85
win1_left:
    mov ah, 0Ch
    int 10h
    inc dx
    cmp dx, 106
    jne win1_left

    ; Sol pencere sa� �izgi
    mov cx, 156
    mov dx, 85
win1_right:
    mov ah, 0Ch
    int 10h
    inc dx
    cmp dx, 106
    jne win1_right

    ; -------------------------
    ; Sa� pencere (d�rtgen)
    ; -------------------------

    ; Sa� pencere �st �izgi
    mov cx, 190
    mov dx, 85
win2_top:
    mov ah, 0Ch
    int 10h
    inc cx
    cmp cx, 211
    jne win2_top

    ; Sa� pencere alt �izgi
    mov cx, 190
    mov dx, 105
win2_bottom:
    mov ah, 0Ch
    int 10h
    inc cx
    cmp cx, 211
    jne win2_bottom

    ; Sa� pencere sol �izgi
    mov cx, 190
    mov dx, 85
win2_left:
    mov ah, 0Ch
    int 10h
    inc dx
    cmp dx, 106
    jne win2_left

    ; Sa� pencere sa� �izgi
    mov cx, 210
    mov dx, 85
win2_right:
    mov ah, 0Ch
    int 10h
    inc dx
    cmp dx, 106
    jne win2_right

; --- Main Loop (Ana D�ng�) ---
main_loop:
    ; Klavye kontrol� (tu� bas�l� m�?)
    mov ah,0            ; Klavyeden karakter oku (bekler)
    int 16h             ; AL = okunan karakter, AH = tarama kodu

    ; Renk se�imi tu�lar�
    cmp al,'1'
    je set_red
    cmp al,'2'
    je set_blue
    cmp al,'3'
    je set_green
    cmp al,'4'
    je set_pink

    ; B�lge boyama tu�lar�
    cmp al, 'R'
    je paint_roof_kb
    cmp al, 'r'
    je paint_roof_kb

    cmp al, 'W'
    je paint_wall_kb
    cmp al, 'w'
    je paint_wall_kb

    cmp al, 'K'
    cmp al, 'k'
    je paint_right_window_kb
    cmp al, 'D'
    cmp al, 'd' 
    je paint_door_kb
    cmp al, 'L'
    cmp al, 'l'
    je paint_left_window_kb


    cmp al,27           ; ESC tu�u
    je exit_game
    
    jmp main_loop       ; Tan�ml� tu� de�ilse, d�ng�ye devam et

; --- Renk Ayarlama Etiketleri ---
set_red:   mov selected_color,4   ; k�rm�z�
           jmp main_loop
set_blue:  mov selected_color,1   ; mavi
           jmp main_loop
set_green: mov selected_color,2   ; ye�il
           jmp main_loop
set_pink:  mov selected_color,13  ; pembe
           jmp main_loop

; --- B�lge Boyama Etiketleri (Klavye ile) ---
; Her b�lge i�in sabit bir (X, Y) koordinat� belirleyin.
; Bu koordinatlar, boyanacak alan�n i�inden olmal� ve s�n�r �izgisi olmamal�d�r.

paint_roof_kb:
    mov cx, 132 ; �at� i�i X koordinat� (yakla��k orta)
    mov dx, 74 ; �at� i�i Y koordinat� (yakla��k orta)
    call call_flood_fill
    jmp main_loop

paint_wall_kb:
    mov cx, 131 ; Duvar i�i X koordinat� (yakla��k orta)
    mov dx, 76 ; Duvar i�i Y koordinat� (yakla��k orta)
    call call_flood_fill
    jmp main_loop

paint_door_kb:
    mov cx, 181 ; Kap� i�i X koordinat� (yakla��k orta)
    mov dx, 124 ; Kap� i�i Y koordinat� (yakla��k orta)
    call call_flood_fill
    jmp main_loop

paint_left_window_kb:
    mov cx, 137 ; Sol pencere i�i X koordinat� (yakla��k orta)
    mov dx, 86  ; Sol pencere i�i Y koordinat� (yakla��k orta)
    call call_flood_fill
    jmp main_loop

paint_right_window_kb:
    mov cx, 191 ; Sa� pencere i�i X koordinat� (yakla��k orta)
    mov dx, 86  ; Sa� pencere i�i Y koordinat� (yakla��k orta)
    call call_flood_fill
    jmp main_loop

; --- Programdan ��k�� ---
exit_game:
    ; Fare imlecini gizle (��kmadan �nce)
    mov ax, 02h
    int 33h
    ; Text moda d�n (opsiyonel)
    mov ax, 0003h
    int 10h

    ; Program sonu
    mov ax, 4c00h
    int 21h

; --- Flood Fill Prosed�r� ---
; Bu prosed�r, belirlenen bir noktadan ba�layarak ayn� renkteki kom�u pikselleri
; yeni renk ile doldurur. Grafik mod 13h (320x200) i�in uyarlanm��t�r.
; CX = X koordinat�
; DX = Y koordinat�
; selected_color = Yeni renk
flood_fill PROC
    pusha
    
    ; 1. T�klanan noktan�n mevcut rengini oku (eski renk).
    mov ah, 0Dh     ; Piksel rengini oku
    int 10h         ; Okunan renk AL'de d�ner.
    mov bl, al      ; Okunan rengi BL'ye kaydet (eski renk)

    ; 2. E�er t�klanan noktan�n rengi zaten se�ilen renkle ayn�ysa, boyama yapma.
    mov al, [selected_color] ; Se�ilen renk
    cmp al, bl      
    je .end_fill

    ; 3. Eski renk, �izgi rengiyle (7h) ayn�ysa, boyama yapma.
    ; Bu kontrol, kullan�c� yanl��l�kla �izgiye t�klarsa boyamamay� sa�lar.
    cmp bl, 7h
    je .end_fill

    ; Y���na it: Ba�lang�� noktas�n� y���na it.
    push dx ; Y koordinat�n� y���na it
    push cx ; X koordinat�n� y���na it

.loop:
    ; Y���n�n bo� olup olmad���n� kontrol et
    cmp sp, [stack_start_value] ; Stack'in ba�lang�� SP de�erine d�n�p d�nmedi�ini kontrol et
    je .end_fill_safety_exit ; D�ng�den g�venli ��k��

    ; Y���ndan (x, y) koordinatlar�n� al
    pop cx
    pop dx
    
    ; Pikseli boya (Cx, Dx koordinat�ndaki pikseli se�ilen renge boya)
    mov ah, 0Ch
    mov al, [selected_color] ; Boyanacak renk
    int 10h

    ; 4 Kom�u Pikseli Kontrol Et ve Gerekirse Y���na �t

    ; Sa� pikseli kontrol et (x+1, y)
    inc cx          ; X koordinat�n� art�r
    cmp cx, 319     ; Ekran�n sa� kenar�n� ge�mediyse (319, ��nk� 0-319 aras�)
    jg .no_right    ; Ge�tiyse kontrol etme
    mov ah, 0Dh     ; Piksel rengini oku
    int 10h         ; Okunan renk AL'de
    cmp al, bl      ; Okunan renk eski renkle ayn� m�?
    jne .no_right   ; Ayn� de�ilse (yani �izgiye geldiyse veya farkl� renkteyse) atla
    push dx         ; Y koordinat�n� y���na it
    push cx         ; X koordinat�n� y���na it
.no_right:
    dec cx          ; CX'i orijinal de�erine geri al

    ; Sol pikseli kontrol et (x-1, y)
    dec cx
    cmp cx, 0       ; Ekran�n sol kenar�n� ge�mediyse (0, ��nk� 0-319 aras�)
    jl .no_left
    mov ah, 0Dh
    int 10h
    cmp al, bl
    jne .no_left
    push dx
    push cx
.no_left:
    inc cx

    ; A�a�� pikseli kontrol et (x, y+1)
    inc dx
    cmp dx, 199     ; Ekran�n alt kenar�n� ge�mediyse (199, ��nk� 0-199 aras�)
    jg .no_down
    mov ah, 0Dh
    int 10h
    cmp al, bl
    jne .no_down
    push dx
    push cx
.no_down:
    dec dx

    ; Yukar� pikseli kontrol et (x, y-1)
    dec dx
    cmp dx, 0       ; Ekran�n �st kenar�n� ge�mediyse (0, ��nk� 0-199 aras�)
    jl .no_up
    mov ah, 0Dh
    int 10h
    cmp al, bl
    jne .no_up
    push dx
    push cx
.no_up:
    inc dx

    jmp .loop       ; D�ng�ye devam et

.end_fill_safety_exit: ; Y���n bo�ald���nda buraya gelinir.
.end_fill:
    popa            ; Kaydedilen t�m registerlar� geri y�kle
    ret             ; Prosed�rden ��k
flood_fill ENDP

; --- Flood Fill �a�r�lar� i�in Prosed�r ---
; CX ve DX'teki koordinatlar� al�p flood_fill'i �a��r�r.
call_flood_fill PROC
    ; flood_fill'e girmeden �nce stack'in bo� oldu�unu (veya ba�lang�� noktas�nda oldu�unu) kontrol edin
    ; ve stack_start_value'ye o anki SP de�erini kaydedin.
    mov [stack_start_value], sp ; Flood fill'e girmeden �nce SP'yi kaydet
    call flood_fill
    ret
call_flood_fill ENDP

end start