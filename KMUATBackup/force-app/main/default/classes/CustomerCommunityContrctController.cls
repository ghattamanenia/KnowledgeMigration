public without sharing class CustomerCommunityContrctController {

   public Asset__c HW_Asset {get;set;}
   public Service_Asset__c SA {get;set;}
   public ServiceContract SC {get;set;}
   public string startDate {get;set;}
   public string enddate {get;set;}
   
   public boolean showerror {get;set;}
   public boolean showdetails  {get;set;} 
   public string NoContractFound {get;set;}
   public string ServContrct {get;set;}
   public string ServAsst {get;set;}
  
   private id AcctId;
    public PageReference forwardToCustomAuthPage() {
      
        if((UserInfo.getUserType() == 'Guest') || (Test.IsRunningTest() && UserInfo.getUserType() == 'Standard')){
            return new PageReference('/CustomerCommunityHome');
        }
        else{
            return null;
        }
    }

  public CustomerCommunityContrctController() {
       // HW_Assets  = new List<Asset__c>();
       NoContractFound  = 'No contract could be found for this Hardware. Please contact Support for details.';
       showerror = false;
       showdetails = false;
       datetime stdt,endt;
       system.debug('## HW_Asset_ID ##' + ApexPages.currentPage().getParameters().get('HwId') );
       AcctId = ApexPages.currentPage().getParameters().get('Accid');
       HW_Asset = [select Id,Name,Serial_Number__c,Account__c from Asset__c where id = :ApexPages.currentPage().getParameters().get('HwId') limit 9000 ]; 
       system.debug('## HW_Asset ##' + HW_Asset );
       List<Service_Asset__c> SAs = new List<Service_Asset__c>();
       SA = new Service_Asset__c();
       SC = new ServiceContract();
       SAs = [select id,Name from Service_Asset__c where Asset__c = :HW_Asset.id limit 1 ];
       system.debug('## SAs ##' + SAs );
       if(SAs.size()>0 ){
       SA = SAs[0];
       showdetails = true;
           SC = [select id,Name,StartDate, EndDate from ServiceContract where Service_Asset__c = :SA.id limit 9000 ];
           ServContrct = SC.name;
           ServAsst = SA.name;
         system.debug('## SC.StartDate ##' + SC.StartDate);
         system.debug('## SC.EndDate ##' + SC.EndDate);   
        stdt = SC.StartDate;
       endt = SC.EndDate;
     date starDate = Date.newInstance(stdt.yeargmt(), stdt.monthGmt(), stdt.dayGmt());
     date enDate = Date.newInstance(endt.yeargmt(), endt.monthGmt(), endt.dayGmt());
     
     startDate = starDate.format();
      enddate = enDate.format();
         
      }
      else{
          showerror = true;
          showdetails = false;
      }

  


  }
  
  public PageReference BackPage() {
        return new PageReference('/CustomerCommunityFindHardWare?AccId='+ AcctId );
    }
    
  
     public PageReference Create_Case_for_Prod() {
        PageReference secondPage = Page.CustomerCommunityCreateCase;
        secondPage.setRedirect(true);
        secondPage.getParameters().put('HWId',HW_Asset.id); 
        secondPage.getParameters().put('prodModel',HW_Asset.Name);
        secondPage.getParameters().put('HWSerialNo',HW_Asset.Serial_Number__c);
        secondPage.getParameters().put('AccId',AcctId);
        secondPage.getParameters().put('hwInfo','true'); 
        return secondPage; 
       // return null;
    }

}