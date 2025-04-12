public without sharing class JP_CopyOpportunityForLightning {
    @AuraEnabled
    public static String doCopyRec(Id recordId,Boolean isChkOLI, Boolean isChkP, Boolean isChkOCR, Boolean isChkOT,Boolean isChkPN, Boolean isChkPT) {//20250212 semba update
        system.debug('===doCopy start');
        system.debug('====recordId : ' + recordId);
        system.debug('====isChkOLI : ' + isChkOLI);
        system.debug('====isChkP : ' + isChkP);
        system.debug('====isChkOCR : ' + isChkOCR);
        system.debug('====isChkOT: ' + isChkOT);
        system.debug('====isChkPN: ' + isChkPN); //20241204 semba add
        system.debug('====isChkPT: ' + isChkPT); //20250212 semba add
        //system.debug('====isChkSN: ' + isChkSN); //20241204 semba update
        //system.debug('====isChkJR: ' + isChkJR); //20241204 semba update
        Opportunity originOpp = OpportunityDAO.getRecById(recordId);
        Opportunity newOpp = originOpp.clone(false,true);
        
//20241204 semba add start
        //プロジェクト
        if(isChkPN==False){
            newopp.JP_Project__c = null; 
        }else{
            system.debug('===6:プロジェクト===');
        }
//20241204 semba add end

//20250212 semba add start
		//商流
		if(isChkPT==False){
            newopp.JP_Partner1__c = null;
            newopp.JP_Partner2__c = null;
            newopp.JP_Partner3__c = null;
            newopp.JP_Partner4__c = null;
            newopp.JP_Partner5__c = null;
        }else{
            system.debug('===7:商流===');
        }
//20250212 semba add end 

//20241204 semba add start
		Date targetDate = Date.today();//今日の日付
		Date startDate = targetDate.toStartOfMonth();//当月月初
        Date After2MonthDate = startDate.addMonths(2);//翌々月の月初
        Date NextLastDate = After2MonthDate.addDays(-1);//翌月の月末
        system.debug('NextLastDate: ' + NextLastDate);
//20241204 semba add end

//20210126 ALLIEDTELESIS-453 terrasky add start
        Boolean isWordSet = false;
        
    List<OpportunityLineItem> orgOppLineItemList = OpportunityLineItemDAO.getOppLineItem(recordId);
//20241204 semba add start
        newOpp.StageName = JP_Const.STAGENAME_PROSPECTQUALIFICATION;
        newOpp.Probability = JP_Const.PROBABILITY_20;
        newOpp.ForecastCategoryName = JP_Const.FORECAST_CATEGORY_PIPELINE;
        newOpp.JP_DirectTouchDegree__c = '不明：今後どのようにE/Uと関わっていくか不明';
        newOpp.JP_DirectRank__c = JP_Const.JP_DIRECT_RANK_D;
        If(originOpp.CloseDate < targetDate){
            newOpp.CloseDate = NextLastDate;
        }
//20241204 semba add end
//20241204 semba update strat
//20241029 ALLIEDTELESIS-510 terrasky mod start
    //if(orgOppLineItemList.size() == 0 || !isChkOLI){
        //if(orgOppLineItemList.size() == 0 || !isChkOLI || (orgOppLineItemList.size() > 0 && originOpp.JP_CopyableClosedOpportunity__c)){
//20241029 ALLIEDTELESIS-510 terrasky mod end
//20211223 ALLIEDTELESIS-481 terrasky mod start
            //if(originOpp.JP_DirectRank__c == JP_Const.JP_DIRECT_RANK_A || originOpp.JP_DirectRank__c == JP_Const.JP_DIRECT_RANK_B){
            //if(checkDirectRank(originOpp.JP_DirectRank__c)){
//20211223 ALLIEDTELESIS-481 terrasky mod end
                //newOpp.JP_DirectRank__c = JP_Const.JP_DIRECT_RANK_D;
            //}
//20211223 ALLIEDTELESIS-481 terrasky mod start
            //if(originOpp.StageName == JP_Const.STAGENAME_BOOKINGFORECAST || originOpp.StageName == JP_Const.STAGENAME_CLOSEDWON){
            //if(checkStageName(originOpp.StageName)){
//20211223 ALLIEDTELESIS-481 terrasky mod end
                //newOpp.StageName = JP_Const.STAGENAME_PROSPECTQUALIFICATION;
                //newOpp.Probability = JP_Const.PROBABILITY_20;
                //newOpp.ForecastCategoryName = JP_Const.FORECAST_CATEGORY_PIPELINE;
                //newOpp.JP_DirectTouchDegree__c = null;
            //}
        //} else {
//20241204 semba update end
            if (String.isBlank(newOpp.JP_ReasonNoOppLineItem__c)) {
                // 入力規則に該当しないよう、登録用に文言設定
                isWordSet = true;
                newOpp.JP_ReasonNoOppLineItem__c = JP_Const.REASON_NO_OPP_LINE_ITEM_COPY;
            }
//20241204 semba update start
            //フェーズ＆ランクのチェックの分岐
            //if(isChkSN == True){
                //newOpp.StageName = originOpp.StageName;
                //newOpp.JP_DirectRank__c = originOpp.JP_DirectRank__c;
            //}else{
                //newOpp.StageName = JP_Const.STAGENAME_PROSPECTQUALIFICATION;
                //newOpp.Probability = JP_Const.PROBABILITY_20;
                //newOpp.ForecastCategoryName = JP_Const.FORECAST_CATEGORY_PIPELINE;
                //newOpp.JP_DirectTouchDegree__c = null;
                //newOpp.JP_DirectRank__c = JP_Const.JP_DIRECT_RANK_D;
            //}
        //}
//20241204 semba update end  
        //}
//20210126 ALLIEDTELESIS-453 terrasky add end
        try{
            insert newOpp;
        }catch(Exception ex){
            throw ex;
        }

        system.debug('===newopp.id = ' + newOpp.Id);

        //商談商品
        if(isChkOLI){
            system.debug('===1:商談商品===');
            List<OpportunityLineItem> newopl = new List<OpportunityLineItem>();

//20201222 ALLIEDTELESIS-453 terrasky mod start  (originsからorgOppLineItemListに使用変数を修正)
            //List<OpportunityLineItem> origins = OpportunityLineItemDAO.getOppLineItem(recordId); 
            if(orgOppLineItemList.size() > 0){
                for(OpportunityLineItem oli : orgOppLineItemList){
//20201222 ALLIEDTELESIS-453 terrasky mod end
                    OpportunityLineItem newoli = oli.clone(false,true);
                    newoli.OpportunityId = newOpp.Id;
                    newopl.add(newoli);
                }

                insert newopl;
            }

//20210126 ALLIEDTELESIS-453 terrasky add start
            if (isWordSet) {
              // 登録用に設定した文言を空に更新
                newOpp.JP_ReasonNoOppLineItem__c = '';
              update newOpp;
            }
        }
//20210126 ALLIEDTELESIS-453 terrasky add end

        //パートナー
        if(isChkP){
            system.debug('===2:パートナー===');
            List<Partner> newpartner = new List<Partner>();
            
            List<Partner> origins = [select AccountToId,IsPrimary,ReversePartnerId,Role from Partner where OpportunityId =:recordId];
            if(origins.size() > 0){
                for(Partner p : origins){
                    if (p.accountToId != newOpp.accountId) {
                        Partner newp = p.clone(false,true);
                        newp.OpportunityId = newOpp.Id;
                        newpartner.add(newp);
                    }
                }

                insert newpartner;
            }
        }

        //取引先責任者（顧客）の役割
        if(isChkOCR){
            system.debug('===3:顧客の役割===');
            List<OpportunityContactRole> newocrs = new List<OpportunityContactRole>();

            List<OpportunityContactRole> origins = [select ContactId,CurrencyIsoCode,IsPrimary,Role from OpportunityContactRole where OpportunityId = :recordId];

            if(origins.size() > 0){
                for(OpportunityContactRole ocr : origins){
                    OpportunityContactRole newocr = ocr.clone(false,true);
                    newocr.OpportunityId = newOpp.Id;
                    newocrs.add(newocr);
                }

                insert newocrs;
            }
        }

        //商談チーム
        if(isChkOT){
            system.debug('===4:商談チーム===');
            List<OpportunityShare> newoses = new List<OpportunityShare>();
            List<OpportunityTeamMember> newotms = new List<OpportunityTeamMember>();

            List<OpportunityShare> originos = [select OpportunityAccessLevel,UserOrGroupId,RowCause from OpportunityShare where OpportunityId = :recordId and RowCause = 'Team'];
            List<OpportunityTeamMember> originotms = [select CurrencyIsoCode,Name,OpportunityAccessLevel,PhotoURL,TeamMemberRole,Title,UserId from OpportunityTeamMember where OpportunityId = :recordId];

            if(originotms.size() > 0){
                for(OpportunityTeamMember otm : originotms){
                    OpportunityTeamMember newotm = otm.clone(false,true);
                    newotm.OpportunityId = newOpp.Id;
                    if(otm.OpportunityAccessLevel == 'All' && otm.UserId != userInfo.getUserId()){
                        newotm.OpportunityAccessLevel = 'Edit';
                    }
                    newotms.add(newotm);
                }

                insert newotms;
            }
        }

        return newOpp.Id;
    }
//20241204 semba update start
//20211223 ALLIEDTELESIS-481 terrasky add start
    //private static Boolean checkDirectRank(String directRank){
        //List<String>rankList = System.Label.JP_HighDirectRank.split(',');
        //return rankList.contains(directRank);
    //}

    //private static Boolean checkStageName(String stageName){
        //List<String>stageList = System.Label.JP_HighStageName.split(',');
        //return stageList.contains(stageName);
    //}
//20211223 ALLIEDTELESIS-481 terrasky add end
//20241204 semba update end
}