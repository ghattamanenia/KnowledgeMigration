public with sharing class JP_CheckExpirationDateController {

    @TestVisible private final JP_QuotationHeader__c record;//製品見積のレコード
    private ApexPages.StandardController stdController;//標準コントローラ

    public String quotationId {get; set;}
    public Boolean isErr {get; set;}
    final String msgReload1 = '画面は自動で更新されません';
    final String msgReload2 = 'LCアプリ　関連タブを Shift + R で更新';
    final String msgReload3 = 'Lアプリ　　F5 で更新';

    //コンストラクタ
    public JP_CheckExpirationDateController(ApexPages.StandardController stdController) {
        this.record = (JP_QuotationHeader__c)stdController.getRecord();//JP_QuotationHeader__cのレコード
        this.stdController = stdController;//標準コントローラ
        this.quotationId = record.Id;
        this.isErr = false;
        init();
    }

    public void init(){
        system.debug('=== init ===');
        String result = JP_ExtendExpirationDateOfQuotation.CheckChange(this.quotationId);

        system.debug('===' + result);

        if(result.startsWith('エラー')){
            this.isErr = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, result));
            system.debug('=== isErr : ' + isErr);
        }

    }

    public PageReference doExtension(){
        system.debug('=== doExtension ===');
        String result = JP_ExtendExpirationDateOfQuotation.JP_ExtendExpirationDate(this.quotationId);
system.debug('=== result : ' + result);
        if(result.startsWith('エラー')){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, result));
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, result));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, msgReload1));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, msgReload2));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, msgReload3));
        }

        return null;
    }

}