public with sharing class JP_PurchaseOrderUploadController {

    public JP_Order010PurchaseOrder__c record { get; set; }

    /** 一覧情報 */
    public transient String body { get; set; }
    public String filename { get; set; }
    public Integer filecount {get; set;}
    public List<JP_PurchaseOrder> orders {get; set;}
    public String quotationNo{get; set;}
    public Boolean CheckChange{ get; set; }
    public Boolean hasError{
        get {
            return ApexPages.hasMessages(ApexPages.severity.ERROR);
        }
        private set;
    }

    public Set<Id> filenameSet;
    public Set<String> docnames;
    private String msgFlag;

    private Set<String> errFileNameSet;
    public String retUrl {get; set;}

    @TestVisible private Integer FILE_SIZE = 4000000;


    /** コンストラクタ */
    public JP_PurchaseOrderUploadController(ApexPages.StandardController stdController) {
        this.record = (JP_Order010PurchaseOrder__c)stdController.getRecord();

        //初期化処理
        body = '';
        filename = '';
        filecount = 0;
        orders = new List<JP_PurchaseOrder>();
        quotationNo = '';
        CheckChange = false;
        filenameSet = new Set<Id>();
        docnames = new Set<String>();
        msgFlag = '';
        errFileNameSet = new Set<String>();
        retUrl = '';
    }
    
    /**
     *  初期処理
     */
    public void init() {
        List<Document> docList = new List<Document>();
        
        if(orders.size() == 0){
            docList = JP_PurchaseOrderDao.getDocuments();
            for(Document doc : docList){
                JP_PurchaseOrder po = new JP_PurchaseOrder(doc);
                orders.add(po);
            }
        }
        
        filecount = orders.size();

        for (Document doc: docList) {
            filenameSet.add(doc.Id);
            docnames.add(doc.Name);
        }
    }
    
    public PageReference doSave() {
        this.msgFlag = '';
        this.hasError = false;

        try{
            if(!String.isBlank(this.quotationNo)){
                // 製品見積レコード取得
                List<JP_QuotationHeader__c> qh = JP_QuotationHeaderDao.getRecByQuotationNo(this.quotationNo);

                // 製品見積紐づけ
                if(qh.size() > 0){ 
                    this.record.JP_QuotationHeader__c = qh[0].Id;
                }else{
                    system.debug('=== 見積書番号に該当する見積が見つからないエラー ===');
                    MyException ex = new MyException();
                    ex.setMEssage('該当の製品見積が見つかりません');
                    throw ex;
                }
            }

            // 拠点選択チェック
            if(String.isEmpty(this.record.JP_Order010_Filed002__c)){
                system.debug('=== 拠点が未選択エラー ===');
                MyException ex = new MyException();
                ex.setMEssage('拠点が空欄です。拠点を選択してください。');
                throw ex;
            }

            //ドキュメントを添付
            doFileTemp();

            if( this.msgFlag == '1' ) {
                String errMsg1 = '下記注文書のファイル名が重複しています。ファイル名を変更してください。';
                for( String fn : errFileNameSet ) {
                    errMsg1 += '<br/> ・' + fn;
                }

                MyException ex = new MyException();
                ex.setMEssage(errMsg1);
                throw ex;
            }else if(this.msgFlag == '2'){
                String errMsg2 = '予期せぬエラーが発生しました。システム管理者に連絡してください。';

                MyException ex = new MyException();
                ex.setMEssage(errMsg2);
                throw ex;
            }

            // ドキュメント削除
            doDocmentDel();
            filecount = orders.size();

            // 保存後に参照画面に遷移
            // return new PageReference('/' + this.record.id);

            String successMsg = '以下のファイルのアップロードに成功しました';
            for(String str : docnames){
                successMsg += '<br />・' + str;
            }

            orders = new List<JP_PurchaseOrder>();
            docnames = new Set<String>();
            record = new JP_Order010PurchaseOrder__c();

            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, successMsg));
            return null;

        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));
            return null;
        }
    }


    /*
     *  Documentを取得しAttachmentに添付
     */ 
    private void doFileTemp() {
        errFileNameSet = new Set<String>();
            
        try {
            // ドキュメント取得
            List<Document> lstDoc = JP_PurchaseOrderDao.getDocuments();

            //1つ目のファイル名から拡張子を除去した文字列を取得
            String fileName = lstDoc[0].Name.substringBeforeLast('.');

            // 既存注文書取得
            List<JP_Order010PurchaseOrder__c> poList = new List<JP_Order010PurchaseOrder__c>();
            poList = JP_PurchaseOrderDao.getPurchaseOrder(fileName);
            
            // 注文書管理レコード重複チェック
            if(poList.size() > 0){
                POException poex = new POException();
                errFileNameSet.add( fileName );
                throw poex;
            }

            this.record.Name = fileName;
            this.record.JP_Order010_Filed013__c = '起票';

            // 注文書管理レコードをinsert
            try{
                insert this.record;
                this.retUrl = '/' + this.record.Id;
            }catch(Exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));
            }

            for(Document doc : lstDoc){
                //ContentVersionにファイルを登録
                createContentVersion(this.record.Id, doc);
            }

        } catch( POException pox){
            this.msgFlag = '1';
        } catch( Exception e ) {
            this.msgFlag = '2';
        }
    }

    /*
     *  Documentを削除
     */ 
    private void doDocmentDel() {
        try {
            List<Document> lstDoc = JP_PurchaseOrderDao.getDocuments();
            if(lstDoc.size() > 0){
                delete lstDoc;
            }

        } catch(Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
        }
    }

    /**
     *  アップロード処理
     */
    public pageReference uploadFile(){
        
        if(!String.isBlank(msgFlag)){
            filenameSet = new Set<Id>();
        }
        
        msgFlag = '';
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/';
        Document doc = new Document();
        //body = body.substringAfterLast(baseUrl);
        body = body.replace(baseUrl,'');
        doc.Body = EncodingUtil.base64Decode(body);
        doc.Name = fileName.replace('C:\\fakepath\\' , '');
        doc.FolderId = userinfo.getUserId();
        doc.Description = 'Upload Temporary';
        
        try{
            if(!docnames.contains(doc.Name)){
                insert doc;
            
                JP_PurchaseOrder po = new JP_PurchaseOrder(doc);
                orders.add(po);
                
                docnames.add(doc.Name);
                filenameSet.add(doc.Id);
    
                filecount = orders.size();
                return null;
            }else{
                POException poex = new POException();
                String errMsg = '下記注文書のファイル名が重複しています。ファイル名を変更して下さい。<br />';
                errMsg += '<br />' + doc.Name;
                poex.setMessage(errMsg);
                throw poex;
            }
        } catch( POException pox){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, pox.getMessage()));
            this.msgFlag = '1';
            return null;
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            return null;
        }finally {
            doc.Body = null;
        }
    }

    /**
     * 選択削除
     */
    public PageReference doDelete() {
        List<Document> delList = new List<Document>();
        
        // ドキュメントを削除
        for(JP_PurchaseOrder po : orders){
            if(po.selected == true && po.obj != null){
                delList.add(po.obj);
            }
        }
        
        // リストから該当業を削除
        for(Integer i=orders.size()-1; i>0; i--){
            if(orders[i].selected == true){
                orders.remove(i);
                filecount = orders.size();
            }
        }

        if(delList.size() > 0){
            delete delList;
        }
        
        return null;
    }

    /**
     * ContentVersion（Salesforce Filesの実体）を作成
     */
    public static void createContentVersion(Id parentId, Document doc){
        ContentVersion cv = new ContentVersion();
        cv.Title = doc.Name;
        cv.VersionData = doc.Body;
        cv.ContentLocation = 'S';
        cv.PathOnClient = doc.Name;
        cv.FirstPublishLocationId = parentId;

        try{
            insert cv;
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
    }
    
    public class poException extends Exception{}
    public class MyException extends Exception{}
}