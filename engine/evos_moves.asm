; try to evolve the mon in [wWhichPokemon]
TryEvolvingMon: ; 3ad0e (e:6d0e)
	ld hl, wCanEvolveFlags
	xor a
	ld [hl], a
	ld a, [wWhichPokemon]
	ld c, a
	ld b, $1
	call Evolution_FlagAction

; this is only called after battle
; it is supposed to do level up evolutions, though there is a bug that allows item evolutions to occur
EvolutionAfterBattle: ; 3ad1c (e:6d1c)
	ld a, [hTilesetType]
	push af
	xor a
	ld [wd121], a
	dec a
	ld [wWhichPokemon], a
	push hl
	push bc
	push de
	ld hl, wPartyCount
	push hl

Evolution_PartyMonLoop: ; loop over party mons
	ld hl, wWhichPokemon
	inc [hl]
	pop hl
	inc hl
	ld a, [hl]
	cp $ff ; have we reached the end of the party?
	jp z, .done
	ld [wEvoOldSpecies], a
	push hl
	ld a, [wWhichPokemon]
	ld c, a
	ld hl, wCanEvolveFlags
	ld b, $2
	call Evolution_FlagAction
	ld a, c
	and a ; is the mon's bit set?
	jp z, Evolution_PartyMonLoop ; if not, go to the next mon
	ld a, [wEvoOldSpecies]
	dec a
	ld b, 0
	ld hl, EvosMovesPointerTable
	add a
	rl b
	ld c, a
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld a, [wcf91]
	push af
	xor a ; PLAYER_PARTY_DATA
	ld [wMonDataLocation], a
	call LoadMonData
	pop af
	ld [wcf91], a
	pop hl

.evoEntryLoop ; loop over evolution entries
	ld a, [hli]
	and a ; have we reached the end of the evolution data?
	jr z, Evolution_PartyMonLoop
	ld b, a ; evolution type
	cp EV_STAT
	jr z, .checkStatEvo
	cp EV_FUSE
	jr z, .checkFuseEvo
	cp EV_TRADE
	jp z, .checkTradeEvo
; not trade evolution
	ld a, [wLinkState]
	cp LINK_STATE_TRADING
	jr z, Evolution_PartyMonLoop ; if trading, go the next mon
	ld a, b
	cp EV_ITEM
	jp z, .checkItemEvo
	ld a, [wForceEvolution]
	and a
	jr nz, Evolution_PartyMonLoop
	ld a, b
	cp EV_LEVEL
	jp z, .checkLevel
	jp .checkTradeEvo
.checkStatEvo
	; compares the mons attack and defense stats
	ld c, 0
	ld a, [wLoadedMonAttack]
	ld d, a
	ld a, [wLoadedMonDefense]
	cp d
	jr z, .hiByteEqual
	jr nc, .defenseGreater
	jr .attackGreater
.hiByteEqual
	ld a, [wLoadedMonAttack + 1]
	ld d, a
	ld a, [wLoadedMonDefense + 1]
	cp d
	jr z, .equal
	jr nc, .defenseGreater
.attackGreater
	inc c
.defenseGreater
	inc c
.equal
	ld a, [hli]
	cp c
	jp nz, .nextEvoEntry1
	jp .checkLevel
.checkFuseEvo
	ld a, $ff
	ld [wWhichPokemonRemove], a
	ld a, [hli] ; does the level matter?
	ld [wCheckLevel], a
	ld a, [hli] ; mon required
	ld b, a
	push hl
	ld hl, wPartySpecies
	ld c, 0
	ld d, 0
	ld a, [wWhichPokemon]
	ld e, a
.countPartyMonLoop
	ld a, [hli]
	cp $ff
	jr z, .doneCounting
	cp b
	jr nz, .noMatch
	ld a, d
	cp e
	jr z, .noMatch
	ld a, d
	ld [wWhichPokemon], a
	push hl
	push de
	push bc
	callba KnowsHMMove
	pop bc
	pop de
	pop hl
	ld a, e
	ld [wWhichPokemon], a
	jr c, .noMatch
	ld a, [wCheckLevel]
	and a
	jr z, .match
	push hl
	push bc
	ld a, d
	ld hl, wPartyMon1Level
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld a, [wLoadedMonLevel]
	cp [hl]
	pop bc
	pop hl
	jr c, .noMatch
.match
	inc c
	push hl
	push de
	ld d, $ff
	ld hl, wWhichPokemonRemove
.notff
	inc d
	ld a, [hli]
	cp $ff
	jr nz, .notff
	ld [hld], a
