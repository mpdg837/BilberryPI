package Assembelr.Compilator.Data;

public class CharTable {

    static char[] charTable = {'_','0','1','2','3','4','5','6','7','8','9','-','+','*','/','e','n','u','d','l','r',
            'a','s','c','f',')','"','(','=','%','$','?','A','B','C','D','E','F','G','H','I','J','K','L','M','N',
            'O','P','Q','R','S','T','U','V','W','X','Y','Z','.',',',':',';','#','!'};

    public static boolean contains(char znak){
        boolean contin = false;

        for(int n=0;n<charTable.length;n++){
            if(charTable[n] == znak) contin = true;
        }

        return contin;
    }

    public static int getNumber(char znak) throws Exception{
        int number = -1;

        for(int n=0;n<charTable.length;n++){
            if(charTable[n] == znak) number = n;
        }

        if(number == -1) throw new Exception();

        return number;
    }

    public static String intToBinary(int n)
    {
        String s = "";
        while (n > 0)
        {
            s =  ( (n % 2 ) == 0 ? "0" : "1") +s;
            n = n / 2;
        }
        return s;
    }

    private static String intTo8Bin(int number){

        String s = intToBinary(number);

        if(s.length()<8){
            for(int n=s.length();n<8;n++){
                s = "0" + s;
            }
        }
        System.out.println(s);


        return s;
    }

    public static String getNumberBinaryString(char znak) throws Exception{
        int number = getNumber(znak);
        return intTo8Bin(number);
    }
}
