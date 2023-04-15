include Project\main\resources\image.dat
include Project\main\resources\house.dat
    putcharme:
        call regcopy

        call setposchar
            ram 0x2163
                read ebx
            call sendGraphics
            call colorMyBlock
        call regback
        ret

    keydetect:
            call regcopy
            ram 0x2105
                read eax
                cmpa eax 0xffff
                    jeq putcharfunctiontest

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
                    savea 0x1e80
                ram 0x212a
                    set edx 0x0
                    save edx

                    nosoundplayme:
            iputcharfunctiontest:

            call regback
        ret

    startup:
            ram 0x2500
                savea 0x4f
            ram 0x2501
                savea 0x50
            ram 0x2502
                savea 0x51
            ram 0x2503
                savea 0xf


            set ecx 0x1e60 // Adres Spritea
            set ebx 0x8 // Numer
                call loadSpriteTex


        jmp main

    main: // Petla glowna systemu
        // image
        ram 0x2501 // X
            savea 0x78
        ram 0x2502 // Y
            savea 0x78
        ram 0x2503 // addr
            savea 0x16fb
        ram 0x2504 // offset
            savea 0x40
        ram 0x250d
            savea 0xffff

            call showimage

        // image
        ram 0x2501 // X
            savea 0xb8
        ram 0x2502 // Y
            savea 0x78
        ram 0x2503 // addr
            savea 0x191b
        ram 0x2504 // offset
            savea 0xb
        ram 0x250d
            savea 0x1

            call showimage

            set eax 0x8
            set ebx 0x3
                 call setcharpos



        call clock
// Num show

            set eax 0x18 // Position
            set ebx 0x2
               call setcharpos

            ram 0x216a // hour
                 read eax

            ram 0x1fa4
                 save eax

            call putnum

            ram 0x2169 // min
                 read eax

            ram 0x1fa4
                 save eax

            call putnum

             ram 0x2168 // seconds
                 read eax

            ram 0x1fa4
                save eax

            call putnum

            ram 0x2167 // ms
                 read eax

            ram 0x1fa4
                save eax

            call putnum
            call putcharme

            call keydetect

        call clearreg

        int

        set eax 0x3 // Poziom dzwieku
        ram 0x2108
            read ebx

            call sendBuzzer



        call playingsound // Odgrywanie dzwieku
        call deltascreen

        call waitingforloopgrph
        call loadBuffer
        jmp main // Zapetlenie
