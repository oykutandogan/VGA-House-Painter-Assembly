.model small
.stack 2000h ; Stack boyutunu artýrdým (2000h = 8KB), Flood Fill için daha güvenli
.data
    selected_color db 4 ; baþlangýç rengi kýrmýzý (4)
    stack_start_value dw 0 ; Flood fill'e girerken SP'nin deðeri burada saklanacak
    
.code
start:
    mov ax, @data
    mov ds, ax

    mov ax, 0013h      ; 320x200 256 renk modu
    int 10h

    mov ax, 02h
    int 33h

    ; Evin dýþ hatlarýný çiz (açýk gri)
    mov al, 7h ; Çizgi rengi: açýk gri (7)

    ; -------------------------
    ; Evin dýþ hatlarý (çerçeve)
    ; -------------------------

    ; Üst yatay çizgi
    mov cx, 130
    mov dx, 75
hseT:
    mov ah, 0Ch
    int 10h
    inc cx
    cmp cx, 216
    jne hseT

    ; Alt yatay çizgi
    mov cx, 130
    mov dx, 125
hseB:
    mov ah, 0Ch
    int 10h
    inc cx
    cmp cx, 216
    jne hseB

    ; Sol dikey çizgi
    mov cx, 130
    mov dx, 75
hseL:
    mov ah, 0Ch
    int 10h
    inc dx
    cmp dx, 125
    jne hseL

    ; Sað dikey çizgi
    mov cx, 216
    mov dx, 75
hseR:
    mov ah, 0Ch
    int 10h
    inc dx
    cmp dx, 125
    jne hseR

    ; Sol çatý çizgisi (yukarý çapraz)
    mov cx, 130
    mov dx, 75
hseLR:
    mov ah, 0Ch
    int 10h
    inc cx
    dec dx
    cmp cx, 173
    jne hseLR

    ; Sað çatý çizgisi (aþaðý çapraz)
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
    ; Kapý çizimi
    ; -------------------------

    ; Sol kapý çizgisi
    mov cx, 164
    mov dx, 125
hseLD:
    mov ah, 0Ch
    int 10h
    dec dx
    cmp dx, 100
    jne hseLD

    ; Sað kapý çizgisi
    mov cx, 182
    mov dx, 125
hseRD:
    mov ah, 0Ch
    int 10h
    dec dx
    cmp dx, 100
    jne hseRD

    ; Kapý üst çizgisi
    mov cx, 164
    mov dx, 100
hseTD:
    mov ah, 0Ch
    int 10h
    inc cx
    cmp cx, 183
    jne hseTD

    ; -------------------------
    ; Sol pencere (dörtgen)
    ; -------------------------

    ; Sol pencere üst çizgi
    mov cx, 136
    mov dx, 85
win1_top:
    mov ah, 0Ch
    int 10h
    inc cx
    cmp cx, 157
    jne win1_top

    ; Sol pencere alt çizgi
    mov cx, 136
    mov dx, 105
win1_bottom:
    mov ah, 0Ch
    int 10h
    inc cx
    cmp cx, 157
    jne win1_bottom

    ; Sol pencere sol çizgi
    mov cx, 136
    mov dx, 85
win1_left:
    mov ah, 0Ch
    int 10h
    inc dx
    cmp dx, 106
    jne win1_left

    ; Sol pencere sað çizgi
    mov cx, 156
    mov dx, 85
win1_right:
    mov ah, 0Ch
    int 10h
    inc dx
    cmp dx, 106
    jne win1_right

    ; -------------------------
    ; Sað pencere (dörtgen)
    ; -------------------------

    ; Sað pencere üst çizgi
    mov cx, 190
    mov dx, 85
win2_top:
    mov ah, 0Ch
    int 10h
    inc cx
    cmp cx, 211
    jne win2_top

    ; Sað pencere alt çizgi
    mov cx, 190
    mov dx, 105
win2_bottom:
    mov ah, 0Ch
    int 10h
    inc cx
    cmp cx, 211
    jne win2_bottom

    ; Sað pencere sol çizgi
    mov cx, 190
    mov dx, 85
