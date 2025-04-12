/**
 * TerraSky 共通モジュール
 * Copyright (C) TerraSky Co.,Ltd.
 * 概要   : JP_StringUtilのテストクラス
 * @version       : 1.0
 * @developedApiVer  : 30.0
 */
@isTest
private class Test_JP_StringUtil {
    /**
     * null2Blankメソッドのテストメソッド
     */
    static testMethod void test_null2Blank_001() {
        // テスト開始
        Test.startTest();
        System.assertEquals('', JP_StringUtil.null2Blank(null));
        System.assertEquals('', JP_StringUtil.null2Blank(''));
        System.assertEquals('a', JP_StringUtil.null2Blank('a'));
        Test.stopTest();
    }
    
    /**
     * blank2Nullメソッドのテストメソッド
     */
    static testMethod void test_blank2Null_001() {
        // テスト開始
        Test.startTest();
        System.assertEquals(null, JP_StringUtil.blank2Null(null));
        System.assertEquals(null, JP_StringUtil.blank2Null(''));
        System.assertEquals('a', JP_StringUtil.blank2Null('a'));
        Test.stopTest();
    }
    
    /**
     * trimメソッドのテスト
     */
    static testMethod void test_trim_001() {
        // テスト開始
        Test.startTest();
        System.assertEquals('test', JP_StringUtil.trim('  test   '));
        System.assertEquals('test', JP_StringUtil.trim('　　test　　'));
        System.assertEquals('test', JP_StringUtil.trim(' 　test 　'));
        System.assertEquals('test', JP_StringUtil.trim('test'));
        System.assertEquals('t　es　t', JP_StringUtil.trim('　t　es　t '));
        System.assertEquals('t es t', JP_StringUtil.trim(' t es t '));
        System.assertEquals(null, JP_StringUtil.trim(null));
        System.assertEquals('', JP_StringUtil.trim(''));
        Test.stopTest();
    }
    
    /**
     * LTrimメソッドのテスト
     */
    static testMethod void test_LTrim_001() {
        // テスト開始
        Test.startTest();
        System.assertEquals('test   ', JP_StringUtil.LTrim('  test   '));
        System.assertEquals('test　　', JP_StringUtil.LTrim('　　test　　'));
        System.assertEquals('test 　', JP_StringUtil.LTrim(' 　test 　'));
        System.assertEquals('test', JP_StringUtil.LTrim('test'));
        System.assertEquals('t　es　t ', JP_StringUtil.LTrim('　t　es　t '));
        System.assertEquals('t es t ', JP_StringUtil.LTrim(' t es t '));
        System.assertEquals(null, JP_StringUtil.LTrim(null));
        System.assertEquals('', JP_StringUtil.LTrim(''));
        Test.stopTest();
    }
    
    /**
     * RTrimメソッドのテスト
     */
    static testMethod void test_RTrim_001() {
        // テスト開始
        Test.startTest();
        System.assertEquals('  test', JP_StringUtil.RTrim('  test   '));
        System.assertEquals('　　test', JP_StringUtil.RTrim('　　test　　'));
        System.assertEquals(' 　test', JP_StringUtil.RTrim(' 　test 　'));
        System.assertEquals('test', JP_StringUtil.RTrim('test'));
        System.assertEquals('　t　es　t', JP_StringUtil.RTrim('　t　es　t '));
        System.assertEquals(' t es t', JP_StringUtil.RTrim(' t es t '));
        System.assertEquals(null, JP_StringUtil.RTrim(null));
        System.assertEquals('', JP_StringUtil.RTrim(''));
        Test.stopTest();
    }
    
    /**
     * isEmメソッドのテスト
     */
    static testMethod void test_isEm_001() {
        // テスト開始
        Test.startTest();
        System.assertEquals(false, JP_StringUtil.isEm(null));
        System.assertEquals(false, JP_StringUtil.isEm(''));
        System.assertEquals(true, JP_StringUtil.isEm('、。，．・：；？！゛゜´｀¨＾￣＿ヽヾゝゞ〃仝々〆〇ー―‐／＼～∥｜…‥‘’“”（）〔〕［］｛｝〈〉《》「」『』【】＋－±×÷＝≠＜＞≦≧∞∴♂♀°′″℃￥＄￠￡％＃＆＊＠§☆★○●◎◇◆□■△▲▽▼※〒→←↑↓〓∈∋⊆⊇⊂⊃∪∩∧∨￢⇒⇔∀∃∠⊥⌒∂∇≡≒≪≫√∽∝∵∫∬Å‰＃♭♪†‡¶◯─│┌┐┘└├┬┤┴┼━┃┏┓┛┗┣┳┫┻╋┠┯┨┷┿┝┰┥┸╂①～⑳Ⅰ～Ⅸ㍉㌶㍑㌻㎜～㎡㍻℡㊤㊨㈱～㍼∮∑∟⊿ⅰⅹ￤＇＂'));
        System.assertEquals(true, JP_StringUtil.isEm('ぁあぃいぅうぇえぉおかがきぎくぐけげこごさざしじすずせぜそぞただちぢっつづてでとどなにぬねのはばぱひびぴふぶぷへべぺほぼぽまみむめもゃやゅゆょよらりるれろゎわゐゑをん'));
        System.assertEquals(true, JP_StringUtil.isEm('ァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶ'));
        System.assertEquals(true, JP_StringUtil.isEm('ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ０１２３４５６７８９'));
        System.assertEquals(false, JP_StringUtil.isEm('aＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ０１２３４５６７８９'));
        Test.stopTest();
    }
    
