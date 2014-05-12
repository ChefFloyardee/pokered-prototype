; The third of three duplicated sound engines.

Func_7d177: ; 7d177 (1f:5177)
	ld c, CH0
.loop
	ld b, $0
	ld hl, $c026
	add hl, bc
	ld a, [hl]
	and a
	jr z, .nextChannel
	ld a, c
	cp CH4
	jr nc, .applyAffects ; if sfx channel
	ld a, [$c002]
	and a
	jr z, .applyAffects
	bit 7, a
	jr nz, .nextChannel
	set 7, a
	ld [$c002], a
	xor a
	ld [$FF00+$25], a
	ld [$FF00+$1a], a
	ld a, $80
	ld [$FF00+$1a], a
	jr .nextChannel
.applyAffects
	call Music1f_Music2_ApplyMusicAffects
.nextChannel
	ld a, c
	inc c ; inc channel number
	cp CH7
	jr nz, .loop
	ret

; this routine checks flags for music effects currently applied
; to the channel and calls certain functions based on flags.
; known flags for $c02e:
;	1: call has been used
;	3: a toggle used only by this routine for vibrato
;	4: pitchbend flag
;	6: dutycycle flag
Music1f_Music2_ApplyMusicAffects: ; 7d1ac (1f:51ac)
	ld b, $0
	ld hl, $c0b6 ; delay until next note
	add hl, bc
	ld a, [hl]
	cp $1 ; if delay is 1, play next note
	jp z, Music1f_Music2_PlayNextNote
	dec a ; otherwise, decrease the delay timer
	ld [hl], a
	ld a, c
	cp CH4
	jr nc, .startChecks ; if a sfx channel
	ld hl, $c02a
	add hl, bc
	ld a, [hl]
	and a
	jr z, .startChecks
	ret
.startChecks
	ld hl, $c02e
	add hl, bc
	bit 6, [hl] ; dutycycle
	jr z, .checkForExecuteMusic
	call Music1f_ApplyDutyCycle
.checkForExecuteMusic
	ld b, $0
	ld hl, $c036
	add hl, bc
	bit 0, [hl]
	jr nz, .checkForPitchBend
	ld hl, $c02e
	add hl, bc
	bit 2, [hl]
	jr nz, .disablePitchBendVibrato
.checkForPitchBend
	ld hl, $c02e
	add hl, bc
	bit 4, [hl] ; pitchbend
	jr z, .checkVibratoDelay
	jp Music1f_ApplyPitchBend
.checkVibratoDelay
	ld hl, $c04e ; vibrato delay
	add hl, bc
	ld a, [hl]
	and a ; check if delay is over
	jr z, .checkForVibrato
	dec [hl] ; otherwise, dec delay
.disablePitchBendVibrato
	ret
.checkForVibrato
	ld hl, $c056 ; vibrato rate
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .vibrato
	ret ; no vibrato
.vibrato
	ld d, a
	ld hl, $c05e
	add hl, bc
	ld a, [hl]
	and $f
	and a
	jr z, .vibratoAlreadyDone
	dec [hl] ; apply vibrato pitch change
	ret
.vibratoAlreadyDone
	ld a, [hl]
	swap [hl]
	or [hl]
	ld [hl], a ; reset the vibrato value and start again
	ld hl, $c066
	add hl, bc
	ld e, [hl] ; get note pitch
	ld hl, $c02e
	add hl, bc
	bit 3, [hl] ; this is the only code that sets/resets bit three so
	jr z, .unset ; it continuously alternates which path it takes
	res 3, [hl]
	ld a, d
	and $f
	ld d, a
	ld a, e
	sub d
	jr nc, .noCarry
	ld a, $0
.noCarry
	jr .done
.unset
	set 3, [hl]
	ld a, d
	and $f0
	swap a
	add e
	jr nc, .done
	ld a, $ff
.done
	ld d, a
	ld b, $3
	call Func_7d8ac
	ld [hl], d
	ret

; this routine executes all music commands that take up no time,
; like tempo changes, duty changes etc. and doesn't return
; until the first note is reached
Music1f_Music2_PlayNextNote: ; 7d244 (1f:5244)
	ld hl, $c06e
	add hl, bc
	ld a, [hl]
	ld hl, $c04e
	add hl, bc
	ld [hl], a
	ld hl, $c02e
	add hl, bc
	res 4, [hl]
	res 5, [hl]
	call Music1f_endchannel
	ret

Music1f_endchannel: ; 7d25a (1f:525a)
	call Music1f_GetNextMusicByte
	ld d, a
	cp $ff ; is this command an endchannel?
	jp nz, Music1f_callchannel ; no
	ld b, $0 ; yes
	ld hl, $c02e
	add hl, bc
	bit 1, [hl]
	jr nz, .returnFromCall
	ld a, c
	cp CH3
	jr nc, .noiseOrSfxChannel
	jr .asm_7d2b3
.noiseOrSfxChannel
	res 2, [hl]
	ld hl, $c036
	add hl, bc
	res 0, [hl]
	cp CH6
	jr nz, .notSfxChannel3
	ld a, $0
	ld [$FF00+$1a], a
	ld a, $80
	ld [$FF00+$1a], a
