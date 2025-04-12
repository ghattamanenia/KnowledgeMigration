public with sharing class JP_CreateList {
    /*---------------------------*/
    /* 定数定義                  */
    /*---------------------------*/
    //valueList Value
    //---------------------------
    // 0 | RecordTypeName        
    //---------------------------
    // 1 | DummyAccountName      
    //---------------------------
    // 2 | OpportunityName
    //---------------------------
    // 3 | StageName
    //---------------------------
    public List<String> getvalueList(String Prefix){
        //国別固定値保持リストを定義
        List<String> valueList = new List<String>();
        
        //JPプロファイルの固定値を設定
        if( Prefix == 'JP'){
            valueList.add('JP_Opportunity');
            valueList.add('エンド不明');
            valueList.add('Enter Opportunity Name');
            valueList.add('Prospect/Qualification - APAC');
            valueList.add('User');
            valueList.add('JP_USE_ONLY02');
        }
        
        //リストをリターン
        return valueList;
    }
}