    /**
     * isEnメソッドのテスト
     */
    static testMethod void test_isEn_001() {
        // テスト開始
        Test.startTest();
        System.assertEquals(false, JP_StringUtil.isEn(null));
        System.assertEquals(false, JP_StringUtil.isEn(''));
        System.assertEquals(true, JP_StringUtil.isEn('!"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~ ｡｢｣､･ｦｧｨｩｪｫｬｭｮｯｰｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟ'));
        System.assertEquals(false, JP_StringUtil.isEn('あ!"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~ ｡｢｣､･ｦｧｨｩｪｫｬｭｮｯｰｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟ'));
        Test.stopTest();
    }
    
    /**
     * isHiraganaメソッドのテスト
     */
    static testMethod void test_isHiragana_001() {
        // テスト開始
        Test.startTest();
        System.assertEquals(false, JP_StringUtil.isHiragana(null));
        System.assertEquals(false, JP_StringUtil.isHiragana(''));
        System.assertEquals(true, JP_StringUtil.isHiragana('あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをんぁぃぅぇぉっゃゅょがぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽ'));
        System.assertEquals(false, JP_StringUtil.isHiragana('aあいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをんぁぃぅぇぉっゃゅょがぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽ'));
        Test.stopTest();
    }
    
    /**
     * isKatakanaメソッドのテスト
     */
    static testMethod void test_isKatakana_001() {
        // テスト開始
        Test.startTest();
        System.assertEquals(false, JP_StringUtil.isKatakana(null));
        System.assertEquals(false, JP_StringUtil.isKatakana(''));
        System.assertEquals(true, JP_StringUtil.isKatakana('ァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶｦｧｨｩｪｫｬｭｮｯｰｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟ'));
        System.assertEquals(false, JP_StringUtil.isKatakana('あァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶｦｧｨｩｪｫｬｭｮｯｰｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟ'));
        Test.stopTest();
    }
    
    /**
     * isEmKatakanaメソッドのテスト
     */
    static testMethod void test_isEmKatakana_001() {
        // テスト開始
        Test.startTest();
        System.assertEquals(false, JP_StringUtil.isEmKatakana(null));
        System.assertEquals(false, JP_StringUtil.isEmKatakana(''));
        System.assertEquals(true, JP_StringUtil.isEmKatakana('ァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶ'));
        System.assertEquals(false, JP_StringUtil.isEmKatakana('あァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶ'));
        Test.stopTest();
    }
    
    /**
     * isEnKatakanaメソッドのテスト
     */
    static testMethod void test_isEnKatakana_001() {
        // テスト開始
        Test.startTest();
        System.assertEquals(false, JP_StringUtil.isEnKatakana(null));
        System.assertEquals(false, JP_StringUtil.isEnKatakana(''));
        System.assertEquals(true, JP_StringUtil.isEnKatakana('ｦｧｨｩｪｫｬｭｮｯｰｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟ'));
        System.assertEquals(false, JP_StringUtil.isEnKatakana('｢｣ｦｧｨｩｪｫｬｭｮｯｰｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟ'));
        System.assertEquals(false, JP_StringUtil.isEnKatakana('ｦｧｨｩｪｫｬｭｮｯｰｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟa'));
        Test.stopTest();
    }
    
    /**
     * isCharCodeEnKanaメソッドのテスト
     */
    static testMethod void test_isCharCodeEnKana_001() {
        // テスト開始
        Test.startTest();
        System.assertEquals(false, JP_StringUtil.isCharCodeEnKana(null));
        System.assertEquals(false, JP_StringUtil.isCharCodeEnKana(''));
        System.assertEquals(true, JP_StringUtil.isCharCodeEnKana('ｰ｡｢｣､･ｦｧｨｩｪｫｬｭｮｯﾀｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾐﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟ'));
        System.assertEquals(false, JP_StringUtil.isCharCodeEnKana('aｰ｡｢｣､･ｦｧｨｩｪｫｬｭｮｯﾀｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾐﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟ'));
        System.assertEquals(false, JP_StringUtil.isCharCodeEnKana('ｰ｡｢｣､･ｦｧｨｩｪｫｬｭｮｯﾀｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾐﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟa'));
        Test.stopTest();
    }
    
    /**
     * isEnNumメソッドのテスト
     */
    static testMethod void test_isEnNum_001() {
        // テスト開始
        Test.startTest();
        System.assertEquals(false, JP_StringUtil.isEnNum(null));
        System.assertEquals(false, JP_StringUtil.isEnNum(''));
        System.assertEquals(true, JP_StringUtil.isEnNum('0123456789'));
        System.assertEquals(false, JP_StringUtil.isEnNum('１0123456789'));
        System.assertEquals(false, JP_StringUtil.isEnNum('0123456789ｦ'));
        Test.stopTest();
    }
    
