/*******************
Description: This cord is a controller for screens making an estimate.
Developer: Hitachi Solutions, Ltd.
Date Created: 12/13/2010
Date Modified: 6/7/2011
*****************/
/**
 * 見積作成画面用コントローラー
 */
public class JP_CLCallSPMSPollingController {

    //URLからパラメータを取得
    String oppId;
    String quoid;

    //連携用レコード、およびその項目値を保持
    List<JP_OrderQuoteMaking__c> chkResult;
    String status = '連携前';
    String errorDetailMsg='';

    // ポーリングの回数のカウントに使用
    Integer i = 1;
    Integer pollingLimit = 5;
    Integer pollingtime  = 5000;
    Integer wholetime    = 25000;

    //エラーメッセージの表示に使用
    ATFE_Exception expWord = new ATFE_Exception();
    String errorMSG;
    String tmpErrorDetailMsg;
    String MSG_Error_TotalTimeoutMSG;

    /**
     * コンストラクタ -    
     * @param   [ApexPages.StandardController]標準コントローラ -    
     * @return  null
     * @throws  なし
     */
    public JP_CLCallSPMSPollingController(ApexPages.StandardController stdController) {

        //URLからパラメータの取得
        oppId     = ApexPages.currentPage().getParameters().get('id');
        quoId     = ApexPages.currentPage().getParameters().get('quoId');

        //エラーメッセージの取得
        MSG_Error_TotalTimeoutMSG = expWord.MSG_Error_TotalTimeoutMSG;
    }
    /**
     * page表示時に起動するJSから呼ばれ、Asteriaで連携された見積作成依頼のレコードステータスを確認
     * @param   なし
     * @return  null
     * @throws  なし
     */
    public PageReference statusCheck(){

        // 連携用レコードの検索およびステータス、メッセージの取得
        chkResult = [select JP_OppId__c, JP_OpportunityId__c, JP_RenkeiStatus__c, JP_OppIdQuoteMakingDate__c, JP_SessionId__c, JP_ErrorMessage__c 
                     from  JP_OrderQuoteMaking__c 
                     where Id =: quoId];
        status = String.valueof(chkResult[0].JP_RenkeiStatus__c);
        tmpErrorDetailMsg = chkResult[0].JP_ErrorMessage__c;

        System.debug('●●●oppId:'+oppId+'/errorDetailMsg:'+errorDetailMsg+'/status:'+status);

        // ポーリング上限回数超過時のMSG取得
        if(i<pollingLimit){
            errorMSG = expWord.MSG_Error_QuoteIFFlow;
        }
        // Asteria連携での異常発生時のMSG取得
        if(chkResult[0].JP_RenkeiStatus__c == '連携済異常'){
            errorMSG = expWord.MSG_NoQuoteStatusChange;
        }
        if(errorMSG == null){
            errorMSG = 'なし';
        }
        errorDetailMsg = '概要'+errorMSG+'/連携時取得メッセージ'+tmpErrorDetailMsg;
        i++;
        return null;
    }
    public pageReference moveToDetailURL(){
        System.debug('●●●detailURL');
        Opportunity opp = [select id from Opportunity where id =: oppId];
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        pageReference pgDetailUrl = sc.view();
        pgDetailUrl.setRedirect(true);
        return pgDetailUrl;
    }
    /**
     * page表示時に起動するJSから呼ばれ、Asteriaで連携された見積作成依頼のレコードステータスを確認
     * @param   なし
     * @return  getStatus() - 見積作成依頼オブジェクトの連携ステータス
     *          getErrMsg() - 見積作成依頼オブジェクトのエラーメッセージ
     *        getStatusCount() - 見積作成依頼オブジェクトへのステータス確認回数
     * @throws  なし
     */
    public String getStatus(){
        return this.status;
    }
    public void setStatus(String s){
        status = s;
    }
    public String getErrorDetailMsg(){
        return this.errorDetailMsg;
    }
    public Integer getStatusCount(){
        return i;
    }
    public String getQuoid(){
        return quoid;
    }
    public Integer getPollingLimit(){
        return pollingLimit;
    }
    public Integer getPollingTime(){
        return pollingTime;
    }
    public Integer getWholeTime(){
        return wholeTime;
    }
    public String getTotalTimeoutMSG(){
        return MSG_Error_TotalTimeoutMSG;
    }
}