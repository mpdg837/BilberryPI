package Assembelr.FileUsing;

import Assembelr.Compilator.Data.CharTable;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.LineNumberReader;
import java.util.ArrayList;
import java.util.Locale;

public class FileLoader {

    ArrayList<String> zaw= new ArrayList<>();

    public char[] analyse(String linia) throws Exception{
        String[] splited = linia.split("\\s+");
        StringBuilder buildSplit = new StringBuilder();

        for(String word : splited){
            buildSplit.append(word);
        }

        char[] split = buildSplit.toString().toCharArray();
        StringBuilder build = new StringBuilder();

        boolean detected = false;
        boolean dete = false;
        boolean stop = false;

        for(char character : split){
            if(detected){
                if(character == '~'){
                    dete = true;
                }else
                if(character == '/'){
                    stop = true;
                }else if(!stop){
                    if (dete) {
                        build.append(CharTable.getNumberBinaryString(character));
                        dete = true;
                    } else build.append(character);
                }
            }else{
                build.append(character);
            }
            if(character == '<') detected = true;
        }

        if(!dete) return linia.toLowerCase(Locale.ROOT).toCharArray();
        else return build.toString().toLowerCase(Locale.ROOT).toCharArray();
    }
    public void ladujPlik(File file) throws Exception{


        FileReader read = new FileReader(file);
        LineNumberReader reader = new LineNumberReader(read);

        String linia = "";
        while((linia = reader.readLine()) !=null){



            char[] znak = analyse(linia);

            StringBuilder build = new StringBuilder();
            boolean start = false;
            boolean stop = false;

            if(znak.length>0) {



                    for (char znaki : znak) {

                        if (!(znaki + "").equals(" ") && !(znaki + "").equals((char) 8 + "")) start = true;

                        if (start) {
                            if ((znaki + "").equals("/")) {
                                stop = true;
                            } else if(!stop){
                                build.append(znaki);
                            }
                        }


                    }

                    if(stop){
                        // Usuwanie spacji
                        String preBuild = build.toString();
                        char[] znaki = preBuild.toCharArray();

                        String dane = "";

                        start = false;

                        for(int n=znaki.length-1;n>=0;n--){
                            if (!(znaki[n] + "").equals(" ") && !(znaki[n] + "").equals((char) 8 + ""))  start  =true;

                            if(start){
                                dane = znaki[n] + dane;
                            }
                        }

                                if(dane.length()>0){
                                    System.out.println(dane);
                                    zaw.add(dane);
                                }


                    }else{

                        String[] data = build.toString().split("\\s+");

                        if(build.toString().length()>0) {
                            if(data[0].equals("include")){

                            }else {
                                System.out.println(build.toString());
                                zaw.add(build.toString());
                            }
                        }
                    }




            }

        }


    }

    public ArrayList<String> getLista(){
        return zaw;
    }
}
