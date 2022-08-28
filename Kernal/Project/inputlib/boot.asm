include Project\inputlib\input.asm
include Project\inputlib\keyboardstack.asm

    nop
    set eax 0xdddd // identyfikator

    start:
        call regcopy

        ram 0x2128
            read eax

            cmpa eax 0x1
                jeq startenablestd
            cmpa eax 0x2
                jeq starttest
            backstart:

        call regback
        ret

    starttest:
        call waitingforloopgrphandinput
        jmp backstart
    startenablestd:
        call enableinput
        jmp backstart
