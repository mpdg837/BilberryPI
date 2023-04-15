
clock:
    call regcopy
        ram 0x212c
            read eax
            set ebx 0x0
            save ebx

            ram 0x2167
                read edx
                add edx eax
                save edx

                cmpa edx 0x3e8
                jeq nextsec
                jgt nextsec
                jmp eecorrectstpowatchloop

        nextsec:

            suba edx 0x3e8
            save edx

            ram 0x2168

            read edx
                inc edx
                save edx

            cmpa edx 0x3c
                jeq nextmin
                jgt nextmin
                jmp eecorrectstpowatchloop

        nextmin:
            suba edx 0x3c
                save edx

            ram 0x2169
                read edx
                inc edx
                save edx

            cmpa edx 0x3c
                jeq nexthour
                jgt nexthour
                jmp eecorrectstpowatchloop
        nexthour:
            suba edx 0x3c
                save edx

            ram 0x216a
                read edx
                inc edx
                save edx

            cmpa edx 0x18
                jeq nextday
                jgt nextday
                jmp eecorrectstpowatchloop

        nextday:
            suba edx 0x18
                 save edx
        eecorrectstpowatchloop:

            ram 0x2166
                save eax
            ram 0x2165
                save ecx
    call regback
    ret

