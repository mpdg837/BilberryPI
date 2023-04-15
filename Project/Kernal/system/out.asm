    include Project\Kernal\conversion\doubledabble.asm
    include Project\Kernal\conversion\inttostr.asm
    include Project\Kernal\presentation\print.asm
    include Project\Kernal\presentation\input.asm


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