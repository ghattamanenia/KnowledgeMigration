public /*with sharing*/ class CustomerCommunityCaseDetailController {
    public String caseID {get;set;}
    public String showrelatedcases {get;set;}
    public String showproductinfo {get;set;}
    public String caseImpact{get;set;}
    public String caseUrgency{get;set;}

    public Case caseDetail {get;set;}
    public List<Case_Comment__c> caseComments {get;set;}
    public List<case> relatedcases {get;set;}
    public List<Attachment> caseAttachments {get;set;}
    //public List<CaseArticle> caseArticles {get;set;}
   // public List<Question_Answer__kav> relatedArticles {get;set;}
    public List<SelectOption> allSelectOptions {get; set;}
     
    public boolean showpage {get;set;}
    // Code we will invoke on page load.
    public PageReference forwardToCustomAuthPage() {

        if((UserInfo.getUserType() == 'Guest') || (Test.IsRunningTest() && UserInfo.getUserType() == 'Standard')){
            return new PageReference('/CustomerCommunityHome');
        }
        else{
            return null;
        }
    }

    public PageReference EditCase() {
        return new PageReference('/CustomerCommunityCaseEdit?caseid=' + caseID);
    }

    public PageReference BackPage() {
        return new PageReference('/CustomerCommunityLoggedIn');
    }

    public CustomerCommunityCaseDetailController() {    
        try {
            showpage = true;
             //Get Case record type info through DescribeSObjectResult - this is better as no SOQL is used.
                Schema.DescribeSObjectResult caseDescribe = Schema.SObjectType.Case; 
                Map<String,Schema.RecordTypeInfo> caseRtMapByName = caseDescribe.getRecordTypeInfosByName();
                Id  ATI_RMAParentCaseID = caseRtMapByName.get('ATI RMA Parent Case').getRecordTypeId();
                Id  ATI_RMAChildCaseID = caseRtMapByName.get('ATI RMA Child Case').getRecordTypeId();
                
            caseID = ApexPages.currentPage().getParameters().get('caseid');

            caseDetail = [SELECT Id, CreatedDate,RecordTypeId ,Accountid ,CaseNumber, Request_Title__c, HW_Asset_Name__r.Name, H_W_Serial_Number__c, 
                            Description, Urgency__c, Impact__c, Status, New_or_Existing_Installation__c, Is_it_reproducible__c, 
                            What_are_the_steps_to_reproduce_it__c, If_existing_were_there_recent_changes__c, 
                            specific_circumstances__c, Is_your_network_down__c, Is_there_a_workaround_in_place__c, 
                            Have_services_degraded__c,  warranty__c ,priority, ATFE_status_comments__c, case_opened_date__c, 
                            first_response__c, closeddate, caseResolution__c,Entitlement.Name, RMA_Number__c, RMA_Status__c,Billing_Address_Company_Name__c,Billing_Street__c,Billing_City__c,Billing_State__c,Billing_Country1__c,Billing_Zip_Code__c,VAT_Number__c,Is_billing_address_different__c,Shipping_Address_Company_Name__c,Shipping_Street__c,Shipping_City__c,Shipping_State__c,Shipping_Country__c,Shipping_Zip_Code__c,Name__c,Phone_Number__c FROM Case where id = :caseID];
                            
            /* Since we are using html, we need this in order to populate the value on the page */
            /*if(caseDetail.Impact__c == 'High') {
                impact = 'High';
            }  
            else if(caseDetail.Impact__c == 'Medium') {
                impact = 'Medium';
            }
            else if(caseDetail.Impact__c == 'Low') {
                impact = 'Low';
            }
            if(caseDetail.Urgency__c == 'High') {
                urgency = 'High';
            }  
            else if(caseDetail.Urgency__c == 'Medium') {
                urgency = 'Medium';
            }
            else if(caseDetail.Urgency__c == 'Low') {
                urgency = 'Low';
            }*/

            caseImpact = caseDetail.Impact__c;
            caseUrgency = caseDetail.Urgency__c;

            User usr = [Select Id, ContactId,Accountid from User where Id =: UserInfo.getUserId()];
            
            if(caseDetail.Accountid != usr.Accountid)
            {
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'<div class="errorMsgMargin">Unfortunately, there was an issue with your request.</div> If the issue continues, please contact Allied Telesis Technical Support.'));
                 showpage = false;
                 return ;
            }
            
            if(caseDetail.RecordTypeId == ATI_RMAParentCaseID )
            {
                showrelatedcases = 'table';
                showproductinfo = 'none';
            }
            else
            {
                showrelatedcases = 'none';
                 showproductinfo = 'table';
            }
            
            caseComments = [SELECT Id, Case_Contact_Email__c, CreatedBy.Name, Case_Ref__c, Case__c, Comment_Type__c, Comment__c, 
                            CreatedById, CreatedDate, IsDeleted, LastModifiedById, LastModifiedDate, 
                            Name, OwnerId, Rel_Email__c 
                            FROM Case_Comment__c where Case__c = :caseID and Public__c = true order by CreatedDate desc];
                 
            relatedcases = [Select Id,RecordTypeId,RMA_Number__c,RMA_Tracking_Number__c,H_W_Serial_Number__c,Hw_Asset_Name__r.Name from case where parentid = :caseID and RecordTypeId = :ATI_RMAChildCaseID ];

            System.debug('$$$ relate caseDetail: '+ caseDetail);
            
            caseAttachments = [SELECT BodyLength, ContentType, CreatedById, CreatedBy.Name, CreatedDate,Description, Id,
                                IsDeleted, IsPrivate, LastModifiedById, LastModifiedDate, Name, OwnerId, ParentId
                                FROM Attachment where ParentId = :caseID and IsDeleted = false and IsPrivate = false];

            
            Set<ID> knowledgeArticleIds = new Set<ID>();
            List<CaseArticle> caseArticles = [select Id, CaseId, KnowledgeArticleId from CaseArticle where CaseId =:caseID];
            
            for(CaseArticle CA : caseArticles)
            {
                knowledgeArticleIds.add(CA.KnowledgeArticleId);
                
            }
            
            // relatedArticles = [SELECT Id, KnowledgeArticleId, Title, UrlName, Summary, ArticleNumber, Question__c, Answers__c FROM Question_Answer__kav WHERE PublishStatus='Online' AND KnowledgeArticleId IN :knowledgeArticleIds];
        
            // get the describe field result for the user timezone field
            /*Schema.DescribeFieldResult userCountryDescribe = Schema.sObjectType.Account.fields.BillingCountryCode;
            // get the list of picklist entries for the timezone field
            List<Schema.PicklistEntry> allPicklistEntries = userCountryDescribe.getPicklistValues();

            // loop through the picklist entries and debug each value and label
            for(Schema.PicklistEntry entry : allPicklistEntries) {
                String pickValue = entry.getValue(); 
                String pickLabel = entry.getLabel();

                SelectOption option = new SelectOption(pickValue, pickLabel);
                allSelectOptions.add(option);
            }
            System.debug(allPicklistEntries);*/
        }
        catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
    }
}