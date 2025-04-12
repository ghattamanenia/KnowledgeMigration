public class JP_QuotationDetailTriggerHandler {

    //親見積更新時例外クラス
    public class HeaderException extends Exception {}

    /*
    * 新規登録時Before呼び出し
    * @param List<JP_QuotationDetail__c> newList //新規登録見積明細レコード
    * @return void
    */
    public static void BeforeInsert (List<JP_QuotationDetail__c> newList){

        //全レコード確認
        for( JP_QuotationDetail__c newRec : newList){     
            if(!newRec.JP_PreSave__c){
                //【見積明細】共通入力チェック処理
                JP_QuotationDetailTriggerAction.detailCommonValidation(newRec);
            }
        }

    } 


    /*
    * 新規登録時After呼び出し
    * @param List<JP_QuotationDetail__c> newList //新規登録見積明細レコード
    * @return void
    */
    public static void AfterInsert (List<JP_QuotationDetail__c> oldList){

        //親の見積基本ID一覧
        Set<ID> headerIdSet = new Set<ID>();
    
        //全レコード確認
        for( JP_QuotationDetail__c oldRec : oldList){     
            //仮保存フラグ確認 true=処理SKIP、false=処理呼び出し
            if(!oldRec.JP_PreSave__c){
                //親見積基本ID取得
                headerIdSet.add(JP_QuotationDetailTriggerAction.getHeaderID(oldRec));
            }
        }

        //更新対象となる親の見積基本リスト
        List<JP_QuotationHeader__c> headerList = new List<JP_QuotationHeader__c>();  
        JP_QuotationHeader__c headerRec;
        
        //更新対象見積リスト作成
        for(Id headerId : headerIdSet){
            headerRec = new JP_QuotationHeader__c();
            headerRec.Id = headerId;
            headerRec.JP_TriggerSkipFLG__c =false;
            headerList.add(headerRec);
        }
        
        //親見積基本更新
        if(0 < headerList.size()){
            try{
                update headerList;
            }catch(DmlException e){
                HeaderException hex = new HeaderException();
                hex.setMessage(e.getDMLMessage(0));
                throw hex;
            }catch (Exception e){
                HeaderException ex = new HeaderException();
                ex.setMessage(e.getMessage());
                throw ex;
            }                    
        }
    } 
    
    /*
    * 削除時呼び出し
    * @param List<JP_QuotationDetail__c> oldList //削除見積明細レコード
    * @return void
    */
    public static void AfterDelete (List<JP_QuotationDetail__c> oldList){
    
        //親の見積基本ID一覧
        Set<ID> headerIdSet = new Set<ID>();
        
        //全レコード確認
        for( JP_QuotationDetail__c oldRec : oldList){     
            //仮保存フラグ確認 true=処理SKIP、false=処理呼び出し
            if(!oldRec.JP_PreSave__c){
                //親見積基本ID取得
                headerIdSet.add(JP_QuotationDetailTriggerAction.getHeaderID(oldRec));
            }
        }

        //更新対象となる親の見積基本リスト
        List<JP_QuotationHeader__c> headerList = new List<JP_QuotationHeader__c>();
        JP_QuotationHeader__c headerRec;  

        //更新対象見積リスト作成
        for(Id headerId : headerIdSet){
            headerRec = new JP_QuotationHeader__c();
            headerRec.Id = headerId;
            headerList.add(headerRec);
        }
        
        //親見積基本更新
        if(0 < headerList.size()){
            try{
                update headerList;
            }catch(DmlException e){
                HeaderException hex = new HeaderException();
                hex.setMessage(e.getDMLMessage(0));
                throw hex;
            }catch (Exception e){
                HeaderException ex = new HeaderException();
                ex.setMessage(e.getMessage());
                throw ex;
            }
        }
        
    } 

    
}