    /**
     * isEmNumメソッドのテスト
     */
    static testMethod void test_isEmNum_001() {
        // テスト開始
        Test.startTest();
        System.assertEquals(false, JP_StringUtil.isEmNum(null));
        System.assertEquals(false, JP_StringUtil.isEmNum(''));
        System.assertEquals(true, JP_StringUtil.isEmNum('０１２３４５６７８９'));
        System.assertEquals(false, JP_StringUtil.isEmNum('０1１２３４５６７８９'));
        System.assertEquals(false, JP_StringUtil.isEmNum('０１２３４５６７８a９'));
        Test.stopTest();
    }
    
    /**
     * isChineseCharメソッドのテスト
     */
    static testMethod void test_isChineseChar_001() {
        // テスト開始
        Test.startTest();
        System.assertEquals(false, JP_StringUtil.isChineseChar(null));
        System.assertEquals(false, JP_StringUtil.isChineseChar(''));
        System.assertEquals(false, JP_StringUtil.isChineseChar('test'));
        System.assertEquals(true, JP_StringUtil.isChineseChar('一柋亜黑々〻'));
        Test.stopTest();
    }
    
    /**
     * isEnNumKanaメソッドのテスト
     */
    static testMethod void test_isEnNumKana_001() {
        // テスト開始
        Test.startTest();
        System.assertEquals(false, JP_StringUtil.isEnNumKana(null));
        System.assertEquals(false, JP_StringUtil.isEnNumKana(''));
        System.assertEquals(true, JP_StringUtil.isEnNumKana('0123456789ｦｧｨｩｪｫｬｭｮｯｰｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟ'));
        System.assertEquals(false, JP_StringUtil.isEnNumKana('１0123456789ｦｧｨｩｪｫｬｭｮｯｰｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟ'));
        System.assertEquals(false, JP_StringUtil.isEnNumKana('0123456789ｦｧｨｩｪｫｬｭｮｯｰｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟア'));
        Test.stopTest();
    }
    
    /**
     * isPostCodeメソッドのテスト
     */
    static testMethod void test_isPostCode_001() {
        // テスト開始
        Test.startTest();
        System.assertEquals(false, JP_StringUtil.isPostCode(null));
        System.assertEquals(false, JP_StringUtil.isPostCode(''));
        System.assertEquals(true, JP_StringUtil.isPostCode('123-4567'));
        System.assertEquals(false, JP_StringUtil.isPostCode('1234567'));
        System.assertEquals(false, JP_StringUtil.isPostCode('123-a567'));
        System.assertEquals(false, JP_StringUtil.isPostCode('123-45678'));
        System.assertEquals(false, JP_StringUtil.isPostCode('123-4567-1'));
        Test.stopTest();
    }
    
    /**
     * isCreditNumメソッドのテスト
     */
    static testMethod void test_isCreditNum_001() {
        // テスト開始
        Test.startTest();
        System.assertEquals(false, JP_StringUtil.isCreditNum(null));
        System.assertEquals(false, JP_StringUtil.isCreditNum(''));
        System.assertEquals(true, JP_StringUtil.isCreditNum('1234-5678-9012-3456'));
        System.assertEquals(false, JP_StringUtil.isCreditNum('1234-56789012-3456'));
        System.assertEquals(false, JP_StringUtil.isCreditNum('a234-5678-9012-3456'));
        System.assertEquals(false, JP_StringUtil.isCreditNum('1234-5678-9012-34567'));
        Test.stopTest();
    }
    
    /**
     * isIPAddressメソッドのテスト
     */
    static testMethod void test_isIPAddress_001() {
        // テスト開始
        Test.startTest();
        System.assertEquals(false, JP_StringUtil.isIPAddress(null));
        System.assertEquals(false, JP_StringUtil.isIPAddress(''));
        System.assertEquals(true, JP_StringUtil.isIPAddress('192.168.0.1'));
        System.assertEquals(true, JP_StringUtil.isIPAddress('0.0.0.0'));
        System.assertEquals(true, JP_StringUtil.isIPAddress('255.255.255.255'));
        System.assertEquals(false, JP_StringUtil.isIPAddress('256.255.255.255'));
        System.assertEquals(false, JP_StringUtil.isIPAddress('255.256.255.255'));
        System.assertEquals(false, JP_StringUtil.isIPAddress('255.255.256.255'));
        System.assertEquals(false, JP_StringUtil.isIPAddress('255.255.255.256'));
        System.assertEquals(false, JP_StringUtil.isIPAddress('-1.255.255.255'));
        Test.stopTest();
    }
    