.notSfxChannel3
	jr nz, .asm_7d296
	ld a, [$c003]
	and a
	jr z, .asm_7d296
	xor a
	ld [$c003], a
	jr .asm_7d2b3
.asm_7d296
	jr .asm_7d2bc
.returnFromCall
	res 1, [hl]
	ld d, $0
	ld a, c
	add a
	ld e, a
	ld hl, $c006
	add hl, de
	push hl ; store current channel address
	ld hl, $c016
	add hl, de
	ld e, l
	ld d, h
	pop hl
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hl], a ; loads channel address to return to
	jp Music1f_endchannel
.asm_7d2b3
	ld hl, Unknown_7db93
	add hl, bc
	ld a, [$FF00+$25]
	and [hl]
	ld [$FF00+$25], a
.asm_7d2bc
	ld a, [$c02a]
	cp $14
	jr nc, .asm_7d2c5
	jr .asm_7d2e2
.asm_7d2c5
	ld a, [$c02a]
	cp $86
	jr z, .asm_7d2e2
	jr c, .asm_7d2d0
	jr .asm_7d2e2
.asm_7d2d0
	ld a, c
	cp CH4
	jr z, .asm_7d2d9
	call Func_7d73b
	ret c
.asm_7d2d9
	ld a, [$c005]
	ld [$FF00+$24], a
	xor a
	ld [$c005], a
.asm_7d2e2
	ld hl, $c026
	add hl, bc
	ld [hl], b
	ret

Music1f_callchannel: ; 7d2e8 (1f:52e8)
	cp $fd ; is this command a callchannel?
	jp nz, Music1f_loopchannel ; no
	call Music1f_GetNextMusicByte ; yes
	push af
	call Music1f_GetNextMusicByte
	ld d, a
	pop af
	ld e, a
	push de ; store pointer
	ld d, $0
	ld a, c
	add a
	ld e, a
	ld hl, $c006
	add hl, de
	push hl
	ld hl, $c016
	add hl, de
	ld e, l
	ld d, h
	pop hl
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hld]
	ld [de], a ; copy current channel address
	pop de
	ld [hl], e
	inc hl
	ld [hl], d ; overwrite current address with pointer
	ld b, $0
	ld hl, $c02e
	add hl, bc
	set 1, [hl] ; set the call flag
	jp Music1f_endchannel

Music1f_loopchannel: ; 7d31d (1f:531d)
	cp $fe ; is this command a loopchannel?
	jp nz, Music1f_notetype ; no
	call Music1f_GetNextMusicByte ; yes
	ld e, a
	and a
	jr z, .infiniteLoop
	ld b, $0
	ld hl, $c0be
	add hl, bc
	ld a, [hl]
	cp e
	jr nz, .loopAgain
	ld a, $1 ; if no more loops to make
	ld [hl], a
	call Music1f_GetNextMusicByte ; skip pointer
	call Music1f_GetNextMusicByte
	jp Music1f_endchannel
.loopAgain ; inc loop count
	inc a
	ld [hl], a
	; fall through
.infiniteLoop ; overwrite current address with pointer
	call Music1f_GetNextMusicByte
	push af
	call Music1f_GetNextMusicByte
	ld b, a
	ld d, $0
	ld a, c
	add a
	ld e, a
	ld hl, $c006
	add hl, de
	pop af
	ld [hli], a
	ld [hl], b
	jp Music1f_endchannel

Music1f_notetype: ; 7d358 (1f:5358)
	and $f0
	cp $d0 ; is this command a notetype?
	jp nz, Music1f_togglecall ; no
	ld a, d ; yes
	and $f
	ld b, $0
	ld hl, $c0c6
	add hl, bc
	ld [hl], a ; store low nibble as speed
	ld a, c
	cp CH3
	jr z, .noiseChannel ; noise channel has 0 params
	call Music1f_GetNextMusicByte
	ld d, a
	ld a, c
	cp CH2
	jr z, .musicChannel3
	cp CH6
	jr nz, .notChannel3
	ld hl, $c0e7
	jr .sfxChannel3
.musicChannel3
	ld hl, $c0e6
.sfxChannel3
	ld a, d
	and $f
	ld [hl], a ; store low nibble of param as duty
	ld a, d
	and $30
	sla a
	ld d, a
	; fall through

	; if channel 3, store high nibble as volume
	; else, store volume (high nibble) and fade (low nibble)
.notChannel3
	ld b, $0
	ld hl, $c0de
	add hl, bc
	ld [hl], d
.noiseChannel
	jp Music1f_endchannel

Music1f_togglecall: ; 7d397 (1f:5397)
	ld a, d
	cp $e8 ; is this command an togglecall?
	jr nz, Music1f_vibrato ; no
	ld b, $0 ; yes
	ld hl, $c02e
	add hl, bc
	ld a, [hl]
	xor $1
	ld [hl], a ; flip bit 0 of $c02e (toggle returning from call)
	jp Music1f_endchannel

