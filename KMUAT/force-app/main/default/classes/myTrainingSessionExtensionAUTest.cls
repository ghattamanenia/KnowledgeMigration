@isTest
public class myTrainingSessionExtensionAUTest
{
   public static List<Lead> lstobj=new List<Lead>();
  
   static testMethod void UpdateProduct()
   {    
       
       //Creating Incoming Case    
       Lead obj=new Lead();
       obj.LastName='Mishra';
       obj.Company='HCL';
       obj.Country='Italy';
       obj.Status='Closed-Converted';
       obj.LeadSource='Web';
       
       lstobj.add(obj);
       
       insert obj;
       
       myTrainingSessionExtensionAU onj1=new myTrainingSessionExtensionAU(null);
       onj1.saveLead();
  onj1.getcourses();
       PageReference p = Page.Session_Registration_Thank_You;
       p.setRedirect(true);
       
     
       
   }
}