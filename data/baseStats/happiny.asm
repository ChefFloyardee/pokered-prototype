HappinyBaseStats: ; 3901e (e:501e)
db DEX_HAPPINY ; pokedex id
db 250 ; base hp
db 5 ; base attack
db 5 ; base defense
db 50 ; base speed
db 105 ; base special
db NORMAL ; species type 1
db NORMAL ; species type 2
db 30 ; catch rate
db 255 ; base exp yield
INCBIN "pic/bmon/happiny.pic",0,1 ; sprite dimensions
dw HappinyPicFront
dw HappinyPicBack
; attacks known at lvl 0
db POUND
db DOUBLESLAP
db 0
db 0
db 4 ; growth rate
; learnset
db %10110001
db %01111111
db %10101111
db %11110001
db %10110111
db %00111001
db %01100011
db BANK(HappinyPicFront)
