/**
 * TerraSky 共通モジュール
 * Copyright (C) TerraSky Co.,Ltd.
 * 概要    : 文字列操作を行うユーティリティクラス
 * @developedApiVer  : 30.0
 */
public with sharing class JP_StringUtil {
    // 半角正規表現
    private static final String ORIG_REG_EN = '[ -~｡-ﾟ]';
    
    // 全角正規表現
    private static final String ORIG_REG_EM = '[^ -~｡-ﾟ]';
    
    // ひらがな正規表現
    private static final String ORIG_REG_HIRAGANA = '[ぁ-ゞ]';
    
    // 半角数値正規表現
    private static final String ORIG_REG_ENNUMBER = '[0-9]';
    
    // 全角数値正規表現
    private static final String ORIG_REG_EMNUMBER = '[０-９]';

    // カタカナ正規表現
    private static final String ORIG_REG_KATAKANA = '[ァ-ヶｦ-ﾟ]';
    
    // 半角カナ正規表現
    private static final String ORIG_REG_ENKATAKANA = '[ｦ-ﾟ]';

    // 半角数値カナ正規表現
    private static final String ORIG_REG_ENNUMKATAKANA = '[ｦ-ﾟ0-9]';
    
    // 文字コード半角カナ正規表現
    private static final String ORIG_REG_CHARCODEENKANA = '[｡-ﾟ]';
    
    // 全角カナ正規表現
    private static final String ORIG_REG_EMKATAKANA = '[ァ-ヶ]';
    
    // 半角記号正規表現
    private static final String ORIG_REG_ENSYMBOL = '[\\u0020-\\u002F\\u003A-\\u0040\\u005B-\\u0060\\u007B-\\u007E\\uFF61-\\uFF65]';
    
    /*
     * 漢字正規表現
     * 3005 々（漢字の踊り字）
     * 3007 〇（漢数字のゼロ）
     * 303B 〻（漢字の踊り字）
     * 3400..9FFF CJK統合漢字拡張A（＋易経の四十六卦）＋CJK統合漢字
     * F900..FAFF CJK互換漢字
     * 20000..2FFFF CJK統合漢字拡張B〜D＋CJK互換漢字追加（＋念のため）
    */

    // 2015/06/01 Okano 5桁のUnicodeはSalesforce対応していないため除外
    // private static final String ORIG_REG_CHINESECHAR = '[\\u3005\\u3007\\u303B\\u3400-\\u9FFF\\uF900-\\uFAFF\\u20000-\\u2FFFF]';
    private static final String ORIG_REG_CHINESECHAR = '[\\u3005\\u3007\\u303B\\u3400-\\u9FFF\\uF900-\\uFAFF]';

    // 郵便番号正規表現
    private static final String ORIG_REG_POSTCODE = '\\d{3}-\\d{4}';

    // クレジットカード番号正規表現
    private static final String ORIG_REG_CREDITNUMBER = '(((\\d{4}-){3}\\d{4})|\\d{16})?';

    // IPアドレス正規表現
    private static final String ORIG_REG_IPADDRESS = '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$';

    // datetimeフォーマット
    public static String dateTimeFormat = 'yyyy/MM/dd HH:mm:ss';

    // ユーザタイムゾーン
    public static TimeZone userTimeZone = UserInfo.getTimeZone();

    /**
     * nullをブランクに変換
     * @param s 対象文字列
     * @return 変換された文字列
     */
    public static String null2Blank(String s) {
        if (s == null) {
            return '';
        }
        return s;
    }
    
    /**
     * ブランクをnullに変換
     * @param s 対象文字列
     * @return 変換された文字列
     */
    public static String blank2Null(String s) {
        if (s == '') {
            return null;
        }
        return s;
    }
    
    /**
     * 半角スペースと全角スペースのトリム
     * @param s 対象文字列
     * @return トリムした文字列
     */
    public static String trim(String s) {
        String dest = null;
        if (s != null) {
            dest = s.replaceAll('^( |　)+|( |　)+$', '');
        }
        return dest;
    }
    
    /**
     * 半角スペースと全角スペースの接頭トリム
     * @param s 対象文字列
     * @return トリムした文字列
     */
    public static String LTrim(String s) {
        String dest = null;
        if (s != null) {
            dest = s.replaceAll('^( |　)+', '');
        }
        return dest;
    }
    
    /**
     * 半角スペースと全角スペースの末尾トリム
     * @param s 対象文字列
     * @return トリムした文字列
     */
    public static String RTrim(String s) {
        String dest = null;
        if (s != null) {
            dest = s.replaceAll('( |　)+$', '');
        }
        return dest;
    }
    
    /**
     * 全角チェック
     * @param s 対象文字列
     * @return 全角：true それ以外：false
     */
    public static Boolean isEm(String s) {
        if (s != null) {
            return Pattern.matches('^' + ORIG_REG_EM + '+$', s);
        }
        return false;
    }
    
    /**
     * 半角チェック
     * @param s 対象文字列
     * @return 半角：true それ以外：false
     */
    public static Boolean isEn(String s) {
        if (s != null) {
            return Pattern.matches('^' + ORIG_REG_EN + '+$', s);
        }
        return false;
    }

    /**
     * ひらかなチェック
     * @param s 対象文字列
     * @return ひらかな：true それ以外：false
     */
    public static Boolean isHiragana(String s) {
        if (s != null) {
            return Pattern.matches('^' + ORIG_REG_HIRAGANA + '+$', s);
        }
        return false;
    }
    
    /**
     * カタカナチェック
     * @param s 対象文字列
     * @return カタカナ：true それ以外：false
     */
    public static Boolean isKatakana(String s) {
        if (s != null) {
            return Pattern.matches('^' + ORIG_REG_KATAKANA + '+$', s);
        }
        return false;
    }
    
    /**
     * 全角カナチェック
     * @param s 対象文字列
     * @return カタカナ：true それ以外：false
     */
    public static Boolean isEmKatakana(String s) {
        if (s != null) {
            return Pattern.matches('^' + ORIG_REG_EMKATAKANA + '+$', s);
        }
        return false;
    }
    
    /**
     * 半角カナチェック（下記の文字は半角カナ領域に含まれているが除外）
     * 除外文字 ｡｢｣､･
     * @param s 対象文字列
     * @return 半角カナ：true それ以外：false
     */
    public static Boolean isEnKatakana(String s) {
        if (s != null) {
            return Pattern.matches('^' + ORIG_REG_ENKATAKANA + '+$', s);
        }
        return false;
    }
    
    /**
     * 文字コード上半角カナチェック
     * @param s 対象文字列
     * @return 半角カナ：true それ以外：false
     */
    public static Boolean isCharCodeEnKana(String s) {
        if (s != null) {
            return Pattern.matches('^' + ORIG_REG_CHARCODEENKANA + '+$', s);
        }
        return false;
    }
    
    /**
     * 半角数値チェック
     * @param s 対象文字列
     * @return 半角数値カナ：true それ以外：false
     */
    public static Boolean isEnNum(String s) {
        if (s != null) {
            return Pattern.matches('^' + ORIG_REG_ENNUMBER + '+$', s);
        }
        return false;
    }
    
    /**
     * 全角数値チェック
     * @param s 対象文字列
     * @return 半角数値カナ：true それ以外：false
     */
    public static Boolean isEmNum(String s) {
        if (s != null) {
            return Pattern.matches('^' + ORIG_REG_EMNUMBER + '+$', s);
        }
        return false;
    }
    
    /**
     * 半角数値カナチェック
     * @param s 対象文字列
     * @return 半角数値カナ：true それ以外：false
     */
    public static Boolean isEnNumKana(String s) {
        if (s != null) {
            return Pattern.matches('^' + ORIG_REG_ENNUMKATAKANA + '+$', s);
        }
        return false;
    }
    
    /**
     * 漢字チェック
     * @param s 対象文字列
     * @return 漢字：true それ以外：false
     */
    public static Boolean isChineseChar(String s) {
        if (s != null) {
            return Pattern.matches('^' + ORIG_REG_CHINESECHAR + '+$', s);
        }
        return false;
    }
    
    /**
     * 郵便番号フォーマットチェック
     * @param s 対象文字列
     * @return 郵便番号：true それ以外：false
     */
    public static Boolean isPostCode(String s) {
        if (s != null) {
            return Pattern.matches(ORIG_REG_POSTCODE, s);
        }
        return false;
    }
    
    /**
     * クレジット番号フォーマットチェック
     * @param s 対象文字列
     * @return クレジット番号：true それ以外：false
     */
    public static Boolean isCreditNum(String s) {
        if (!String.isEmpty(s)) {
            return Pattern.matches(ORIG_REG_CREDITNUMBER, s);
        }
        return false;
    }
    
    /**
     * IPアドレスフォーマットチェック
     * @param s 対象文字列
     * @return クレジット番号：true それ以外：false
     */
    public static Boolean isIPAddress(String s) {
        if (!String.isEmpty(s)) {
            return Pattern.matches(ORIG_REG_IPADDRESS, s);
        }
        return false;
    }
    
    /**
     * RegExpBuilderクラスで生成した正規表現チェック
     * @param s 対象文字列
     * @param regExp 正規表現ビルダクラスで生成した正規表現
     * @return 正規表現に一致する：true それ以外：false
     */
    public static Boolean isRegExp(String s, String regExp) {
        if (!String.isEmpty(s) && !String.isEmpty(regExp)) {
            return Pattern.matches('^(' + regExp  + ')+$', s);
        }
        return false;
    }
    
    /**
     * 正規表現ビルダクラス
     * Copyright (C) TerraSky Co.,Ltd.
     * 概要    : JP_StringUtil#isRegExpで指定する正規表現を生成する
     * @developedApiVer  : 30.0
     */
    public class RegExpBuilder {
        // 半角正規表現
        public final String REG_EN = ORIG_REG_EN;
        
        // 全角正規表現
        public final String REG_EM = ORIG_REG_EM;
        
        // ひらがな正規表現
        public final String REG_HIRAGANA = ORIG_REG_HIRAGANA;
        
        // 半角数値正規表現
        public final String REG_ENNUMBER = ORIG_REG_ENNUMBER;
        
        // 全角数値正規表現
        public final String REG_EMNUMBER = ORIG_REG_EMNUMBER;
        
        // 半角カナ正規表現
        public final String REG_ENKATAKANA = ORIG_REG_ENKATAKANA;
        
        // 文字コード半角カナ正規表現
        public final String REG_CHARCODEENKANA = ORIG_REG_CHARCODEENKANA;
        
        // 全角カナ正規表現
        public final String REG_EMKATAKANA = ORIG_REG_EMKATAKANA;
        
        // 半角記号正規表現
        public final String REG_ENSYMBOL = ORIG_REG_ENSYMBOL;
        
        // 漢字正規表現
        public final String REG_CHINESECHAR = ORIG_REG_CHINESECHAR;
        
        // 正規表現
        private String regExp;
        
        /**
         * コンストラクタ
         */
        public RegExpBuilder() {
            this.regExp = '';
        }
        
        /**
         * 正規表現追加
         * @param regExp 追加する正規表現
         * @return this
         */
        public RegExpBuilder add(String regExp) {
            if (!String.isEmpty(this.regExp) && !String.isEmpty(regExp)) {
                this.regExp += '|';
            }

            if (!String.isEmpty(regExp)) {
                this.regExp += regExp;
            }
            return this;
        }

        /**
         * 正規表現クリア
         * @return this
         */
        public RegExpBuilder clear() {
            this.regExp = '';
            return this;
        }
        
        /**
         * 正規表現生成
         * @return 生成した正規表現
         */
        public String build() {
            return this.regExp;
        }
    }

    /**
     * バイト数取得
     * @param s 対象文字列
     * @return 全角２バイト(UTF-8上で3バイト以上でも2バイト)・半角１バイトで算出したバイト数
     */
    public static Integer getBytes(String s) {
        Integer bytes = 0;
        if (!String.isEmpty(s)) {
            RegExpBuilder builder = new RegExpBuilder();
            String regExp = builder.add(builder.REG_EN).build();
            String doubleByteStr = s.replaceAll(regExp, '');
            bytes += doubleByteStr.length() * 2;
            bytes += s.length() - doubleByteStr.length();
        }
        return bytes;
    }

    /**
     * 半角数字を全角数字に変換
     * @param s 対象文字列
     * @return 変換後文字列
     */
    public static String enNumberToEm(String s) {
        if (String.isEmpty(s)) {
            return s;
        }
        
        return s
            .replace('0', '０').replace('1', '１').replace('2', '２').replace('3', '３').replace('4', '４')
            .replace('5', '５').replace('6', '６').replace('7', '７').replace('8', '８').replace('9', '９');
    }

    /**
     * 全角数字を半角数字に変換
     * @param s 対象文字列
     * @return 変換後文字列
     */
    public static String emNumberToEn(String s) {
        if (String.isEmpty(s)) {
            return s;
        }
        
        return s
            .replace('０', '0').replace('１', '1').replace('２', '2').replace('３', '3').replace('４', '4')
            .replace('５', '5').replace('６', '6').replace('７', '7').replace('８', '8').replace('９', '9');
    }

    /**
     * 半角カタカナを全角カタカナに変換
     * @param s 対象文字列
     * @return 変換後文字列
     */
    public static String enKatakanaToEm(String s) {
        if (String.isEmpty(s)) {
            return s;
        }
        
        return s
            .replace('ｶﾞ', 'ガ').replace('ｷﾞ', 'ギ').replace('ｸﾞ', 'グ').replace('ｹﾞ', 'ゲ').replace('ｺﾞ','ゴ')
            .replace('ｻﾞ', 'ザ').replace('ｼﾞ', 'ジ').replace('ｽﾞ', 'ズ').replace('ｾﾞ', 'ゼ').replace('ｿﾞ','ゾ')
            .replace('ﾀﾞ', 'ダ').replace('ﾁﾞ', 'ヂ').replace('ﾂﾞ', 'ヅ').replace('ﾃﾞ', 'デ').replace('ﾄﾞ','ド')
            .replace('ﾊﾞ', 'バ').replace('ﾊﾟ', 'パ').replace('ﾋﾞ', 'ビ').replace('ﾋﾟ', 'ピ').replace('ﾌﾞ','ブ')
            .replace('ﾌﾟ', 'プ').replace('ﾍﾞ', 'ベ').replace('ﾍﾟ', 'ペ').replace('ﾎﾞ', 'ボ').replace('ﾎﾟ','ポ')
            .replace('ｳﾞ', 'ヴ')
            .replace('ｧ', 'ァ').replace('ｱ', 'ア').replace('ｨ', 'ィ').replace('ｲ', 'イ').replace('ｩ', 'ゥ')
            .replace('ｳ', 'ウ').replace('ｪ', 'ェ').replace('ｴ', 'エ').replace('ｫ', 'ォ').replace('ｵ', 'オ')
            .replace('ｶ', 'カ').replace('ｷ', 'キ').replace('ｸ', 'ク').replace('ｹ', 'ケ').replace('ｺ', 'コ')
            .replace('ｻ', 'サ').replace('ｼ', 'シ').replace('ｽ', 'ス').replace('ｾ', 'セ').replace('ｿ', 'ソ')
            .replace('ﾀ', 'タ').replace('ﾁ', 'チ').replace('ｯ', 'ッ').replace('ﾂ', 'ツ').replace('ﾃ', 'テ')
            .replace('ﾄ', 'ト').replace('ﾅ', 'ナ').replace('ﾆ', 'ニ').replace('ﾇ', 'ヌ').replace('ﾈ', 'ネ')
            .replace('ﾉ', 'ノ').replace('ﾊ', 'ハ').replace('ﾋ', 'ヒ').replace('ﾌ', 'フ').replace('ﾍ', 'ヘ')
            .replace('ﾎ', 'ホ').replace('ﾏ', 'マ').replace('ﾐ', 'ミ').replace('ﾑ', 'ム').replace('ﾒ', 'メ')
            .replace('ﾓ', 'モ').replace('ｬ', 'ャ').replace('ﾔ', 'ヤ').replace('ｭ', 'ュ').replace('ﾕ', 'ユ')
            .replace('ｮ', 'ョ').replace('ﾖ', 'ヨ').replace('ﾗ', 'ラ').replace('ﾘ', 'リ').replace('ﾙ', 'ル')
            .replace('ﾚ', 'レ').replace('ﾛ', 'ロ').replace('ﾜ', 'ワ').replace('ｦ', 'ヲ')
            .replace('ﾝ', 'ン').replace('ｰ', 'ー');
    }

    /**
     * 全角カタカナを半角カタカナに変換
     * @param s 対象文字列
     * @return 変換後文字列
     */
    public static String emKatakanaToEn(String s) {
        if (String.isEmpty(s)) {
            return s;
        }
        
        return s
            .replace('ガ', 'ｶﾞ').replace('ギ', 'ｷﾞ').replace('グ', 'ｸﾞ').replace('ゲ', 'ｹﾞ').replace('ゴ','ｺﾞ')
            .replace('ザ', 'ｻﾞ').replace('ジ', 'ｼﾞ').replace('ズ', 'ｽﾞ').replace('ゼ', 'ｾﾞ').replace('ゾ','ｿﾞ')
            .replace('ダ', 'ﾀﾞ').replace('ヂ', 'ﾁﾞ').replace('ヅ', 'ﾂﾞ').replace('デ', 'ﾃﾞ').replace('ド','ﾄﾞ')
            .replace('バ', 'ﾊﾞ').replace('パ', 'ﾊﾟ').replace('ビ', 'ﾋﾞ').replace('ピ', 'ﾋﾟ').replace('ブ','ﾌﾞ')
            .replace('プ', 'ﾌﾟ').replace('ベ', 'ﾍﾞ').replace('ペ', 'ﾍﾟ').replace('ボ', 'ﾎﾞ').replace('ポ','ﾎﾟ')
            .replace('ヴ', 'ｳﾞ')
            .replace('ァ', 'ｧ').replace('ア', 'ｱ').replace('ィ', 'ｨ').replace('イ', 'ｲ').replace('ゥ', 'ｩ')
            .replace('ウ', 'ｳ').replace('ェ', 'ｪ').replace('エ', 'ｴ').replace('ォ', 'ｫ').replace('オ', 'ｵ')
            .replace('カ', 'ｶ').replace('キ', 'ｷ').replace('ク', 'ｸ').replace('ケ', 'ｹ').replace('コ', 'ｺ')
            .replace('サ', 'ｻ').replace('シ', 'ｼ').replace('ス', 'ｽ').replace('セ', 'ｾ').replace('ソ', 'ｿ')
            .replace('タ', 'ﾀ').replace('チ', 'ﾁ').replace('ッ', 'ｯ').replace('ツ', 'ﾂ').replace('テ', 'ﾃ')
            .replace('ト', 'ﾄ').replace('ナ', 'ﾅ').replace('ニ', 'ﾆ').replace('ヌ', 'ﾇ').replace('ネ', 'ﾈ')
            .replace('ノ', 'ﾉ').replace('ハ', 'ﾊ').replace('ヒ', 'ﾋ').replace('フ', 'ﾌ').replace('ヘ', 'ﾍ')
            .replace('ホ', 'ﾎ').replace('マ', 'ﾏ').replace('ミ', 'ﾐ').replace('ム', 'ﾑ').replace('メ', 'ﾒ')
            .replace('モ', 'ﾓ').replace('ャ', 'ｬ').replace('ヤ', 'ﾔ').replace('ュ', 'ｭ').replace('ユ', 'ﾕ')
            .replace('ョ', 'ｮ').replace('ヨ', 'ﾖ').replace('ラ', 'ﾗ').replace('リ', 'ﾘ').replace('ル', 'ﾙ')
            .replace('レ', 'ﾚ').replace('ロ', 'ﾛ').replace('ワ', 'ﾜ').replace('ヲ', 'ｦ')
            .replace('ン', 'ﾝ').replace('ー', 'ｰ');
    }

    /**
     * 半角アルファベットを全角アルファベットに変換
     * @param s 対象文字列
     * @return 変換後文字列
     */
    public static String enAlphabetToEm(String s) {
        if (String.isEmpty(s)) {
            return s;
        }
        
        return s
            .replace('A', 'Ａ').replace('B', 'Ｂ').replace('C', 'Ｃ').replace('D', 'Ｄ').replace('E', 'Ｅ')
            .replace('F', 'Ｆ').replace('G', 'Ｇ').replace('H', 'Ｈ').replace('I', 'Ｉ').replace('J', 'Ｊ')
            .replace('K', 'Ｋ').replace('L', 'Ｌ').replace('M', 'Ｍ').replace('N', 'Ｎ').replace('O', 'Ｏ')
            .replace('P', 'Ｐ').replace('Q', 'Ｑ').replace('R', 'Ｒ').replace('S', 'Ｓ').replace('T', 'Ｔ')
            .replace('U', 'Ｕ').replace('V', 'Ｖ').replace('W', 'Ｗ').replace('X', 'Ｘ').replace('Y', 'Ｙ')
            .replace('Z', 'Ｚ')
            .replace('a', 'ａ').replace('b', 'ｂ').replace('c', 'ｃ').replace('d', 'ｄ').replace('e', 'ｅ')
            .replace('f', 'ｆ').replace('g', 'ｇ').replace('h', 'ｈ').replace('i', 'ｉ').replace('j', 'ｊ')
            .replace('k', 'ｋ').replace('l', 'ｌ').replace('m', 'ｍ').replace('n', 'ｎ').replace('o', 'ｏ')
            .replace('p', 'ｐ').replace('q', 'ｑ').replace('r', 'ｒ').replace('s', 'ｓ').replace('t', 'ｔ')
            .replace('u', 'ｕ').replace('v', 'ｖ').replace('w', 'ｗ').replace('x', 'ｘ').replace('y', 'ｙ')
            .replace('z', 'ｚ');
    }

    /**
     * 全角アルファベットを半角アルファベットに変換
     * @param s 対象文字列
     * @return 変換後文字列
     */
    public static String emAlphabetToEn(String s) {
        if (String.isEmpty(s)) {
            return s;
        }
        
        return s
            .replace('Ａ', 'A').replace('Ｂ', 'B').replace('Ｃ', 'C').replace('Ｄ', 'D').replace('Ｅ', 'E')
            .replace('Ｆ', 'F').replace('Ｇ', 'G').replace('Ｈ', 'H').replace('Ｉ', 'I').replace('Ｊ', 'J')
            .replace('Ｋ', 'K').replace('Ｌ', 'L').replace('Ｍ', 'M').replace('Ｎ', 'N').replace('Ｏ', 'O')
            .replace('Ｐ', 'P').replace('Ｑ', 'Q').replace('Ｒ', 'R').replace('Ｓ', 'S').replace('Ｔ', 'T')
            .replace('Ｕ', 'U').replace('Ｖ', 'V').replace('Ｗ', 'W').replace('Ｘ', 'X').replace('Ｙ', 'Y')
            .replace('Ｚ', 'Z')
            .replace('ａ', 'a').replace('ｂ', 'b').replace('ｃ', 'c').replace('ｄ', 'd').replace('ｅ', 'e')
            .replace('ｆ', 'f').replace('ｇ', 'g').replace('ｈ', 'h').replace('ｉ', 'i').replace('ｊ', 'j')
            .replace('ｋ', 'k').replace('ｌ', 'l').replace('ｍ', 'm').replace('ｎ', 'n').replace('ｏ', 'o')
            .replace('ｐ', 'p').replace('ｑ', 'q').replace('ｒ', 'r').replace('ｓ', 's').replace('ｔ', 't')
            .replace('ｕ', 'u').replace('ｖ', 'v').replace('ｗ', 'w').replace('ｘ', 'x').replace('ｙ', 'y')
            .replace('ｚ', 'z');
    }

    /**
     * 半角記号を全角記号に変換
     * @param s 対象文字列
     * @return 変換後文字列
     */
    public static String enSignToEm(String s) {
        if (String.isEmpty(s)) {
            return s;
        }
        
        return s
            .replace('!', '！').replace('#', '＃').replace('$', '＄').replace('%', '％')
            .replace('&', '＆').replace('(', '（').replace(')', '）').replace('*', '＊')
            .replace('+', '＋').replace(',', '，').replace('-', '－').replace('.', '．').replace('/', '／')
            .replace(':', '：').replace(';', '；').replace('<', '＜').replace('=', '＝').replace('>', '＞')
            .replace('?', '？').replace('@', '＠').replace('[', '［').replace(']', '］')
            .replace('^', '＾').replace('_', '＿').replace('{', '｛').replace('|', '｜')
            .replace('}', '｝').replace('~', '～').replace('｡', '。').replace('｢', '「').replace('｣', '」')
            .replace('､', '、').replace('`', '｀').replace(' ' , '　')
            .replace('"', '”').replace('･', '・').replace('·', '・').replace('\'','’').replace('\\','￥');
    }

    /**
     * 全角記号を半角記号に変換
     * @param s 対象文字列
     * @return 変換後文字列
     */
    public static String emSignToEn(String s) {
        if (String.isEmpty(s)) {
            return s;
        }
        
        return s
            .replace('！', '!').replace('＃', '#').replace('＄', '$').replace('％', '%')
            .replace('＆', '&').replace('（', '(').replace('）', ')').replace('＊', '*')
            .replace('＋', '+').replace('，', ',').replace('－', '-').replace('．', '.').replace('／', '/')
            .replace('：', ':').replace('；', ';').replace('＜', '<').replace('＝', '=').replace('＞', '>')
            .replace('？', '?').replace('＠', '@').replace('［', '[').replace('］', ']')
            .replace('＾', '^').replace('＿', '_').replace('｛', '{').replace('｜', '|')
            .replace('｝', '}').replace('～', '~').replace('。', '｡').replace('「', '｢').replace('」', '｣')
            .replace('、', '､').replace('｀', '`').replace('　' , ' ')
            .replace('”', '"').replace('・', '･').replace('’','\'').replace('￥','\\');
    }

    /**
     * 半角を全角に変換
     * @param s 対象文字列
     * @return 変換後文字列
     */
    public static String enToEm(String s) {
        if (String.isEmpty(s)) {
            return s;
        }

        return enNumberToEm(enKatakanaToEm(enAlphabetToEm(enSignToEm(s))));
    }

    /**
     * 全角を半角に変換
     * @param s 対象文字列
     * @return 変換後文字列
     */
    public static String emToEn(String s) {
        if (String.isEmpty(s)) {
            return s;
        }

        return emNumberToEn(emKatakanaToEn(emAlphabetToEn(emSignToEn(s))));
    }

    /**
     * SObject型からString値を取得
     * @Param rec sObject型
     * @Param fieldNm 項目API名
     * @return 引数recの型及び値に対応した文字列
     * @throws Exception 汎用例外
     */
    public static String getStringValue(SObject rec, String fieldNm) {
        String dest = null;
        if (rec != null && !String.isEmpty(fieldNm)) {
            List<String> flds = fieldNm.split('\\.',-1);
            system.assert(flds.size()<=2, 'getStringValueメソッドは親オブジェクトの値まで取得可能です。親の親は対応してません。');

            if (flds.size() > 1) {
                // __r.XXXXを取得
                SObject parent = rec.getSObject(flds[0]);
                dest = parent != null && parent.get(flds[1]) != null ? String.valueOf(parent.get(flds[1])) : '';    // 親レコードがNullの場合も空文字を返す 2013.09.08 yokoyama
            } else {
                // 通常の項目値を取得
                dest = rec.get(fieldNm) != null ? String.valueOf(rec.get(fieldNm)) : '';
            }
        }
        return dest;
    }

    /**
     * 引数の型に応じて適切な文字列を変換する
     * Blob：バイナリ文字列(BOM付きはBOMを除去して返す)
     * Date：yyyy/MM/ddでフォーマットされた文字列
     * Datetime：yyyy/MM/dd HH:mm:ssでフォーマットされた文字列
     * それ以外：String#valueOfの結果文字列
     * @param o 対象オブジェクト
     * @return 変換した文字列
     */
    public static String toString(Object o) {
        String dest = null;
        if (o != null) {
            if (o instanceof Blob) {
                dest = toStringRemoveUTF8BOM((Blob) o);
            } else if (o instanceof Date) {
                dest = Date.valueOf(o).format();
            } else if (o instanceof Datetime) {
                dest = Datetime.valueOf(o).format(dateTimeFormat, userTimezone.toString());
            } else {
                dest = String.valueOf(o);
            }
        }
        return dest;
    }

    /**
     * UTF-8のBOMを除去したバイナリ文字列に変換する
     * @param src 対象バイナリ
     * @return UTF-8のBOMを除去したバイナリ文字列
     */
    public static String toStringRemoveUTF8BOM(Blob src) {
        String dest = null;

        // バイナリを文字列化
        if (src != null) {
            final String BOM = 'efbbbf';
            dest = src.toString();

            // 16進で変換したプレフィックスにBOMがあれば除去
            String hex = Encodingutil.convertToHex(src);
            if (hex.length() >= 6
                    && hex.subString(0, 6).indexOf(BOM) == 0) {
                dest = dest.substring(1);
            }
        }
        return dest;
    }

    /**
     * 左パディング
     * @param o 対象オブジェクト
     * @param len 全体文字列長
     * @param padStr パディング文字
     * @return 左パディングした文字列
     */
    public static String leftPad(Object o, Integer len, String padStr) {
        String dest = toString(o);
        return leftPad(dest, len, padStr);
    }

    /**
     * 左パディング
     * @param s 対象オブジェクト
     * @param len 全体文字列長
     * @param padStr パディング文字
     * @return 左パディングした文字列
     */
    public static String leftPad(String s, Integer len, String padStr) {
        String dest = toString(s);
        if (dest != null) {
            dest = dest.leftPad(len, padStr);
        }
        return dest;
    }

    /**
     * 右パディング
     * @param o 対象オブジェクト
     * @param len 全体文字列長
     * @param padStr パディング文字
     * @return 右パディングした文字列
     */
    public static String rightPad(Object o, Integer len, String padStr) {
        String dest = toString(o);
        return rightPad(dest, len, padStr);
    }

    /**
     * 右パディング
     * @param s 対象オブジェクト
     * @param len 全体文字列長
     * @param padStr パディング文字
     * @return 右パディングした文字列
     */
    public static String rightPad(String s, Integer len, String padStr) {
        String dest = toString(s);
        if (dest != null) {
            dest = dest.rightPad(len, padStr);
        }
        return dest;
    }

    /**
     * dateをYYYYMMDD形式で出力する
     * @param d 対象date
     * @return 変換した文字列
     */
    public static String date2YYYYMMDD(Date d) {
        String dest = null;
        if (d != null) {
            dest = toString(d.year() + leftPad(d.month(), 2, '0') + leftPad(d.day(), 2, '0'));
        }
        return dest;
    }

    /**
     * datetimeをYYYYMMDD形式で出力する
     * @param dt 対象datetime
     * @return 変換した文字列
     */
    public static String datetime2YYYYMMDD(Datetime dt) {
        String dest = null;
        if (dt != null) {
            dest = toString(dt.year() + leftPad(dt.month(), 2, '0') + leftPad(dt.day(), 2, '0'));
        }
        return dest;
    }

    /**
     * 文字列を指定長で分割する
     * @param s 対象文字列
     * @param len 文字列長
     * @return 分割した文字列リスト
     */
    public static List<String> splitByLength(String s, Integer len) {
        List<String> dest = new List<String>();
        if (!String.isEmpty(s) && len != null && len > 1) {
            String str = s;
            while (str.length() > 0) {
                String val = str.left(len);
                dest.add(val);
                str = str.removeStart(val);
            }
        }
        return dest;
    }
}