win2_left:
    mov ah, 0Ch
    int 10h
    inc dx
    cmp dx, 106
    jne win2_left

    ; Sað pencere sað çizgi
    mov cx, 210
    mov dx, 85
win2_right:
    mov ah, 0Ch
    int 10h
    inc dx
    cmp dx, 106
    jne win2_right

; --- Main Loop (Ana Döngü) ---
main_loop:
    ; Klavye kontrolü (tuþ basýlý mý?)
    mov ah,0            ; Klavyeden karakter oku (bekler)
    int 16h             ; AL = okunan karakter, AH = tarama kodu

    ; Renk seçimi tuþlarý
    cmp al,'1'
    je set_red
    cmp al,'2'
    je set_blue
    cmp al,'3'
    je set_green
    cmp al,'4'
    je set_pink

    ; Bölge boyama tuþlarý
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


    cmp al,27           ; ESC tuþu
    je exit_game
    
    jmp main_loop       ; Tanýmlý tuþ deðilse, döngüye devam et

; --- Renk Ayarlama Etiketleri ---
set_red:   mov selected_color,4   ; kýrmýzý
           jmp main_loop
set_blue:  mov selected_color,1   ; mavi
           jmp main_loop
set_green: mov selected_color,2   ; yeþil
           jmp main_loop
set_pink:  mov selected_color,13  ; pembe
           jmp main_loop

; --- Bölge Boyama Etiketleri (Klavye ile) ---
; Her bölge için sabit bir (X, Y) koordinatý belirleyin.
; Bu koordinatlar, boyanacak alanýn içinden olmalý ve sýnýr çizgisi olmamalýdýr.

paint_roof_kb:
    mov cx, 132 ; Çatý içi X koordinatý (yaklaþýk orta)
    mov dx, 74 ; Çatý içi Y koordinatý (yaklaþýk orta)
    call call_flood_fill
    jmp main_loop

paint_wall_kb:
    mov cx, 131 ; Duvar içi X koordinatý (yaklaþýk orta)
    mov dx, 76 ; Duvar içi Y koordinatý (yaklaþýk orta)
    call call_flood_fill
    jmp main_loop

paint_door_kb:
    mov cx, 181 ; Kapý içi X koordinatý (yaklaþýk orta)
    mov dx, 124 ; Kapý içi Y koordinatý (yaklaþýk orta)
    call call_flood_fill
    jmp main_loop

paint_left_window_kb:
    mov cx, 137 ; Sol pencere içi X koordinatý (yaklaþýk orta)
    mov dx, 86  ; Sol pencere içi Y koordinatý (yaklaþýk orta)
    call call_flood_fill
    jmp main_loop

paint_right_window_kb:
    mov cx, 191 ; Sað pencere içi X koordinatý (yaklaþýk orta)
    mov dx, 86  ; Sað pencere içi Y koordinatý (yaklaþýk orta)
    call call_flood_fill
    jmp main_loop

; --- Programdan Çýkýþ ---
exit_game:
    ; Fare imlecini gizle (çýkmadan önce)
    mov ax, 02h
    int 33h
    ; Text moda dön (opsiyonel)
    mov ax, 0003h
    int 10h

    ; Program sonu
    mov ax, 4c00h
    int 21h

; --- Flood Fill Prosedürü ---
; Bu prosedür, belirlenen bir noktadan baþlayarak ayný renkteki komþu pikselleri
; yeni renk ile doldurur. Grafik mod 13h (320x200) için uyarlanmýþtýr.
; CX = X koordinatý
; DX = Y koordinatý
; selected_color = Yeni renk
flood_fill PROC
    pusha
    
    ; 1. Týklanan noktanýn mevcut rengini oku (eski renk).
    mov ah, 0Dh     ; Piksel rengini oku
    int 10h         ; Okunan renk AL'de döner.
    mov bl, al      ; Okunan rengi BL'ye kaydet (eski renk)

    ; 2. Eðer týklanan noktanýn rengi zaten seçilen renkle aynýysa, boyama yapma.
    mov al, [selected_color] ; Seçilen renk
    cmp al, bl      
    je .end_fill

    ; 3. Eski renk, çizgi rengiyle (7h) aynýysa, boyama yapma.
    ; Bu kontrol, kullanýcý yanlýþlýkla çizgiye týklarsa boyamamayý saðlar.
    cmp bl, 7h
    je .end_fill

    ; Yýðýna it: Baþlangýç noktasýný yýðýna it.
    push dx ; Y koordinatýný yýðýna it
    push cx ; X koordinatýný yýðýna it

