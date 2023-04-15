package FontConverter;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

public class FontConverter {

    public FontConverter(){
        File file = new File("font.png");
        try {
            BufferedImage image = ImageIO.read(file);

            int k = 0;
            int n=2048;
            for(int y=0;y<64;y+=8){
                for(int x=0;x<64;x+=8){
                    for(int ny=0;ny<8;ny++){
                        String hex = Integer.toHexString(n);
                        System.out.print("&data 0x0"+hex+" < ");

                        for(int nx=0;nx<8;nx++){

                            int rgb = image.getRGB(x+nx,y+ny);

                            if(rgb == -16777216)  System.out.print("11");
                            else System.out.print("00");


                        }
                        n++;
                        System.out.println("");

                    }
                    k++;
                    System.out.println(" ");
                }
            }

        }catch (IOException err){
            System.out.println("Nie wykryto pliku czcionki");
        }
    }

    public static void main(String[] args){
        new FontConverter();
    }
}
