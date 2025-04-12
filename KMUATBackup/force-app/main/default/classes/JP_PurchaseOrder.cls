public with sharing class JP_PurchaseOrder {
    public Document obj {get; set;}
    public Blob file {get; set;}
    public String fileName {get; set;}
    public Boolean selected {get; set;}
    public Integer rowNo { get; set; }
    
    public JP_PurchaseOrder( Document obj ){
        this.obj = obj;
        this.fileName = obj.Name;
        this.selected = false;
        this.rowNo = 0;
    }
}