Music1f_vibrato: ; 7d3a9 (1f:53a9)
	cp $ea ; is this command a vibrato?
	jr nz, Music1f_pitchbend ; no
	call Music1f_GetNextMusicByte ; yes
	ld b, $0
	ld hl, $c04e
	add hl, bc
	ld [hl], a ; store delay
	ld hl, $c06e
	add hl, bc
	ld [hl], a ; store delay
	call Music1f_GetNextMusicByte
	ld d, a
	and $f0
	swap a
	ld b, $0
	ld hl, $c056
	add hl, bc
	srl a
	ld e, a
	adc b
	swap a
	or e
	ld [hl], a ; store rate as both high and low nibbles
	ld a, d
	and $f
	ld d, a
	ld hl, $c05e
	add hl, bc
	swap a
	or d
	ld [hl], a ; store depth as both high and low nibbles
	jp Music1f_endchannel

Music1f_pitchbend: ; 7d3e1 (1f:53e1)
	cp $eb ; is this command a pitchbend?
	jr nz, Music1f_duty ; no
	call Music1f_GetNextMusicByte ; yes
	ld b, $0
	ld hl, $c076
	add hl, bc
	ld [hl], a ; store first param
	call Music1f_GetNextMusicByte
	ld d, a
	and $f0
	swap a
	ld b, a
	ld a, d
	and $f
	call Func_7d8cc
	ld b, $0
	ld hl, $c0a6
	add hl, bc
	ld [hl], d ; store unknown part of second param
	ld hl, $c0ae
	add hl, bc
	ld [hl], e ; store unknown part of second param
	ld b, $0
	ld hl, $c02e
	add hl, bc
	set 4, [hl] ; set pitchbend flag
	call Music1f_GetNextMusicByte
	ld d, a
	jp Music1f_notelength

Music1f_duty: ; 7d419 (1f:5419)
	cp $ec ; is this command a duty?
	jr nz, Music1f_tempo ; no
	call Music1f_GetNextMusicByte ; yes
	rrca
	rrca
	and $c0
	ld b, $0
	ld hl, $c03e
	add hl, bc
	ld [hl], a ; store duty
	jp Music1f_endchannel

Music1f_tempo: ; 7d42e (1f:542e)
	cp $ed ; is this command a tempo?
	jr nz, Music1f_unknownmusic0xee ; no
	ld a, c ; yes
	cp CH4
	jr nc, .sfxChannel
	call Music1f_GetNextMusicByte
	ld [$c0e8], a ; store first param
	call Music1f_GetNextMusicByte
	ld [$c0e9], a ; store second param
	xor a
	ld [$c0ce], a ; clear RAM
	ld [$c0cf], a
	ld [$c0d0], a
	ld [$c0d1], a
	jr .musicChannelDone
.sfxChannel
	call Music1f_GetNextMusicByte
	ld [$c0ea], a ; store first param
	call Music1f_GetNextMusicByte
	ld [$c0eb], a ; store second param
	xor a
	ld [$c0d2], a ; clear RAM
	ld [$c0d3], a
	ld [$c0d4], a
	ld [$c0d5], a
.musicChannelDone
	jp Music1f_endchannel

Music1f_unknownmusic0xee: ; 7d46e (1f:546e)
	cp $ee ; is this command an unknownmusic0xee?
	jr nz, Music1f_unknownmusic0xef ; no
	call Music1f_GetNextMusicByte ; yes
	ld [$c004], a ; store first param
	jp Music1f_endchannel

; this appears to never be used
Music1f_unknownmusic0xef: ; 7d47b (1f:547b)
	cp $ef ; is this command an unknownmusic0xef?
	jr nz, Music1f_dutycycle ; no
	call Music1f_GetNextMusicByte ; yes
	push bc
	call Func_7d8ea
	pop bc
	ld a, [$c003]
	and a
	jr nz, .skip
	ld a, [$c02d]
	ld [$c003], a
	xor a
	ld [$c02d], a
.skip
	jp Music1f_endchannel

Music1f_dutycycle: ; 7d49a (1f:549a)
	cp $fc ; is this command a dutycycle?
	jr nz, Music1f_stereopanning ; no
	call Music1f_GetNextMusicByte ; yes
	ld b, $0
	ld hl, $c046
	add hl, bc
	ld [hl], a ; store full cycle
	and $c0
	ld hl, $c03e
	add hl, bc
	ld [hl], a ; store first duty
	ld hl, $c02e
	add hl, bc
	set 6, [hl] ; set duty flag
	jp Music1f_endchannel

Music1f_stereopanning: ; 7d4b8 (1f:54b8)
	cp $f0 ; is this command a stereopanning?
	jr nz, Music1f_executemusic ; no
	call Music1f_GetNextMusicByte ; yes
	ld [$FF00+$24], a ; store stereopanning
	jp Music1f_endchannel

Music1f_executemusic: ; 7d4c4 (1f:54c4)
	cp $f8 ; is this command an executemusic?
	jr nz, Music1f_octave ; no
	ld b, $0 ; yes
	ld hl, $c036
	add hl, bc
	set 0, [hl]
	jp Music1f_endchannel

Music1f_octave: ; 7d4d3 (1f:54d3)
	and $f0
	cp $e0 ; is this command an octave?
	jr nz, Music1f_unknownsfx0x20 ; no
	ld hl, $c0d6 ; yes
	ld b, $0
	add hl, bc
	ld a, d
	and $f
	ld [hl], a ; store low nibble as octave
	jp Music1f_endchannel

