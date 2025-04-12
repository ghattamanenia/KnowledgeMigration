public class JP_PurchaseOrderDao {

    // ドキュメントを取得
    public static List<Document> getDocuments(){
        List<Document> docList = new List<Document>();
        docList = [Select id, Name, Body, Type, FolderId, CreatedDate From Document where folderId = :UserInfo.getUserId() and Description = 'Upload Temporary' order by Id Asc];
        return docList;
	}
    
    // ビューを取得
    /*#402 20191007 Terrasky mod
    public static ListView getView(){
        ListView view = [Select Id, Name, SObjectType, DeveloperName from Listview
                         Where SObjectType = 'JP_Order010PurchaseOrder__c' 
                         And DeveloperName = :System.Label.JP_PurchaseOrderView];
        return view;
    }
    */
    
    // 既存の注文書管理を取得
    public static List<JP_Order010PurchaseOrder__c> getPurchaseOrder(String fileName){
        List<JP_Order010PurchaseOrder__c> poList = new List<JP_Order010PurchaseOrder__c>();
        poList = [Select Id,Name from JP_Order010PurchaseOrder__c where Name = :fileName];
        return poList;
    }
    
    // 製品見積を取得
    /*#402 20191007 Terrasky mod
    public static List<JP_QuotationHeader__c> getQuotationHeaderByQuotationNo(String quotationNo){
        return [Select Id From JP_QuotationHeader__c Where JP_QuotationNo__c = :quotationNo limit 1];
    }
    */
    
}