    /**
     * isRegExpメソッドのテスト
     */
    static testMethod void test_isRegExp_001() {
        // テスト開始
        Test.startTest();
        JP_StringUtil.RegExpBuilder builder = new JP_StringUtil.RegExpBuilder();
        String regExp = builder.add( builder.REG_ENKATAKANA).add( builder.REG_ENNUMBER).build();
        System.assertEquals(false, JP_StringUtil.isRegExp(null, regExp));
        System.assertEquals(false, JP_StringUtil.isRegExp('', regExp));
        System.assertEquals(false, JP_StringUtil.isRegExp('12345', null));
        System.assertEquals(false, JP_StringUtil.isRegExp('12345', ''));

        // 半角カナ＋半角数値チェック
        System.assertEquals(true, JP_StringUtil.isRegExp('0123456789ｦｧｨｩｪｫｬｭｮｯｰｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟ', regExp));
        System.assertEquals(false, JP_StringUtil.isRegExp('z0123456789ｦｧｨｩｪｫｬｭｮｯｰｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟ', regExp));

        // 半角＋漢字チェック
        builder.clear();
        regExp = builder.add(builder.REG_EN).add(builder.REG_CHINESECHAR).build();
        System.assertEquals(true, JP_StringUtil.isRegExp('!"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~ ｡｢｣､･ｦｧｨｩｪｫｬｭｮｯｰｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟ一柋', regExp));
        System.assertEquals(true, JP_StringUtil.isRegExp('!"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~ ｡｢｣､･ｦｧｨｩｪｫｬｭｮｯｰｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟ亜黑', regExp));
        System.assertEquals(true, JP_StringUtil.isRegExp('!"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~ ｡｢｣､･ｦｧｨｩｪｫｬｭｮｯｰｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟ々〻', regExp));
        System.assertEquals(false, JP_StringUtil.isRegExp('!"#$%&\'()ﾞﾟ亜黑㏍', regExp));

        // 全角＋半角カナチェック
        builder.clear();
        regExp = builder.add(builder.REG_EM).add(builder.REG_ENKATAKANA).build();
        System.assertEquals(true, JP_StringUtil.isRegExp('、。，．・：；？！゛゜´｀¨＾￣＿ヽヾゝゞ〃仝々〆〇ー―‐／＼～∥｜…‥‘’“”（）〔〕［］｛｝〈〉《》「」『』【】＋－±×÷＝≠＜＞≦≧∞∴♂♀°′″℃￥＄￠￡％＃＆＊＠§☆★○●◎◇◆□■△▲▽▼※〒→←↑↓〓∈∋⊆⊇⊂⊃∪∩∧∨￢⇒⇔∀∃∠⊥⌒∂∇≡≒≪≫√∽∝∵∫∬Å‰＃♭♪†‡¶◯─│┌┐┘└├┬┤┴┼━┃┏┓┛┗┣┳┫┻╋┠┯┨┷┿┝┰┥┸╂①～⑳Ⅰ～Ⅸ㍉㌶㍑㌻㎜～㎡㍻℡㊤㊨㈱～㍼∮∑∟⊿亜熙ⅰⅹ￤＇＂', regExp));
        System.assertEquals(true, JP_StringUtil.isRegExp('ぁあぃいぅうぇえぉおかがきぎくぐけげこごさざしじすずせぜそぞただちぢっつづてでとどなにぬねのはばぱひびぴふぶぷへべぺほぼぽまみむめもゃやゅゆょよらりるれろゎわゐゑをん', regExp));
        System.assertEquals(true, JP_StringUtil.isRegExp('ァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶ', regExp));
        System.assertEquals(true, JP_StringUtil.isRegExp('ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ０１２３４５６７８９', regExp));
        System.assertEquals(true, JP_StringUtil.isRegExp('ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ０１２３４５６７８９ｦｧｨｩｪｫｬｭｮｯｰｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟ', regExp));
        
        // ひらがな＋半角記号チェック
        builder.clear();
        regExp = builder.add(builder.REG_HIRAGANA).add(builder.REG_ENSYMBOL).build();
        System.assertEquals(true, JP_StringUtil.isRegExp('  !"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~ ｡｢｣､･ぁあぃいぅうぇえぉおかがきぎくぐけげこごさざしじすずせぜそぞただちぢっつづてでとどなにぬねのはばぱひびぴふぶぷへべぺほぼぽまみむめもゃやゅゆょよらりるれろゎわゐゑをん', regExp));
        System.assertEquals(false, JP_StringUtil.isRegExp('！!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~ ｡｢｣､･ぁあぃいぅうぇえぉおかがきぎくぐけげこごさざしじすずせぜそぞただちぢっつづてでとどなにぬねのはばぱひびぴふぶぷへべぺほぼぽまみむめもゃやゅゆょよらりるれろゎわゐゑをん', regExp));
        System.assertEquals(false, JP_StringUtil.isRegExp('!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~ ｡｢｣､･ぁあぃいぅうぇえぉおかがきぎくぐけげこごさざしじすずせぜそぞただちぢっつづてでとどなにぬねのはばぱひびぴふぶぷへべぺほぼぽまみむめもゃやゅゆょよらりるれろゎわゐゑをんア', regExp));
        
        // 全角数値＋文字コード上半角カナチェック
        builder.clear();
        regExp = builder.add(builder.REG_EMNUMBER).add(builder.REG_CHARCODEENKANA).build();
        System.assertEquals(true, JP_StringUtil.isRegExp('ｰ｡｢｣､･ｦｧｨｩｪｫｬｭｮｯﾀｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾐﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟ０１２３４５６７８９', regExp));
        System.assertEquals(false, JP_StringUtil.isRegExp('￥ｰ｡｢｣､･ｦｧｨｩｪｫｬｭｮｯﾀｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾐﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟ０１２３４５６７８９', regExp));
        System.assertEquals(false, JP_StringUtil.isRegExp('ｰ｡｢｣､･ｦｧｨｩｪｫｬｭｮｯﾀｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾐﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟ０１２３４５６７８９0', regExp));

        Test.stopTest();
    }

