UmbreonBaseStats: ; 3924e (e:524e)
db DEX_UMBREON ; pokedex id
db 55 ; base hp
db 55 ; base attack
db 50 ; base defense
db 55 ; base speed
db 65 ; base special
db NORMAL ; species type 1
db NORMAL ; species type 2
db 45 ; catch rate
db 92 ; base exp yield
INCBIN "pic/bmon/umbreon.pic",0,1 ; sprite dimensions
dw UmbreonPicFront
dw UmbreonPicBack
; attacks known at lvl 0
db TACKLE
db SAND_ATTACK
db 0
db 0
db 0 ; growth rate
; learnset
db %10100000
db %00000011
db %00001000
db %11000000
db %11000011
db %00001000
db %00000010
db BANK(UmbreonPicFront)