Music1f_unknownsfx0x20: ; 7d4e6 (1f:54e6)
	cp $20 ; is this command an unknownsfx0x20?
	jr nz, Music1f_unknownsfx0x10 ; no
	ld a, c
	cp CH3 ; is this a noise or sfx channel?
	jr c, Music1f_unknownsfx0x10 ; no
	ld b, $0
	ld hl, $c036
	add hl, bc
	bit 0, [hl]
	jr nz, Music1f_unknownsfx0x10 ; no
	call Music1f_notelength ; yes
	ld d, a
	ld b, $0
	ld hl, $c03e
	add hl, bc
	ld a, [hl]
	or d
	ld d, a
	ld b, $1
	call Func_7d8ac
	ld [hl], d
	call Music1f_GetNextMusicByte
	ld d, a
	ld b, $2
	call Func_7d8ac
	ld [hl], d
	call Music1f_GetNextMusicByte
	ld e, a
	ld a, c
	cp CH7
	ld a, $0
	jr z, .sfxNoiseChannel ; only two params for noise channel
	push de
	call Music1f_GetNextMusicByte
	pop de
.sfxNoiseChannel
	ld d, a
	push de
	call Func_7d69d
	call Func_7d66c
	pop de
	call Func_7d6bf
	ret

Music1f_unknownsfx0x10 ; 7d533 (1f:5533)
	ld a, c
	cp CH4
	jr c, Music1f_note ; if not a sfx
	ld a, d
	cp $10 ; is this command an unknownsfx0x10?
	jr nz, Music1f_note ; no
	ld b, $0
	ld hl, $c036
	add hl, bc
	bit 0, [hl]
	jr nz, Music1f_note ; no
	call Music1f_GetNextMusicByte ; yes
	ld [$FF00+$10], a
	jp Music1f_endchannel

Music1f_note: ; 7d54f (1f:554f)
	ld a, c
	cp CH3
	jr nz, Music1f_notelength ; if not noise channel
	ld a, d
	and $f0
	cp $b0 ; is this command a dnote?
	jr z, Music1f_dnote ; yes
	jr nc, Music1f_notelength ; no
	swap a
	ld b, a
	ld a, d
	and $f
	ld d, a
	ld a, b
	push de
	push bc
	jr asm_7d571

Music1f_dnote: ; 7d569 (1f:5569)
	ld a, d
	and $f
	push af
	push bc
	call Music1f_GetNextMusicByte ; get dnote instrument
asm_7d571
	ld d, a
	ld a, [$c003]
	and a
	jr nz, .asm_7d57c
	ld a, d
	call Func_7d8ea
.asm_7d57c
	pop bc
	pop de

Music1f_notelength: ; 7d57e (1f:557e)
	ld a, d
	push af
	and $f
	inc a
	ld b, $0
	ld e, a  ; store note length (in 16ths)
	ld d, b
	ld hl, $c0c6
	add hl, bc
	ld a, [hl]
	ld l, b
	call Func_7d8bb
	ld a, c
	cp CH4
	jr nc, .sfxChannel
	ld a, [$c0e8]
	ld d, a
	ld a, [$c0e9]
	ld e, a
	jr .skip
.sfxChannel
	ld d, $1
	ld e, $0
	cp CH7
	jr z, .skip ; if noise channel
	call Func_7d707
	ld a, [$c0ea]
	ld d, a
	ld a, [$c0eb]
	ld e, a
.skip
	ld a, l
	ld b, $0
	ld hl, $c0ce
	add hl, bc
	ld l, [hl]
	call Func_7d8bb
	ld e, l
	ld d, h
	ld hl, $c0ce
	add hl, bc
	ld [hl], e
	ld a, d
	ld hl, $c0b6
	add hl, bc
	ld [hl], a
	ld hl, $c036
	add hl, bc
	bit 0, [hl]
	jr nz, Music1f_notepitch
	ld hl, $c02e
	add hl, bc
	bit 2, [hl]
	jr z, Music1f_notepitch
	pop hl
	ret

Music1f_notepitch: ; 7d5dc (1f:55dc)
	pop af
	and $f0
	cp $c0 ; compare to rest
	jr nz, .notRest
	ld a, c
	cp CH4
	jr nc, .sfxChannel
	ld hl, $c02a
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .quit
	; fall through
.sfxChannel
	ld a, c
	cp CH2
	jr z, .musicChannel3
	cp CH6
	jr nz, .notSfxChannel3
.musicChannel3
	ld b, $0
	ld hl, Unknown_7db93
	add hl, bc
	ld a, [$FF00+$25]
	and [hl]
	ld [$FF00+$25], a
	jr .quit
.notSfxChannel3
	ld b, $2
	call Func_7d8ac
	ld a, $8
	ld [hli], a
	inc hl
	ld a, $80
	ld [hl], a
.quit
	ret
.notRest
	swap a
	ld b, $0
	ld hl, $c0d6
	add hl, bc
	ld b, [hl]
	call Func_7d8cc
	ld b, $0
	ld hl, $c02e
	add hl, bc
	bit 4, [hl]
	jr z, .asm_7d62c
	call Func_7d803
