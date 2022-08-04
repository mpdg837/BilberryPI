
    keydetect:
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
                    savea 0x0780

                    nosoundplayme:
                call putchar
            iputcharfunctiontest:
        ret

    init: // Czyszczenie ramu

        set eax 0x0
        uoff -3 eax

        set eax 0x5 // LED Display
        set ebx 0x0
            call sendCopper

        call ramclear
        call clearPalette
        call clearSprites

        set eax 0x5 // LED Display
        set ebx 0x1
            call sendCopper

        call diskloader

        set eax 0x5 // LED Display
        set ebx 0x2
            call sendCopper


        ram 0x2110
            savea 0x0800
        call loadcharset // Ladowanie znakow

        ram 0x1faf // Wartosc konwertowana
                set edx 0x0
                save edx

        ram 0x2107
            savea 0x07a0
        call loadPalette

        call clearreg

        ram 0x2010 // Dzwiek poczatkowy
            savea 0x0780

        ram 0x210d // Delta screen
            savea 0x0
        ram 0x210e
            savea 0x0


        set ecx 0x0760 // Adres Spritea
        set ebx 0x8 // Numer
            call loadSpriteTex

        call spriteload

        set eax 0x5 // LED Display
        set ebx 0x3
            call sendCopper

        ram 0x2108
            savea 0x3
        jmp main


    main: // Petla glowna systemu

            ram 0x210a
                savea 0x1

            set eax 0x5
            set ebx 0x3
                 call setcharpos

            ram 0x1fc3 // Wskzanik strigna do wartosci konwertowaej
                 savea 0x07b0


            call prints // tekst



            set eax 0xf // Position
            set ebx 0x8
               call setcharpos

             ram 0x1fe1 // Klawisz
                 read eax

            ram 0x1fa4
                save eax

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

        ram 0x1fc2 // Sprawdzanie zgloszenia przerwania przez uklad graficzny
            set eax 0x0
            save eax

        waitForGraphics:
            read eax
            // Wartosc oczekiwana
            cmpa eax 0xffff
                jeq renderGraphics // Przekierowanie wrazie wykrycia rozpoczecia nowej klatki
            jmp waitForGraphics

        renderGraphics: // Render nowej klatki
        call loadBuffer

        set ebx 0x0 // Czysczenie wartosci rejestru detekotora
        save ebx





        jmp main // Zapetlenie