    /**
     * RegExpBuilderクラスのテスト
     */
    static testMethod void test_RegExpBuilder_001() {
        // テスト開始
        Test.startTest();
        JP_StringUtil.RegExpBuilder builder = new JP_StringUtil.RegExpBuilder();
        System.assertEquals('', builder.build());
        builder.add(builder.REG_EM);
        System.assertEquals(builder.REG_EM, builder.build());
        builder.clear();
        System.assertEquals('', builder.build());
        builder.add(builder.REG_EMKATAKANA).add(builder.REG_CHINESECHAR).add(builder.REG_ENNUMBER);
        System.assertEquals(builder.REG_EMKATAKANA + '|' + builder.REG_CHINESECHAR + '|' + builder.REG_ENNUMBER, builder.build());
        Test.stopTest();
    }

    /**
     * getBytesメソッドのテスト
     */
    static testMethod void test_getBytes_001() {
        // テスト開始
        Test.startTest();
        System.assertEquals(0, JP_StringUtil.getBytes(null));
        System.assertEquals(0, JP_StringUtil.getBytes(''));
        System.assertEquals(5, JP_StringUtil.getBytes('あいu'));
        System.assertEquals(5, JP_StringUtil.getBytes('10ald'));
        System.assertEquals(10, JP_StringUtil.getBytes('あいうえお'));
        Test.stopTest();
    }

    /**
     * enNumberToEmメソッドのテスト
     */
    static testMethod void test_enNumberToEm_001() {
        // テスト開始
        Test.startTest();
        System.assertEquals(null, JP_StringUtil.enNumberToEm(null));
        System.assertEquals('', JP_StringUtil.enNumberToEm(''));
        System.assertEquals('０１２３４５６７８９', JP_StringUtil.enNumberToEm('0123456789'));
        System.assertEquals('０１２３４５６７８９', JP_StringUtil.enNumberToEm('０１２３４５６７８９'));
        Test.stopTest();
    }

    /**
     * emNumberToEnメソッドのテスト
     */
    static testMethod void test_emNumberToEn_001() {
        // テスト開始
        Test.startTest();
        System.assertEquals(null, JP_StringUtil.emNumberToEn(null));
        System.assertEquals('', JP_StringUtil.emNumberToEn(''));
        System.assertEquals('0123456789', JP_StringUtil.emNumberToEn('０１２３４５６７８９'));
        System.assertEquals('0123456789', JP_StringUtil.emNumberToEn('0123456789'));
        Test.stopTest();
    }

    /**
     * enKatakanaToEmメソッドのテスト
     */
    static testMethod void test_enKatakanaToEm_001() {
        // テスト開始
        Test.startTest();
        System.assertEquals(null, JP_StringUtil.enKatakanaToEm(null));
        System.assertEquals('', JP_StringUtil.enKatakanaToEm(''));
        System.assertEquals('アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホラリルレロワヲンヴガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポーァィゥェォッ', JP_StringUtil.enKatakanaToEm('ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾗﾘﾙﾚﾛﾜｦﾝｳﾞｶﾞｷﾞｸﾞｹﾞｺﾞｻﾞｼﾞｽﾞｾﾞｿﾞﾀﾞﾁﾞﾂﾞﾃﾞﾄﾞﾊﾞﾋﾞﾌﾞﾍﾞﾎﾞﾊﾟﾋﾟﾌﾟﾍﾟﾎﾟｰｧｨｩｪｫｯ'));
        System.assertEquals('アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホラリルレロワヲンヴガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポーァィゥェォッ', JP_StringUtil.enKatakanaToEm('アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホラリルレロワヲンヴガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポーァィゥェォッ'));
        Test.stopTest();
    }

