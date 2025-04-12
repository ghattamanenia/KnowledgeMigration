public with sharing class JP_NewQuotationController {

    @TestVisible private final JP_QuotationDistributor__c record;//製品見積のレコード
    private ApexPages.StandardController stdController;//標準コントローラ

    public String distId {get; set;}
    private final String errMsg = '見積を作成できません。';

    //コンストラクタ
    public JP_NewQuotationController(ApexPages.StandardController stdController) {
        this.record = (JP_QuotationDistributor__c)stdController.getRecord();//JP_QuotationDistributor__cのレコード
        this.stdController = stdController;//標準コントローラ
        this.distId = record.Id;
    }
    
    public PageReference QuotationCreate(){
        try{
            List<JP_QuotationDistributor__c> qdList = JP_QuotationDistributorDAO.getRecByDistId(this.distId);
            JP_QuotationDistributor__c qd = qdList[0];
            if(qd.JP_QuotationCreatableFlag__c
            && qd.JP_DistributorActiveFlag__c
            && qd.JP_EffectiveFlagForMainDistributor__c){
                String retUrl = '/apex/JP_QuotationEdit?distributorId=' + qd.Id + '&spotflg=' + qd.JP_SpotDistributor__c + '&retURL=' + qd.Id; 
                system.debug('===retUrl : ' + retUrl);
                return new PageReference(retUrl);
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errMsg));
            }
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }

    return null;
    
    }
}