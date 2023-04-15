include Project\main\image\scaling.asm
bufferimgresolution:
    call regcopy
        ram 0x2503
             read eax
             uram eax
                read ebx
         ram 0x2508 // bX
             save ebx

         inc eax

         uram eax
             read ebx
         ram 0x2509 // bY
             save ebx

         inc eax

         uram eax // load palette
             read ebx
         ram 0x250a
             save ebx

    call regback
    ret


putnormalsegment:
    set eax 0xa // X
        ram 0x2501
            read ebx
            call sendGraphics

        set eax 0xb // Y
        ram 0x2502
            read ebx
            call sendGraphics

        set eax 0xc // char
        ram 0x2520
            read ebx

        ram 0x2504 // palette
            read ecx
               add ebx ecx
               call sendGraphics

        set eax 0xd
            ram 0x250a // memorized palette
                read ebx
                call sendGraphics
    ret

imagreadpropperbyte:
     ram 0x2503
     read eax
     uram eax
        read eax
     ram 0x2521
        read ebx
        cmpa ebx 0xffff
            jeq firstbytetoreadtoimage
            jmp secondbytetoreadtoimage
        firstbytetoreadtoimage:
        set ecx 0x7
            shr eax ebx
            res eax
     jmp finishbytetoreadtoimage
        secondbytetoreadtoimage:
            anda eax 0xff
        finishbytetoreadtoimage:

    ram 0x2520
        save eax
    ret

selectpropernewaddr:
    ram 0x2521
        read ebx
        cmpa ebx 0xffff
            jeq omitnextaddrtodo

            savea 0xffff

    ram 0x2503
        read ebx
        inc ebx
            save ebx
            jmp noomitnextaddrtodo
    omitnextaddrtodo:
         set eax 0x0
         save eax

    noomitnextaddrtodo:

    ret

showimage:
    call regcopy
    call countimagesize

    ram 0x2503
        read eax
        adda eax 0x3
        save eax

    ram 0x2501
        read eax
    ram 0x2505
        save eax
    ram 0x2521
        savea 0xffff

    looprendery:

        ram 0x2505
            read eax
        ram 0x2501
            save eax

        looprenderx:

            call imagreadpropperbyte
            call putsegment

            //select next addr

            call selectpropernewaddr

            ram 0x2501
                read ebx
                adda ebx 0x8
                save ebx
            ram 0x2506
                read ecx

                cmp ebx ecx
                    jgt finishlooprenderx
                    jmp looprenderx
        finishlooprenderx:

        ram 0x250d
            read eax
        ram 0x2502
            read ebx
            cmpa eax 0xffff
                jeq scaledstepimage
                jmp noscalestepimage

            scaledstepimage:
                adda ebx 0x8
            noscalestepimage:
                adda ebx 0x8

            save ebx

        ram 0x2507
            read ecx
            cmp ebx ecx
                jgt finishlooprendery

            jmp looprendery
    finishlooprendery:

    call regback

    ret