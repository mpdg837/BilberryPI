# BilberryPI

## Czym jest projekt
 Jest to projekt SOC wykonanym na jednym z układów FPGA - Cyclone IV polegający na implementacji prostego komputera 16-bitowego (w stylu komputera retro), umożliwiający mimo niskich parametrów sprzętowych (14 kB RAMu + 8 VRAM) na 
 wyświetlanie obrazu (VGA 344x256, 27 kolorów) oraz dźwieku samplowanego (16 kHz 4-kanałowego). Umożliwia proste ładowanie programów poprzez odpowiednio przygotowaną kartę SD (układ posiada moduł obsługi tych kart). Układ posiada też 
 obsługe interfejsu PS/2 dzieki któremu można podłączyć klawiaturę po tym złaczu.
 
 Układ jest oparty o autorski 16-bitowy procesor (projekt był rodzajem ekspetymentu ile można uzyskać tworząc oprogramowanie na własny układ opaty o własną nigdzie indziej nie wspieraną architekrurę oraz na tym jak bardzo 
 zaawansowany procesor da się "wymyśleć" w warunkach domowych, korzystając z niewielkich zasobów - płytka na którą stworzono układ ma zaledwie 6k bloków logicznych LE's). Roboczo układ nazwano Bilberry a sam 
 układ Bilberry PI, gdyż podobnie jak słynne Raspberry PI jest komputerem umieszczonym w zasadzie na jednym chipie, ładuje on oprogramowanie z karty SD. Projekt jest nadal w fazie Beta, wymaga jeszcze wielu testów.
 
## Opis architektury
 
![Alt text](https://raw.githubusercontent.com/mpdg837/BilberryPI/main/Architecture.png "a title")