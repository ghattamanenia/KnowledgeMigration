/**
 * シフト作成
 */

global class JP_CreateShift{

    // 指定日～指定日(土日を除く)のシフトをマスタをもとに作成
    // ユーザも指定可能
    public static void specifiedPeriodUser(Date StartDate, Date EndDate, String userAlias){

        FeedItem feed = new FeedItem(parentId = '0F91I000000doo5SAA', body = '#Shift登録');  // Chatter投稿用
        feed.Body += '\n' + '期間:' + StartDate.format() + '～' + EndDate.format();

        String feedBody = '';
        List<JP_Shift__c> masterShiftList= new List<JP_Shift__c>();  // マスタ
        List<JP_Shift__c> newShiftList= new List<JP_Shift__c>();  // 新規シフト
        
        if(String.isBlank(userAlias)){
            //シフトのマスタを取得
            masterShiftList = [SELECT Id,Name,ownerId,
                                      JP_User__c,JP_Date__c,JP_WorkingHours__c,
                                      JP_0900__c,JP_0930__c,JP_1000__c,JP_1030__c,
                                      JP_1100__c,JP_1130__c,JP_1300__c,JP_1330__c,
                                      JP_1400__c,JP_1430__c,JP_1500__c,JP_1530__c,
                                      JP_1600__c,JP_1630__c,JP_1700__c
                                FROM  JP_Shift__c
                                WHERE JP_Master__c = true
                                      AND JP_User__r.IsActive = true];
                                
            feed.Body += '\n' + 'マスタ件数:' + masterShiftList .size();

        }else{
            //ユーザを指定してシフトのマスタを取得
            masterShiftList = [SELECT Id,Name,ownerId,
                                      JP_User__c,JP_Date__c,JP_WorkingHours__c,
                                      JP_0900__c,JP_0930__c,JP_1000__c,JP_1030__c,
                                      JP_1100__c,JP_1130__c,JP_1300__c,JP_1330__c,
                                      JP_1400__c,JP_1430__c,JP_1500__c,JP_1530__c,
                                      JP_1600__c,JP_1630__c,JP_1700__c
                                FROM  JP_Shift__c
                                WHERE JP_Master__c = true
                                      AND JP_User__r.alias =: userAlias
                                      AND JP_User__r.IsActive = true];
                                      
            feed.Body += '\n' + 'マスタ:' + userAlias;
        }

        Integer numberDaysDue = startDate.daysBetween(EndDate);

        // マスタをもとにシフトを作成
        for(JP_Shift__c masterShift : masterShiftList){
            masterShift.Id = null;
            masterShift.ownerId = masterShift.JP_User__c;

            for (Integer i = 0; i <= numberDaysDue; i++) {
                Date TargetDate = StartDate.addDays(i);
                Datetime targetDt = Datetime.newInstance(TargetDate, Time.newInstance(9, 0, 0, 0));  // JST、日時型に変換、

                if(targetDt.format('E') != 'SAT' && targetDt.format('E') != 'SUN'){
                    JP_Shift__c wkShift = masterShift.clone();
                    wkShift.JP_Date__c = TargetDate;
                    newShiftList.add(wkShift);
                }
            }
        }

        feed.Body += '\n' + '件数:' + newShiftList.size();
        
        if(newShiftList.size() > 0){
            insert newShiftList;
        }
        insert feed;
    }

}