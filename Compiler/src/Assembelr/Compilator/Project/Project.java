package Assembelr.Compilator.Project;

import java.io.File;
import java.util.ArrayList;

public class Project {

    ArrayList<File> lista = new ArrayList<File>();
    private int index;

    public Project(){
        index = 0;
    }

    public void addFile(String fileName){
        lista.add(new File(fileName));
    }

    public File next(){
        File answ = lista.get(index);
        index++;
        return answ;
    }

    public int getLength(){
        return lista.size();
    }
}
