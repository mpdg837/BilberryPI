

    sendGraphics: // Wyslanie wiadomosci
        call regcopyn

        // Dodanie identyfikatora
        eora eax 0x8000

        out ebx 0x0 // Wyslanie informacji
        out eax 0x1

        call regback
        ret


    loadPalette:
        call regcopy

        ram 0x2107
            read edx

        set ecx 0x0
               looploadPalette:
                    set eax 0x3 // GET PALETTE.NUMBER
                        mov ebx ecx


                        call sendGraphics

                    set eax 0x4 // GET PALETTE.NUMBER
                        uram edx
                            read ebx
                        call sendGraphics

                    inc edx
                    set eax 0x5
                        uram edx
                            read ebx

                        call sendGraphics
                    inc edx
                    inc ecx

                    cmpa ecx 0x8
                        jeq elooploadPalette

               jmp looploadPalette
               elooploadPalette:

        call regback
        ret


    deltascreen:

        set eax 0x1
            ram 0x210d
            read ebx
            call sendGraphics

        set eax 0x2
            ram 0x210e
            read ebx
            call sendGraphics

        ret

    grphstart: // 60 Hz
        nint
        call regcopyinter

        ram 0x2111 // Aby przyspieszyc procesy ladowania
            read eax
            cmpa eax 0xffff
                jeq ignoresystemmanagment


        ram 0x1fc2 // informowanie o zapetleniu
            savea 0xffff

        ignoresystemmanagment:
        int
        call regbackinter
        ret

    grphcleared:
        call regcopyinter

        ram 0x2002
            savea 0xffff


        call regbackinter
        ret

    loadSpriteTex:
        call regcopyn

        set eax 0x12
            call sendGraphics

        set edx 0x0

        looploadSpriteTex:
            set eax 0x13 // Linia tekstury
                mov ebx edx
                call sendGraphics

            uram ecx // Sektor1
                read ebx
                set eax 0x14
                    call sendGraphics
            inc ecx

            uram ecx // Sektor1
                read ebx
                set eax 0x15
                    call sendGraphics

            inc ecx
            inc edx
                cmpa edx 0x10
                jeq finlooploadSpriteTex
            jmp looploadSpriteTex
        finlooploadSpriteTex:

        call regback
        ret

    loadcharset:
        call clearreg

        ram 0x2110
            read edx // Adresowanie komórki tekstury

                ram 0x2119 // Zerowanie pierwotnej petli
                    set ebx 0x0
                    save ebx


                looptypechar: // Wybieranie typu znaku

                    ram 0x2119
                        read ebx

                    set eax 0x6
                        call sendGraphics

                        set ecx 0x0
                        loopchar:

                            set eax 0x7
                            mov ebx ecx
                                call sendGraphics

                            uram edx
                                read ebx

                                set eax 0x8
                                    call sendGraphics
                                set eax 0x9
                                    call sendGraphics



                            inc edx // Adres komorki do przeniesienia
                            inc ecx // YLINE

                            // Warunek koncowy petli
                                cmpa ecx 0x7
                                jgt endloopchar

                            jmp loopchar

                    endloopchar:

                    ram 0x2119 // Wcyztanie licznika znakow
                        read ebx

                    // Sprawdzenie przekroczenia
                        cmpa ebx 0x007e
                        jgt endlooptypechar // Koniec

                        inc ebx // Postep
                            save ebx
                    jmp looptypechar

                endlooptypechar:

            ram 0x2119
            set eax 0x0
            save eax

            call clearreg
        ret

    clearPalette:
            set ecx 0x0

                loopgrph:
                    set eax 0x3 // GET PALETTE.NUMBER
                    mov ebx ecx


                        call sendGraphics

                    set eax 0x4 // GET PALETTE.NUMBER
                    set ebx 0x0


                        call sendGraphics
                    set eax 0x5 // GET PALETTE.NUMBER
                    set ebx 0x0


                        call sendGraphics

                    inc edx
                    inc ecx

                    cmpa ecx 0x2

                    jgt endloopgrph
                    jmp loopgrph

                endloopgrph:

        ret

    waitForGraphAnswer:

        loopfinishClearScreen:
                ram 0x2002
                    read eax
                    cmpa eax 0xffff
                        jeq finishClearScreen
                    jmp loopfinishClearScreen

                finishClearScreen:
        ret

    loadBuffer:
            call clearreg

            ram 0x2002
                 set eax 0x0
                 save eax

            set eax 0xfd
            set ebx 0x0

            // Wyslanie prosby do karty
                call sendGraphics


                call waitForGraphAnswer
            ret

    clearSprites:
         call clearreg

         set ebx 0x8
         ram 0x2116
            save ebx

         clearspritesloop:
             ram 0x2116
                read ebx

             set ecx 0x1b00 // Adres Spritea
                 call loadSpriteTex

             ram 0x2116
                  read ebx
                  cmpa ebx 0x1f
                    jeq clearspritesloope
                  inc ebx
                  save ebx

                  jmp clearspritesloop
         clearspritesloope:
         ret


    waitingforloopgrph:
        call regcopy

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
        call regback
        ret