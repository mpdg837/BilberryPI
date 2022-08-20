            
    keydetect:
            call regcopy
            ram 0x2105
                read eax
                cmpa eax 0xffff
                    jeq putcharfunctiontest

                    call putchari
                    jmp iputcharfunctiontest
            putcharfunctiontest:
                ram 0x1fe1
                    read eax
                    cmpa eax 0x11
                        jeq playmysoundinit
                        jmp nosoundplayme

                playmysoundinit:
                ram 0x2011  // Udzwiekowienie
                    read eax
                    cmpa eax 0xffff
                        jeq nosoundplayme

                ram 0x2010
                    savea 0x1380

                    nosoundplayme:
                call putchar
            iputcharfunctiontest:

            ram 0x2105
                set eax 0x0
                save eax

            call regback
        ret
        
    spriteload:
            set eax 0x16
            set ebx 0x1
                call sendGraphics

            set eax 0x17
            set ebx 0x20
                call sendGraphics

            set eax 0x18
            set ebx 0x14
                call sendGraphics

            set eax 0x19
            set ebx 0xb
                call sendGraphics

            set eax 0x1a
            set ebx 0xd
                call sendGraphics

            set eax 0x1e
            set ebx 0x8
                call sendGraphics


            set eax 0x20
            set ebx 0x0
                call sendGraphics

            set eax 0x21
            set ebx 0x1
                call sendGraphics

            set eax 0x22
            set ebx 0x2
                call sendGraphics
        ret

    main: // Petla glowna systemu

            ram 0x210a
                savea 0x1

            set eax 0x8
            set ebx 0x3
                 call setcharpos

            ram 0x2116
                 savea 0x0
            ram 0x1fc3 // Wskzanik strigna do wartosci konwertowaej
                 savea 0x13b0

            call prints // tekst


            ram 0x2116
                 savea 0x0

            set eax 0xf // Position
            set ebx 0x8
               call setcharpos

             ram 0x1fe1 // Klawisz
                 read eax

            ram 0x1fa4
                save eax

                addr
                res edx
                save edx
            ram 0x1fe1
                set ebx 0x0
                save eax

            call putnum
            call keydetect

        call clearreg

        int

        set eax 0x3 // Poziom dzwieku
        ram 0x2108
            read ebx

            call sendBuzzer

        call deltascreen
        call playingsound // Odgrywanie dzwieku

        call waitingforloopgrph
        call loadBuffer

        set ebx 0x0 // Czysczenie wartosci rejestru detekotora
        save ebx

        jmp main // Zapetlenie


    // String
    &data 0x13b0 < 0000000000111110
    &data 0x13b1 < 0000000000100111
    &data 0x13b2 < 0000000000100100
    &data 0x13b3 < 0000000000101011
    &data 0x13b4 < 0000000000101011
    &data 0x13b5 < 0000000000101110
    &data 0x13b6 < 0000000000000000
    &data 0x13b7 < 0000000000110110
    &data 0x13b8 < 0000000000101110
    &data 0x13b9 < 0000000000110001
    &data 0x13ba < 0000000000101011
    &data 0x13bb < 0000000000100011
    &data 0x13bc < 0000000010000011
    &data 0x13bd < 0000000011000011
    &data 0x13be < 0000000000001111