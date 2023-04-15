
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
                ram 0x212a
                    set edx 0x0
                    save edx

                    nosoundplayme:
                call putchar
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
            ram 0x17b0
                savea 0x3e
            ram 0x17b1
                savea 0xf

            set ecx 0x1360 // Adres Spritea
            set ebx 0x8 // Numer
                call loadSpriteTex

            call spriteload

//
            ram 0x2125 // Pole tekstowe
                savea 0x17b0
            ram 0x2126
                 savea 0x1a

            ram 0x2118
                set eax 0x0
                save eax

            ram 0x211b
                savea 0x4
            ram 0x2128
                savea 0x1

            call calltoblock
//

        jmp main

    main: // Petla glowna systemu




            set eax 0x8
            set ebx 0x3
                 call setcharpos

            ram 0x2116
                 savea 0x0
            ram 0x1fc3 // Wskzanik strigna do wartosci konwertowaej
                 savea 0x17b0

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

        call playingsound // Odgrywanie dzwieku
        call deltascreen
//
              ram 0x2118
                  set eax 0x0
                  save eax

              ram 0x211b
                  savea 0x4
              ram 0x2128
                  savea 0x2

              call calltoblock
  //



        jmp main // Zapetlenie


    // String
