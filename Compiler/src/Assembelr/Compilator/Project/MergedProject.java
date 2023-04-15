package Assembelr.Compilator.Project;

import java.util.ArrayList;

public class MergedProject {
    private ArrayList<String> list = new ArrayList<>();

    public MergedProject(ArrayList<String> list){
        this.list = list;
    }

    public ArrayList<String> getList(){
        return list;
    }
}
