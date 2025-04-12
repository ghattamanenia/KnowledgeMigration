trigger ATFE_SendChatterMessage on Account (after insert,after update) {
    //System.debug('Entering into Chatter Trigger :'+userInfo.getUserId());
    Set<Id> naSalesOpsUserIds = new Set<id>();
    Set<Id> emeaSalesOpsUserIds = new Set<id>();
    List<FeedItem> feedsToInsert = new List<FeedItem>();
    List<FeedItem> feedCommentList = new List<FeedItem>();
    User currentUser = [select Profile.Name, Price_Book_Region__c from User where id = :userinfo.getUserId()];
    //check that the current user has the "NA" or "EMEA" pricebook region
    Boolean hasValidRegion = ATFE_Utility.validateUserPriceBookRegion(currentUser, new Set<String>{'NA', 'EMEA'});
    
    if (hasValidRegion) {
        
           system.debug('Profile ID :::>' + UserInfo.getProfileId());
        if(trigger.isInsert && UserInfo.getProfileId() != '00eg0000000DjuDAAS' /*sarvinder - fix this hardcode*/){
             //Get Account record type info through DescribeSObjectResult
            Schema.DescribeSObjectResult accountDescribe = Schema.SObjectType.Account; 
            Map<String,Schema.RecordTypeInfo> acctRtMapByName = accountDescribe.getRecordTypeInfosByName();
            Id americasAccountsRtId =  acctRtMapByName.get('ATI Accounts').getRecordTypeId(); //returns the 18 digit id
                        
            for(GroupMember gm : [Select UserOrGroupId, GroupId, Group.DeveloperName From GroupMember where  Group.DeveloperName IN ('NA_Account_Ops', 'EMEA_Account_Ops')]){
                if (gm.Group.DeveloperName == 'NA_Account_Ops') {
                    naSalesOpsUserIds.add(gm.UserOrGroupId);
                } else if (gm.Group.DeveloperName == 'EMEA_Account_Ops') {
                    emeaSalesOpsUserIds.add(gm.UserOrGroupId);
                }
            }
            
            for(Account acc : trigger.new){
                if (acc.Region__c=='NA') {
                    for(Id  userId : naSalesOpsUserIds){
                        FeedItem post = new FeedItem();
                        post.ParentId = userId;
                        post.Body = 'A new account has been created. To view the account please click on the following link:';
                        post.LinkUrl = '/'+acc.id;
                        post.Title = acc.Name ;
                        system.debug('sarvinder debug post::: ' + post);
                        feedsToInsert.add(post);
                    }
                }
                
                if (acc.Region__c=='EMEA') {
                    for(Id userId : emeaSalesOpsUserIds){
                        FeedItem post = new FeedItem();
                        post.ParentId = userId;
                        post.Body = 'A new account has been created. To view the account please click on the following link:';
                        post.LinkUrl = '/'+acc.id;
                        post.Title = acc.Name ;
        
                        feedsToInsert.add(post);
                    }
                }
            }
            if(feedsToInsert != null && feedsToInsert.size() > 0)
                insert feedsToInsert ;
        }
    }    
}