.asm_7d62c
	push de
	ld a, c
	cp CH4
	jr nc, .skip ; if sfx Channel
	ld hl, $c02a
	ld d, $0
	ld e, a
	add hl, de
	ld a, [hl]
	and a
	jr nz, .done
	jr .skip
.done
	pop de
	ret
.skip
	ld b, $0
	ld hl, $c0de
	add hl, bc
	ld d, [hl]
	ld b, $2
	call Func_7d8ac
	ld [hl], d
	call Func_7d69d
	call Func_7d66c
	pop de
	ld b, $0
	ld hl, $c02e
	add hl, bc
	bit 0, [hl]
	jr z, .asm_7d663
	inc e
	jr nc, .asm_7d663
	inc d
.asm_7d663
	ld hl, $c066
	add hl, bc
	ld [hl], e
	call Func_7d6bf
	ret

Func_7d66c: ; 7d66c (1f:566c)
	ld b, $0
	ld hl, Unknown_7db9b
	add hl, bc
	ld a, [$FF00+$25]
	or [hl]
	ld d, a
	ld a, c
	cp CH7
	jr z, .sfxNoiseChannel
	cp CH4
	jr nc, .skip ; if sfx channel
	ld hl, $c02a
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .skip
.sfxNoiseChannel
	ld a, [$c004]
	ld hl, Unknown_7db9b
	add hl, bc
	and [hl]
	ld d, a
	ld a, [$FF00+$25]
	ld hl, Unknown_7db93
	add hl, bc
	and [hl]
	or d
	ld d, a
.skip
	ld a, d
	ld [$FF00+$25], a
	ret

Func_7d69d: ; 7d69d (1f:569d)
	ld b, $0
	ld hl, $c0b6
	add hl, bc
	ld d, [hl]
	ld a, c
	cp CH2
	jr z, .channel3 ; if music channel 3
	cp CH6
	jr z, .channel3 ; if sfx channel 3
	ld a, d
	and $3f
	ld d, a
	ld hl, $c03e
	add hl, bc
	ld a, [hl]
	or d
	ld d, a
.channel3
	ld b, $1
	call Func_7d8ac
	ld [hl], d
	ret

Func_7d6bf: ; 7d6bf (1f:56bf)
	ld a, c
	cp CH2
	jr z, .channel3
	cp CH6
	jr nz, .notSfxChannel3
	; fall through
.channel3
	push de
	ld de, $c0e6
	cp CH2
	jr z, .musicChannel3
	ld de, $c0e7
.musicChannel3
	ld a, [de]
	add a
	ld d, $0
	ld e, a
	ld hl, Music1f_Channel3DutyPointers
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, $ff30
	ld b, $f
	ld a, $0
	ld [$FF00+$1a], a
.loop
	ld a, [de]
	inc de
	ld [hli], a
	ld a, b
	dec b
	and a
	jr nz, .loop
	ld a, $80
	ld [$FF00+$1a], a
	pop de
.notSfxChannel3
	ld a, d
	or $80
	and $c7
	ld d, a
	ld b, $3
	call Func_7d8ac
	ld [hl], e
	inc hl
	ld [hl], d
	call Func_7d729
	ret

Func_7d707: ; 7d707 (1f:5707)
	call Func_7d759
	jr nc, .asm_7d71f
	ld d, $0
	ld a, [$c0f2]
	add $80
	jr nc, .asm_7d716
	inc d
.asm_7d716
	ld [$c0eb], a
	ld a, d
	ld [$c0ea], a
	jr .asm_7d728
.asm_7d71f
	xor a
	ld [$c0eb], a
	ld a, $1
	ld [$c0ea], a
.asm_7d728
	ret

Func_7d729: ; 7d729 (1f:5729)
	call Func_7d759
	jr nc, .asm_7d73a
	ld a, [$c0f1]
	add e
	jr nc, .asm_7d735
	inc d
.asm_7d735
	dec hl
	ld e, a
	ld [hl], e
	inc hl
	ld [hl], d
.asm_7d73a
	ret

Func_7d73b: ; 7d73b (1f:573b)
	call Func_7d759
	jr nc, .asm_7d756
	ld hl, $c006
	ld e, c
	ld d, $0
	sla e
	rl d
	add hl, de
	ld a, [hl]
	sub $1
	ld [hl], a
	inc hl
	ld a, [hl]
	sbc $0
	ld [hl], a
	scf
	ret
.asm_7d756
	scf
	ccf
	ret

Func_7d759: ; 7d759 (1f:5759)
	ld a, [$c02a]
	cp $14
	jr nc, .asm_7d762
	jr .asm_7d768
.asm_7d762
	cp $86
	jr z, .asm_7d768
	jr c, .asm_7d76b
.asm_7d768
	scf
	ccf
	ret
.asm_7d76b
	scf
	ret

