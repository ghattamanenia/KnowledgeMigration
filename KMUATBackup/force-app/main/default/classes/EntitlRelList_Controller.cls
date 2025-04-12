public class EntitlRelList_Controller 
{

    public List<Entitlement> entiles {get;set;}
    public boolean NaRegion{get;set;}
    public String s{get;set;}
    public String s1{get;set;}
  
    public EntitlRelList_Controller () 
    {
     Id  Obj_Id = ApexPages.currentPage().getParameters().get('id');
     //SObjectType objectType = Obj_Id.getsobjecttype();
     String objecttype=Obj_Id.getSobjectType().getDescribe().getName(); 
     String userregion = [select id,Price_Book_Region__c from user where  Id = :UserInfo.getUserId()].Price_Book_Region__c;
     if(userregion.contains('NA'))
         NaRegion = true;
     else
         NaRegion = false;    
     entiles = new List<Entitlement>();
     string var = 'Default';
     string ActiveEntitl = 'Active';
     if(objecttype.equals('Asset__c')){
     List<Service_Asset__c> Serv_Asset = new List<Service_Asset__c>();
     List<ServiceContract> Serv_Contract =  new List<ServiceContract>();
     
     Serv_Asset = [Select id, Asset__c from Service_Asset__c where Asset__c = :Obj_Id];
     Serv_Contract = [Select id, Service_Asset__c,Status from ServiceContract where Service_Asset__c IN :Serv_Asset];
     if(Serv_Contract.size()>0 && Serv_Contract[0].Status == 'Active')
         entiles = database.query('select Id,Name,StartDate,Type,Region__c,EndDate,Status,HW_Asset__c from Entitlement where Status =  :ActiveEntitl  and  Name != :var and HW_Asset__c = :Obj_Id order by createdDate DESC limit 1');
     
     
     }
     else
          entiles = database.query('select Id,Name,StartDate,Type,Region__c,EndDate,Status,'+objecttype+'.Id from Entitlement where '+objecttype+'.Id = :Obj_Id');
     if(entiles.size()>0){
      s = entiles[0].StartDate.format();
      s1 = entiles[0].EndDate.format();
      }
    } 

   
}