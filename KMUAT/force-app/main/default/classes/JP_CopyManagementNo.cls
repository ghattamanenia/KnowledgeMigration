/**
 * 管理番号コピー
 */
Global class JP_CopyManagementNo{

    @InvocableMethod
    public static List<String> doAction(List<Id> idList){
    
        Id targetId = idList[0];                        // 管理番号(コピー元)のID
        List<String> results = new List<String>();      // 結果用
        String newTargetRec = '';                       // 新規管理番号の名前
        Id parentId = '000000000000000000';             // 管理番号の親SOのID
        Boolean existsSo = false;                       // 管理番号の親SOが存在したらtrue
        Set<String> mailParentSet = new Set<String>();  // アラートメール(コピー対象)のIDセット
        Set<Id> ManagementNoIdSet = new Set<Id>();      // 管理番号(コピー対象)のIDセット
        Set<Id> productSet = new Set<Id>();             // 商品のIDセット
        Map<Id, Id> productMap = new Map<Id, Id>();     // 商品のマップ(新規商品のID,更新商品のID)

        // エラーメッセージ
        final String error_Copied = '・管理番号はコピー済です。';
        final String error_ManagementNoStatus = '・コピーは、statusが新規・更新の管理番号から実行してください。';
        final String error_SoStatus = '・親SOのstatusが新規・更新以外なのでコピーできません。';


        // 管理番号(コピー元)の詳細を取得
        JP_Management_No__c targetRec =  [SELECT Id, Name,
                                          JP_Contract_No__c,
                                          JP_SO_Header__c,
                                          JP_Status__c,
                                          JP_Copied__c
                                   FROM   JP_Management_No__c
                                   WHERE  Id =: targetId];

        // 管理番号の親SOの情報をセット
        if(String.isNotBlank(targetRec.JP_SO_Header__c)){  // 管理番号の親SOが存在す
            existsSo = true;
            parentId = targetRec.JP_SO_Header__c;
        }

        // 管理番号取得
        List<JP_Management_No__c> ManagementNoList = new List<JP_Management_No__c>();
        ManagementNoList = JP_CopyManagementNo_DAO.getManagementNoList(targetId, parentId);
        
        for(JP_Management_No__c ManagementNo : ManagementNoList){
            ManagementNoIdSet.add(ManagementNo.Id);  // 管理番号(コピー対象)のIDを管理番号IDセットへ
            mailParentSet.add(String.ValueOf(ManagementNo.Id).left(15));  // 管理番号(コピー対象)のIDをメールアラートIDセットへ
            mailParentSet.add(String.ValueOf(ManagementNo.JP_Contract_No__c).left(15));  // コピー対象の親契約番号のIDをアラートメールIDセットへ
        }

        // SOヘッダ取得
        JP_RequestInformation__c so = new JP_RequestInformation__c();
        if(existsSo){  // SOヘッダが存在する
            so = JP_CopyManagementNo_DAO.getSo(parentId);
            mailParentSet.add(String.ValueOf(so.Id).left(15));  // SOヘッダIDをアラートメールIDセットへ
        }

        // SO明細取得
        List<JP_SO_Detail__c> sodList = new List<JP_SO_Detail__c>();
        sodList = JP_CopyManagementNo_DAO.getSoDList(ManagementNoIdSet);
    
        // POヘッダ取得
        List<JP_ConsignmentInformation__c> poList = new List<JP_ConsignmentInformation__c>();
        poList = JP_CopyManagementNo_DAO.getPoList(ManagementNoIdSet);

        for(JP_ConsignmentInformation__c po : poList){
            mailParentSet.add(String.ValueOf(po.Id).left(15));  // POヘッダIDをアラートメールIDセットへ
        }

        // PO明細取得
        List<JP_PO_Detail__c> podList = new List<JP_PO_Detail__c>();
        podList = JP_CopyManagementNo_DAO.getPoDList(ManagementNoIdSet);
        
        for(JP_PO_Detail__c pod : podList){
            if(String.isNotBlank(pod.JP_MaterialCode__c)){
                productSet.add(pod.JP_MaterialCode__c);  // PO明細の商品IDを商品IDセットへ
            }
        }

        // アラートメール取得
        List<JP_AlertMail__c> mailList = new List<JP_AlertMail__c>();
        mailList = JP_CopyManagementNo_DAO.getAlertMailList(mailParentSet);
        
        // 更新商品管理取得
        List<JP_ProductUpdateManagement__c> productUMList = new List<JP_ProductUpdateManagement__c>();
        productUMList = JP_CopyManagementNo_DAO.getproductUMList(ProductSet);

        for(JP_ProductUpdateManagement__c productUM : productUMList){
            productMap.put(productUM.JP_NewProduct__c, productUM.JP_UpdateProduct__c);
        }
    
    
        // エラーチェック
        // 管理番号(コピー元)のstatusが新規・更新以外はエラー
        if(targetRec.JP_Copied__c){
            results.add(error_Copied);
            return results;
        // 管理番号(コピー元)のstatusが新規・更新以外はエラー
        }else if(targetRec.JP_Status__c != '新規' && targetRec.JP_Status__c != '更新'){
            results.add(error_ManagementNoStatus);
            return results;

        // 親SOのstatus
        }else if(existsSo && (So.JP_Management_Number__r.JP_Status__c != '新規' && So.JP_Management_Number__r.JP_Status__c != '更新')){
            results.add(error_SoStatus );
            return results;
        }


        Savepoint sp = Database.setSavepoint();
        try{

        // 管理番号作成
        Map<Id, JP_Management_No__c> newManagementNoMap = new Map<Id, JP_Management_No__c>();

        for(JP_Management_No__c ManagementNo : ManagementNoList){
            JP_Management_No__c newManagementNo = ManagementNo.clone(false,true);
            
            // コピー元から変更
            newManagementNo.JP_SO_Header__c = null;
            newManagementNo.JP_Contract_Status__c = '運用準備';
            newManagementNo.JP_StaYmd__c = (ManagementNo.JP_StaYmd__c==null)?null:ManagementNo.JP_StaYmd__c.addYears(1);
            newManagementNo.JP_EndYmd__c = (ManagementNo.JP_EndYmd__c==null)?null:ManagementNo.JP_EndYmd__c.addYears(1);
            newManagementNo.JP_Service_StaYmd__c = (ManagementNo.JP_Service_StaYmd__c==null)?null:ManagementNo.JP_Service_StaYmd__c.addYears(1);
            newManagementNo.JP_Billing_Status__c = '調整中';
            newManagementNo.JP_ContractAmount_First__c = ManagementNo.JP_ContractAmount_Next__c;
            newManagementNo.JP_Status__c = '更新';
            newManagementNo.JP_Estimate_Month__c = '12';

            newManagementNoMap.put(ManagementNo.Id, newManagementNo);
        }
        insert newManagementNoMap.values();


        // SOヘッダ作成
        JP_RequestInformation__c newSo;
        if(existsSo){
            newSo = So.clone(false,true);
            
            // コピー元から変更
            newSo.JP_Management_Number__c = newManagementNoMap.get(so.JP_Management_Number__c).Id;
            newSo.JP_Gi_Date_Change__c = true;

            insert newSo;
            
            for(JP_Management_No__c ManagementNo : newManagementNoMap.values()){
                ManagementNo.JP_SO_Header__c = newSo.Id;  // 管理番号の親SOを設定
            }
            update newManagementNoMap.values();
        }
        
        // SO明細作成
        List<JP_SO_Detail__c> newSoDList = new List<JP_SO_Detail__c>();

        for(JP_SO_Detail__c SoD : SoDList){
            JP_SO_Detail__c newSoD = SoD.clone(false,true);

            // コピー元から変更
            newSoD.JP_Management_No__c = newManagementNoMap.get(SoD.JP_Management_No__c).Id;
            newSoD.JP_SO_Item_Common4__c = (Sod.JP_SO_Item_Common4__c==null)?null:getNewTerm(Sod.JP_SO_Item_Common4__c);
            newSod.JP_Price__c = (newManagementNoMap.get(SoD.JP_Management_No__c).JP_ContractAmount_First__c==null || newManagementNoMap.get(SoD.JP_Management_No__c).JP_ContractAmount_First__c<1)?1:newManagementNoMap.get(SoD.JP_Management_No__c).JP_ContractAmount_First__c;
            newSoDList.add(newSoD);
        }
        insert newSoDList;

        // POヘッダ作成
        Map<Id, JP_ConsignmentInformation__c> newPoMap = new Map<Id, JP_ConsignmentInformation__c>();

        for(JP_ConsignmentInformation__c Po : PoList){
            JP_ConsignmentInformation__c newPo = Po.clone(false,true);

            // コピー元から変更
            newPo.JP_Management_No__c = newManagementNoMap.get(Po.JP_Management_No__c).Id;
            newPo.JP_Header_Text3__c = (Po.JP_Header_Text3__c==null)?null:getNewTerm(Po.JP_Header_Text3__c);
            newPo.JP_Header_Text4__c = (Po.JP_Header_Text4__c==null)?null:getNewTerm(Po.JP_Header_Text4__c);
            newPoMap.put(Po.Id,newPo);
        }
        insert newPoMap.values();

        // PO明細作成
        List<JP_PO_Detail__c> newPoDList = new List<JP_PO_Detail__c>();

        for(JP_PO_Detail__c PoD : PoDList){
            JP_PO_Detail__c newPoD = PoD.clone(false,true);

            // コピー元から変更
            newPoD.JP_PO_Header__c = newPoMap.get(PoD.JP_PO_Header__c).Id;
            newPoD.JP_MaterialCode__c = (productMap.containsKey(PoD.JP_MaterialCode__c))?productMap.get(PoD.JP_MaterialCode__c):PoD.JP_MaterialCode__c;
            newPoD.JP_ItemText__c = (PoD.JP_ItemText__c==null)?null:getNewTerm(PoD.JP_ItemText__c);
            newPoD.JP_Req_Delivery_Date_Change__c = true;

            newPoDList.add(newPoD);
        }
        insert newPoDList;


        // アラートメール作成
        List<JP_AlertMail__c> newMailList = new List<JP_AlertMail__c>();

        for(JP_AlertMail__c mail : mailList){
            JP_AlertMail__c newMail = mail.clone(false,true);  // クローン

            // 親 ※契約番号は変更不要
            if(mail.JP_Management_No__c != null){
                newMail.JP_Management_No__c = newManagementNoMap.get(newMail.JP_Management_No__c).Id;  // 管理番号
            }else if(mail.JP_RequestInformation__c != null){
                newMail.JP_RequestInformation__c = newSo.Id;  // SOヘッダ
            }else if(mail.JP_ConsignmentInformation__c != null){
                newMail.JP_ConsignmentInformation__c = newPoMap.get(mail.JP_ConsignmentInformation__c).Id;  // POヘッダ
            }
            
            // コピー元から変更
            newMail.JP_DesiredSendDate__c = (newMail.JP_DesiredSendDate__c==null)?null:newMail.JP_DesiredSendDate__c.addYears(1);// 送信希望日

            newMailList.add(newMail);
        }
        insert newMailList;

        targetRec.JP_Copied__c = true;
        update targetRec;

        // 新規管理番号を取得 (名前はマップで取得できない)
        newTargetRec = [SELECT Id, Name
                        FROM   JP_Management_No__c
                        WHERE  Id =: newManagementNoMap.get(targetId).Id].Name;

        }catch(Exception e){
            System.debug('◆error');
            Database.rollback(sp);
            results.add('・'+ e.getMessage());
            return results;
        }
        results.add(newTargetRec);
        System.debug('◆results'+ results);
        return results;
    }



    // 契約期間テキスト変更ルール
    private static String getNewTerm(String str){
        String regexDate = '([0-9]{4})/([0-9]{1,2})/([0-9]{1,2})';

        if(Pattern.matches('(.*)' + regexDate + '(.*)' + regexDate + '$', str)){
            Pattern p = Pattern.compile(regexDate);
            Matcher m = p.matcher(Str);

            while(m.find()){
                Date wk =Date.parse(m.group());
                wk = wk.addYears(1);
                Str = Str.replace(m.group(), wk.format());
            }
        }
        return str;
    }

}