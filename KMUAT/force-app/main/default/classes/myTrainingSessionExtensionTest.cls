@isTest
public class myTrainingSessionExtensionTest
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
       
       myTrainingSessionExtension onj1=new myTrainingSessionExtension(null);
       onj1.saveLead();
  onj1.getcourses();
       PageReference p = Page.Session_Registration_Thank_You;
       p.setRedirect(true);
       
     
       
   }
}