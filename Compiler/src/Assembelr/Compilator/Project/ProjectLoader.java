package Assembelr.Compilator.Project;

import java.io.*;
import java.util.ArrayList;

public class ProjectLoader {
    Project paths = new Project();

    void loadFile(String file) throws IOException{
        File filen = new File(file);
        ArrayList<String> localPaths = new ArrayList<>();

            FileReader read = new FileReader(filen);
            LineNumberReader lines = new LineNumberReader(read);

            String line="";

            while((line = lines.readLine()) != null){
                String[] words = line.split("\\s+");

                if(words.length>0){

                    for(int k=0;k<words.length;k++){
                        if(words[k].equals("include")){
                            StringBuilder path = new StringBuilder();

                            for(int n=k+1;n<words.length;n++){
                                path.append(words[n]+" ");
                            }

                            paths.addFile(path.toString());
                            localPaths.add(path.toString());
                            break;
                        }
                    }


                }
            }

            for(String localPath : localPaths){
                loadFile(localPath);
            }

    }
    public ProjectLoader(String file) throws IOException{
        paths.addFile(file);
        loadFile(file);

    }

    public Project getProject(){
        return paths;
    }
}
