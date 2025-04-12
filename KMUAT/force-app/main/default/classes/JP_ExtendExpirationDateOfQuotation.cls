global with sharing class JP_ExtendExpirationDateOfQuotation {
    
    /*
    * 見積有効期限延長チェック
    * @param JP_QuotationＨｅａｄｅｒ__c.Id id
    * @return String Message 
    */
    webservice static String CheckChange(String qId){
        String errMsg;
        Date SpecialPriceEndDate;
        Date endDate = Date.newInstance(2999,12,31);
        JP_QuotationHeader__c QHeader = new JP_QuotationHeader__c();
        Map<String, JP_QuotationDetail__c> qdMap = new Map<String, JP_QuotationDetail__c>();

        QHeader = JP_QuotationHeaderDAO.getRecById(qId);
        Map<String, JP_SpecailPriceApprove__c> spaMap = JP_SpecailPriceApproveDAO.getRecById(qId);

        /**
         * チェック1(3-1-1)
         * 「製品見積」の「見積有効期限」が設定されているかチェック
         */
        if(String.isBlank(QHeader.JP_EstimatesExpirationDate__c)){
            errMsg = system.Label.JP_ExtendExpirationDate_Msg4;
            return errMsg;
        }
        
        /**
         * チェック5(3-1-2)
         * 「製品見積」オブジェクトの見積書番号が「2015,2016,2017」から始まるかをチェック
         */
        if(QHeader.JP_QuotationNo__c.startsWith('2015')
           || QHeader.JP_QuotationNo__c.startsWith('2016')
           || QHeader.JP_QuotationNo__c.startsWith('2017')){
                errMsg = system.Label.JP_ExtendExpirationDate_Msg5;
                return errMsg;
        }
        
        /**
         * チェック4(3-1-3)
         * 見積明細の仕切価格と当月の価格表の価格を比較
         */
        system.debug('===== Check 4 =====');
        String priceYearMonth = 'JP ' + String.valueOf(system.today().year())+'/';
        if(system.today().month() < 10){
            priceYearMonth += '0';
        }
        priceYearMonth += +String.valueOf(system.today().month());
        String priceListType = QHeader.JP_Price_List_Type__c;
        
        for(JP_QuotationDetail__c qd : JP_QuotationDetailDAO.getRecByParentId(QHeader.Id)){
            qdMap.put(qd.JP_ProductCatalogCode__c, qd);
        }

        List<JP_DistributorPrice__c> dpList = JP_DistributorPriceDAO.selectForQuotationEdit(qdMap.keySet(),priceListType,priceYearMonth);

        for(JP_DistributorPrice__c dp : dpList){
            
            if(dp.JP_WholeSalePrice__c != qdMap.get(dp.JP_ProductCatalogCode__c).JP_UnitPrice__c){
                errMsg = system.Label.JP_ExtendExpirationDate_Msg3;
                return errMsg;
            }
        }
        
        /**
         * チェック0(3-1-4)
         * 特価承認情報が存在しない場合は、承認済みの元の見積書の見積発行日が330日より前かチェック
         */
        if(spaMap == null){
            if(QHeader.JP_QuoteOutputDate__c.daysBetween(system.today()) > 330){
                errMsg = system.Label.JP_ExtendExpirationDate_Msg2;
                return errMsg;
            }else{
                return '変更可能です';
            }
        }
        
        /**
         * チェック3(3-1-4)
         * 承認済みの元の見積書の見積発行日が330日より前かチェック
         */
        if(QHeader.JP_QuoteOutputDate__c.daysBetween(system.today()) >= 330){
            errMsg = system.Label.JP_ExtendExpirationDate_Msg2;
            return errMsg;
        }
        
        //製品種別毎に最も作成日の新しいレコードの日付をセット
        for(JP_SpecailPriceApprove__c spa : spaMap.values()){
            if(SpecialPriceEndDate == null){
                SpecialPriceEndDate = spa.JP_SpecailPriceEndDate__c;
            }else{
                if(SpecialPriceEndDate > spa.JP_SpecailPriceEndDate__c){
                    SpecialPriceEndDate = spa.JP_SpecailPriceEndDate__c;
                }
            }
        }

        /**
         * チェック2(3-1-5)
         * 取得した特価適用期限日までの期間が30日未満かチェック
         */
        if(system.today().daysBetween(SpecialPriceEndDate) < 30){
            errMsg = system.Label.JP_ExtendExpirationDate_Msg1;
            return errMsg;
        }
        
        

        return '変更可能です';
    }
    
    
    /*
    * 見積有効期限延長処理
    * @param JP_QuotationHeader__c.Id
    * @return String Message 
    */
    webservice static String JP_ExtendExpirationDate(String qId){
        Integer revision;
        String errMsg;
        Date thisDate = system.today();
        Date outputDate = thisDate;
        Date expirationDate = thisDate.addDays(30);
        JP_QuotationHeader__c QHeader = new JP_QuotationHeader__c();
        JP_QuoationChangesEexpirationDate__c record = new JP_QuoationChangesEexpirationDate__c();
        
        QHeader = JP_QuotationHeaderDAO.getRecById(qId);
        
        record.JP_QuotationHeader__c = qId;
        record.JP_QuoteOutputDate__c = outputDate;
        record.JP_QuotationExpireDate__c = expirationDate;
        
        // YYYYMMDD + 連番  を取得
        String strPrefix = QHeader.JP_QuotationNo__c;
        // YYYYMMDD + 連番 の revision が最大であるレコードを取得
        JP_QuoationChangesEexpirationDate__c rec = JP_QuoationChangesEexpirationDateDAO.getRecByQuotationNoMax(strPrefix);
            
        // revision の文字コードを取得
        if(rec != null){
            revision = rec.Name.charAt(9);
            revision++;
            
            if(revision > 90){
                // リビジョンが Z を超える場合
                //エラーメッセージ JP_QuotationNo over Z
                errMsg = system.Label.JP_ExtendExpirationDate_Msg6; 
                return errMsg;    
                       
            } else {
                String strRevision = String.fromCharArray( new List<integer> { revision } );
                record.Name = strPrefix + strRevision;
            }
        }else{
            record.Name = strPrefix + 'A';
        }
        
        try{
            insert record;
        }catch(Exception ex){
            system.debug('=====エラー：' + ex.getMessage());
            return 'エラー：' + ex.getMessage();
        }
        
        String strExpirationDate = expirationDate.year() + '年' + expirationDate.month() + '月' + expirationDate.day() + '日';
        return '見積有効期限は' + strExpirationDate + 'です';
    }
}