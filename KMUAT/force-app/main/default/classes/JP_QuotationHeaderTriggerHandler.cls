public with sharing class JP_QuotationHeaderTriggerHandler{

    //多重起動防止
    public static Boolean isFirst = true;
    
    /*
    * 新規登録時処理
    * @param Trigger.new => List<JP_QuotationHeader__c> newList
    * @return void
    */
    public static void BeforeInsert(List<JP_QuotationHeader__c> newList){
        
        //見積書番採番処理
        JP_QuotationHeaderTriggerAction.QuotationNoAutoNumbering(newList);
        //全Record確認
        for(JP_QuotationHeader__c qh: newList){
            //実行判定：仮保存フラグ
            if(!qh.JP_PreSave__c){
                //実行判定：トリガースキップフラグ
                if(!qh.JP_TriggerSkipFLG__c){
                    //見積基本共通入力チェック処理
                    JP_QuotationHeaderTriggerAction.headerCommonValidation(qh);
                }
            }
            //仮保存フラグ=false;
            //qh.JP_PreSave__c = false;
        }
        
    }


    /*
    * 更新時処理
    * @param Trigger.old,Trigger.new => Map<ID,JP_QuotationHeader__c>  oldMap,List<JP_QuotationHeader__c> newList
    * @return void
    */
    public static void BeforeUpdate(Map<Id,JP_QuotationHeader__c> oldMap,List<JP_QuotationHeader__c> newList){

        //エラー有無フラグ
        Boolean hasError = false;
        
        
        for(JP_QuotationHeader__c newRec : newList){
            //実行判定：仮保存フラグ
            if(!newRec.JP_PreSave__c){        
                //見積基本共通入力チェック処理
                hasError = JP_QuotationHeaderTriggerAction.headerCommonValidation(newRec);
            }       
        }
        
        //見積基本共通入力チェックでのエラー有無確認：有=後続処理終了、無=後続処理継続
        if(hasError) return;
        
        //承認プロセス判定処理    
        //system.debug('■START CHECK APPROVAL PROCESS NO');           
        JP_QuotationHeaderTriggerAction.getApprovalProcessNo(newList);
        
        ///承認プロセスNo有無確認処理
        hasError = JP_QuotationHeaderTriggerAction.processNoExistCheck(newList);
        
        //承認プロセスNo有無確認処理エラー有無確認：有=後続処理終了、無=後続処理継続
        if(hasError) return;
        
        
        //申請中承認プロセスNo変更制約処理
        hasError = JP_QuotationHeaderTriggerAction.processNoNotChangeForRequest(oldMap,newList);
        
        //申請中承認プロセスNo変更制約処理のエラー有無確認：有=後続処理終了、無=後続処理継続
        if(hasError) return;
         
        //承認プロセスNo別入力チェック処理
        hasError = JP_QuotationHeaderTriggerAction.processNoValidation(newList);
        
        //承認プロセスNo別入力チェック処理のエラー有無確認：有=後続処理終了、無=後続処理継続
        if(hasError) return;
        
        //承認ステップユーザ初期化処理
        JP_QuotationHeaderTriggerAction.stepUserReset(oldMap,newList);
        
        //仮保存フラグ=false;
        //for(JP_QuotationHeader__c newRec : newList){
            //newRec.JP_PreSave__c = false;
        //}        
        
    }
    
    
}