.loop:
    ; Yýðýnýn boþ olup olmadýðýný kontrol et
    cmp sp, [stack_start_value] ; Stack'in baþlangýç SP deðerine dönüp dönmediðini kontrol et
    je .end_fill_safety_exit ; Döngüden güvenli çýkýþ

    ; Yýðýndan (x, y) koordinatlarýný al
    pop cx
    pop dx
    
    ; Pikseli boya (Cx, Dx koordinatýndaki pikseli seçilen renge boya)
    mov ah, 0Ch
    mov al, [selected_color] ; Boyanacak renk
    int 10h

    ; 4 Komþu Pikseli Kontrol Et ve Gerekirse Yýðýna Ýt

    ; Sað pikseli kontrol et (x+1, y)
    inc cx          ; X koordinatýný artýr
    cmp cx, 319     ; Ekranýn sað kenarýný geçmediyse (319, çünkü 0-319 arasý)
    jg .no_right    ; Geçtiyse kontrol etme
    mov ah, 0Dh     ; Piksel rengini oku
    int 10h         ; Okunan renk AL'de
    cmp al, bl      ; Okunan renk eski renkle ayný mý?
    jne .no_right   ; Ayný deðilse (yani çizgiye geldiyse veya farklý renkteyse) atla
    push dx         ; Y koordinatýný yýðýna it
    push cx         ; X koordinatýný yýðýna it
.no_right:
    dec cx          ; CX'i orijinal deðerine geri al

    ; Sol pikseli kontrol et (x-1, y)
    dec cx
    cmp cx, 0       ; Ekranýn sol kenarýný geçmediyse (0, çünkü 0-319 arasý)
    jl .no_left
    mov ah, 0Dh
    int 10h
    cmp al, bl
    jne .no_left
    push dx
    push cx
.no_left:
    inc cx

    ; Aþaðý pikseli kontrol et (x, y+1)
    inc dx
    cmp dx, 199     ; Ekranýn alt kenarýný geçmediyse (199, çünkü 0-199 arasý)
    jg .no_down
    mov ah, 0Dh
    int 10h
    cmp al, bl
    jne .no_down
    push dx
    push cx
.no_down:
    dec dx

    ; Yukarý pikseli kontrol et (x, y-1)
    dec dx
    cmp dx, 0       ; Ekranýn üst kenarýný geçmediyse (0, çünkü 0-199 arasý)
    jl .no_up
    mov ah, 0Dh
    int 10h
    cmp al, bl
    jne .no_up
    push dx
    push cx
.no_up:
    inc dx

    jmp .loop       ; Döngüye devam et

.end_fill_safety_exit: ; Yýðýn boþaldýðýnda buraya gelinir.
.end_fill:
    popa            ; Kaydedilen tüm registerlarý geri yükle
    ret             ; Prosedürden çýk
flood_fill ENDP

; --- Flood Fill Çaðrýlarý için Prosedür ---
; CX ve DX'teki koordinatlarý alýp flood_fill'i çaðýrýr.
call_flood_fill PROC
    ; flood_fill'e girmeden önce stack'in boþ olduðunu (veya baþlangýç noktasýnda olduðunu) kontrol edin
    ; ve stack_start_value'ye o anki SP deðerini kaydedin.
    mov [stack_start_value], sp ; Flood fill'e girmeden önce SP'yi kaydet
    call flood_fill
    ret
call_flood_fill ENDP

end start