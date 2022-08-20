

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

    // String
    &data 0x07b0 < ~RB
    &data 0x07b1 < ~AI
    &data 0x07b2 < ~TL
    &data 0x07b3 < ~EB
    &data 0x07b4 < ~DE
    &data 0x07b5 < ~_R
    &data 0x07b6 < ~CR
    &data 0x07b7 < ~HY
    &data 0x07b8 < ~I_
    &data 0x07b9 < ~PI
    &data 0x07ba < ~_N
    &data 0x07bb < ~VT
    &data 0x07bc < ~0E
    &data 0x07bd < ~1G
    &data 0x07be < ~ee
