    include Kernal\conversion\doubledabble.asm
    include Kernal\conversion\inttostr.asm
    include Kernal\presentation\print.asm

    setposchar:
                   set eax 0x0a // Wybor pozycji w X

                         ram 0x1fc0 // Wczytanie z rejestru pozycji pisarza dla X
                            read ebx

                         set ecx 0x2 // Odstęp

                         shl ebx ecx // Przesuniecie aby byl odstep miedzy znakami
                            res ebx

                          // Wyslanie prosby do karty
                         call sendGraphics

                    set eax 0x0b // Wybor pozycji Y
                          ram 0x1fc1 // Wczytanie z rejestru pozycji pisarza dla Y
                              read ebx

                          set ecx 0x2 // Odstęp

                          shl ebx ecx // Przesuniecie aby byl odstep miedzy znakami
                          res ebx

                           // Wyslanie prosby do karty
                          call sendGraphics



                    set eax 0x0c // Wybor znaku


        ret

    colorMyBlock:
        set eax 0x0d
            ram 0x210a
            read ebx

            // Wyslanie prosby do karty
            call sendGraphics
        ret


    abs:
            cmpa eax 0x0
                jlt makeAbs
                jmp endAbs
        makeAbs:
            not eax
            inc eax
        endAbs:

        ret

    putchari:
        call regcopy

        call setposchar
            ram 0x1fe1
                read ebx
            call sendGraphics
            call colorMyBlock
        call regback
        ret

    putchar:
        call regcopy

        call setposchar
            set ebx 0x3e
            call sendGraphics
            call colorMyBlock
        call regback
        ret

    setcharpos:
            ram 0x1fc0
                save eax
            ram 0x1fc1
                save ebx
        ret