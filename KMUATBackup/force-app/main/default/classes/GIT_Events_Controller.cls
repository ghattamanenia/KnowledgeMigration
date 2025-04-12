public class GIT_Events_Controller 
{

    public GIT_Events_Controller(ApexPages.StandardController controller) {

    }


    public Global_IT_Events__c GIT_Events {get;set;}

    public GIT_Events_Controller () 
    {
         GIT_Events = new Global_IT_Events__c();
         list<Global_IT_Events__c> GL = new list<Global_IT_Events__c>();
         GL = [ Select Global_Business_Owner_Prioritization__c, Global_SFDC_Board__c, Technical_Review_Board__c from Global_IT_Events__c order by createdDate DESC limit 1];
         if(GL.size()>0)
             GIT_Events = GL[0];
      
    } 

}