Music1f_ApplyPitchBend: ; 7d76d (1f:576d)
	ld hl, $c02e
	add hl, bc
	bit 5, [hl]
	jp nz, .asm_7d7b4
	ld hl, $c09e
	add hl, bc
	ld e, [hl]
	ld hl, $c096
	add hl, bc
	ld d, [hl]
	ld hl, $c07e
	add hl, bc
	ld l, [hl]
	ld h, b
	add hl, de
	ld d, h
	ld e, l
	ld hl, $c08e
	add hl, bc
	push hl
	ld hl, $c086
	add hl, bc
	ld a, [hl]
	pop hl
	add [hl]
	ld [hl], a
	ld a, $0
	adc e
	ld e, a
	ld a, $0
	adc d
	ld d, a
	ld hl, $c0a6
	add hl, bc
	ld a, [hl]
	cp d
	jp c, .asm_7d7fa
	jr nz, .asm_7d7e7
	ld hl, $c0ae
	add hl, bc
	ld a, [hl]
	cp e
	jp c, .asm_7d7fa
	jr .asm_7d7e7
.asm_7d7b4
	ld hl, $c09e
	add hl, bc
	ld a, [hl]
	ld hl, $c096
	add hl, bc
	ld d, [hl]
	ld hl, $c07e
	add hl, bc
	ld e, [hl]
	sub e
	ld e, a
	ld a, d
	sbc b
	ld d, a
	ld hl, $c086
	add hl, bc
	ld a, [hl]
	add a
	ld [hl], a
	ld a, e
	sbc b
	ld e, a
	ld a, d
	sbc b
	ld d, a
	ld hl, $c0a6
	add hl, bc
	ld a, d
	cp [hl]
	jr c, .asm_7d7fa
	jr nz, .asm_7d7e7
	ld hl, $c0ae
	add hl, bc
	ld a, e
	cp [hl]
	jr c, .asm_7d7fa
.asm_7d7e7
	ld hl, $c09e
	add hl, bc
	ld [hl], e
	ld hl, $c096
	add hl, bc
	ld [hl], d
	ld b, $3
	call Func_7d8ac
	ld a, e
	ld [hli], a
	ld [hl], d
	ret
.asm_7d7fa
	ld hl, $c02e
	add hl, bc
	res 4, [hl]
	res 5, [hl]
	ret

Func_7d803: ; 7d803 (1f:5803)
	ld hl, $c096
	add hl, bc
	ld [hl], d
	ld hl, $c09e
	add hl, bc
	ld [hl], e
	ld hl, $c0b6
	add hl, bc
	ld a, [hl]
	ld hl, $c076
	add hl, bc
	sub [hl]
	jr nc, .asm_7d81b
	ld a, $1
.asm_7d81b
	ld [hl], a
	ld hl, $c0ae
	add hl, bc
	ld a, e
	sub [hl]
	ld e, a
	ld a, d
	sbc b
	ld hl, $c0a6
	add hl, bc
	sub [hl]
	jr c, .asm_7d837
	ld d, a
	ld b, $0
	ld hl, $c02e
	add hl, bc
	set 5, [hl]
	jr .asm_7d85a
.asm_7d837
	ld hl, $c096
	add hl, bc
	ld d, [hl]
	ld hl, $c09e
	add hl, bc
	ld e, [hl]
	ld hl, $c0ae
	add hl, bc
	ld a, [hl]
	sub e
	ld e, a
	ld a, d
	sbc b
	ld d, a
	ld hl, $c0a6
	add hl, bc
	ld a, [hl]
	sub d
	ld d, a
	ld b, $0
	ld hl, $c02e
	add hl, bc
	res 5, [hl]
.asm_7d85a
	ld hl, $c076
	add hl, bc
.asm_7d85e
	inc b
	ld a, e
	sub [hl]
	ld e, a
	jr nc, .asm_7d85e
	ld a, d
	and a
	jr z, .asm_7d86c
	dec a
	ld d, a
	jr .asm_7d85e
.asm_7d86c
	ld a, e
	add [hl]
	ld d, b
	ld b, $0
	ld hl, $c07e
	add hl, bc
	ld [hl], d
	ld hl, $c086
	add hl, bc
	ld [hl], a
	ld hl, $c08e
	add hl, bc
	ld [hl], a
	ret

Music1f_ApplyDutyCycle: ; 7d881 (1f:5881)
	ld b, $0
	ld hl, $c046
	add hl, bc
	ld a, [hl]
	rlca
	rlca
	ld [hl], a
	and $c0
	ld d, a
	ld b, $1
	call Func_7d8ac
	ld a, [hl]
	and $3f
	or d
	ld [hl], a
	ret

Music1f_GetNextMusicByte: ; 7d899 (1f:5899)
	ld d, $0
	ld a, c
	add a
	ld e, a
	ld hl, $c006
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hld]
	ld d, a
	ld a, [de] ; get next music command
	inc de
	ld [hl], e ; store address of next command
	inc hl
	ld [hl], d
	ret

Func_7d8ac: ; 7d8ac (1f:58ac)
	ld a, c
	ld hl, Unknown_7db8b
	add l
	jr nc, .noCarry
	inc h
.noCarry
	ld l, a
	ld a, [hl]
	add b
	ld l, a
	ld h, $ff
	ret

Func_7d8bb: ; 7d8bb (1f:58bb)
	ld h, $0
