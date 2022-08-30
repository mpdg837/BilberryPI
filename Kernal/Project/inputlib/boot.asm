include Project\inputlib\input.asm
include Project\inputlib\keyboardstack.asm
include Project\inputlib\cursor.asm
include Project\inputlib\strtoint.asm
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
            cmpa eax 0x3
                jeq strtointtest
            backstart:

        call regback
        ret

    strtointtest:
        call fromstringtoint
        jmp backstart
    starttest:
        call waitingforloopgrphandinput
        jmp backstart
    startenablestd:
        call enableinput
        jmp backstart




