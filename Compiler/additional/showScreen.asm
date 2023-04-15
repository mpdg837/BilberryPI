
    showScreen:

        ram 0x211a
            set eax 0x0
            save eax

        loopshowScreen:

            ram 0x210a
                savea 0x0

            set eax 0x8
            set ebx 0x3
                 call setcharpos

            ram 0x2116
                 savea 0x0
            ram 0x1fc3 // Wskzanik strigna do wartosci konwertowaej
                 savea 0x07b0

            call prints // tekst

            ram 0x2116
                 savea 0xffff
            ram 0x1fc3 // Wskzanik strigna do wartosci konwertowaej
                 savea 0x07b0

            call prints // tekst

            ram 0x211a
                read eax
                cmpa eax 0xffff
                    jeq eloopshowScreen
                savea 0xffff

                 call waitingforloopgrph
                 call loadBuffer

            jmp loopshowScreen
        eloopshowScreen:
        call loadBuffer

        ret