.keepShifting
	ld a, d
	and a
	jr z, .doneShifting
	dec hl
	ld a, [hli]
	ld [hld], a
	dec d
	jr .keepShifting
.doneShifting
	pop de
	ld a, d
	ld [hl], a
	pop hl
.noMatch
	inc d
	jr .countPartyMonLoop
.doneCounting
	pop hl
	ld a, [hli] ; number required
	ld b, a
	ld a, c
	cp b
	jp c, .nextEvoEntry2
	ld a, 1
	ld [wRemovePokemon], a
	push hl
	ld hl, wWhichPokemonRemove
	ld c, b
	ld b, 0
	add hl, bc
	ld a, $ff
	ld [hl], a
	pop hl
	ld a, [wLoadedMonLevel]
	jr .asm_3adb6
.checkTradeEvo
	ld a, [wLinkState]
	cp LINK_STATE_TRADING
	jp nz, .nextEvoEntry1 ; if not trading, go to the next evolution entry
	ld a, [hli] ; level requirement
	ld b, a
	ld a, [wLoadedMonLevel]
	cp b ; is the mon's level greater than the evolution requirement?
	jp c, Evolution_PartyMonLoop ; if so, go the next mon
	jr .asm_3adb6
.checkItemEvo
	ld a, [hli]
	ld b, a ; evolution item
	ld a, [wcf91] ; this is supposed to be the last item used, but it is also used to hold species numbers
	cp b ; was the evolution item in this entry used?
	jp nz, .nextEvoEntry1 ; if not, go to the next evolution entry
.checkLevel
	ld a, [hli] ; level requirement
	ld b, a
	ld a, [wLoadedMonLevel]
	cp b ; is the mon's level greater than the evolution requirement?
	jp c, .nextEvoEntry2 ; if so, go the next evolution entry
.asm_3adb6
	ld [W_CURENEMYLVL], a
	ld a, $1
	ld [wd121], a
	push hl
	ld a, [hl]
	ld [wEvoNewSpecies], a
	ld a, [wWhichPokemon]
	ld hl, wPartyMonNicks
	call GetPartyMonName
	call CopyStringToCF4B
	ld a, [wRemovePokemon]
	and a
	jr nz, .fusingText
	ld hl, IsEvolvingText
	jr .printText1
.fusingText
	ld hl, IsFusingText
.printText1
	call PrintText
	ld c, 50
	call DelayFrames
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	coord hl, 0, 0
	lb bc, 12, 20
	call ClearScreenArea
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a
	ld a, $ff
	ld [wUpdateSpritesEnabled], a
	call ClearSprites
	callab EvolveMon
	jp c, CancelledEvolution
	ld a, [wRemovePokemon]
	and a
	jr nz, .fusedText
	ld hl, EvolvedText
	jr .printText2
.fusedText
	ld hl, FusedText
.printText2
	call PrintText
	pop hl
	ld a, [hl]
	ld [wd0b5], a
	ld [wLoadedMonSpecies], a
	ld [wEvoNewSpecies], a
	ld a, MONSTER_NAME
	ld [wNameListType], a
	ld a, BANK(TrainerNames) ; bank is not used for monster names
	ld [wPredefBank], a
	call GetName
	push hl
	ld hl, IntoText
	call PrintText_NoCreatingTextBox
	ld a, SFX_GET_ITEM_2
	call PlaySoundWaitForCurrent
	call WaitForSoundToFinish
	ld c, 40
	call DelayFrames
	call ClearScreen
	call RenameEvolvedMon
	ld a, [wd11e]
	push af
	ld a, [wd0b5]
	ld [wd11e], a
	predef IndexToPokedex
	ld a, [wd11e]
	dec a
	ld hl, BaseStats
	ld bc, $1c
	call AddNTimes
	ld de, W_MONHEADER
	call CopyData
	ld a, [wd0b5]
	ld [W_MONHDEXNUM], a
	pop af
	ld [wd11e], a
	ld hl, wLoadedMonHPExp - 1
	ld de, wLoadedMonStats
	ld b, $1
	call CalcStats
	ld a, [wWhichPokemon]
	ld hl, wPartyMon1
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld e, l
	ld d, h
	push hl
	push bc
	ld bc, wPartyMon1MaxHP - wPartyMon1
	add hl, bc
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, wLoadedMonMaxHP + 1
	ld a, [hld]
	sub c
	ld c, a
	ld a, [hl]
	sbc b
	ld b, a
	ld hl, wLoadedMonHP + 1
	ld a, [hl]
	add c
	ld [hld], a
	ld a, [hl]
	adc b
	ld [hl], a
	dec hl
	pop bc
	call CopyData
	ld a, [wd0b5]
	ld [wd11e], a
	xor a
	ld [wMonDataLocation], a
	call LearnMoveFromLevelUp
	pop hl
	predef SetPartyMonTypes
	ld a, [W_ISINBATTLE]
	and a
	call z, Evolution_ReloadTilesetTilePatterns
	predef IndexToPokedex
	ld a, [wd11e]
	dec a
	ld c, a
	ld b, $1
	ld hl, wPokedexOwned
	push bc
	call Evolution_FlagAction
	pop bc
	ld hl, wPokedexSeen
	call Evolution_FlagAction
	pop de
	pop hl
	ld a, [wLoadedMonSpecies]
	ld [hl], a
	push hl
	ld l, e
	ld h, d
	ld a, [wRemovePokemon]
	and a
	jr z, .skipRemovePokemon
	push hl
	xor a
	ld [wRemovePokemon], a
	ld [wRemoveMonFromBox], a
	ld a, [wWhichPokemon]
	push af
	ld hl, wWhichPokemonRemove
