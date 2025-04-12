/**
 * 説明：ユーザの新規登録・更新が行われた場合にTriggerから呼ばれるクラスです。
 *       CS部・Logi部門に関連するプロファイルを持つユーザの情報をRepairItem担当者オブジェクトに
         登録/更新/削除します。
 * 作成者名: 深草 佑貴
 * 作成日: 2011/7/14
 * 最終更新日: 2012/01/27
 */

global class JP_CLSynchronizeRMAPICWithUser {


    /**
    * 説明：RepairItem担当者名オブジェクトの更新・作成を判断する為の作成条件クラス
    */
    private class CreateRepairItemCondition {
        /**
        * ConditionFieldsmap：RepairItem担当者名を作成するための条件値マップ
        * string：ユーザ項目名（API）
        * set<string>：条件値セット
        */
        map <string, set<string>> ConditionFieldsmap = new map <string, set<string>>();

        /**
        * CreateFieldsmap：作成するRepairItem担当者名の設定値マップ
        * string1：RepairItem担当者名項目名（API）
        * string1：設定値
        */
        map <string, string> CreateFieldsmap = new map <string, string>();

        /**
        * 説明：ConditionFieldsmapに新たな条件値をセットする。
        *       条件項目が参照項目だった場合、IDマップからID値を取得し、条件値を書き換えてからセットする。
        * @param string：ユーザ項目名（API）
        * @param set<string>：条件値セット
        * @return なし
        */
        void SetConditionMap(string str1, set<string> strSet){

            // 比較対象がプロファイル、ロールだった場合
            if ( ObjectIdMap.containsKey(str1)){
                set<string> strSet2 = new set<string>();
                for (string s : strSet){
                    if ( ObjectIdMap.containsKey(str1) && ObjectIdMap.get(str1).containsKey(s)){
                        strSet2.add(ObjectIdMap.get(str1).get(s));
                    }
                }
                strSet = strSet2;
            }
            ConditionFieldsmap.put(str1,strSet);
        }

        /**
        * 説明：SetCreateMapに新たな条件値をセットする。
        *       設定項目が参照項目だった場合、IDマップからID値を取得し、設定値を書き換えてからセットする。
        * @param string：RepairItem担当者名項目名（API）
        * @param string：設定値
        * @return なし
        */
        void SetCreateMap(string str1,string str2){
            // 設定対象がレコードタイプだった場合
            if ( ObjectIdMap.containsKey(str1) && ObjectIdMap.get(str1).containsKey(str2)){
                str2 = ObjectIdMap.get(str1).get(str2);
            }
            CreateFieldsmap.put(str1,str2);
        }

        /**
        * 説明：指定されたユーザレコードがRepairItem担当者作成条件に一致しているか判定。
        *       一致していた場合はRepairItem担当者を作成
        * @param User：RepairItem担当者の作成を判定するユーザ情報
        * @return RepairItem担当者インスタンス（作成条件に一致しない場合はnull）
        */
        JP_RepairItemPersonInCharge__c GetObject(User us){

            // ユーザが現在アクティブ、またはキューユーザでなければRepairItem担当者オブジェクトは作成されない
            boolean b = us.JP_QueueFlag__c || us.IsActive;

            // 条件マップ全ての条件を満たすかチェック
            for (string key : ConditionFieldsmap.keySet()){
                b &= (us.get(key)!=null && ConditionFieldsmap.get(key).contains(String.valueOf(us.get(key))));
            }

            // 上記チェック結果から、条件を満たさない場合はRETURN。
            if (!b)   return null;

            // 条件を満たす場合はRepairItemに値を設定
            JP_RepairItemPersonInCharge__c rmaPICRec = new JP_RepairItemPersonInCharge__c();

            // 設定条件値に従って値を設定
            for (string key : CreateFieldsmap .keySet()){
                rmaPICRec.put(key,CreateFieldsmap.get(key));
            }

            // ユーザ情報から値を設定
            rmaPICRec.JP_IsDeleted__c = false;
            rmaPICRec.JP_UserID__c = string.ValueOf(rmaPICRec.RecordTypeId) + string.ValueOf(us.Id);
            rmaPICRec.Name = us.JP_FullName__c;
            rmaPICRec.JP_OriginUser__c = us.Id;

            // キューフラグがTrueの場合（キュー用ユーザの場合）、ユーザ区分に"グループ"をセットする
            // キューフラグがFalseの場合（一般ユーザの場合）、   ユーザ区分に"ユーザ"をセットする
            rmaPICRec.JP_UserDivision__c = us.JP_QueueFlag__c ? JP_CLCommonConst.SELECTEDLISTVALUE_GROUP : JP_CLCommonConst.SELECTEDLISTVALUE_USER;

            return rmaPICRec;
        }
    }

    /**
    * 説明：RepairItem担当者の作成条件値/設定値となるProfileId/UserRoleId/RecordTypeIdを
    *       取得してMapとして保持する。
    *       （ただし、UserRoleIdは現在利用していないためコメントアウト）
    */
    private static map<string,map<string,Id>> ObjectIdMap{
        get{
            if (ObjectIdMap==null){

                ObjectIdMap = new map<string,map<string,Id>>();
                // プロファイルIDマップ作製 START //
                list<Profile> tmpProList = [SELECT ID,NAME FROM Profile];
                map<string,Id> tmpProMap = new map<string,Id>();
                for (Profile pro : tmpProList){    tmpProMap.put(pro.Name, pro.Id);    }
                ObjectIdMap.put('ProfileId', tmpProMap);
                // プロファイルIDマップ作製  END //

                // レコードタイプIDマップ作製 START //
                Schema.DescribeSObjectResult R = JP_RepairItemPersonInCharge__c.SObjectType.getDescribe();
                List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
                map<string,Id> tmpRecMap = new map<string,Id>();
                for (RecordTypeInfo i : RT){    tmpRecMap.put(i.getName(), i.getRecordTypeId());    }
                ObjectIdMap.put('RecordTypeId', tmpRecMap);
                // レコードタイプIDマップ作製 END //

                /* 現在は利用していないので、コメントアウト
                // ユーザーロールIDマップ作製 START //
                list<UserRole> tmpRolList = [SELECT ID,NAME FROM UserRole];
                map<string,Id> tmpRolMap = new map<string,Id>();
                for (UserRole rol : tmpRolList){    tmpRolMap.put(rol.Name, rol.Id);    }
                ObjectIdMap.put('UserRoleId', tmpRolMap);
                // ユーザーロールIDマップ作製 END //
                */
            }

            return ObjectIdMap;
        }
        set;//ALLIEDTELESIS-568 terrasky D.Ariga SalesforceAPIバージョン更新のためsetterを追加
    }

    /**
    * 説明：RepairItem担当者名作成条件クラスのインスタンスを作成し、リストとして保持する。
    ※※※※※ 作成条件の変更やレコードタイプの追加が発生した場合は、ここを修正する。 ※※※※※
    */
    private static list<CreateRepairItemCondition> createConditionList{
        get{
            if (createConditionList==null){
                list<CreateRepairItemCondition> tmpCreateConditionList = new list<CreateRepairItemCondition>();

                // 作成条件インスタンス１
                // プロファイル：'JP_SalesUser' または 'JP_CSC/TeleMarketingUser' の時、
                // レコードタイプ：'JP_LeadTrans'のRepairItem担当者名を作成
                CreateRepairItemCondition cric1 = new CreateRepairItemCondition();
                cric1.SetConditionMap('ProfileId', new Set<string>{'JP_SalesUser','JP_CSC/TeleMarketingUser'});
                cric1.SetCreateMap('RecordTypeId','JP_LeadTrans');
                tmpCreateConditionList.add(cric1);

                // 作成条件インスタンス２
                // プロファイル：'JP_Logi' または 'JP_CS' の時、
                // レコードタイプ：'JP_RepairItem'のRepairItem担当者名を作成
                CreateRepairItemCondition cric2 = new CreateRepairItemCondition();
                cric2.SetConditionMap('ProfileId', new Set<string>{'JP_Logi','JP_CS'});
                cric2.SetCreateMap('RecordTypeId','JP_RepairItem');
                tmpCreateConditionList.add(cric2);

                createConditionList = tmpCreateConditionList;
            }
            return createConditionList;
        }
        set;//ALLIEDTELESIS-568 terrasky D.Ariga SalesforceAPIバージョン更新のためsetterを追加
    }

    /**
    * 説明：ユーザー新規登録時・更新時、RepairItem担当者オブジェクトの登録・更新・削除を行う。
    * @param Set<ID> newUserId：Trigger.newで取得したユーザのIDセット
    * @param boolean isInsert ：Insertから呼ばれた場合、True
    * @return なし
    */
    @future
    public static void InsertUpdatepdateUserDataFuture(Set<Id> newUserId, boolean isInsert) {

        // 登録更新するレコードを格納するList
        List<JP_RepairItemPersonInCharge__c> newPICRecList = new List<JP_RepairItemPersonInCharge__c>();

        // 更新された全ユーザをチェック
        List<User> newUserData = [Select Id,JP_FullName__c,JP_QueueFlag__c,IsActive,ProfileId from User Where Id IN: newUserId];
        for(User tmpUserData : newUserData) {
            JP_RepairItemPersonInCharge__c rmaPICRec = null;
            for (CreateRepairItemCondition cric : createConditionList){
                // オブジェクトが返却された場合は、更新用Listにオブジェクトのデータを格納
                rmaPICRec =cric.GetObject(tmpUserData);
                if (rmaPICRec!=null)    newPICRecList.add(rmaPICRec);
            }
        }

        try {
            // Update処理の場合は、予め関連するRepairItem担当者の削除フラグを全てTrueにする
            if(!isInsert) {
                List<JP_RepairItemPersonInCharge__c> rmaPICdeleteList = [Select JP_IsDeleted__c from JP_RepairItemPersonInCharge__c where JP_OriginUser__c IN: newUserId for update];
                for(JP_RepairItemPersonInCharge__c rmaPICdel : rmaPICdeleteList) {    rmaPICdel.JP_IsDeleted__c = true;    }
                if ( rmaPICdeleteList!=null && 0<rmaPICdeleteList.size() )  update rmaPICdeleteList;
            }

            // 登録更新対象がある場合はupsertを実行
            if(newPICRecList.size() != 0) {
                if (isInsert)   insert newPICRecList;
                else            upsert newPICRecList JP_UserID__c;
            }

        // Exception発生時
        } catch (DMLException ex){
            System.debug('Error:'+ ex.getMessage());
        }
    }

    /**
    * 説明：ユーザー新規作成時、プロファイルがCS・Logiのものの場合はRMA担当者にレコードを作成する。
    * @param List<User> Trigger.Newで渡された更新後のユーザー情報
    * @return なし
    */
/*    @future
    public static void insertNewUserFuture(Set<Id> newUserId) {

        //対象となるユーザの情報を取得する。
        //List<User> newUserData = [Select Id,JP_FullName__c,Email,JP_QueueFlag__c,IsActive,ProfileId from User Where Id IN: newUserId];
        List<User> newUserData = [Select Id,JP_FullName__c,JP_QueueFlag__c,IsActive,ProfileId from User Where Id IN: newUserId];

        //インスタンス作成
        //Insertするオブジェクト情報を格納するList
        List<JP_RepairItemPersonInCharge__c> insertList = new List<JP_RepairItemPersonInCharge__c>();

        //対象ProfileのIdを格納したSet
        Set<Id> targetProfileIds = JP_CLCommonConst.PROFILENAME();

        //すべての新規登録ユーザに対して実行
        for(User tmpUser : newUserData) {

            //CS部・Logi部門関連のプロファイルを持つユーザは後続の処理を実施
            if(targetProfileIds.contains(tmpUser.ProfileId)
            &&((tmpUser.JP_QueueFlag__c == true)
             ||(tmpUser.JP_QueueFlag__c == false && tmpUser.isActive == true))) {

                //RepairItem担当者オブジェクトのインスタンス作成
                JP_RepairItemPersonInCharge__c rmaPIC = new JP_RepairItemPersonInCharge__c();

                //ユーザの日本語名・メールアドレス・ユーザIDをRepairItem担当者のインスタンスに格納
                rmaPIC.Name = tmpUser.JP_FullName__c;
                //rmaPIC.JP_Email__c = tmpUser.Email;
                rmaPIC.JP_UserID__c = tmpUser.Id;
                rmaPIC.JP_OriginUser__c = tmpUser.Id;

                //キューフラグがTrueの場合はユーザ区分に"グループ"を、それ以外は"ユーザ"をセット
                if(tmpUser.JP_QueueFlag__c) {
                    rmaPIC.JP_UserDivision__c = JP_CLCommonConst.SELECTEDLISTVALUE_GROUP;
                } else{
                    rmaPIC.JP_UserDivision__c = JP_CLCommonConst.SELECTEDLISTVALUE_USER;
                }

                //登録対象レコードをListに格納
                insertList.add(rmaPIC);
            }
        }

        //レコードをRMA担当者オブジェクトに登録
        //登録用のListが空でない場合のみ実行
        if(insertList.size() != 0) {
            try {
                insert insertList;

            //Exception発生時
            } catch (DMLException ex){
                System.debug('Error:'+ ex.getMessage());
            }
        }
    }

*/
    /**
    * 説明：ユーザー更新時、RepairItem担当者オブジェクトの登録・更新・削除を行う。
    * @param Map<ID,ID> Key：Trigger.oldで取得したユーザのID，Value:Trigger.oldで取得したユーザのプロファイルID　を格納したMap
    * @param List<ID> Trigger.Newで取得したIDのList
    * @return なし
    */
 /*   @future
    public static void updateUserDataFuture(Set<Id> newUserId) {

        //更新されたユーザのデータを取得
        //List<User> newUserData = [Select Id,JP_FullName__c,Email,JP_QueueFlag__c,IsActive,ProfileId from User Where Id IN: newUserId];
        List<User> newUserData = [Select Id,JP_FullName__c,JP_QueueFlag__c,IsActive,ProfileId from User Where Id IN: newUserId];

        //インスタンス作成
        //削除するレコードを格納するList
        List<JP_RepairItemPersonInCharge__c> rmaPICdeleteList = new List<JP_RepairItemPersonInCharge__c>();

        //登録更新するレコードを格納するList
        List<JP_RepairItemPersonInCharge__c> newPICRecList = new List<JP_RepairItemPersonInCharge__c>();

        //削除を行うユーザのIDのSet
        Set<Id> deleteIdSet = new Set<Id>();

        //対象ProfileのIdを格納したSet
        Set<Id> targetProfileIds = JP_CLCommonConst.PROFILENAME();

        //更新された全ユーザをチェック
        for(User tmpUserData : newUserData) {

            //キューフラグがTrueの場合（キュー用ユーザの場合）
            if(tmpUserData.JP_QueueFlag__c) {

                //RepairItem担当者オブジェクトのインスタンス作成
                JP_RepairItemPersonInCharge__c rmaPICRec = new JP_RepairItemPersonInCharge__c();

                //ユーザレコード更新後のプロファイルがCS・Logi関連の場合は登録更新対象としてRepairItem担当者オブジェクトにデータを格納
                if(targetProfileIds.contains(tmpUserData.ProfileId)) {

                    rmaPICRec.JP_UserID__c = tmpUserData.Id;
                    rmaPICRec.Name = tmpUserData.JP_FullName__c;
                    //rmaPICRec.JP_Email__c = tmpUserData.Email;
                    rmaPICRec.JP_OriginUser__c = tmpUserData.Id;

                    //ユーザ区分に"グループ"をセットする
                    rmaPICRec.JP_UserDivision__c = JP_CLCommonConst.SELECTEDLISTVALUE_GROUP;

                    //upsert用Listにオブジェクトのデータを格納
                    newPICRecList.add(rmaPICRec);

                //ユーザレコード更新後のプロファイルがCS・Logi関連以外の場合は削除対象のIDのSetに追加
                } else {
                    deleteIdSet.add(tmpUserData.Id);
                }

            //キューフラグがFalseの場合（一般ユーザの場合）
            } else {

                //更新後の有効フラグがTrueの場合、かつ更新後プロファイルがCS・Logi関連の場合は登録更新対象としてRepairItem担当者オブジェクトにデータを格納
                if(tmpUserData.IsActive == true && targetProfileIds.contains(tmpUserData.ProfileId)) {

                    //RepairItem担当者オブジェクトのインスタンス作成
                    JP_RepairItemPersonInCharge__c rmaPICRec = new JP_RepairItemPersonInCharge__c();

                    rmaPICRec.JP_UserID__c = tmpUserData.Id;
                    rmaPICRec.Name = tmpUserData.JP_FullName__c;
                    //rmaPICRec.JP_Email__c = tmpUserData.Email;
                    rmaPICRec.JP_OriginUser__c = tmpUserData.Id;

                    //ユーザ区分に"ユーザ"をセットする
                    rmaPICRec.JP_UserDivision__c = JP_CLCommonConst.SELECTEDLISTVALUE_USER;

                    //upsert用Listにオブジェクトのデータを格納
                    newPICRecList.add(rmaPICRec);

                //更新後の有効フラグがFalseの場合、または更新後のユーザのプロファイルがCS・Logi関連以外の場合は削除対象のIDのSetに追加
                } else if ( !targetProfileIds.contains(tmpUserData.ProfileId) || tmpUserData.IsActive == false) {
                    deleteIdSet.add(tmpUserData.Id);
                }
            }
        }


        try {
            //登録更新対象がある場合はupsertを実行
            if(newPICRecList.size() != 0) {
                upsert newPICRecList JP_UserID__c;
            }

            ////削除対象がある場合はdeleteを実行
            if(deleteIdSet.size() != 0) {
                rmaPICdeleteList = [Select ID,Name from JP_RepairItemPersonInCharge__c where JP_UserID__c IN: deleteIdSet];
                delete rmaPICdeleteList;
            }

        //Exception発生時
        } catch (DMLException ex){
            System.debug('Error:'+ ex.getMessage());
        }
    }
*/
    /**
    * 説明：ユーザ新規登録時、トリガから呼ばれる。
    *       RepairItem担当者レコード登録の準備を行い、実処理を行うメソッドを呼び出す。
    * @param List<User> Trigger.Newで渡された更新後のユーザー情報
    * @return なし
    */
/*    public void insertNewUser(List<User> newUserList) {

        //実処理に渡すIdのSetのインスタンスを作成
        Set<Id> newUserId = new Set<Id>();

        //新規登録ユーザ分のIDのSetを作成する。
        //@futureアノテーションを使用する場合、sObject型のListを
        //引数として指定する事ができない。そのため、下記処理を行い、
        //ユーザIdのSetを実処理側に渡してユーザを検索し、情報を取得する必要がある。
        for(User tmpNewUser : newUserList) {
            newUserId.add(tmpNewUser.Id);
        }

        //Insertを実行するメソッドを呼び出す
        insertNewUserFuture(newUserId);
    }
*/
    /**
    * 説明：ユーザ更新時、トリガから呼ばれる。
    *       RepairItem担当者レコード登録・更新・削除の準備を行い、実処理を行うメソッドを呼び出す。
    * @param List<User> Trigger.Newで渡された更新後のユーザー情報
    * @return なし
    */
/*    public void updateUserData(List<User> newUserList) {

        //実処理に渡すIdのSetのインスタンスを作成
        Set<Id> newUserId = new Set<Id>();

        //実処理に渡すユーザIdとプロファイルIdのMapのインスタンスを作成
        //Map<Id,Id> oldProfileMap = new Map<Id,Id>();

        //新規登録ユーザ分のIDのSetを作成する。
        for(User tmpNewUser : newUserList) {
            newUserId.add(tmpNewUser.Id);
        }

        //Key:更新前ユーザのId Value:更新前ユーザのプロファイルId のMapを作成
        //for(User tmpOldUser : oldUserList) {
            //oldProfileMap.put(tmpOldUser.Id,tmpOldUser.ProfileId);
        //}

        //Upsert・Deleteを実行するメソッドを呼び出す
        updateUserDataFuture(newUserId);
    }
 */
}