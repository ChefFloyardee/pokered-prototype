ViridianForestObject: ; 0x611da (size=127)
	db $2 ; border block

	db $6 ; warps
	db $0, $11, $2, VIRIDIAN_FOREST_EXIT
	db $0, $12, $3, VIRIDIAN_FOREST_EXIT
	db $2f, $f, $1, VIRIDIAN_FOREST_ENTRANCE
	db $2f, $10, $1, VIRIDIAN_FOREST_ENTRANCE
	db $2f, $11, $1, VIRIDIAN_FOREST_ENTRANCE
	db $2f, $12, $1, VIRIDIAN_FOREST_ENTRANCE

	db $6 ; signs
	db $a, $14, $9 ; ViridianForestText9
	db $12, $c, $a ; ViridianForestText10
	db $16, $1a, $b ; ViridianForestText11
	db $22, $6, $c ; ViridianForestText12
	db $2d, $12, $d ; ViridianForestText13
	db $3, $12, $e ; ViridianForestText14

	db $8 ; objects
	object SPRITE_BUG_CATCHER, $1b, $a, STAY, NONE, $1
	object SPRITE_BUG_CATCHER, $1f, $22, STAY, LEFT, $2, BUG_CATCHER + $C8, $1
	object SPRITE_BUG_CATCHER, $12, $1b, STAY, LEFT, $3, BUG_CATCHER + $C8, $2
	object SPRITE_BUG_CATCHER, $9, $5, STAY, LEFT, $4, BUG_CATCHER + $C8, $3
	object SPRITE_BALL, $c, $1b, STAY, NONE, $5, ANTIDOTE
	object SPRITE_BALL, $14, $5, STAY, NONE, $6, POTION
	object SPRITE_BALL, $2, $24, STAY, NONE, $7, POKE_BALL
	object SPRITE_BUG_CATCHER, $3, $20, STAY, NONE, $8

	; warp-to
	EVENT_DISP VIRIDIAN_FOREST_WIDTH, $0, $11 ; VIRIDIAN_FOREST_EXIT
	EVENT_DISP VIRIDIAN_FOREST_WIDTH, $0, $12 ; VIRIDIAN_FOREST_EXIT
	EVENT_DISP VIRIDIAN_FOREST_WIDTH, $2f, $f ; VIRIDIAN_FOREST_ENTRANCE
	EVENT_DISP VIRIDIAN_FOREST_WIDTH, $2f, $10 ; VIRIDIAN_FOREST_ENTRANCE
	EVENT_DISP VIRIDIAN_FOREST_WIDTH, $2f, $11 ; VIRIDIAN_FOREST_ENTRANCE
	EVENT_DISP VIRIDIAN_FOREST_WIDTH, $2f, $12 ; VIRIDIAN_FOREST_ENTRANCE
