

    clearSystem:

        call ramclear
        call clearPalette
            call clearSprites

            call loadBuffer
                call waitingforloopgrph
            call loadBuffer
                call waitingforloopgrph
            call loadBuffer
                call waitingforloopgrph
            call loadBuffer
                call waitingforloopgrph
        ret



    prepareSystem:

            call clearSystem

            set eax 0x5 // LED Display
            set ebx 0x0
                call sendCopper

            ram 0x2110
                savea 0x0800
            call loadcharset // Ladowanie znakow

        ret

    init: // Czyszczenie ramu

        call prepareSystem

        call diskstarter
        call bootloader

        set eax 0x5 // LED Display
        set ebx 0x2
            call sendCopper

        set eax 0x802
            jmpr eax
