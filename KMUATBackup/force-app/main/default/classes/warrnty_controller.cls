public class warrnty_controller 
{

    public List<Warranty_Items__c> entiles {get;set;}
     public boolean NaRegion{get;set;}
     public String s{get;set;}
    public String s1{get;set;}
    public warrnty_controller () 
    {
     Id  Obj_Id = ApexPages.currentPage().getParameters().get('id');
     //SObjectType objectType = Obj_Id.getsobjecttype();
     String objecttype=Obj_Id.getSobjectType().getDescribe().getName(); 
     String userregion = [select id,Price_Book_Region__c from user where  Id = :UserInfo.getUserId()].Price_Book_Region__c;
     if(userregion.contains('NA'))
         NaRegion = true;
     else
         NaRegion = false;    
     entiles = new List<Warranty_Items__c>();
     if(objecttype.equals('Asset__c'))
         entiles = database.query('select Id,Name,Product__c,Warranty_End_Date__c,Warranty_Start_Date__c,Region__c,Sub_Region__c,Warranty__c from Warranty_Items__c where HW_Asset__c = :Obj_Id order by createdDate DESC limit 1');
     else
          entiles = database.query('select Id,Name,Product__c,Warranty_End_Date__c,Warranty_Start_Date__c,Region__c,Sub_Region__c,Warranty__c from Warranty_Items__c where warranty__r.Id = :Obj_Id');
         if(entiles.size()>0 ){
             if(entiles[0].Warranty_Start_Date__c != null)
                  s = entiles[0].Warranty_Start_Date__c.format();
             if(entiles[0].Warranty_End_Date__c!= null)     
                  s1 = entiles[0].Warranty_End_Date__c.format();
         }     
      
    } 

   
}