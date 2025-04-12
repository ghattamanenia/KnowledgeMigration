public class JP_ProductQuotationSelectController {

    public JP_QuotationHeader__c record {get;set;} //製品見積のレコード
    private ApexPages.StandardController stdController;//標準コントローラ
    public List<SelectOption> selectValues {get; set;} //選択リスト値
    public String selectedValue {get; set;} //選択された値
    public Boolean hasError {get; private set;} //error フラグ
    public Boolean isApploved {get; set;} //承認済みフラグ
    public Boolean hasError2 {
        get {
            return ApexPages.hasMessages();
        }
    }
    
    /*
    * Constructor
    */
    public JP_ProductQuotationSelectController(ApexPages.StandardController stdController){
        this.record = (JP_QuotationHeader__c)stdController.getRecord(); //JP_QuotationHeader__cのレコード
        this.stdController = stdController; //標準コントローラ
        this.selectValues = new List<SelectOption>();
        this.hasError = false;
        this.isApploved = false;

        //製品見積情報取得
        this.record = JP_QuotationHeaderDAO.getQuoteOutPutDate(this.record.Id);

        //見積書番号がブランクの場合はエラー
        if(String.isBlank(this.record.JP_QuotationNo__c)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, JP_Const.ERR_URL_PARAMETER, '-'));
            hasError = true;
        }

        //承認済みフラグ設定
        if(this.record.JP_QuotationStatus__c == '承認済'){
            this.isApploved = true;
        }
        
        //カスタム設定情報取得
        List<JP_QuotationTemplate__c> tempList = JP_QuotationTemplate__c.getAll().Values();
        sortList(tempList,'JP_No__c');
        selectValues = new List<SelectOption>();
        for(JP_QuotationTemplate__c temp : tempList){
            selectValues.add(new SelectOption(temp.JP_TemplateName__c,temp.JP_NAME__c));
        }
        
        //初期値設定
        if(0 < tempList.size()){
            selectedValue = tempList[0].JP_NAME__c;
        }
    }
    
    public void doExecute(){
        //見積情報取得
        JP_QuotationHeader__c qh = JP_QuotationHeaderDAO.getQuoteOutPutDate(this.record.Id);
        
        if(qh.JP_ApprovedDateTime__c != null){
            /*
            * 見積発行日がブランクだった場合は値をセット
            */
            if(this.record.JP_QuoteOutputDate__c == null || String.isBlank(String.valueOf(this.record.JP_QuoteOutputDate__c))){
                //承認完了日時から２週間以内の場合
                if(getBetweenDays(this.record.JP_ApprovedDateTime__c,System.now()) <= 14){
                    this.record.JP_QuoteOutputDate__c = System.today();
                }
                //承認完了日時から2週間以上経過した場合
                if(14 < getBetweenDays(this.record.JP_ApprovedDateTime__c,System.now())){
                    this.record.JP_QuoteOutputDate__c = this.record.JP_ApprovedDateTime__c.date().addDays(14);
                }    
            }
        }

        //保存 ALLIEDTELESIS-407 20190801 yorikasa Add
        doSave();
    }

    // ALLIEDTELESIS-407 20190801 yorikasa Add
    public void doSave(){
        system.debug('### doSave');
        this.hasError = false;

        try{
            system.debug('*** update ***');
            update this.record;
        }catch(Exception ex){
            system.debug('ERROR : ' + ex.getMessage());
            this.hasError = true;
            //ApexPages.Message message = new ApexPages.Message( ApexPages.severity.ERROR, ex.getMessage()); 
            //ApexPages.addMessage(message);
        }
    }

    public Integer getBetweenDays(DateTime startDateTime,DateTime endDateTime){
        //日付/時間→日付変換
        Date startDate = startDateTime.date();
        Date endDate = endDateTime.date();
        
        //日数取得
        return startDate.daysBetween(endDate);
    }
    
    /** sObjectを指定した項目でソートをかける */
    public static void sortList(List<Sobject> items, String sortField){
        List<Sobject> resultList = new List<Sobject>();
        Map<object, List<Sobject>> objectMap = new Map<object, List<Sobject>>();
        for(Sobject ob : items){
            if(!objectMap.containsKey(ob.get(sortField))){
                objectMap.put(ob.get(sortField), new List<Sobject>()); 
            }
            objectMap.get(ob.get(sortField)).add(ob);
        }       
 
        List<object> keys = new List<object>(objectMap.keySet());
        keys.sort();
   
        for(object key : keys){ 
            resultList.addAll(objectMap.get(key)); 
        }
        items.clear();
        for(Sobject ob : resultList){
            items.add(ob); 
        }
    }
}