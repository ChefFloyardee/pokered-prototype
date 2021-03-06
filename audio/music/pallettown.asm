Music_PalletTown_Ch0::
	tempo 255
	volume 7, 7
	duty 2
	octave 2

Music_PalletTown_Ch0_branch_1::
	notetype 12, 10, 7
	C_ 2
	D_ 2
	notetype 12, 10, 0
	G_ 4
	notetype 12, 10, 7
	G_ 8
	C_ 2
	D_ 2
	notetype 12, 10, 0
	F_ 4
	notetype 12, 10, 7
	F_ 8
	loopchannel 0, Music_PalletTown_Ch0_branch_1


Music_PalletTown_Ch1::
	duty 2
	notetype 12, 8, 7
	callchannel Music_PalletTown_Ch1_Sub1
	callchannel Music_PalletTown_Ch1_Sub1

Music_PalletTown_Ch1_branch_1::
	callchannel Music_PalletTown_Ch1_Sub1
	callchannel Music_PalletTown_Ch1_Sub1

Music_PalletTown_Ch1_branch_2::
	duty 3
	notetype 12, 5, 5
	octave 3
	G_ 2
	A_ 2
	octave 4
	C_ 1
	rest 3
	C_ 8
	octave 3
	G_ 2
	A_ 2
	octave 4
	F_ 2
	E_ 2
	C_ 8
	loopchannel 2, Music_PalletTown_Ch1_branch_2
	notetype 12, 6, 7
	G_ 6
	F_ 1
	G_ 1
	A_ 6
	G_ 2
	D_ 6
	C_ 2
	D_ 4
	E_ 1
	F_ 1
	E_ 2
	D_ 6
	C_ 2
	octave 3
	G_ 6
	F_ 1
	G_ 1
	A_ 6
	octave 4
	notetype 12, 10, 7
	D_ 2
	C_ 8
	loopchannel 0, Music_PalletTown_Ch1_branch_1

Music_PalletTown_Ch1_Sub1::
	octave 3
	C_ 2
	D_ 2
	notetype 12, 7, 0
	G_ 4
	notetype 12, 7, 7
	G_ 8
	C_ 2
	D_ 2
	notetype 12, 7, 0
	F_ 4
	notetype 12, 7, 7
	F_ 8
	endchannel

Music_PalletTown_Ch2::
	duty 0
	notetype 12, 2, 2
	rest 16
	rest 16
	rest 16
	rest 16

Music_PalletTown_Ch2_branch_1::
	notetype 12, 1, 2
	octave 4
	G_ 2
	A_ 2
	octave 5
	C_ 1
	rest 3
	C_ 8
	octave 4
	G_ 2
	A_ 2
	octave 5
	F_ 2
	E_ 2
	C_ 8
	loopchannel 2, Music_PalletTown_Ch2_branch_1
	duty 2
	G_ 6
	F_ 1
	G_ 1
	A_ 6
	G_ 2
	D_ 6
	C_ 2
	D_ 4
	E_ 1
	F_ 1
	E_ 2
	D_ 6
	C_ 2
	octave 4
	G_ 6
	F_ 1
	G_ 1
	A_ 6
	octave 5
	D_ 2
	C_ 8
	octave 4
	G_ 4
	octave 5
	D_ 8
	C_ 4
	D_ 4
	E_ 1
	F_ 1
	E_ 2
	D_ 6
	C_ 2
	D_ 4
	E_ 1
	F_ 1
	E_ 2
	D_ 4
	C_ 4
	D_ 4
	notetype 12, 2, 2
	C_ 4
	octave 4
	notetype 12, 3, 2
	G_ 8
	loopchannel 0, Music_PalletTown_Ch2_branch_1
