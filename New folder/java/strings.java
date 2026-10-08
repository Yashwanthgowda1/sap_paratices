public class strings {

    public static void main(String[] args) {
        String values=" amama where are you";
            System.out.println(values.indexOf("where"));
        String values1=new String(values);
        System.out.println(values.toString());
        System.out.println(values.hashCode());
        System.out.println(values.equals(values1));
        System.out.println(values.length());
        System.out.println(values.charAt(2));
        char arryas[]=values.toCharArray();
        System.out.println("the length of then array "+ arryas.length);
        System.out.println(arryas[6]);
        System.out.println(values.toUpperCase());
        System.out.println(values.toLowerCase());
        String spaces[]=values.split(" ");
        for(String str:spaces){
            System.out.println(str);
        }
        System.out.println(values.strip());
        System.out.println(values.concat(values1));
        System.out.println(values.replace('a', 'Z'));
        int a=10;
        Integer b1=a;
        // implictly and explict to unboxing
        System.out.println(b1.intValue());

        String a3="12345";
        Integer val=Integer.parseInt(a3);
        if (val instanceof Integer){
            System.out.println(val.intValue());
        }


    }
    
}
