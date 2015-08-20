MagmortarBaseStats:
db DEX_MAGMORTAR ; pokedex id
db 65 ; base hp
db 95 ; base attack
db 57 ; base defense
db 93 ; base speed
db 85 ; base special
db FIRE ; species type 1
db FIRE ; species type 2
db 45 ; catch rate
db 167 ; base exp yield
INCBIN "pic/bmon/magmortar.pic",0,1 ; sprite dimensions
dw MagmortarPicFront
dw MagmortarPicBack
; attacks known at lvl 0
db EMBER
db 0
db 0
db 0
db 0 ; growth rate
; learnset
	tmlearn 1,5,6,8
	tmlearn 9,10,15
	tmlearn 17,18,19,20
	tmlearn 29,30,31,32
	tmlearn 34,35,38,40
	tmlearn 44,46
	tmlearn 50,54
db BANK(MagmortarPicFront)