.removeMonLoop
	ld a, [hli]
	cp $ff
	jr z, .doneRemoving
	ld [wWhichPokemon], a
	push hl
	call RemovePokemon
	pop hl
	jr .removeMonLoop
.doneRemoving
	pop af
	ld [wWhichPokemon], a
	pop hl
.skipRemovePokemon
	jr .nextEvoEntry2

.nextEvoEntry1
	inc hl

.nextEvoEntry2
	inc hl
	jp .evoEntryLoop

.done
	pop de
	pop bc
	pop hl
	pop af
	ld [hTilesetType], a
	ld a, [wLinkState]
	cp LINK_STATE_TRADING
	ret z
	ld a, [W_ISINBATTLE]
	and a
	ret nz
	ld a, [wd121]
	and a
	call nz, PlayDefaultMusic
	ret

; checks if the evolved mon's name is different from the standard name (i.e. it has a nickname)
; if so, rename it to is evolved form's standard name
RenameEvolvedMon: ; 3aef7 (e:6ef7)
	ld a, [wd0b5]
	push af
	ld a, [W_MONHDEXNUM]
	ld [wd0b5], a
	call GetName
	pop af
	ld [wd0b5], a
	ld hl, wcd6d
	ld de, wcf4b
.compareNamesLoop
	ld a, [de]
	inc de
	cp [hl]
	inc hl
	ret nz
	cp $50
	jr nz, .compareNamesLoop
	ld a, [wWhichPokemon]
	ld bc, $b
	ld hl, wPartyMonNicks
	call AddNTimes
	push hl
	call GetName
	ld hl, wcd6d
	pop de
	jp CopyData

CancelledEvolution: ; 3af2e (e:6f2e)
	xor a
	ld [wRemovePokemon], a
	ld hl, StoppedEvolvingText
	call PrintText
	call ClearScreen
	pop hl
	call Evolution_ReloadTilesetTilePatterns
	jp Evolution_PartyMonLoop

EvolvedText: ; 3af3e (e:6f3e)
	TX_FAR _EvolvedText
	db "@"

FusedText:
	TX_FAR _FusedText
	db "@"

IntoText: ; 3af43 (e:6f43)
	TX_FAR _IntoText
	db "@"

StoppedEvolvingText: ; 3af48 (e:6f48)
	TX_FAR _StoppedEvolvingText
	db "@"

IsEvolvingText: ; 3af4d (e:6f4d)
	TX_FAR _IsEvolvingText
	db "@"

IsFusingText:
	TX_FAR _IsFusingText
	db "@"

Evolution_ReloadTilesetTilePatterns: ; 3af52 (e:6f52)
	ld a, [wLinkState]
	cp LINK_STATE_TRADING
	ret z
	jp ReloadTilesetTilePatterns

LearnMoveFromLevelUp: ; 3af5b (e:6f5b)
	ld hl, EvosMovesPointerTable
	ld a, [wd11e] ; species
	ld [wcf91], a
	dec a
	ld bc, 0
	ld hl, EvosMovesPointerTable
	add a
	rl b
	ld c, a
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
.skipEvolutionDataLoop ; loop to skip past the evolution data, which comes before the move data
	ld a, [hli]
	and a ; have we reached the end of the evolution data?
	jr nz, .skipEvolutionDataLoop ; if not, jump back up