.loop
	srl a
	jr nc, .noCarry
	add hl, de
.noCarry
	sla e
	rl d
	and a
	jr z, .done
	jr .loop
.done
	ret

Func_7d8cc: ; 7d8cc (1f:58cc)
	ld h, $0
	ld l, a
	add hl, hl
	ld d, h
	ld e, l
	ld hl, Unknown_7dba3
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, b
.loop
	cp $7
	jr z, .done
	sra d
	rr e
	inc a
	jr .loop
.done
	ld a, $8
	add d
	ld d, a
	ret

Func_7d8ea: ; 7d8ea (1f:58ea)
	ld [$c001], a
	cp $ff
	jp z, Func_7daa8
	cp $c2
	jp z, Func_7d9c2
	jp c, Func_7d9c2
	cp $fe
	jr z, .asm_7d901
	jp nc, Func_7d9c2
.asm_7d901
	xor a
	ld [$c000], a
	ld [$c003], a
	ld [$c0e9], a
	ld [$c0e6], a
	ld [$c0e7], a
	ld d, $8
	ld hl, $c016
	call FillMusicRAM1f
	ld hl, $c006
	call FillMusicRAM1f
	ld d, $4
	ld hl, $c026
	call FillMusicRAM1f
	ld hl, $c02e
	call FillMusicRAM1f
	ld hl, $c03e
	call FillMusicRAM1f
	ld hl, $c046
	call FillMusicRAM1f
	ld hl, $c04e
	call FillMusicRAM1f
	ld hl, $c056
	call FillMusicRAM1f
	ld hl, $c05e
	call FillMusicRAM1f
	ld hl, $c066
	call FillMusicRAM1f
	ld hl, $c06e
	call FillMusicRAM1f
	ld hl, $c036
	call FillMusicRAM1f
	ld hl, $c076
	call FillMusicRAM1f
	ld hl, $c07e
	call FillMusicRAM1f
	ld hl, $c086
	call FillMusicRAM1f
	ld hl, $c08e
	call FillMusicRAM1f
	ld hl, $c096
	call FillMusicRAM1f
	ld hl, $c09e
	call FillMusicRAM1f
	ld hl, $c0a6
	call FillMusicRAM1f
	ld hl, $c0ae
	call FillMusicRAM1f
	ld a, $1
	ld hl, $c0be
	call FillMusicRAM1f
	ld hl, $c0b6
	call FillMusicRAM1f
	ld hl, $c0c6
	call FillMusicRAM1f
	ld [$c0e8], a
	ld a, $ff
	ld [$c004], a
	xor a
	ld [$FF00+$24], a
	ld a, $8
	ld [$FF00+$10], a
	ld a, $0
	ld [$FF00+$25], a
	xor a
	ld [$FF00+$1a], a
	ld a, $80
	ld [$FF00+$1a], a
	ld a, $77
	ld [$FF00+$24], a
	jp Func_7db03

Func_7d9c2: ; 7d9c2 (1f:59c2)
	ld l, a
	ld e, a
	ld h, $0
	ld d, h
	add hl, hl
	add hl, de
	ld de, SFX_Headers_1f
	add hl, de
	ld a, h
	ld [$c0ec], a
	ld a, l
	ld [$c0ed], a
	ld a, [hl]
	and $c0
	rlca
	rlca
	ld c, a
.asm_7d9db
	ld d, c
	ld a, c
	add a
	add c
	ld c, a
	ld b, $0
	ld a, [$c0ec]
	ld h, a
	ld a, [$c0ed]
	ld l, a
	add hl, bc
	ld c, d
	ld a, [hl]
	and $f
	ld e, a
	ld d, $0
	ld hl, $c026
	add hl, de
	ld a, [hl]
	and a
	jr z, .asm_7da17
	ld a, e
	cp $7
	jr nz, .asm_7da0e
	ld a, [$c001]
	cp $14
	jr nc, .asm_7da07
	ret
.asm_7da07
	ld a, [hl]
	cp $14
	jr z, .asm_7da17
	jr c, .asm_7da17
.asm_7da0e
	ld a, [$c001]
	cp [hl]
	jr z, .asm_7da17
	jr c, .asm_7da17
	ret
.asm_7da17
	xor a
	push de
	ld h, d
	ld l, e
	add hl, hl
	ld d, h
	ld e, l
	ld hl, $c016
	add hl, de
	ld [hli], a
	ld [hl], a
	ld hl, $c006
	add hl, de
	ld [hli], a
	ld [hl], a
	pop de
	ld hl, $c026
	add hl, de
	ld [hl], a
	ld hl, $c02e
	add hl, de
	ld [hl], a
	ld hl, $c03e
	add hl, de
	ld [hl], a
	ld hl, $c046
	add hl, de
	ld [hl], a
	ld hl, $c04e
	add hl, de
	ld [hl], a
	ld hl, $c056
	add hl, de
	ld [hl], a
	ld hl, $c05e
	add hl, de
	ld [hl], a
	ld hl, $c066
	add hl, de
	ld [hl], a
	ld hl, $c06e
	add hl, de
	ld [hl], a
	ld hl, $c076
	add hl, de
	ld [hl], a
	ld hl, $c07e
	add hl, de
	ld [hl], a
	ld hl, $c086
	add hl, de
	ld [hl], a
	ld hl, $c08e
	add hl, de
	ld [hl], a
	ld hl, $c096
	add hl, de
	ld [hl], a
	ld hl, $c09e
	add hl, de
	ld [hl], a
	ld hl, $c0a6
	add hl, de
	ld [hl], a
	ld hl, $c0ae
	add hl, de
	ld [hl], a
	ld hl, $c036
	add hl, de
	ld [hl], a
	ld a, $1
	ld hl, $c0be
	add hl, de
	ld [hl], a
	ld hl, $c0b6
	add hl, de
	ld [hl], a
	ld hl, $c0c6
	add hl, de
	ld [hl], a
	ld a, e
	cp $4
	jr nz, .asm_7da9f
	ld a, $8
	ld [$FF00+$10], a
