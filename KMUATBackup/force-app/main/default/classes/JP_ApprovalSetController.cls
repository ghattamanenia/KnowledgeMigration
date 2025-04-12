public with sharing class JP_ApprovalSetController {

    @TestVisible private final JP_QuotationHeader__c record;//製品見積のレコード
    private ApexPages.StandardController stdController;//標準コントローラ

    public String quotationId {get; set;}
    private final String errMsg = '承認プロセス番号が割り当てられていません';

    //コンストラクタ
    public JP_ApprovalSetController(ApexPages.StandardController stdController) {
        this.record = (JP_QuotationHeader__c)stdController.getRecord();//JP_QuotationHeader__cのレコード
        this.stdController = stdController;//標準コントローラ
        this.quotationId = record.Id;
    }
    
    public PageReference approvalSet(){
        JP_QuotationHeader__c qh = JP_QuotationHeaderDAO.getRecById(this.quotationId);
        if(String.isNotBlank(qh.JP_QuotationApprovalProcessNo__c)){
            String retUrl = '/apex/JP_SetAuthorizer?id=' + this.quotationId + '&retURL=' + this.quotationId;
            system.debug('===retUrl : ' + retUrl);
            return new PageReference(retUrl);
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errMsg));
        }
        return null;
    }
}