.learnSetLoop ; loop over the learn set until we reach a move that is learnt at the current level or the end of the list
	ld a, [hli]
	and a ; have we reached the end of the learn set?
	jr z, .done ; if we've reached the end of the learn set, jump
	ld b, a ; level the move is learnt at
	ld a, [W_CURENEMYLVL]
	cp b ; is the move learnt at the mon's current level?
	ld a, [hli] ; move ID
	jr nz, .learnSetLoop
	ld d, a ; ID of move to learn
	ld a, [wMonDataLocation]
	and a
	jr nz, .next
; If [wMonDataLocation] is 0 (PLAYER_PARTY_DATA), get the address of the mon's
; current moves in party data. Every call to this function sets
; [wMonDataLocation] to 0 because other data locations are not supported.
; If it is not 0, this function will not work properly.
	ld hl, wPartyMon1Moves
	ld a, [wWhichPokemon]
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
.next
	ld b, NUM_MOVES
.checkCurrentMovesLoop ; check if the move to learn is already known
	ld a, [hli]
	cp d
	jr z, .done ; if already known, jump
	dec b
	jr nz, .checkCurrentMovesLoop
	ld a, d
	ld [wMoveNum], a
	ld [wd11e], a
	call GetMoveName
	call CopyStringToCF4B
	predef LearnMove
.done
	ld a, [wcf91]
	ld [wd11e], a
	ret

; writes the moves a mon has at level [W_CURENEMYLVL] to [de]
; move slots are being filled up sequentially and shifted if all slots are full
WriteMonMoves: ; 3afb8 (e:6fb8)
	call GetPredefRegisters
	push hl
	push de
	push bc
	ld hl, EvosMovesPointerTable
	ld b, 0
	ld a, [wcf91]  ; cur mon ID
	dec a
	add a
	rl b
	ld c, a
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
.skipEvoEntriesLoop
	ld a, [hli]
	and a
	jr nz, .skipEvoEntriesLoop
	jr .firstMove
.nextMove
	pop de
.nextMove2
	inc hl
.firstMove
	ld a, [hli]       ; read level of next move in learnset
	and a
	jp z, .done       ; end of list
	ld b, a
	ld a, [W_CURENEMYLVL]
	cp b
	jp c, .done       ; mon level < move level (assumption: learnset is sorted by level)
	ld a, [wLearningMovesFromDayCare]
	and a
	jr z, .skipMinLevelCheck
	ld a, [wDayCareStartLevel]
	cp b
	jr nc, .nextMove2 ; min level >= move level

.skipMinLevelCheck

; check if the move is already known
	push de
	ld c, NUM_MOVES
.alreadyKnowsCheckLoop
	ld a, [de]
	inc de
	cp [hl]
	jr z, .nextMove
	dec c
	jr nz, .alreadyKnowsCheckLoop

; try to find an empty move slot
	pop de
	push de
	ld c, NUM_MOVES
.findEmptySlotLoop
	ld a, [de]
	and a
	jr z, .writeMoveToSlot2
	inc de
	dec c
	jr nz, .findEmptySlotLoop

; no empty move slots found
	pop de                        
	push de
	push hl
	ld h, d
	ld l, e
	call WriteMonMoves_ShiftMoveData ; shift all moves one up (deleting move 1)
	ld a, [wLearningMovesFromDayCare]
	and a
	jr z, .writeMoveToSlot

; shift PP as well if learning moves from day care
	push de
	ld bc, wPartyMon1PP - (wPartyMon1Moves + 3)
	add hl, bc
	ld d, h
	ld e, l
	call WriteMonMoves_ShiftMoveData ; shift all move PP data one up
	pop de

.writeMoveToSlot
	pop hl
.writeMoveToSlot2
	ld a, [hl]
	ld [de], a
	ld a, [wLearningMovesFromDayCare]
	and a
	jr z, .nextMove

; write move PP value if learning moves from day care
	push hl            
	ld a, [hl]
	ld hl, wPartyMon1PP - wPartyMon1Moves
	add hl, de
	push hl
	dec a
	ld hl, Moves
	ld bc, 6
	call AddNTimes
	ld de, wBuffer
	ld a, BANK(Moves)
	call FarCopyData
	ld a, [wBuffer + 5]
	pop hl
	ld [hl], a
	pop hl
	jr .nextMove

.done
	pop bc
	pop de
	pop hl
	ret

; shifts all move data one up (freeing 4th move slot)
WriteMonMoves_ShiftMoveData: ; 3b04e (e:704e)
	ld c, NUM_MOVES - 1
.loop
	inc de
	ld a, [de]
	ld [hli], a
	dec c
	jr nz, .loop
	ret

Evolution_FlagAction: ; 3b057 (e:7057)
	predef_jump FlagActionPredef

INCLUDE "data/evos_moves.asm"
