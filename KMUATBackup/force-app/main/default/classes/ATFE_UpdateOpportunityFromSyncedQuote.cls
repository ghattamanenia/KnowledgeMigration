public without sharing class ATFE_UpdateOpportunityFromSyncedQuote {
  public ATFE_UpdateOpportunityFromSyncedQuote()
  {
      system.debug('@@@dump data');
  }

  /*
    public static final String QUOTE_UPDATE_ERROR = 'There was a problem updating the this Quote. Please review this message: ';
    public static final String OPP_UPDATE_ERROR = 'There was a problem updating the related Opportunity of this Quote. Please review this message: ';
    public static boolean byPassCode = false ;
    //constructor
    public ATFE_UpdateOpportunityFromSyncedQuote(Quote[] pTriggerOld, Quote[] pTriggerNew) {
        
        Map<Id, Quote> opptyIdToQuote = new Map<Id, Quote>();
        Map<Id, Quote> quoteIdToQuote = new Map<Id, Quote>();
        //loop through the updated quotes...
        for (Integer i=0; i<Trigger.New.size(); i++) {
            Quote quoteB4Update = pTriggerOld[i];
            Quote quoteAfterUpdate= pTriggerNew[i];
            Boolean newlyMarkedForSyncing = (quoteAfterUpdate.isSyncing == true && quoteB4Update.isSyncing == false);
            Boolean alreadySyncingAndSPQChanged = (quoteAfterUpdate.isSyncing == true && quoteB4Update.isSyncing == true 
                                                  && quoteAfterUpdate.ATFE_Approval_Status__c != quoteB4Update.ATFE_Approval_Status__c);
            //...if the updated quote has an opportunity, then check two additional conditions:
            //      1) if the quote has been marked for syncing, but wasn't syncing before... 
            //      2) or if the quote was already marked for syncing, and it's SPQ Approval Status has changed...
            //System.debug('newlyMarkedForSyncing : ' +newlyMarkedForSyncing);
            //System.debug('alreadySyncingAndSPQChanged : ' +alreadySyncingAndSPQChanged);
             
            if (quoteAfterUpdate.OpportunityId != null && (newlyMarkedForSyncing || alreadySyncingAndSPQChanged)) {
                System.debug('hit here');
                //...populate maps for processing further...
                opptyIdToQuote.put(quoteAfterUpdate.OpportunityId, quoteAfterUpdate);
                quoteIdToQuote.put(quoteAfterUpdate.Id, quoteAfterUpdate);
            }
        }
        //...if quotes were found to process further
        if (opptyIdToQuote.size() > 0) {
            queryAndUpdateOpportunities(opptyIdToQuote, quoteIdToQuote);
        }
    }
    
    public void queryAndUpdateOpportunities(Map<Id, Quote> pOpptyIdToQuote, Map<Id, Quote> pQuoteIdToQuote) {
        Opportunity[] opptiesToUpdate = new Opportunity[]{};  
        
        //select the oppties that need to be updated and update their SPQ fields
        for (Opportunity oppToUpdate : [SELECT EMEA_ApprovalRequired__c, ATFE_ApprovalStatus__c, ATFE_ApprovalDate__c  
                                        FROM Opportunity WHERE Id IN :pOpptyIdToQuote.keySet()]) {
                                            
            Quote syncedQuote = pOpptyIdToQuote.get(oppToUpdate.Id);
            //Update to opporunties SPQ fields with the synced quotes SPQ fields
            oppToUpdate.ATFE_ApprovalRequired__c = syncedQuote.ATFE_Approval_required__c;
            oppToUpdate.ATFE_ApprovalStatus__c = syncedQuote.ATFE_Approval_Status__c;
            oppToUpdate.ATFE_ApprovalDate__c = syncedQuote.ATFE_ApprovalDate__c;
            oppToUpdate.ATFE_SPQApproved__c = syncedQuote.ATFESPQ_Approved__c;
            
            opptiesToUpdate.add(oppToUpdate);
        }
        updateOpportunities(opptiesToUpdate, pOpptyIdToQuote, pQuoteIdToQuote);
    }
    
    public void updateOpportunities(Opportunity[] pOpptiesToUpdate, Map<Id, Quote> pOpptyIdToQuote, Map<Id, Quote> pQuoteIdToQuote) {
        
        try {
            
            Database.SaveResult[] oppSRs = Database.Update(pOpptiesToUpdate);
        } catch (Exception exs) {
            if (exs.getTypeName() == 'DmlException') {
                for (Integer i=0; i<exs.getNumDml(); i++) {
                    Id idWithError = exs.getDmlId(i);
                    //the error might have occured on the opportunity or the quote, check which map has the id in it, and add the error to the quote
                    if (pQuoteIdToQuote.containsKey(idWithError)) {
                        pQuoteIdToQuote.get(idWithError).addError(QUOTE_UPDATE_ERROR + exs.getDmlMessage(i));
                    } else if (pOpptyIdToQuote.containsKey(idWithError)) {
                        pOpptyIdToQuote.get(idWithError).addError(OPP_UPDATE_ERROR + exs.getDmlMessage(i));
                    }
                }
            }   
        }
    }

   */
    
}