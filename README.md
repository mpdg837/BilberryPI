# BilberryPI
<p align='center'>
<img src="https://raw.githubusercontent.com/mpdg837/BilberryPI/main/demo1.jpg"  width="700" height="400">
</p>
## Czym jest projekt
 Jest to projekt SOC wykonanym na jednym z układów FPGA - Cyclone IV polegający na implementacji prostego komputera 16-bitowego (w stylu komputera retro), umożliwiający mimo niskich parametrów sprzętowych (14 kB RAMu + 6 VRAM) na 
 wyświetlanie obrazu (VGA 344x256, 27 kolorów) oraz dźwieku samplowanego (16 kHz 4-kanałowego). Umożliwia proste ładowanie programów poprzez odpowiednio przygotowaną kartę SD (układ posiada moduł obsługi tych kart). Układ posiada też 
 obsługe interfejsu PS/2 dzieki któremu można podłączyć klawiaturę po tym złaczu.
 
 Układ jest oparty o autorski 16-bitowy procesor (projekt był rodzajem ekspetymentu ile można uzyskać tworząc oprogramowanie na własny układ opaty o własną nigdzie indziej nie wspieraną architekrurę oraz na tym jak bardzo 
 zaawansowany procesor da się "wymyśleć" w warunkach domowych, korzystając z niewielkich zasobów - płytka na którą stworzono układ ma zaledwie 6k bloków logicznych LE's). Roboczo układ nazwano Bilberry a sam 
 układ Bilberry PI, gdyż podobnie jak słynne Raspberry PI jest komputerem umieszczonym w zasadzie na jednym chipie, ładuje on oprogramowanie z karty SD. Projekt jest nadal w fazie Beta, wymaga jeszcze wielu testów.
 
## Opis architektury
 Poniższy schemat opisuje architekurę rozwiązania:
 
 <p align='center'>
<img src="https://raw.githubusercontent.com/mpdg837/BilberryPI/main/Architecture.png"  width="700" height="550">
</p>

Tak jak w wstępnym opisie układ posiada kilka komponentów:
* Procesor 16-bitowy oprty o autorską arrchitekturę obsługujący ponad 40 rozkazów. Posiada odzielną magistralę do obslugi urządzeń oraz odzielną do obsługi pamięci. Kontroler przerwań przyjmuje 7 przerwań pochodzących od komponentów.
Procesor posiada wbudowaną mnożarkę oraz układ dzielący, ALU obsługujące proste operacje logiczne (AND,OR,XOR) oraz arytmetyczne. Procesor nie rozróżnia trybów signed lub unsigned - wszystkie rejestry 16-bitowe są uwzględniane z 
ich znakiem (czyli signed). Procesor ma dostęp do 4 komponentów wejścia i 4 komponentów wyjścia.
* Układ wspiera DMA, dzieki niemu układ dźwiękowy może czytać próbki bezpośrednio z pamięci RAM.
* Dostępna jest pamięć 14 kB RAMu oraz 5 kB ROM-u; 4 kB tzw. KERNAL-a, oproramowanie startowe - bootloader posiadaący podstawowe biblioteki do obsługi układu graficznego i dźwiękowego, odpowiada za diagnostykę pamięci RAM oraz
za ładowanie oprogramowania z karty SD. Odpowiada on też za obsługe przerwań (szczególnie odbiera wciskanie klawiszy na klawiaturze oraz za tzw. timery). Niemniej do poprawnego działania wymagane jest oprogramowanie dostarczone na karcie SD, bez niego komputer się nie uruchomi. Pozostaly 1 kB zawiera podstawowa czcionke systemu. Rozwiazanie to 
skraca programy ladowane z karty i ułatwia prace podczas pisania oprogramowania. Pozostały 1 kB przechowuje podstawową czcionkę systemu:

<p align='center'>
<img src="https://raw.githubusercontent.com/mpdg837/BilberryPI/main/font.png"  width="160" height="160">
</p>
<p align='center'>
Wzorzec czcionki systemowej.
</p>
<p align='center'>
<img src="https://raw.githubusercontent.com/mpdg837/BilberryPI/main/charset.jpg"  width="700" height="400">
</p>
<p align='center'>
Czcionka systemowa wyswietlona przez uklad.

</p>

* Timer wysyla cykliczne przerwanie co 1 ms - dzieki niemu możliwy jest pomiar czasu przez programy procesora.
* Moduł graficzny o rozdzielczości 344x256 - obsługuje on 27 kolorów. Obraz generowany przez niego posiada 3 warstwy. Pierwsza sklada sie z znakow których wzorzec jest ladowany do VRAMU oraz na podstawie jego i pozostalych informacji w VRAM o ich polozniu
generowany jest obraz z znaków o rozdzielczosci 8x8 , co tworzy tablice znaków o wymiarach 43x32. Rodzajów znaków na jednej klatce może być maksymalnie 128. Istnieje możliwość powiekszenia 2x w osi Y znaków. Każdemu znakowi można 
przyporządkować jedną z 8 4-kolorwych palet. W ten sposób można uzyskać dobrej jakości tło korzystając z małych zasobów. Druga warstwą jest warstwa spriteów - można ich wyświetlać na raz maksymalnie 24 przy czym 8 w jednej linii. Kazdemu takiemu spriteowi
 jest przydzelana paleta kolorów 3-kolorowa (4-kolorowa jezeli uwzględnamy kolor przezroczysty). Spritey te mają rozdzielczość 16x16 mozna je rozciągać i skurczac w osi X i skurczać w osi Y. Obie te warstwy są ruchome można zmieniać ich pozycje względem lewego,
 górnego kąta ekranu. Ostatnią warstwą jest warstwa przednia- jest ona nieruchoma obsługuje zaledwie 16 znaków i tylko jedną 3-kolorwą paletę (4 kolory z przezorcyzstym). Układ korzysta z 6 kB VRAMu.

<p align='center'>
<img src="https://raw.githubusercontent.com/mpdg837/BilberryPI/main/demo2.jpg"  width="700" height="400">
</p>
<p align='center'>
Przykladowe obrazy mozliwe do wyswietlenia na ukladzie.
</p>
<p align='center'>
<img src="https://raw.githubusercontent.com/mpdg837/BilberryPI/main/paleta.jpg"  width="200" height="350">
</p>
<p align='center'>
Paleta dostepnych 27 kolorów.
</p>

 * Moduł dźwiękowy korzysta on z 3 kanałów umożliwająych odtwarzanie sampli z pamięci oraz jeden kanał umożliwiający generowanie dźwięków za pomocą wbudowanego generatora (umożliwia generowanie sygnału sinusoidalnego, piłokształtnego, trójkątnego , szumu oraz prostokątnego). 
 Dźwięki te są na wyjściu sumowane, moduł jako jedyny korzysta z DMA.Dźwięk jest generowany za pomocą 8 wyjść PWM, głośność jest ustalana na podstawie tego ile danych PWM-ów generuje w danym momencie sygnał. PWM-y są podłączane do jednego węłza a ten węzeł jest
 podłączany do jednego z wyjść głośnika zaś drugie wyjście głośnika jest podłączone do masy.
 
 * Moduł kart SD - umożliwia on odczyt oraz zapis kart SD, dzięki niemu możliwe jest ładowanie oprogramowania na układ.
 * Układy I/O obsługujące przyciski, diody kontrolne oraz klawiaturę PS/2
<p align='center'>
<img src="https://raw.githubusercontent.com/mpdg837/BilberryPI/main/testtekstu1.jpg"  width="700" height="400">
</p>
<p align='center'>
<img src="https://raw.githubusercontent.com/mpdg837/BilberryPI/main/testtesktu2.jpg"  width="700" height="400">
</p>
<p align='center'>
Możliwość edycji teksu.

</p>
 
 ## Dostarczony kod
 Dostarczony w tym repozytorium kod zawiera
 * Kod układu w języku Verilog.
 * Kod kompilatora oraz konwertera czcionki wykoanego w Javie.
 * Kod Kernala oraz programu przykładowego (prosty "input" ) wykonanego w assemblerze procesora, możliwy jest on do skomiplowania w dostarczonym kompilatorze.
 
# Podlaczenie komponentów.
Projekt był tworzony na układ EP4CE6E22C8. Na dosyc dobrze rozpowszechnionej płytce (min na EBay-u <a href = "https://www.ebay.com/itm/223546638831">link</a>), należało dodatkowo użyć własnego
modułu złącza kart SD (Najlepszy dla tego układu będzie moduł będzie moduł bez dodatkowego mikrokontrolera, projekt obsługuje jedynie tryb SPI)oraz odpowiednio podłączonego głośnika. Do jednej z nóg głośnika należało podłączyć wszystkie PWM-y a do drugiej masę tak jak na poniższym schemacie:
<p align='center'>
<img src="https://raw.githubusercontent.com/mpdg837/BilberryPI/main/plytka.jpg"  width="600" height="400">
</p>
<p align='center'>
Podlaczenie na plytce.

</p>


 