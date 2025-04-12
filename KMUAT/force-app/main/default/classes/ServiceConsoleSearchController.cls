public with sharing class ServiceConsoleSearchController {
    public String keyword{get;set;}

    public List<Account> acct{get;set;}
    public List<Contact> contact{get;set;}
    public List<Asset__c> hwasset{get;set;}
    public List<Service_Asset__c> sasset{get;set;}
    public List<Case> cases{get;set;}

    public String acctCount{get;set;}
    public String contactCount{get;set;}
    public String hwassetCount{get;set;}
    public String sassetCount{get;set;}
    public String casesCount{get;set;}

    public ServiceConsoleSearchController() {}

    public void search() {

        String myKeyword = '%' + keyword.trim() + '%';
        String acctID = '';

        // Throw an error if the search criteria is blank
        if(String.isBlank(keyword)) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Please enter your query in the search field.'));
            return;
        }

        try {

            // Check the returned records size for each object, and throw an error if any of the objects return more than Salesforce limit 
            // Limit to 1000 since Salesforce cannot show more than 1000 elements on a Visualforce page as of 5/7/2014
            Integer acctSize = [
              select count()
              from Account where Name like :myKeyword LIMIT 1000
            ];
            Integer conSize = [
              select count()
              from Contact where Name like :myKeyword or Account.Name like :myKeyword LIMIT 1000
            ];
            Integer hwAssetSize = [
              select count()
              from Asset__c where Serial_Number__c like :myKeyword or Account__r.Name like :myKeyword LIMIT 1000
            ];
            Integer sAssetSize = [
              select count()
              from Service_Asset__c where Account__r.Name like :myKeyword LIMIT 1000
            ];
            Integer caseSize = [
              select count()
              from Case where Account.Name like :myKeyword or CaseNumber like :myKeyword or Request_Title__c like :myKeyword LIMIT 1000
            ];

            // Show error message
            if((acctSize == 1000) || (conSize == 1000) || (hwAssetSize == 1000) || (sAssetSize == 1000) || (caseSize == 1000)) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Too many results have been returned. Please refine your query.'));
                
                // Clear out the previous results.
                acctCount = contactCount = contactCount = hwassetCount = sassetCount = casesCount = '[0]';
                acct.clear(); contact.clear(); hwasset.clear(); sasset.clear(); cases.clear(); 
                return;
            }

            // If records returned are less than Salesforce limits, then go ahead and query and show the result
            acct = [Select Id, Name from Account 
                where Name like :myKeyword];
            contact = [Select Id, Name, AccountId, Account.Name from Contact 
                    where Name like :myKeyword or Account.Name like :myKeyword];
            hwasset = [Select Id, Name, Serial_Number__c, Account__c, Account__r.Name from Asset__c 
                    where Serial_Number__c like :myKeyword or Account__r.Name like :myKeyword];
            sasset = [Select Id, Name, Account__c, Account__r.Name from Service_Asset__c 
                    where Account__r.Name like :myKeyword];
            cases = [Select Id, Request_Title__c, CaseNumber, AccountId, Account.Name from Case 
                    where Account.Name like :myKeyword or CaseNumber like :myKeyword or Request_Title__c like :myKeyword];
                
            if (acct.size() != 0) { acctCount = '[' + string.valueof(acct.size()) + ']';} else { acctCount = '[0]';}
            if (contact.size() != 0) { contactCount = '[' + string.valueof(contact.size()) + ']';} else { contactCount = '[0]';}
            if (hwasset.size() != 0) { hwassetCount = '[' + string.valueof(hwasset.size()) + ']';} else { hwassetCount = '[0]';}
            if (sasset.size() != 0) { sassetCount = '[' + string.valueof(sasset.size()) + ']';} else { sassetCount = '[0]';}
            if (cases.size() != 0) { casesCount = '[' + string.valueof(cases.size()) + ']';} else { casesCount = '[0]';}   
                      
        }
        catch (Exception ex) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'acct: ' + acctID + ' & ' + ex.getMessage()));
        }   
    }

}