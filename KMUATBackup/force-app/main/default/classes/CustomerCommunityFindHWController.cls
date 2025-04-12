public class CustomerCommunityFindHWController{

    public List<Asset__c> HW_Assets {get ; set;}
    public string HW_id{get ; set;}
    public string HW_SerialNo{get ; set;}
    public string HW_name{get ; set;}
    public Boolean showpage{get;set;}
    public string searchtxt {get;set;}
    
    private class Autocomplete{
    private string label;
    private string category;  
    Autocomplete(string x,string y){
    label = x;
    category = y;
    }  
    }
    @RemoteAction
    public static list<Autocomplete> getHWList(id accid)  
    {
        system.debug('## HW_Assets ##' );
        List<Asset__c> HW_Assets  = new List<Asset__c>();
        HW_Assets = [select Id,Name,Serial_Number__c,Account__c from Asset__c where Account__c = :accid limit 9000]; 
        system.debug('## HW_Assets ##' + HW_Assets );
      
        list<Autocomplete> HWmap = new list<Autocomplete>();
        SET<string> Names = new SET<string>();
        SET<string> Serial = new SET<string>();
        for (Asset__c HW : HW_Assets )
        {  
          if(!Names.contains(HW.Name)){
              Names.add(HW.Name);
              HWmap.add(new Autocomplete(HW.Name,'Name'));
          }
        }
        for (Asset__c HW : HW_Assets )
        {  
          if(!Serial.contains(HW.Serial_Number__c)){
              Serial.add(HW.Serial_Number__c);
              HWmap.add(new Autocomplete(HW.Serial_Number__c,'Serial Number'));
          }
        }
       // productList.addAll(tempproductset);
         //system.debug('### productList ###' + productList);
        return HWmap;
    }
    // Code we will invoke on page load.
    public PageReference forwardToCustomAuthPage() {

        if((UserInfo.getUserType() == 'Guest') || (Test.IsRunningTest() && UserInfo.getUserType() == 'Standard')){
            return new PageReference('/CustomerCommunityHome');
        }
        else{
            return null;
        }
    }

    public CustomerCommunityFindHWController() {
        showpage = true;
        HW_Assets  = new List<Asset__c>();
        HW_Assets = [select Id,Name,Serial_Number__c,Account__c from Asset__c where Account__c = :ApexPages.currentPage().getParameters().get('AccId') limit 9000]; 
         
        User usr = [Select Id, ContactId,Accountid from User where Id =: UserInfo.getUserId()];
      
        if(ApexPages.currentPage().getParameters().get('AccId') != usr.Accountid)
        {
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unfortunately, there was an issue with your request. If the issue continues, please contact Allied Telesis Technical Support.'));
             showpage = false;
             return ;
        }
        //HW_SerialNo = '1234';
        system.debug('HW Assets are ::' + HW_Assets);

    }

   public void Search_Hardware(){
   system.debug('## searcg TXT ###' + searchtxt);
   string srch = '%' + searchtxt + '%';
       HW_Assets = [select Id,Name,Serial_Number__c,Account__c from Asset__c where Account__c = :ApexPages.currentPage().getParameters().get('AccId') and (Name like :srch OR  Serial_Number__c like :srch) limit 9000 ];
       if(HW_Assets.size()  < 1){
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'No Product Name or Serial Number matched the search text.'));
       }
   system.debug('## HW_Assets  ###' + HW_Assets );
   }

    public PageReference Create_Case_for_Prod() {
        PageReference secondPage = Page.CustomerCommunityCreateCase;
        secondPage.setRedirect(true);
        secondPage.getParameters().put('HWId',HW_id); 
        secondPage.getParameters().put('prodModel',HW_name);
        secondPage.getParameters().put('HWSerialNo',HW_SerialNo);
        secondPage.getParameters().put('AccId',ApexPages.currentPage().getParameters().get('AccId'));
        secondPage.getParameters().put('hwInfo','true'); 
        return secondPage; 
       // return null;
    }
   
    public PageReference Create_Case_noHW() {
        PageReference secondPage = Page.CustomerCommunityCreateCaseHWReg;
        secondPage.setRedirect(true);
        secondPage.getParameters().put('AccId',ApexPages.currentPage().getParameters().get('AccId'));
        // If Create Case btn, don't do anything 
        return secondPage;
    }
   
    public PageReference Create_Case() {
        PageReference secondPage = Page.CustomerCommunityCreateCase;
        secondPage.getParameters().put('source', 'Create_Case_Button');
        secondPage.setRedirect(true);
        secondPage.getParameters().put('AccId',ApexPages.currentPage().getParameters().get('AccId'));
        secondPage.getParameters().put('hwInfo','false'); 
        return secondPage;
    }

    public PageReference BackPage() {
        return new PageReference('/CustomerCommunityLoggedIn');
    }

}