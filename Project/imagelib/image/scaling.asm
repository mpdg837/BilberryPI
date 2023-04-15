
putuppersegment:
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

    ram 0x2504
        read ecx
           add ebx ecx
           adda ebx 0x40
           call sendGraphics

    set eax 0xd
        ram 0x250a // memorized palette
            read ebx
            call sendGraphics
    ret

putlowersegment:

        set eax 0xb // Y
        ram 0x2502
            read ebx
            adda ebx 0x8
            call sendGraphics

        set eax 0xc // char
        ram 0x2520 // offset
            read ebx

        ram 0x2504
            read ecx
               add ebx ecx
               adda ebx 0x80
               call sendGraphics

        set eax 0xd
            ram 0x250a // memorized palette
                read ebx
                call sendGraphics
    ret


countimagesize:
    call regcopy

         call bufferimgresolution

         ram 0x2501
              read eax


         ram 0x2508
              read ebx
                  dec ebx

                  set ecx 0x2

                  shl ebx ecx
                  res ebx

              add eax ebx
          ram 0x2506 // limX
              save eax

          ram 0x2502
              read eax

          ram 0x250d // offset
              read edx

         ram 0x2509
              read ebx

              dec ebx

              cmpa edx 0xffff
                   jeq scaleimagesize
                   jmp noscaleimagesize

              scaleimagesize:
                       set ecx 0x3
                  jmp finishscaleimagesize
                  noscaleimagesize:
                       set ecx 0x2
                  finishscaleimagesize:
                  shl ebx ecx
                  res ebx

              add eax ebx
          ram 0x2507 // limY
              save eax


    call regback
    ret

putsegment:
    ram 0x250d
        read eax
        cmpa eax 0xffff
            jeq putscaledsegemnt
            jmp noputscaledsegemnt
    putscaledsegemnt:
        call putuppersegment
        call putlowersegment
            jmp finishputscaledsegemnt
    noputscaledsegemnt:
        call putnormalsegment
    finishputscaledsegemnt:

    ret