    /**
     * emKatakanaToEnメソッドのテスト
     */
    static testMethod void test_emKatakanaToEn_001() {
        // テスト開始
        Test.startTest();
        System.assertEquals(null, JP_StringUtil.emKatakanaToEn(null));
        System.assertEquals('', JP_StringUtil.emKatakanaToEn(''));
        System.assertEquals('ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾗﾘﾙﾚﾛﾜｦﾝｳﾞｶﾞｷﾞｸﾞｹﾞｺﾞｻﾞｼﾞｽﾞｾﾞｿﾞﾀﾞﾁﾞﾂﾞﾃﾞﾄﾞﾊﾞﾋﾞﾌﾞﾍﾞﾎﾞﾊﾟﾋﾟﾌﾟﾍﾟﾎﾟｰｧｨｩｪｫｯ', JP_StringUtil.emKatakanaToEn('アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホラリルレロワヲンヴガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポーァィゥェォッ'));
        System.assertEquals('ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾗﾘﾙﾚﾛﾜｦﾝｳﾞｶﾞｷﾞｸﾞｹﾞｺﾞｻﾞｼﾞｽﾞｾﾞｿﾞﾀﾞﾁﾞﾂﾞﾃﾞﾄﾞﾊﾞﾋﾞﾌﾞﾍﾞﾎﾞﾊﾟﾋﾟﾌﾟﾍﾟﾎﾟｰｧｨｩｪｫｯ', JP_StringUtil.emKatakanaToEn('ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾗﾘﾙﾚﾛﾜｦﾝｳﾞｶﾞｷﾞｸﾞｹﾞｺﾞｻﾞｼﾞｽﾞｾﾞｿﾞﾀﾞﾁﾞﾂﾞﾃﾞﾄﾞﾊﾞﾋﾞﾌﾞﾍﾞﾎﾞﾊﾟﾋﾟﾌﾟﾍﾟﾎﾟｰｧｨｩｪｫｯ'));
        Test.stopTest();
    }

    /**
     * enAlphabetToEmメソッドのテスト
     */
    static testMethod void test_enAlphabetToEm_001() {
        // テスト開始
        Test.startTest();
        System.assertEquals(null, JP_StringUtil.enAlphabetToEm(null));
        System.assertEquals('', JP_StringUtil.enAlphabetToEm(''));
        System.assertEquals('ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ', JP_StringUtil.enAlphabetToEm('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'));
        System.assertEquals('ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ', JP_StringUtil.enAlphabetToEm('ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ'));
        Test.stopTest();
    }

    /**
     * emAlphabetToEnメソッドのテスト
     */
    static testMethod void test_emAlphabetToEn_001() {
        // テスト開始
        Test.startTest();
        System.assertEquals(null, JP_StringUtil.emAlphabetToEn(null));
        System.assertEquals('', JP_StringUtil.emAlphabetToEn(''));
        System.assertEquals('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', JP_StringUtil.emAlphabetToEn('ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ'));
        System.assertEquals('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', JP_StringUtil.emAlphabetToEn('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'));
        Test.stopTest();
    }

    /**
     * enSignToEmメソッドのテスト
     */
    static testMethod void test_enSignToEm_001() {
        // テスト開始
        Test.startTest();
        System.assertEquals(null, JP_StringUtil.enSignToEm(null));
        System.assertEquals('', JP_StringUtil.enSignToEm(''));
        System.assertEquals('！＃＄％＆（）＊＋，－．／：；＜＝＞？＠［］＾＿｛｜｝～。「」、｀　”・・’￥', JP_StringUtil.enSignToEm('!#$%&()*+,-./:;<=>?@[]^_{|}~｡｢｣､` "･・\'\\'));
        System.assertEquals('！＃＄％＆（）＊＋，－．／：；＜＝＞？＠［］＾＿｛｜｝～。「」、｀　”・・’￥', JP_StringUtil.enSignToEm('！＃＄％＆（）＊＋，－．／：；＜＝＞？＠［］＾＿｛｜｝～。「」、｀　”・・’￥'));
        Test.stopTest();
    }

    /**
     * emSignToEnメソッドのテスト
     */
    static testMethod void test_emSignToEn_001() {
        // テスト開始
        Test.startTest();
        System.assertEquals(null, JP_StringUtil.emSignToEn(null));
        System.assertEquals('', JP_StringUtil.emSignToEn(''));
        System.assertEquals('!#$%&()*+,-./:;<=>?@[]^_{|}~｡｢｣､` "･\'\\', JP_StringUtil.emSignToEn('！＃＄％＆（）＊＋，－．／：；＜＝＞？＠［］＾＿｛｜｝～。「」、｀　”・’￥'));
        System.assertEquals('!#$%&()*+,-./:;<=>?@[]^_{|}~｡｢｣､` "･\'\\', JP_StringUtil.emSignToEn('!#$%&()*+,-./:;<=>?@[]^_{|}~｡｢｣､` "･\'\\'));
        Test.stopTest();
    }