.asm_7da9f
	ld a, c
	and a
	jp z, Func_7db03
	dec c
	jp .asm_7d9db

Func_7daa8: ; 7daa8 (1f:5aa8)
	ld a, $80
	ld [$FF00+$26], a
	ld [$FF00+$1a], a
	xor a
	ld [$FF00+$25], a
	ld [$FF00+$1c], a
	ld a, $8
	ld [$FF00+$10], a
	ld [$FF00+$12], a
	ld [$FF00+$17], a
	ld [$FF00+$21], a
	ld a, $40
	ld [$FF00+$14], a
	ld [$FF00+$19], a
	ld [$FF00+$23], a
	ld a, $77
	ld [$FF00+$24], a
	xor a
	ld [$c000], a
	ld [$c003], a
	ld [$c002], a
	ld [$c0e9], a
	ld [$c0eb], a
	ld [$c0e6], a
	ld [$c0e7], a
	ld d, $a0
	ld hl, $c006
	call FillMusicRAM1f
	ld a, $1
	ld d, $18
	ld hl, $c0b6
	call FillMusicRAM1f
	ld [$c0e8], a
	ld [$c0ea], a
	ld a, $ff
	ld [$c004], a
	ret

; fills d bytes at hl with a
FillMusicRAM1f: ; 7dafd (1f:5afd)
	ld b, d
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	ret

Func_7db03: ; 7db03 (1f:5b03)
	ld a, [$c001]
	ld l, a
	ld e, a
	ld h, $0
	ld d, h
	add hl, hl
	add hl, de
	ld de, SFX_Headers_1f
	add hl, de
	ld e, l
	ld d, h
	ld hl, $c006
	ld a, [de] ; get channel number
	ld b, a
	rlca
	rlca
	and $3
	ld c, a
	ld a, b
	and $f
	ld b, c
	inc b
	inc de
	ld c, $0
.asm_7db25
	cp c
	jr z, .asm_7db2d
	inc c
	inc hl
	inc hl
	jr .asm_7db25
.asm_7db2d
	push hl
	push bc
	push af
	ld b, $0
	ld c, a
	ld hl, $c026
	add hl, bc
	ld a, [$c001]
	ld [hl], a
	pop af
	cp $3
	jr c, .asm_7db46
	ld hl, $c02e
	add hl, bc
	set 2, [hl]
.asm_7db46
	pop bc
	pop hl
	ld a, [de] ; get channel pointer
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	inc c
	dec b
	ld a, b
	and a
	ld a, [de]
	inc de
	jr nz, .asm_7db25
	ld a, [$c001]
	cp $14
	jr nc, .asm_7db5f
	jr .asm_7db89
.asm_7db5f
	ld a, [$c001]
	cp $86
	jr z, .asm_7db89
	jr c, .asm_7db6a
	jr .asm_7db89
.asm_7db6a
	ld hl, $c02a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, $c012 ; sfx noise channel pointer
	ld de, Noise1f_endchannel
	ld [hl], e
	inc hl
	ld [hl], d ; overwrite pointer to point to endchannel
	ld a, [$c005]
	and a
	jr nz, .asm_7db89
	ld a, [$FF00+$24]
	ld [$c005], a
	ld a, $77
	ld [$FF00+$24], a
.asm_7db89
	ret

Noise1f_endchannel: ; 7db8a (1f:5b8a)
	endchannel

Unknown_7db8b: ; 7db8b (1f:5b8b)
	db $10, $15, $1A, $1F ; channels 0-3
	db $10, $15, $1A, $1F ; channels 4-7

Unknown_7db93: ; 7db93 (1f:5b93)
	db $EE, $DD, $BB, $77 ; channels 0-3
	db $EE, $DD, $BB, $77 ; channels 4-7

Unknown_7db9b: ; 7db9b (1f:5b9b)
	db $11, $22, $44, $88 ; channels 0-3
	db $11, $22, $44, $88 ; channels 4-7

Unknown_7dba3: ; 7dba3 (1f:5ba3)
	dw $F82C
	dw $F89D
	dw $F907
	dw $F96B
	dw $F9CA
	dw $FA23
	dw $FA77
	dw $FAC7
	dw $FB12
	dw $FB58
	dw $FB9B
	dw $FBDA


