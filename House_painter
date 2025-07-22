.model small
.stack 2000h ; Stack boyutunu artırdım (2000h = 8KB), Flood Fill için daha güvenli
.data
    selected_color db 4 ; başlangıç rengi kırmızı (4)
    stack_start_value dw 0 ; Flood fill'e girerken SP'nin değeri burada saklanacak
    
.code
start:
    mov ax, @data
    mov ds, ax

    mov ax, 0013h      ; 320x200 256 renk modu
    int 10h

    mov ax, 02h
    int 33h

    ; Evin dış hatlarını çiz (açık gri)
    mov al, 7h ; Çizgi rengi: açık gri (7)

    ; -------------------------
    ; Evin dış hatları (çerçeve)
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

    ; Sağ dikey çizgi
    mov cx, 216
    mov dx, 75
hseR:
    mov ah, 0Ch
    int 10h
    inc dx
    cmp dx, 125
    jne hseR

    ; Sol çatı çizgisi (yukarı çapraz)
    mov cx, 130
    mov dx, 75
hseLR:
    mov ah, 0Ch
    int 10h
    inc cx
    dec dx
    cmp cx, 173
    jne hseLR

    ; Sağ çatı çizgisi (aşağı çapraz)
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
    ; Kapı çizimi
    ; -------------------------

    ; Sol kapı çizgisi
    mov cx, 164
    mov dx, 125
hseLD:
    mov ah, 0Ch
    int 10h
    dec dx
    cmp dx, 100
    jne hseLD

    ; Sağ kapı çizgisi
    mov cx, 182
    mov dx, 125
hseRD:
    mov ah, 0Ch
    int 10h
    dec dx
    cmp dx, 100
    jne hseRD

    ; Kapı üst çizgisi
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

    ; Sol pencere sağ çizgi
    mov cx, 156
    mov dx, 85
win1_right:
    mov ah, 0Ch
    int 10h
    inc dx
    cmp dx, 106
    jne win1_right

    ; -------------------------
    ; Sağ pencere (dörtgen)
    ; -------------------------

    ; Sağ pencere üst çizgi
    mov cx, 190
    mov dx, 85
win2_top:
    mov ah, 0Ch
    int 10h
    inc cx
    cmp cx, 211
    jne win2_top

    ; Sağ pencere alt çizgi
    mov cx, 190
    mov dx, 105
win2_bottom:
    mov ah, 0Ch
    int 10h
    inc cx
    cmp cx, 211
    jne win2_bottom

    ; Sağ pencere sol çizgi
    mov cx, 190
    mov dx, 85
win2_left:
    mov ah, 0Ch
    int 10h
    inc dx
    cmp dx, 106
    jne win2_left

    ; Sağ pencere sağ çizgi
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
    ; Klavye kontrolü (tuş basılı mı?)
    mov ah,0            ; Klavyeden karakter oku (bekler)
    int 16h             ; AL = okunan karakter, AH = tarama kodu

    ; Renk seçimi tuşları
    cmp al,'1'
    je set_red
    cmp al,'2'
    je set_blue
    cmp al,'3'
    je set_green
    cmp al,'4'
    je set_pink

    ; Bölge boyama tuşları
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


    cmp al,27           ; ESC tuşu
    je exit_game
    
    jmp main_loop       ; Tanımlı tuş değilse, döngüye devam et

; --- Renk Ayarlama Etiketleri ---
set_red:   mov selected_color,4   ; kırmızı
           jmp main_loop
set_blue:  mov selected_color,1   ; mavi
           jmp main_loop
set_green: mov selected_color,2   ; yeşil
           jmp main_loop
set_pink:  mov selected_color,13  ; pembe
           jmp main_loop

; --- Bölge Boyama Etiketleri (Klavye ile) ---
; Her bölge için sabit bir (X, Y) koordinatı belirleyin.
; Bu koordinatlar, boyanacak alanın içinden olmalı ve sınır çizgisi olmamalıdır.

paint_roof_kb:
    mov cx, 132 ; Çatı içi X koordinatı (yaklaşık orta)
    mov dx, 74 ; Çatı içi Y koordinatı (yaklaşık orta)
    call call_flood_fill
    jmp main_loop

paint_wall_kb:
    mov cx, 131 ; Duvar içi X koordinatı (yaklaşık orta)
    mov dx, 76 ; Duvar içi Y koordinatı (yaklaşık orta)
    call call_flood_fill
    jmp main_loop

paint_door_kb:
    mov cx, 181 ; Kapı içi X koordinatı (yaklaşık orta)
    mov dx, 124 ; Kapı içi Y koordinatı (yaklaşık orta)
    call call_flood_fill
    jmp main_loop

paint_left_window_kb:
    mov cx, 137 ; Sol pencere içi X koordinatı (yaklaşık orta)
    mov dx, 86  ; Sol pencere içi Y koordinatı (yaklaşık orta)
    call call_flood_fill
    jmp main_loop

