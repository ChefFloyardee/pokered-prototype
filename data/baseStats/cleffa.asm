CleffaBaseStats:
db DEX_CLEFFA ; pokedex id
db 70 ; base hp
db 45 ; base attack
db 48 ; base defense
db 35 ; base speed
db 60 ; base special
db NORMAL ; species type 1
db NORMAL ; species type 2
db 150 ; catch rate
db 68 ; base exp yield
INCBIN "pic/bmon/cleffa.pic",0,1 ; sprite dimensions
dw CleffaPicFront
dw CleffaPicBack
; attacks known at lvl 0
db POUND
db GROWL
db 0
db 0
db 4 ; growth rate
; learnset
	tmlearn 1,5,6,8
	tmlearn 9,10,11,12,13,14
	tmlearn 17,18,19,20,22,24
	tmlearn 25,29,30,31,32
	tmlearn 33,34,35,38,40
	tmlearn 44,45,46
	tmlearn 49,50,54,55
db BANK(CleffaPicFront)