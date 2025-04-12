trigger ATFE_SendChatterCaseMessage on Case (after insert,after update) {
    //System.debug('Entering into Chatter Trigger :'+userInfo.getUserId());
    Set<Id> naSalesOpsUserIds = new Set<id>();
    Set<Id> emeaSalesOpsUserIds = new Set<id>();
    List<FeedItem> feedsToInsert = new List<FeedItem>();
    Set<Id> ownershipRequestCaseIds = new Set<Id>();
    if(trigger.isInsert){
        User currentUser = [select Profile.Name, Price_Book_Region__c from User where id = :userinfo.getUserId()];
        //check if the current user has the "NA" or "EMEA" price book region
        Boolean hasValidRegion = ATFE_Utility.validateUserPriceBookRegion(currentUser, new Set<String>{'NA', 'EMEA'});
        
        if (hasValidRegion) {
            for(GroupMember gm : [Select UserOrGroupId, GroupId, Group.DeveloperName From GroupMember where  Group.DeveloperName IN ('NA_Account_Ops', 'EMEA_Account_Ops')]){
                if (gm.Group.DeveloperName == 'NA_Account_Ops') {
                    naSalesOpsUserIds.add(gm.UserOrGroupId);
                } else if (gm.Group.DeveloperName == 'EMEA_Account_Ops') {
                    emeaSalesOpsUserIds.add(gm.UserOrGroupId);
                }
            }
            for(Case cas : trigger.new){
                if (cas.Reason == 'Account Ownership Request') {
                    System.debug('$$$ Account Ownership Request found');
                    ownershipRequestCaseIds.add(cas.Id);
                }
            }
            
            if (ownershipRequestCaseIds.size() > 0) {
                for (Case cas : [SELECT Id, CaseNumber, Account.Region__c FROM Case WHERE Id IN :ownershipRequestCaseIds]) {
                    System.debug('$$$ inside case loop');
                    System.debug('cas.Account.Region__c: ' + cas.Account.Region__c);
                    if (cas.Account.Region__c=='NA') {
                        System.debug('$$$ NA Account Region found');
                        for(Id userId : naSalesOpsUserIds){
                            FeedItem post = new FeedItem();
                            post.ParentId = userId;
                            post.Body = 'An account ownership request case has been created. Please click on the following link.';
                            post.LinkUrl = '/'+cas.id;
                            post.Title = cas.CaseNumber ;
                            feedsToInsert.add(post);
                        }
                    }
                    if (cas.Account.Region__c=='EMEA') {
                        for(Id userId : emeaSalesOpsUserIds){
                            FeedItem post = new FeedItem();
                            post.ParentId = userId;
                            post.Body = 'An account ownership request case has been created. Please click on the following link.';
                            post.LinkUrl = '/'+cas.id;
                            post.Title = cas.CaseNumber ;
                            feedsToInsert.add(post);
                        }
                    }
                }
            }
            if (feedsToInsert.size() > 0) {
                insert feedsToInsert;
            }
        }
    }
}