Music_WildBattle_Ch1::
	tempo 107
	duty 2
	notetype 12, 10, 0
	octave 2
	E_ 4
	F_ 4
	G_ 4
	G# 4
	A# 4
	B_ 4
	octave 3
	C# 4
	D_ 4
	octave 2
	D_ 4
	rest 16
	rest 8
	octave 1
	G_ 4
.mainLoop
	A_ 8
	octave 2
	D_ 8
	G_ 8
	A_ 8
	octave 1
	A_ 4
	octave 2
	D_ 4
	F# 8
	rest 12
	octave 1
	G_ 4
	A_ 8
	octave 2
	D_ 8
	G_ 8
	E_ 8
	A_ 4
	G_ 4
	F# 8
	rest 14
	D_ 2
	A_ 4
	G_ 4
	F# 4
	D_ 4
	D_ 8
	rest 4
	G_ 4
	A_ 8
	octave 3
	C_ 8
	E_ 8
	G_ 4
	E_ 4
	F# 8
	rest 6
	octave 2
	E_ 2
	F# 4
	A_ 4
	octave 3
	D_ 4
	E_ 2
	C_ 2
	D_ 4
	octave 2
	A_ 4
	G_ 6
	A_ 2
	F# 8
	octave 3
	D_ 4
	E_ 2
	C_ 2
	D_ 4
	F_ 4
	F# 6
	octave 2
	B_ 2
	octave 3
	C_ 4
	octave 2
	B_ 4
	F_ 2
	G_ 2
	A# 2
	rest 2
	A_ 8
	rest 8
	C_ 8
	G_ 8
	D_ 4
	C# 4
	C_ 4
	octave 1
	B_ 4
	octave 2
	A_ 4
	F# 1
	G_ 1
	G# 1
	A_ 1
	octave 3
	F# 2
	rest 2
	G_ 2
	rest 2
	F# 8
	F# 2
	rest 4
	octave 2
	A_ 2
	E_ 4
	octave 1
	A_ 2
	octave 2
	C_ 2
	D_ 2
	rest 16
	rest 4
	A_ 2
	F# 8
	E_ 4
	C_ 4
	D_ 4
	rest 16
	rest 8
	octave 1
	G_ 4
	loopchannel 0, .mainLoop


Music_WildBattle_Ch2::
	notetype 12, 9, 0
	rest 8
	duty 2
	octave 5
	D_ 1
	C# 1
	C_ 1
	octave 4
	B_ 1
	octave 5
	C_ 1
	octave 4
	B_ 1
	A# 1
	A_ 1
	A# 1
	A_ 1
	G# 1
	G_ 1
	G# 1
	G_ 1
	F# 1
	F_ 1
	F# 1
	F_ 1
	E_ 1
	D# 1
	octave 3
	D_ 1
	octave 4
	C# 1
	D_ 1
	octave 5
	C# 1
	D_ 4
	rest 16
	rest 10
	octave 3
	E_ 2
.mainLoop
	A_ 4
	octave 4
	D_ 2
	E_ 2
	D_ 4
	rest 2
	octave 3
	A_ 1
	G# 1
	G_ 4
	D_ 4
	F# 2
	rest 2
	E_ 2
	rest 2
	F# 16
	rest 14
	octave 4
	C_ 2
	D_ 4
	D_ 2
	C_ 2
	octave 3
	A_ 4
	rest 2
	A_ 1
	G# 1
	G_ 4
	A_ 4
	D_ 2
	rest 2
	E_ 2
	rest 2
	F# 4
	A_ 2
	octave 4
	D_ 1
	F_ 1
	F# 8
	rest 12
	octave 3
	A_ 4
	octave 4
	D_ 4
	octave 3
	A_ 1
	B_ 1
	octave 4
	D_ 2
	D_ 4
	F_ 4
	F# 8
	rest 6
	octave 3
	E_ 2
	A_ 8
	octave 4
	G_ 6
	F# 1
	F_ 1
	E_ 4
	E_ 1
	F# 1
	G_ 1
	A_ 1
	octave 5
	C_ 8
	D_ 8
	rest 4
	C_ 4
	D_ 4
	octave 4
	A_ 2
	B_ 2
	octave 5
	D_ 6
	F_ 2
	D_ 6
	C_ 1
	E_ 1
	D_ 6
	C_ 2
	D_ 4
	octave 4
	A_ 1
	B_ 1
	octave 5
	D_ 2
	D_ 4
	F_ 4
	D_ 4
	C_ 1
	E_ 1
	octave 4
	B_ 2
	octave 5
	D_ 8
	C_ 8
	octave 4
	B_ 6
	B_ 1
	octave 5
	C_ 1
	D_ 8
	rest 8
	octave 4
	C_ 8
	G_ 6
	D_ 2
	A_ 4
	F# 1
	G_ 1
	G# 1
	A_ 1
	octave 5
	F# 2
	rest 2
	G_ 2
	rest 2
	F# 4
	rest 12
	D_ 8
	octave 4
	A_ 2
	rest 4
	B_ 2
	octave 5
	C_ 4
	C_ 1
	octave 4
	B_ 1
	A_ 1
	F_ 1
	F# 2
	rest 16
	rest 4
	B_ 2
	A_ 8
	octave 5
	C_ 4
	octave 4
	E_ 1
	G_ 1
	B_ 1
	octave 5
	C_ 1
	D_ 4
	rest 16
	rest 10
	octave 3
	E_ 2
	loopchannel 0, .mainLoop


Music_WildBattle_Ch3::
	notetype 12, 1, 4
	octave 3
.loop1
	D_ 1
	rest 2
	D_ 1
	loopchannel 8, .loop1
	octave 2
.mainLoop
	callchannel Music_WildBattle_Ch3_sub_0
	callchannel Music_WildBattle_Ch3_sub_0
	callchannel Music_WildBattle_Ch3_sub_0
	callchannel Music_WildBattle_Ch3_sub_0
	callchannel Music_WildBattle_Ch3_sub_0
	callchannel Music_WildBattle_Ch3_sub_0
	callchannel Music_WildBattle_Ch3_sub_0
	callchannel Music_WildBattle_Ch3_sub_0
	callchannel Music_WildBattle_Ch3_sub_0
	callchannel Music_WildBattle_Ch3_sub_0
	D_ 8
	A_ 8
	C_ 8
	G_ 8
	D_ 2
	A_ 2
	C# 2
	A_ 2
	C_ 2
	A_ 2
	octave 1
	B_ 2
	octave 2
	A_ 2
	D_ 2
	A_ 2
	D_ 2
	A_ 2
	D_ 2
	A_ 2
	C_ 4
	callchannel Music_WildBattle_Ch3_sub_0
	callchannel Music_WildBattle_Ch3_sub_0
	loopchannel 0, .mainLoop

Music_WildBattle_Ch3_sub_0::
	D_ 2
	A_ 2
	D_ 2
	A_ 2
	D_ 2
	A_ 2
	D_ 2
	A_ 2
	D_ 2
	A_ 2
	D_ 2
	A_ 2
	D_ 2
	A_ 2
	C_ 4
	endchannel