    /**
     * enToEmメソッドのテスト
     */
    static testMethod void test_enToEm_001() {
        // テスト開始
        Test.startTest();
        System.assertEquals(null, JP_StringUtil.enToEm(null));
        System.assertEquals('', JP_StringUtil.enToEm(''));
        System.assertEquals('０１２３４５６７８９アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホラリルレロワヲンヴガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポーァィゥェォッａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ！＃＄％＆（）＊＋，－．／：；＜＝＞？＠［］＾＿｛｜｝～。「」、｀　”・’￥', JP_StringUtil.enToEm('0123456789ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾗﾘﾙﾚﾛﾜｦﾝｳﾞｶﾞｷﾞｸﾞｹﾞｺﾞｻﾞｼﾞｽﾞｾﾞｿﾞﾀﾞﾁﾞﾂﾞﾃﾞﾄﾞﾊﾞﾋﾞﾌﾞﾍﾞﾎﾞﾊﾟﾋﾟﾌﾟﾍﾟﾎﾟｰｧｨｩｪｫｯabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!#$%&()*+,-./:;<=>?@[]^_{|}~｡｢｣､` "･\'\\'));
        System.assertEquals('０１２３４５６７８９アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホラリルレロワヲンヴガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポーァィゥェォッａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ！＃＄％＆（）＊＋，－．／：；＜＝＞？＠［］＾＿｛｜｝～。「」、｀　”・’￥', JP_StringUtil.enToEm('０１２３４５６７８９アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホラリルレロワヲンヴガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポーァィゥェォッａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ！＃＄％＆（）＊＋，－．／：；＜＝＞？＠［］＾＿｛｜｝～。「」、｀　”・’￥'));
        Test.stopTest();
    }

    /**
     * enToEmメソッドのテスト
     */
    static testMethod void test_emToEn_001() {
        // テスト開始
        Test.startTest();
        System.assertEquals(null, JP_StringUtil.emToEn(null));
        System.assertEquals('', JP_StringUtil.emToEn(''));
        System.assertEquals('0123456789ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾗﾘﾙﾚﾛﾜｦﾝｳﾞｶﾞｷﾞｸﾞｹﾞｺﾞｻﾞｼﾞｽﾞｾﾞｿﾞﾀﾞﾁﾞﾂﾞﾃﾞﾄﾞﾊﾞﾋﾞﾌﾞﾍﾞﾎﾞﾊﾟﾋﾟﾌﾟﾍﾟﾎﾟｰｧｨｩｪｫｯabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!#$%&()*+,-./:;<=>?@[]^_{|}~｡｢｣､` "･\'\\', JP_StringUtil.emToEn('０１２３４５６７８９アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホラリルレロワヲンヴガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポーァィゥェォッａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ！＃＄％＆（）＊＋，－．／：；＜＝＞？＠［］＾＿｛｜｝～。「」、｀　”・’￥'));
        System.assertEquals('0123456789ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾗﾘﾙﾚﾛﾜｦﾝｳﾞｶﾞｷﾞｸﾞｹﾞｺﾞｻﾞｼﾞｽﾞｾﾞｿﾞﾀﾞﾁﾞﾂﾞﾃﾞﾄﾞﾊﾞﾋﾞﾌﾞﾍﾞﾎﾞﾊﾟﾋﾟﾌﾟﾍﾟﾎﾟｰｧｨｩｪｫｯabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!#$%&()*+,-./:;<=>?@[]^_{|}~｡｢｣､` "･\'\\', JP_StringUtil.emToEn('0123456789ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾗﾘﾙﾚﾛﾜｦﾝｳﾞｶﾞｷﾞｸﾞｹﾞｺﾞｻﾞｼﾞｽﾞｾﾞｿﾞﾀﾞﾁﾞﾂﾞﾃﾞﾄﾞﾊﾞﾋﾞﾌﾞﾍﾞﾎﾞﾊﾟﾋﾟﾌﾟﾍﾟﾎﾟｰｧｨｩｪｫｯabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!#$%&()*+,-./:;<=>?@[]^_{|}~｡｢｣､` "･\'\\'));
        Test.stopTest();
    }

    /**
     * getStringValueメソッドのテスト
     */
    static testMethod void test_getStringValue_001() {
        // テスト開始
        Test.startTest();
        System.assertEquals(null, JP_StringUtil.getStringValue(null, null));
        System.assertEquals(null, JP_StringUtil.getStringValue(null, ''));
        Group grp = createGroup(true, 'aaa');
        System.assertEquals(grp.Name, JP_StringUtil.getStringValue(grp, 'Name'));
        GroupMember grpMem = createGroupMember(true, grp.Id);
        GroupMember resGrpMem = [select Id, Group.Name from GroupMember where GroupId = :grp.Id].get(0);
        System.assertEquals(grp.Name, JP_StringUtil.getStringValue(resGrpMem, 'Group.Name'));

        Exception resE = null;
        try {
            String dest = JP_StringUtil.getStringValue(grpMem, 'Names');
        } catch (Exception e) {
            resE = e;
        }
        System.assertNotEquals(null, resE);
        Test.stopTest();
    }

    /**
     * toStringメソッドのテスト
     */
    static testMethod void test_toString_001() {
        // テスト開始
        Test.startTest();
        // Blobテスト
        System.assertEquals(null, JP_StringUtil.toString(null));
        String str = 'test';
        Blob b = Blob.valueOf(str);
        String base64Str = EncodingUtil.base64Encode(b);
        final String base64BOM = '77u/';
        base64Str = base64BOM + base64Str;
        b = EncodingUtil.base64Decode(base64Str);
        System.assertEquals(str, JP_StringUtil.toString(b));

        // Datetimeテスト
        Datetime dt = Datetime.newInstance(2014, 3, 5, 12, 36, 40);
        System.assertEquals('2014/03/05 12:36:40', JP_StringUtil.toString(dt));

        // Dateテスト
        // Date d = Date.newInstance(2014, 5, 8);
        // System.assertEquals('2014/05/08', JP_StringUtil.toString(d));

        // その他テスト
        System.assertEquals('123', JP_StringUtil.toString(123));
        Test.stopTest();
    }

