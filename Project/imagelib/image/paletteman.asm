
setpaletteimage:
    call regcopyn

    set eax 0x3
        ram 0x250e
        read ebx
        call sendGraphics

    uram edx
       set eax 0x4
       read ebx
           call sendGraphics
    inc edx
    uram edx
       set eax 0x5
       read ebx
           call sendGraphics

    call regback
    ret

bufferpalette:
    call regcopy

        ram 0x250b
            read edx

        uram edx
            read eax
        ram 0x250f
            save eax
            inc edx

        uram edx
            read eax
        ram 0x2510
            save eax

    call regback
    ret

paletteman:
    call regcopy
    // load palette
    ram 0x250b
        read edx

    ram 0x2107
        save edx

    call bufferpalette
    call palettelist

    call setpaletteimage

    call regback
    ret

palettelist:
    call regcopy

    set edx 0x2511
    set ecx 0x2

    loopaddpalettelist:

        cmpa ecx 0x8 // too many palettes
            jeq eloopaddpalettelist

        uram edx // Decsicion about adding new palette
            read eax
        inc edx
        uram edx
            read ebx

        cmpa eax 0x0
            jeq firstnullfieldoflistpalette
            jmp nonullfieldoflistpalette

        firstnullfieldoflistpalette:

            cmpa ebx 0x0
                jeq addnewpalettex
                jmp nonullfieldoflistpalette

        addnewpalettex:
            call addnewpalette
            jmp eloopaddpalettelist
        nonullfieldoflistpalette:

        // Does that palette exists
        dec edx

        uram edx
            read eax
        ram 0x250f
            read ebx
            cmp eax ebx
                jeq analysenextsegmentofpalette
                jmp analysenextpalette


        analysenextsegmentofpalette:

        inc edx
            uram edx
            read eax
        ram 0x2510
            read ebx
            cmp eax ebx
                jeq eloopaddpalettelist

                dec edx
        analysenextpalette:

        adda edx 0x2
        inc ecx

        jmp loopaddpalettelist
    eloopaddpalettelist:

    ram 0x250e
        save ecx

    call regback
    ret

addnewpalette:
    call regcopyn

    ram 0x250f // read from buffer
        read eax
    ram 0x2510
        read ebx

    dec edx
        uram edx
        save eax
    inc edx
        uram edx
        save ebx

    call regback
    ret