public class JP_ProductQuotationPreviewController {
    
    @TestVisible private final JP_QuotationHeader__c record;//製品見積のレコード
    private ApexPages.StandardController stdController;//標準コントローラ

    public List<SelectOption> selectValues {get; set;} //選択リスト値
    public String selectedValue {get; set;} //選択された値
    public String param_qhid {get;set;} //見積基本ID
    public String param_qhno {get;set;} //見積書基本番号
    public Boolean hasError{get; private set;} //error フラグ
    
    /*
    * Constructor
    */
    public JP_ProductQuotationPreviewController(ApexPages.StandardController stdController){
        this.record = (JP_QuotationHeader__c)stdController.getRecord();//JP_QuotationHeader__cのレコード
        this.stdController = stdController;//標準コントローラ
        
        //初期化
        selectValues = new List<SelectOption>();
        hasError = false;
        
        //paramチェック
        //param_qhid = ApexPages.currentPage().getParameters().get('qhid');
        param_qhid = this.record.Id;
        JP_QuotationHeader__c qh = JP_QuotationHeaderDAO.getRecById(param_qhid);
        //param_qhno = ApexPages.currentPage().getParameters().get('qhno');
        param_qhno = qh.JP_QuotationNo__c;
        if(param_qhid ==null || String.isBlank(param_qhid) || param_qhno ==null || String.isBlank(param_qhno)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, JP_Const.ERR_URL_PARAMETER, '-'));
            hasError = true;
        }
        
        //カスタム設定情報取得
        List<JP_QuotationTemplate__c> tempList = JP_QuotationTemplate__c.getAll().Values();
        sortList(tempList,'JP_No__c','asc');
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

    }

    public Integer getBetweenDays(DateTime startDateTime,DateTime endDateTime){
        //日付/時間→日付変換
        Date startDate = startDateTime.date();
        Date endDate = endDateTime.date();
        
        //日数取得
        return startDate.daysBetween(endDate);
    
    }
    
    /** sObjectを指定した項目でソートをかける */
    public static void sortList(List<Sobject> items, String sortField, String order){
 
        List<Sobject> resultList = new List<Sobject>();
        Map<object, List<Sobject>> objectMap = new Map<object, List<Sobject>>();
        for(Sobject ob : items){
            if(objectMap.get(ob.get(sortField)) == null){
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
        if(order.toLowerCase() == 'asc'){
            for(Sobject ob : resultList){
                items.add(ob); 
            }
        }
        else if(order.toLowerCase() == 'desc'){
            for(integer i = resultList.size()-1; i >= 0; i--){
                items.add(resultList[i]);  
            }
        }
    }

}