public class JP_Util {
    /**
     *  左Padding　文字指定可
     *      @param: String s 元の文字列
     *              Integer len 文字列の長さ
     *              String padstr 左埋め文字列
     */
    public static String leftpadBy(String s, Integer len, String padStr){
        if(s == null || len == null){
            return s ;
        }
        padStr = (padStr == null)?'':padStr;
        return s.leftPad(len,padStr);
    }

    /*  数値左ゼロ埋め */
    public static String leftpadBy(Integer num, Integer len){
        if(num==null){num=0;}

        return leftPadBy(String.valueOf(num), len, '0');
    }

}