paint_right_window_kb:
    mov cx, 191 ; Sağ pencere içi X koordinatı (yaklaşık orta)
    mov dx, 86  ; Sağ pencere içi Y koordinatı (yaklaşık orta)
    call call_flood_fill
    jmp main_loop

; --- Programdan Çıkış ---
exit_game:
    ; Fare imlecini gizle (çıkmadan önce)
    mov ax, 02h
    int 33h
    ; Text moda dön (opsiyonel)
    mov ax, 0003h
    int 10h

    ; Program sonu
    mov ax, 4c00h
    int 21h

; --- Flood Fill Prosedürü ---
; Bu prosedür, belirlenen bir noktadan başlayarak aynı renkteki komşu pikselleri
; yeni renk ile doldurur. Grafik mod 13h (320x200) için uyarlanmıştır.
; CX = X koordinatı
; DX = Y koordinatı
; selected_color = Yeni renk
flood_fill PROC
    pusha
    
    ; 1. Tıklanan noktanın mevcut rengini oku (eski renk).
    mov ah, 0Dh     ; Piksel rengini oku
    int 10h         ; Okunan renk AL'de döner.
    mov bl, al      ; Okunan rengi BL'ye kaydet (eski renk)

    ; 2. Eğer tıklanan noktanın rengi zaten seçilen renkle aynıysa, boyama yapma.
    mov al, [selected_color] ; Seçilen renk
    cmp al, bl      
    je .end_fill

    ; 3. Eski renk, çizgi rengiyle (7h) aynıysa, boyama yapma.
    ; Bu kontrol, kullanıcı yanlışlıkla çizgiye tıklarsa boyamamayı sağlar.
    cmp bl, 7h
    je .end_fill

    ; Yığına it: Başlangıç noktasını yığına it.
    push dx ; Y koordinatını yığına it
    push cx ; X koordinatını yığına it

.loop:
    ; Yığının boş olup olmadığını kontrol et
    cmp sp, [stack_start_value] ; Stack'in başlangıç SP değerine dönüp dönmediğini kontrol et
    je .end_fill_safety_exit ; Döngüden güvenli çıkış

    ; Yığından (x, y) koordinatlarını al
    pop cx
    pop dx
    
    ; Pikseli boya (Cx, Dx koordinatındaki pikseli seçilen renge boya)
    mov ah, 0Ch
    mov al, [selected_color] ; Boyanacak renk
    int 10h

    ; 4 Komşu Pikseli Kontrol Et ve Gerekirse Yığına İt

    ; Sağ pikseli kontrol et (x+1, y)
    inc cx          ; X koordinatını artır
    cmp cx, 319     ; Ekranın sağ kenarını geçmediyse (319, çünkü 0-319 arası)
    jg .no_right    ; Geçtiyse kontrol etme
    mov ah, 0Dh     ; Piksel rengini oku
    int 10h         ; Okunan renk AL'de
    cmp al, bl      ; Okunan renk eski renkle aynı mı?
    jne .no_right   ; Aynı değilse (yani çizgiye geldiyse veya farklı renkteyse) atla
    push dx         ; Y koordinatını yığına it
    push cx         ; X koordinatını yığına it
.no_right:
    dec cx          ; CX'i orijinal değerine geri al

    ; Sol pikseli kontrol et (x-1, y)
    dec cx
    cmp cx, 0       ; Ekranın sol kenarını geçmediyse (0, çünkü 0-319 arası)
    jl .no_left
    mov ah, 0Dh
    int 10h
    cmp al, bl
    jne .no_left
    push dx
    push cx
.no_left:
    inc cx

    ; Aşağı pikseli kontrol et (x, y+1)
    inc dx
    cmp dx, 199     ; Ekranın alt kenarını geçmediyse (199, çünkü 0-199 arası)
    jg .no_down
    mov ah, 0Dh
    int 10h
    cmp al, bl
    jne .no_down
    push dx
    push cx
.no_down:
    dec dx

    ; Yukarı pikseli kontrol et (x, y-1)
    dec dx
    cmp dx, 0       ; Ekranın üst kenarını geçmediyse (0, çünkü 0-199 arası)
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

.end_fill_safety_exit: ; Yığın boşaldığında buraya gelinir.
.end_fill:
    popa            ; Kaydedilen tüm registerları geri yükle
    ret             ; Prosedürden çık
flood_fill ENDP

; --- Flood Fill Çağrıları için Prosedür ---
; CX ve DX'teki koordinatları alıp flood_fill'i çağırır.
call_flood_fill PROC
    ; flood_fill'e girmeden önce stack'in boş olduğunu (veya başlangıç noktasında olduğunu) kontrol edin
    ; ve stack_start_value'ye o anki SP değerini kaydedin.
    mov [stack_start_value], sp ; Flood fill'e girmeden önce SP'yi kaydet
    call flood_fill
    ret
call_flood_fill ENDP

end start
