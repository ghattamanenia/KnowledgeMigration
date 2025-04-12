public class myTrainingSessionExtension {


   public List<Session__c> getcourses()  {
String strCountry = ApexPages.currentPage().getParameters().get('country');
if (strCountry != null) {
return [SELECT Name, atfe_Session_Title__c, atfe_Session_Start_Date__c, atfe_Country__c, atfe_Language__c, atfe_Session_Description__c, atfe_Location__c, atfe_Training_Partner__c, atfe_Training_Partner__r.name from Session__c where atfe_Status__c = 'Available to Book' and atfe_Internal_Session_Only__c = false and atfe_Session_Start_Date__c >= :Date.Today() and atfe_Country__c = :strCountry order by atfe_Session_Start_Date__c];
}
else {
return [SELECT Name, atfe_Session_Title__c, atfe_Session_Start_Date__c, atfe_Country__c, atfe_Language__c, atfe_Session_Description__c, atfe_Location__c, atfe_Training_Partner__c, atfe_Training_Partner__r.name from Session__c where atfe_Status__c = 'Available to Book' and atfe_Internal_Session_Only__c = false and atfe_Session_Start_Date__c >= :Date.Today() order by atfe_Session_Start_Date__c];
}
        
    }

    public Lead weblead {get; set;}

    public myTrainingSessionExtension(ApexPages.StandardController stdController) {
        weblead = new Lead();
    }

     public PageReference saveLead() {
       try {           
           webLead.LeadSource = 'Training Calendar';
           webLead.Industry = 'Other';
           //webLead.Country = 'United Kingdom';
           insert weblead;
       }
       catch(System.Exception e) {
           ApexPages.addMessages(e);
           return null;
       }
       PageReference p = Page.Session_Registration_Thank_You;
       p.setRedirect(true);
       return p;
    }
}