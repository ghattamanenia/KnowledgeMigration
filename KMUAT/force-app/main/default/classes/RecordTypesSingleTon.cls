public class RecordTypesSingleTon
{
   
    private static RecordTypesSingleTon instance = null;    
    public map<String,RecordType> RtMap = new map<String,RecordType>();
  
    
    
    private RecordTypesSingleTon()
    {
        list<RecordType> rts = [SELECT Id,DeveloperName,IsActive,Name,SobjectType FROM RecordType WHERE  isActive = true];
        for(RecordType sType : rts)
        {
            RtMap.put(sType.DeveloperName,sType);
        }        
    }
    

    public static RecordTypesSingleTon getInstance()
    {

        if(instance == null) instance = new RecordTypesSingleTon();
            return instance;
    }
}