    /**
     * toStringRemoveUTF8BOMメソッドのテスト
     */
    static testMethod void test_toStringRemoveUTF8BOM_001() {
        // テスト開始
        Test.startTest();
        System.assertEquals(null, JP_StringUtil.toStringRemoveUTF8BOM(null));
        String str = 'test';
        Blob b = Blob.valueOf(str);
        String base64Str = EncodingUtil.base64Encode(b);
        final String base64BOM = '77u/';
        base64Str = base64BOM + base64Str;
        b = EncodingUtil.base64Decode(base64Str);
        System.assertEquals(str, JP_StringUtil.toStringRemoveUTF8BOM(b));
        Test.stopTest();
    }

    /**
     * leftPaddingメソッドのテスト
     */
    static testMethod void test_leftPadding_001() {
        // テスト開始
        Test.startTest();
        Integer i = 100;
        System.assertEquals('00100', JP_StringUtil.leftPad(i, 5, '0'));
        Decimal deci = 200;
        System.assertEquals('00200', JP_StringUtil.leftPad(deci, 5, '0'));
        Double d = 300;
        System.assertEquals('00300.0', JP_StringUtil.leftPad(d, 7, '0'));
        String str ='400';
        System.assertEquals('00400', JP_StringUtil.leftPad(str, 5, '0'));
        System.assertEquals(null, JP_StringUtil.leftPad((String) null, 5, '0'));
        Test.stopTest();
    }

    /**
     * rightPaddingメソッドのテスト
     */
    static testMethod void test_rightPadding_001() {
        // テスト開始
        Test.startTest();
        Integer i = 100;
        System.assertEquals('10000', JP_StringUtil.rightPad(i, 5, '0'));
        Decimal deci = 200;
        System.assertEquals('20000', JP_StringUtil.rightPad(deci, 5, '0'));
        Double d = 300;
        System.assertEquals('300.000', JP_StringUtil.rightPad(d, 7, '0'));
        String str ='400';
        System.assertEquals('40000', JP_StringUtil.rightPad(str, 5, '0'));
        System.assertEquals(null, JP_StringUtil.rightPad((String) null, 5, '0'));
        Test.stopTest();
    }

    /**
     * date2YYYYMMDDメソッドのテスト
     */
    static testMethod void test_date2YYYYMMDD_001() {
        // テスト開始
        Test.startTest();
        System.assertEquals(null, JP_StringUtil.date2YYYYMMDD(null));
        Date d = Date.newInstance(2014, 1, 3);
        System.assertEquals('20140103', JP_StringUtil.date2YYYYMMDD(d));
        Test.stopTest();
    }

    /**
     * datetime2YYYYMMDDメソッドのテスト
     */
    static testMethod void test_datetime2YYYYMMDD_001() {
        // テスト開始
        Test.startTest();
        System.assertEquals(null, JP_StringUtil.datetime2YYYYMMDD(null));
        Datetime dt = Datetime.newInstance(2014, 1, 3);
        System.assertEquals('20140103', JP_StringUtil.datetime2YYYYMMDD(dt));
        Test.stopTest();
    }

    /**
     * splitByLengthメソッドのテスト
     */
    static testMethod void test_splitByLength_001() {
        // テスト開始
        Test.startTest();
        System.assertNotEquals(null, JP_StringUtil.splitByLength(null, 10));
        List<String> dest = JP_StringUtil.splitByLength('1234567890', 3);
        System.assertEquals(4, dest.size());
        for (Integer i = 0; i < dest.size(); i++) {
            if (i == 0) {
                System.assertEquals('123', dest.get(i));
            } else if (i == 1) {
                System.assertEquals('456', dest.get(i));
            } else if (i == 2) {
                System.assertEquals('789', dest.get(i));
            } else if (i == 3) {
                System.assertEquals('0', dest.get(i));
            }
        }
        Test.stopTest();
    }

    /**
     * テストグループインスタンス生成
     * @param isInsert insertするかどうか
     * @param name 取引先名
     * @return 生成したグループインスタンス
     */
    public static Group createGroup(Boolean isInsert, String name) {
        Group dest = new Group(Name = name);
        if (isInsert) {
            insert dest;
        }
        return dest;
    }

    /**
     * テストグループメンバーインスタンス生成
     * @param isInsert insertするかどうか
     * @param groupID グループID
     * @return 生成したグループメンバーインスタンス
     */
    public static GroupMember createGroupMember(Boolean isInsert, ID groupID) {
        GroupMember dest = new GroupMember(GroupID = groupID, UserOrGroupID = UserInfo.getUserId());
        if (groupID == null) {
            dest.groupID = createGroup(true, 'test').Id;
        }

        if (isInsert) {
            insert dest;
        }
        return dest;
    }
}