public class ATFE_SelectProductWrapper{
    public PricebookEntry pbe {get;set;}
    public Boolean selected {get;set;}
    
    public ATFE_SelectProductWrapper(){
        pbe = new PricebookEntry();
        selected = false;
    }
    
    public ATFE_SelectProductWrapper(PricebookEntry p){
        pbe = p;
        selected = false;
    }
    
}