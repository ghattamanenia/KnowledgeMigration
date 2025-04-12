public class ATFE_ClonePriceBook {

    public static void ClonePriceBook(ID masterPricebookId, String newPriceBookName, ID masterOppID){
        try{
          //   User u = [select Profile.Name from User where id = :userinfo.getUserId()];

         //    if(u.Profile.Name.startsWith('NA') || u.Profile.Name.startsWith('EMEA') || u.Profile.Name == 'System Administrator'){ 
    
        
            system.debug('Start ClonePriceBook');
      system.debug('PriceBookIds' + masterPricebookId +':::::::::' +   newPriceBookName +'::::::::::::'+ masterOppID);
      boolean creatingNewPriceBook = false;
      list<Pricebook2> newPriceBook = [select id,Name from Pricebook2 where Name = :newPriceBookName ];
      Set<Id> pbidSet = new Set<Id>();
      //for(Pricebook2 objpb: newPriceBook ){
      //     pbidSet.add(objpb.id);                    
      // }
      system.debug('newPriceBook ' + newPriceBook );
      boolean newPriceBookBoolean = newPriceBook.size() > 0;
      boolean newPriceBookEntryBoolean = false;
      if (newPriceBookBoolean == true) {
        if ([select count() from Pricebookentry where Pricebook2Id in :pbidSet Limit 1] >0) {
          newPriceBookEntryBoolean = true;
        }
      }
       
            system.debug('newPriceBookBoolean ' + newPriceBookBoolean +':::::::::' +   newPriceBookEntryBoolean +'::::::::::::'+ [select count() from Pricebookentry where Pricebook2Id in :pbidSet] );
            //if child pricebook already exists, then just get its id       
            if (newPriceBookBoolean && newPriceBookEntryBoolean){ 
                system.debug('found new pricebook');

                Pricebook2 newpbook = [select Id, Name from PriceBook2 where Name =:newPriceBookName Limit 1];
                system.debug('newpricebook: ' + newPriceBookName);
                
                Map<Id, OpportunityLineItem> oppli = new Map<Id, OpportunityLineItem>([Select o.UnitPrice, PricebookEntry.Product2id, o.PricebookEntryId, o.Id From OpportunityLineItem o where OpportunityId = :masterOppID]);
                system.debug('Oppertunity: ' + oppli );
                Set<Id> idSet = new Set<Id>();
                Map<String, Double> prodMap = new Map<String, Double>();
                
                for(OpportunityLineItem oli : oppli.values()){
                    idSet.add(oli.PricebookEntry.Product2id);
                    prodMap.put(oli.PricebookEntry.Product2Id, oli.unitPrice);
                }
                
                
                List<PricebookEntry> pbeList = [select Name, Product2Id from PricebookEntry where Pricebook2Id = :newpbook.Id and Product2Id in :idSet];
                for(PricebookEntry p : pbeList)
                    p.UnitPrice = prodMap.get(p.Product2Id);
                update pbeList;
            }
            //if not then create the new child pricebook

            else {
              creatingNewPriceBook = true;
                
                system.debug('newPriceBookName: ' + newPriceBookName);
                
                    
                


                Opportunity parentOpp =  [select Pricebook2Id, Name, Pricebook2.Id from opportunity where id = :masterOppID];
                
                Pricebook2 oldpbook = [select id, Name, IsStandard, IsActive, Description from Pricebook2 where id=: masterPricebookId];

                Pricebook2 newpbook = oldpbook.clone(false, true);
                newpbook.Name = newPriceBookName;
                system.debug('OLDPriceBook: ' + oldpbook + 'NewPriceBook' + newpbook  );
                insert newpbook;
                system.debug('newPriceBookName: ' + newPriceBookName);

                parentOpp.ATFE_ChildOpportunityPricebook__c = newpbook.Id;
                update parentOpp;
                
                Map<Id, OpportunityLineItem> oppli = new Map<Id, OpportunityLineItem>([Select o.UnitPrice, PricebookEntry.Product2id, o.PricebookEntryId, o.Id From OpportunityLineItem o where OpportunityId = :masterOppID]);
                system.debug('Oppertunity: ' + oppli );
                Set<Id> idSet = new Set<Id>();
                Map<String, Double> prodMap = new Map<String, Double>();
                List<PricebookEntry> objPriceBookList= new List<PricebookEntry>();
                for(OpportunityLineItem oli : oppli.values()){
                    PricebookEntry p = new PricebookEntry();
                    p.UnitPrice = oli.unitPrice;
                    p.Pricebook2Id = newpbook.Id;
                    p.Product2Id = oli.PricebookEntry.Product2id;
                    p.IsActive = true;
                    objPriceBookList.add(p); 
                    /*idSet.add(oli.PricebookEntry.Product2id);
                    prodMap.put(oli.PricebookEntry.Product2Id, oli.unitPrice);*/
                }
                system.debug('TempPricebookEntry: ' + objPriceBookList);
                insert objPriceBookList;                
                /*PricebookEntry[] oldpbookentry = [Select UseStandardPrice, UnitPrice, ProductCode, Product2Id, Pricebook2Id, Name, IsActive From PricebookEntry where IsActive = true and Pricebook2Id = : masterPricebookId];
                
                PricebookEntry[] newpbookentry = oldpbookentry.deepClone(false);
                List<PricebookEntry> lstobjPriceBookEntry = new List<PricebookEntry>();
                system.debug('oldpbookentry : ' + oldpbookentry + 'newpbookentry : ' + newpbookentry );
                for (PricebookEntry x : newpbookentry)
                {
                   x.Pricebook2Id = newpbook.Id;
                   
                   lstobjPriceBookEntry.add(x);  

                } */
                  // system.debug('newpbookentry: ' + oldpbookentry[3948]);
                  //system.debug('newpbookentry--->'+oldpbookentry[3753]);
                  //system.debug('Product2.IsActive--->'+oldpbookentry[3753].Product2.IsActive);
                      //insert lstobjPriceBookEntry;
                //system.debug('newpbookentry: ' + newpbookentry);
              }
              system.debug('creatingNewPriceBook: ' + creatingNewPriceBook);
         //   }
        }
        catch(Exception e){
            system.debug('exception found in NA_ClonePriceBook2: ' + e);    

        }
   }
    

}