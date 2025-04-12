public with sharing class JP_CopyQuotationController {

    @TestVisible private final JP_QuotationHeader__c record;//製品見積のレコード
    private ApexPages.StandardController stdController;//標準コントローラ

    public String quotationId {get; set;}
    public String result {get; set;}
    public Boolean takeoverFlg {get; set;}

    //コンストラクタ
    public JP_CopyQuotationController(ApexPages.StandardController stdController) {
        this.record = (JP_QuotationHeader__c)stdController.getRecord();//JP_QuotationHeader__cのレコード
        this.stdController = stdController;//標準コントローラ
        this.quotationId = record.Id;
        this.takeoverFlg = false;
    }
    
    public PageReference doCopy(){
        system.debug('=== doCopy start ===');

        try {
            system.debug('=== takeoverFlg : ' + takeoverFlg);
            this.result = JP_CopyQuotationToQuotation.copyQuotationtoQuotation(this.quotationId, this.takeoverFlg);
            system.debug('=== result : ' + this.result);
            if(this.result.startsWith('エラー')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, this.result));
            }else{
                return new PageReference('/' + result);
            }
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        return null;
    }

    // 見積番号を引き継いでコピーするフラグ（true）
    public PageReference setTakeoverFlgTrue(){
        system.debug('=== setTakeoverFlgTrue');
        this.takeoverFlg = true;
        
        return null;
    }

    // 見積番号を引き継いでコピーするフラグ（false）
    public PageReference setTakeoverFlgFalse(){
        system.debug('=== setTakeoverFlgFalse');
        this.takeoverFlg = false;
        
        return null;
    }
}