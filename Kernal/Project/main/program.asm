
include Project\main\support\cursor.asm
include Project\main\support\input.asm
include Project\main\support\keyboardstack.asm
include Project\main\support\strtoint.asm

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
                    savea 0x1b80
                ram 0x212a
                    set edx 0x0
                    save edx

                    nosoundplayme:
                nop
            iputcharfunctiontest:

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


    startup:
            ram 0x2500
                savea 0x3e
            ram 0x2501
                savea 0xf

            set ecx 0x1b60 // Adres Spritea
            set ebx 0x8 // Numer
                call loadSpriteTex

            call spriteload

                ram 0x2125 // Pole tekstowe
                    savea 0x2500
                ram 0x2126
                     savea 0x1a

            call enableinput

        jmp main

    main: // Petla glowna systemu

            set eax 0x8
            set ebx 0x3
                 call setcharpos

            ram 0x2116
                 savea 0x0
            ram 0x1fc3 // Wskzanik strigna do wartosci konwertowaej
                 savea 0x2500

            call prints // tekst

            ram 0x2164
                savea 0x2500

        call stopwatch
// Num show

            set eax 0xf // Position
            set ebx 0x8
               call setcharpos

             ram 0x2166 // delta
                 read eax

            ram 0x1fa4
                save eax

            call putnum

            call fromstringtoint
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

        call waitingforloopgrphandinput

        jmp main // Zapetlenie

stopwatch:
    call regcopy
        ram 0x212c
            read eax
            read ecx
        ram 0x2165
            read ebx

        cmp eax ebx
            jlt correctstpowatchloop
            jmp ecorrectstpowatchloop

        correctstpowatchloop:
            set edx 0xffff
                sub edx ebx
                inc edx

                add edx eax
                mov eax edx
            jmp eecorrectstpowatchloop
        ecorrectstpowatchloop:

            sub eax ebx

        eecorrectstpowatchloop:

            ram 0x2166
                save eax
            ram 0x2165
                save ecx
    call regback
    ret



    waitingforloopgrphandinput:
        call regcopy
            ram 0x1fc2 // Sprawdzanie zgloszenia przerwania przez uklad graficzny
                set eax 0x0
                save eax

            inputwaitForGraphics:
                ram 0x2162
                    set edx 0x0
                    save edx

                loopreadkeyinpause:
                    call getfromstackkey
                    call changecursor
                    ram 0x213f
                        read edx
                            cmpa edx 0xffff
                            jeq eloopreadkeyinpause

                            call stdinput

                            ram 0x2162
                                read edx
                                cmpa edx 0xffff
                                    jeq eloopreadkeyinpause
                    jmp loopreadkeyinpause
                eloopreadkeyinpause:



                ram 0x1fc2
                    read eax
                // Wartosc oczekiwana
                cmpa eax 0xffff
                    jeq inputrenderGraphics // Przekierowanie wrazie wykrycia rozpoczecia nowej klatki
                jmp inputwaitForGraphics

            inputrenderGraphics: // Render nowej klatki
        call changecursor
        call loadBuffer


        set ebx 0x0 // Czysczenie wartosci rejestru detekotora
        save ebx

        call regback
        ret