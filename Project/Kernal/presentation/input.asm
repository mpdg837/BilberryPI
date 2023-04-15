
waitforkeyboard:
    call regcopy

    loopwaitforkeykeyboard:

    ram 0x2105
        read eax

        cmpa eax 0xffff
            jeq eloopwaitforkeykeyboard
        jmp loopwaitforkeykeyboard

    eloopwaitforkeykeyboard:

    call regback
    ret

resetkeybuffer:
    ram 0x2105
        savea 0x0
    ret

getkey:
    call regcopy

    call resetkeybuffer
    call regback
    ret

input:
    call regcopy

    call resetkeybuffer
    call regback
    ret

