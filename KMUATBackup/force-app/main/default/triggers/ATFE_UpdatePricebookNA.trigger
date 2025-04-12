trigger ATFE_UpdatePricebookNA on Quote (before insert) {
    
    User u = [select Profile.Name, Price_Book_Region__c from User where id = :userinfo.getUserId()];
    Set<Id> includeRts = new Set<Id>();
    Set<String> oppRts = new Set<String>{'EMEA Opportunity','Editable Amount','ATI Opportunity'};
    Set<Id> oppIds = new Set<Id>();
    List<Quote> lstQuote = trigger.new;
    set<Id> setAccountId = new set<Id>();
    set<Id> setQuoteId = new set<Id>();
    Set<String> setPriceBookName = new Set<String>();
    Map<String, Id> mapPriceBookIdByString = new Map<String, Id>();
    Map<Id,Account> MapAccountById = new Map<Id,Account>();
    
    //check that the current user has the "NA" or "EMEA" pricebook region
    Boolean hasValidRegion = ATFE_Utility.validateUserPriceBookRegion(u, new Set<String>{'NA', 'EMEA'});
    
    if(!ATFE_QuoteCloneWithProducts.byPassQuoteTrigger){
        //if(u.Profile.Name.startsWith('NA') || u.Profile.Name.startsWith('EMEA') || u.Profile.Name == 'System Administrator'){
        if (hasValidRegion) {
            //System.debug('Has valid region');
            for(RecordType rt : [select id from RecordType where SObjectType ='Opportunity' and name in :oppRts ]){
                includeRts.add(rt.id);
            }
            //System.debug('includeRts:'+includeRts);
            for(Quote objQut : trigger.new){
                oppIds.add(objQut.OpportunityId);
            }
             
            Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>([select id ,RecordTypeId,PriceBook2Id from Opportunity where id in :oppIds]); 
            for(Quote objQut : lstQuote){
                if(objQut.ATFE_Partner_Name__c != null && oppMap.containsKey(objQut.OpportunityId) && includeRts.contains(oppMap.get(objQut.OpportunityId).RecordTypeId) ) {
                    //System.debug('Has Quote To Name and Valid record type');
                    setAccountId.add(objQut.ATFE_Partner_Name__c);
                    setAccountId.add(objQut.ATFE_Account_ID__c);
                    setQuoteId.add(objQut.Id);       
                }
            }
            //System.debug('setAccountId:'+setAccountId);
            if(setAccountId != null && setAccountId.size() > 0){
                MapAccountById = new Map<Id,Account>([select Id,Name,ATFE_Price_Book__c From Account Where Id in :setAccountId]);
                for(Account account : MapAccountById.values()){
                    setPriceBookName.add(account.ATFE_Price_Book__c);
                }
                    
                for(Pricebook2 objPriceBook : [Select Name, IsActive, Id From Pricebook2 where isActive = true AND Name in :setPriceBookName]){
                    mapPriceBookIdByString.put(objPriceBook.Name, objPriceBook.Id);
                }
            }
            
            /*  
            List<QuoteLineItem> lstQuoLineItem = [Select o.QuoteId, o.Id From QuoteLineItem o where o.QuoteId in :setQuoteId];
            setQuoteId.clear();
            if(lstQuoLineItem != null && lstQuoLineItem.size()>0)
            {
                for(QuoteLineItem objQuoLineItem : lstQuoLineItem)
                {
                    setQuoteId.add(objQuoLineItem.QuoteId);   
                }
            }
            String strPriceBook;
            Account objAccount = new Account();
            */
            for(Quote objQut : lstQuote){
                if(setQuoteId != null && setQuoteId.contains(objQut.id)){
                        
                    if(objQut.ATFE_Partner_Name__c != null && MapAccountById.containsKey(objQut.ATFE_Partner_Name__c)){
                        Account objAccount = MapAccountById.get(objQut.ATFE_Partner_Name__c);
                        if(mapPriceBookIdByString.containsKey(objAccount.ATFE_Price_Book__c) && mapPriceBookIdByString.get(objAccount.ATFE_Price_Book__c) != null)
                            objQut.Pricebook2Id = mapPriceBookIdByString.get(objAccount.ATFE_Price_Book__c);
                            //System.debug('mapPriceBookIdByString.get(objAccount.ATFE_Price_Book__c): ' + mapPriceBookIdByString.get(objAccount.ATFE_Price_Book__c));
                    
                    } else if(objQut.ATFE_Account_ID__c != null && MapAccountById.containsKey(objQut.ATFE_Account_ID__c)){
                        Account objAccount = MapAccountById.get(objQut.ATFE_Account_ID__c);
                        if(mapPriceBookIdByString.containsKey(objAccount.ATFE_Price_Book__c) &&  mapPriceBookIdByString.get(objAccount.ATFE_Price_Book__c) != null) 
                            objQut.Pricebook2Id = mapPriceBookIdByString.get(objAccount.ATFE_Price_Book__c); 
                            //System.debug('mapPriceBookIdByString.get(objAccount.ATFE_Price_Book__c): ' + mapPriceBookIdByString.get(objAccount.ATFE_Price_Book__c));
                    }    
                            
                        
                } else if(OppMap.containsKey(objQut.OpportunityId) && OppMap.get(objQut.OpportunityId) != null){
                    //For Children
                    objQut.Pricebook2Id = OppMap.get(objQut.OpportunityId).PriceBook2Id;
                }
            }//End For
        }
    }//By Pass Trigger Code
}