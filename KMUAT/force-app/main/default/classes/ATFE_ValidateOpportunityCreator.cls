public without sharing class ATFE_ValidateOpportunityCreator {

    private Id currentUserId = UserInfo.getUserId();
    public static final String INVALID_OPP_CREATOR_ERROR = 'Only the account owner and account team members with the appropriate access can create opportunities for accounts.';
    public boolean isIntegrationUser=false;
    
    public ATFE_ValidateOpportunityCreator(Opportunity[] pTriggerNew) {
        User currentUser = [select Profile.Name, Price_Book_Region__c from User where id = :userinfo.getUserId()];
        //check if the current user has the "NA" or "EMEA" price book region
        //Update: this check was moved to ATFE_Opportunity Objec Trigger
        //Boolean hasValidRegion = ATFE_Utility.validateUserPriceBookRegion(currentUser, new Set<String>{'NA', 'EMEA'});
        /* Check if the current logged in user is integraiton user **/
      for(string userId:label.IntegrationUsers.split(':'))
      {
          if(currentUserId==userId)
          {
              isIntegrationUser=true;
              break;
          }
              
      }
                
        if (currentUser.Profile.Name != 'System Administrator' && currentUser.Profile.Name != 'Service Ops') {
            Set<Id> acctIds = new Set<Id>();
            Opportunity[] opptiesWithAccounts = new Opportunity[]{}; 
             
            //loop through and check to see whether the inserted oppties have related accounts
            for (Opportunity newOpp : pTriggerNew) {
                if (newOpp.AccountId != null) {
                    //acctIdToOpp.put(newOpp.AccountId, newOpp);
                    opptiesWithAccounts.add(newOpp);
                    acctIds.add(newOpp.AccountId);
                }
            }
            
            if (opptiesWithAccounts.size() > 0) {
                queryForRelatedAccountsAndCompare(opptiesWithAccounts, acctIds);
            }
        }
    }
    
    public void queryForRelatedAccountsAndCompare(Opportunity[] pOpptiesWithAccounts, Set<Id> pAcctIds) {
        Opportunity[] oppsToCheckAcctShare = new Opportunity[]{};
        Set<Id> acctIdsToCheckAcctShare = new Set<Id>();
        
        Map<Id, Account> relatedAccounts = new Map<Id, Account>([SELECT Id, OwnerId FROM Account WHERE Id IN :pAcctIds]);
        
        //Loop through the new oppties and check if their account's owner is the same as the current user.  
        //If they are the owner then we allow them to create the oppty...
        for (Opportunity opp : pOpptiesWithAccounts) {
            if (this.currentUserId != relatedAccounts.get(opp.AccountId).OwnerId) {
                //...if not, add to collections to process further
                oppsToCheckAcctShare.add(opp);
                acctIdsToCheckAcctShare.add(opp.AccountId);
            }
        }
        
        if (oppsToCheckAcctShare.size() > 0) {
            queryForRelatedAccountShareRecordsAndCheckOppAccess(oppsToCheckAcctShare, acctIdsToCheckAcctShare);
        }
    }
    
    public void queryForRelatedAccountShareRecordsAndCheckOppAccess(Opportunity[] pOppsToCheckAcctShare, Set<Id> pAcctIdsToCheckAcctShare) {
        Opportunity[] opptiesToAddError = new Opportunity[]{}; 
        //query for the account share records for the related accounts of the new oppties for the current user
        AccountShare[] accountShareRecords = [SELECT AccountId, OpportunityAccessLevel 
                                              FROM AccountShare 
                                              WHERE AccountId IN :pAcctIdsToCheckAcctShare AND UserOrGroupId = :this.currentUserId];
        
        //loop through the new oppties to check if the current user has edit access to oppties for the related account...
        for (Opportunity opp : pOppsToCheckAcctShare) {
            Boolean currentUserHasOppEditAccess = false;
            for (AccountShare acctShare : accountShareRecords) {
                if (acctShare.AccountId == opp.AccountId) {
                    if (acctShare.OpportunityAccessLevel == 'Edit') {
                        currentUserHasOppEditAccess = true;
                    }
                }
            }
            //...if not, add the oppty to a list to add errors to
            if (!currentUserHasOppEditAccess && isIntegrationUser==false) {
                opptiesToAddError.add(opp);
            }
        }
        
        if (opptiesToAddError.size() > 0) {
            addErrorsToOpportunities(opptiesToAddError);
        }
    }
    
    public void addErrorsToOpportunities(Opportunity[] pOpptiesToAddError) {
        for (Opportunity opp : pOpptiesToAddError) {
            opp.addError(INVALID_OPP_CREATOR_ERROR);
        }
    }
    
    
}