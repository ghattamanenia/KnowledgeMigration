trigger ATFE_ChildOpportunityPriceBookCreation on Opportunity (after insert, after update) {
/*
    //User u = [select Profile.Name , Price_Book_Region__c from User where id = :userinfo.getUserId()];
    //if(u.Price_Book_Region__c=='NA' || u.Price_Book_Region__c=='EMEA' || u.Profile.Name == 'System Administrator'){ 
    //user Obj = [select id,Price_Book_Region__c ,Profile.Name from User where id =: userInfo.getUserID()];
    //String userRegion = Obj.Price_Book_Region__c ;
    //userRegion = userRegion.toLowerCase();
    //if( userRegion.contains('na') || userRegion.contains('emea') || Obj.Profile.Name == 'System Administrator'){
       
    User currentUser = [select Profile.Name, Price_Book_Region__c from User where id = :userinfo.getUserId()];
    //check if the current user has the "NA" or "EMEA" price book region
    Boolean hasValidRegion = ATFE_Utility.validateUserPriceBookRegion(currentUser, new Set<String>{'NA', 'EMEA'});
    
    if (hasValidRegion) {
        if(ATFE_utility.isFutureUpdate == null || ATFE_utility.isFutureUpdate == false){
            if(Trigger.isUpdate){
                try{
                    ID masterOppID = Trigger.old.get(0).Id;
                    Opportunity parentOpp =  [select Pricebook2Id, Name, Pricebook2.Id from opportunity where id = :masterOppID];
                    system.debug('parentOpp.Pricebook2Id: ' + parentOpp.Pricebook2Id);
                    if (parentOpp.Pricebook2Id != null ){
                        
                        //get a total amount of the child opportunities and assign it to the Child Total Amount field on the master opp
                        RecordType rt = [select DeveloperName from RecordType where id = :Trigger.new[0].RecordTypeId];
                        system.debug('recordType: ' + Trigger.new[0].RecordTypeId);
                        system.debug('recordTypeName: ' + rt.DeveloperName);
                        
                        if (rt.DeveloperName == 'Child_Opportunity' && Trigger.new[0].Amount != Trigger.old[0].Amount){
                            
                            //Update the Master with the sum of the Related Children's Amount field
                            decimal totalAmount = 0;
                            Opportunity masterOpp =  [select Id from opportunity where id =: Trigger.new[0].ATFE_RelatedOpportunity__c];
                            //system.debug('masterOpp.Id: ' + masterOpp.Id);
                            List<Opportunity> objMasterOpp = [select Id, Amount from Opportunity where ATFE_RelatedOpportunity__c = :masterOpp.Id];
                            for (Opportunity childOpp: objMasterOpp ) {
                                if (childOpp.Amount == null){
                                    totalAmount += 0;
                                }
                                else {
                                    totalAmount += childOpp.Amount;
                                }
                            }
                            masterOpp.ATFE_ChildTotalAmount__c = totalAmount;
                            update masterOpp;
                        }
                        
                        //Create the child pricebook for the first time
                        if (Trigger.new[0].ATFE_MasterOpportunity__c && !Trigger.old[0].ATFE_MasterOpportunity__c){  
                            ATFE_utility.isFutureUpdate = true;
                            String newPriceBookName = 'MasterOppPriceBook' + masterOppID;                   
                            ID masterPricebookID = parentOpp.Pricebook2.Id;
                            try 
                            {
                                system.debug('start class');
                                ATFE_ClonePriceBook.ClonePriceBook(parentOpp.Pricebook2.Id, newPriceBookName, masterOppID);
                                system.debug('stop class');
                                
                                if(Trigger.new[0].Amount != Trigger.old[0].Amount){  
                                    //get a total amount of the child opportunities and assign it to the Child Total Amount field on the master opp
                                    decimal totalAmount = 0;
                                    system.debug('parentOpp.Id: ' + parentOpp.Id);
                                    List<Opportunity> objParentOpp = [select Id, Amount from Opportunity where ATFE_RelatedOpportunity__c = :parentOpp.Id];
                                    for (Opportunity childOpp: objParentOpp ) {
                                        if (childOpp.Amount == null){
                                            totalAmount += 0;
                                        }
                                        else {
                                            totalAmount += childOpp.Amount;
                                        }
                                    }
                                    parentOpp.ATFE_ChildTotalAmount__c = totalAmount;
                                    system.debug('totalAmount: ' + String.valueOf(totalAmount));
                                    parentOpp.ForecastCategoryName='Omitted';
                                    update parentOpp;
                                }
                            }
                            catch (Exception e){
                                system.debug('exception found in ChildOpportunityPriceBookCreation: ' + e);                 
                            }       
                                
                        }
                        else {
                            system.debug('trigger else');
                            PageReference pr = new PageReference('/a0G/o');
                            pr.setRedirect(true);
                        }
                    }
                }
                catch (Exception e){
                    system.debug('exception found in ChildOpportunityPriceBookCreation2: ' + e);        
                }
            }
            
            if(Trigger.isInsert){
                //update the child opp with the parent's defined child opp pricebook
                //only used when a new child is created
                
                RecordType rt = [select DeveloperName from RecordType where id = :Trigger.new[0].RecordTypeId];
                system.debug('recordType: ' + Trigger.new[0].RecordTypeId);
                system.debug('recordTypeName: ' + rt.DeveloperName);
                
                
                //assigning the pricebook from master to the child opportunity
                if (rt.DeveloperName == 'ATI_Opportunity' || rt.DeveloperName == 'EMEA_Opportunity' || rt.DeveloperName == 'Child_Opportunity'){ 
                    Opportunity childOpp = [SELECT Id FROM Opportunity where id =: Trigger.new[0].id];
                    childOpp.Pricebook2Id = Trigger.new[0].ATFE_ChildOpportunityPricebook__c;
                  // update childOpp;
                }   
                
                for(Opportunity o: trigger.new){
                    system.debug(o);                
                }
            }
        }
    }  */
}