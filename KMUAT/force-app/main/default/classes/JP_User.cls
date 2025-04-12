/**
 * ユーザ登録
 */

public with sharing class JP_User{

    
    // ユーザ登録
    public static String newUser(String email,
                              String lastName, String firstName, String kana, String kanji,
                              String Division, String Department, String DeptCode, String GroupCode, String UserRoleId, String ProfileId, String Clas,
                              String Pardot, Boolean UserPermissionsMarketingUser){

        Id userId = null;
        FeedItem feed = new FeedItem(parentId = '0F91I000000doo5SAA');  // Chatter投稿用

        List<User> userList = CheckUser(email);
        if(userList.size() == 0){

            // ユーザ登録
            userId = CreateUser(email, lastName, firstName, kana, kanji,
                                Division, Department, DeptCode, GroupCode, UserRoleId, ProfileId, Clas, Pardot, UserPermissionsMarketingUser);

            feed.body = '#ユーザ登録';
            feed.body += '\n' + Division +','+ kanji +','+ email +','+ userId;
            feed.body += '\n' + 'https://alliedtelesis.lightning.force.com/lightning/setup/ManageUsers/page?address=%2F' + userId + '%3Fnoredirect%3D1%26isUserEntityOverride%3D1';


        }else if(userList.size() == 1 && userList[0].IsActive == false){
            userList[0].IsActive = true;
            feed.body = '#ユーザ有効化';
            feed.body += '\n' + userList[0].Division +','+ userList[0].JP_FULLNAME__C +','+ userList[0].email +','+ userList[0].Id;
            feed.body += '\n' + 'https://alliedtelesis.lightning.force.com/lightning/setup/ManageUsers/page?address=%2F' + userList[0].Id + '%3Fnoredirect%3D1%26isUserEntityOverride%3D1';
            update userList[0];
            
        }else if(userList.size() == 1 && userList[0].IsActive == true){
            feed.body = '#ユーザ登録_エラー';
            feed.body += '\n' + '既存ユーザ！';
            feed.body += '\n' + 'https://alliedtelesis.lightning.force.com/lightning/setup/ManageUsers/page?address=%2F' + userList[0].Id + '%3Fnoredirect%3D1%26isUserEntityOverride%3D1';

        }else{
            System.debug('◆ユーザ登録しない');
            System.debug('◆USER:'+ userList);
            feed.body = '#ユーザ登録_エラー';
        }
        insert feed;
        return userId; 

    }


    // 生存確認
    public static List<user> CheckUser(String email){
        List<User> userList = [SELECT Id, IsActive, Division, JP_FULLNAME__C, email
                               FROM   User
                               WHERE  Username =: email];

        System.debug('◆ユーザ数:'+ userList.size());
        System.debug('◆ユーザリスト:'+ userList);

        return userList;
    }

    
    // ユーザ作成
    public static Id CreateUser(String email,
                              String lastName, String firstName, String kana, String kanji,
                              String Division, String Department, String DeptCode, String GroupCode, String UserRoleId, String ProfileId, String Clas,
                              String Pardot, Boolean UserPermissionsMarketingUser){

            // 作成
            User wkUser = new User();
            String Alias = email.substringBefore('@');

            wkUser.Username = email;
            wkUser.Email = email;
            wkUser.communityNickname = Alias;
            wkUser.Alias = Alias;
            wkUser.lastName = lastName;
            wkUser.firstName = firstName;
            wkUser.UserRoleId = UserRoleId;
            wkUser.ProfileId = ProfileId;
            wkUser.Department = Department;
            wkUser.Division = Division;
            wkUser.JP_Class__c = Clas;
            wkUser.JP_DeptCode__c = DeptCode;
            wkUser.JP_GroupCode__c = GroupCode;
            wkUser.JP_Pardot__c = Pardot;
            wkUser.JP_FULLKANA__C = kana;
            wkUser.JP_FULLNAME__C = kanji;
            wkUser.UserPermissionsMarketingUser = UserPermissionsMarketingUser;


            // 固定値
            wkUser.COMPANYNAME = 'Allied Telesis K.K.';
            wkUser.COUNTRY = 'Japan';
            wkUser.DEFAULTCURRENCYISOCODE = 'JPY';
            wkUser.CURRENCYISOCODE = 'JPY';
            wkUser.Price_Book_Region__c = 'JP';
            wkUser.TimeZoneSidKey = 'Asia/Tokyo';
            wkUser.LocaleSidKey = 'ja_JP';
            wkUser.LanguageLocaleKey = 'ja';
            wkUser.EmailEncodingKey = 'UTF-8';
            wkUser.isActive = true;

            System.debug('◆wkUser'+ wkUser);
            insert wkUser;
            System.debug('◆ユーザ登録しました');
            
        return wkUser.id;
    }

    /**
    * 特定のユーザに #OPRO の権限を付与
    * ・レコード
    * 
    * @param  ID ユーザのID
    * @return 結果
    */
    // OPRO
    public static void authorizationOpro(Id userId){

        // OPRO
        OPROARTS020__OproartsUser__c OproartsUserRec = new OPROARTS020__OproartsUser__c(OPROARTS020__Oproarts__c = 'a0vw000000rqk6JAAQ',
                                                                                       OPROARTS020__User__c = userId,
                                                                                       OPROARTS020__UID__c = 'V6RG8D5R9ZKSRW',
                                                                                       OPROARTS020__UPW__c = 'UhnWZDCDC3');
        insert OproartsUserRec;

    }
    

    /**
    * １か月以上ログインがないユーザを無効化
    */
    public static void disableUser(){

        List<User> userList = new List<User>();
        FeedItem feed = new FeedItem(parentId = '0F91I000000doo5', body = '#ユーザ無効化_ログインなし');

        if(!Test.isRunningTest()){
            userList = [SELECT id, userName, IsActive, JP_FullName__c, LastLoginDate, Division
                         FROM User
                        WHERE IsActive=true
                          AND Profile.name LIKE 'JP_%'
                          AND LastLoginDate != LAST_N_DAYS:32
                          AND LastLoginDate != NULL
                          AND alias != 'arii'//合原さん、長尾さんは適用外に設定
                          AND alias != 'skimu'
                          AND alias != 'snagano'
                          AND alias != 'tomohiro'
                          AND alias != 'ssatoh'
                          AND alias != 'jptkeiko'
                          AND alias != 'yuichi'
                          AND alias != 'takao'
                          AND alias != 'matumoto'//ロジ
                          AND alias != 'ajima'//シスG
                          AND alias != 'yonezawa'//STRE
                          AND alias != 'hniwa'//品管3名
                          AND alias != 'kmatsuno'
                          AND alias != 'ttanaka'
                          AND alias != 'mizobuti'//SP7名、更新
                          AND alias != 'tsuchida'
                          AND alias != 'kkaji'
                          AND alias != 'shingon'
                          AND alias != 'wada'
                          AND alias != 'kisizawa'
                          AND alias != 'akaris'
                          AND alias != 'motohiro'//経理財務3名、更新
                          AND alias != 'miyauchi'
                          AND alias != 'akikoyos'
                          AND alias != 'nobuhara'//案件コミ、17名
                          AND alias != 'iwagaki'
                          AND alias != 'yuichio'
                          AND alias != 'sueki'
                          AND alias != 'shibuya'
                          AND alias != 'tgotoh'
                          AND alias != 'toyoda'
                          AND alias != 'nishida'
                          AND alias != 'tatsuyas'
                          AND alias != 'uno'
                          AND alias != 'akimotos'
                          AND alias != 'kfukuda'
                          AND alias != 'yurube'
                          AND alias != 'tachi'
                          AND alias != 'kaito'
                          AND alias != 'araki'
                          AND alias != 'tohrun'                                  
                      ORDER BY LastLoginDate];

        }else{
            // テストクラス対策
            userList = [SELECT id, userName, IsActive, JP_FullName__c, LastLoginDate, Division
                          FROM User
                         WHERE IsActive=true
                           AND UserName = 'terraskyTest_disable1@test.allied-telesis.co.jp'
                         ORDER BY LastLoginDate];
        }

        feed.body += '\n' + '件数:' + userList.size();

        for(User wkUser : userList){
            wkUser.IsActive = false;
            feed.body += '\n' + wkUser.LastLoginDate +','+ wkUser.Division +','+ wkUser.JP_FullName__c +','+ wkUser.userName +','+ wkUser.id;
        }

        if(userList.size() > 0){
            update userList;
        }

        insert feed;
    }

    /**
    * 退職したユーザを無効化
    */
    public static void retiredUser(Set<String> retiredUserSet, Boolean isTestRun){

        List<User> userList = new List<User>();
        FeedItem feed = new FeedItem(parentId = '0F91I000000doo5');

        if(isTestRun == false){
            feed.body = '#ユーザ無効化_退職';
        }else{
            feed.body = '#ISテスト';
        }

        if(!Test.isRunningTest()){
            userList = [SELECT id, userName, IsActive, JP_FullName__c, LastLoginDate, Division
                         FROM User
                        WHERE IsActive=true
                          AND Profile.name LIKE 'JP_%'
                          AND JP_FullName__c != ''
                          AND JP_FullName__c =: retiredUserSet
                     ORDER BY LastLoginDate];

        }else{
            // テストクラス対策
            userList = [SELECT id, userName, IsActive, JP_FullName__c, LastLoginDate, Division
                          FROM User
                         WHERE IsActive=true
                           AND Profile.name LIKE 'JP_%'
                           AND UserName = 'terraskyTest_Retired1@test.allied-telesis.co.jp'
                         ORDER BY LastLoginDate];
        }

        for(User wkUser : userList){
            wkUser.IsActive = false;
            feed.body += '\n' + wkUser.LastLoginDate +','+ wkUser.Division +','+ wkUser.JP_FullName__c +','+ wkUser.userName +','+ wkUser.id;
        }

        if(isTestRun == false){
            if(userList.size() > 0){
                update userList;
            }
        }
        insert feed;
    }

}