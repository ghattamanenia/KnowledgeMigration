/*******************
Description: This code is used to edit the OpportunityItem.
Developer: Hitachi Solutions, Ltd.
Date Created: 11/19/2010
Date Modified: 6/7/2011
*****************/
/*
 * Edit(Add and Modify) OpportunityLineItem record class
 */
public with sharing class JP_CLEditOppLineItem {
    
    private String sErrorMsg = null;
    
    // Takeuchi Ryo Modified at 2022/05/14 <https://atkk-is2.backlog.com/view/SF_1-350#comment-102967660>
    //private Integer iMAX_YYYYMM_TYPE_CNT = 2;
    private Integer iMAX_YYYYMM_TYPE_CNT = 1200;
    
    private String sJP_PB_KEYWORD = 'JP ';
    private String sMONTLY_FIXED_PRICEBOOK_CODE = 'SS';
    
    /**
     * ErrorMsg getter
     *
     * @param -
     * @return [String]: ErrorMsg
     */
    public String getErrorMsg(){
        System.debug(this.sErrorMsg);
        return this.sErrorMsg;
    }
    
    private static RecordType rtJpOpp = [SELECT r.Id FROM RecordType r WHERE r.SobjectType='Opportunity' and r.DeveloperName='JP_Opportunity'];
    
    
    //parent opp's recordType
    private static Map<Id, Opportunity> mOpp = new Map<Id, Opportunity>();
    
    //This is a flag that stop to execute opportunity trigger.
    private static Boolean exeTR = false;

    public static boolean checkExeTR(){
        return exeTR;
    }
    public static void setexeTR(Boolean exeTrVal) {
         exeTR = exeTrVal;
    }
    
    /**
     * set Fixed Price on every OpportunityLineItem records
     *
     * @param oList : List of Before changing data
     * @param nList : List of After changing data
     * @return [Integer]: result (result=0-->OK, result < 0 --> NG)
     * @throws -
     */
    public Integer setFixedPrice(List<OpportunityLineItem> oList, List<OpportunityLineItem> nList){
        
        //set [Stop Opportunity Trigger Flag] TRUE-
        JP_CLEditOppLineItem.setexeTR(TRUE);
        
        Integer iResult = 0;
        
        //TargetList
        List<OpportunityLineItem> lModTargetList = new List<OpportunityLineItem>();
        
        
        try{
            //-- 1.pick up target record----------------------------------
            
            //Get parent opp's recordType
            Set<id> sOppSet = new Set<id>();
            for(OpportunityLineItem oli: nList){
                if(!mOpp.containsKey(oli.OpportunityId)){
                    sOppSet.add(oli.OpportunityId);
                }
            }
            if(sOppSet.size() > 0){
                for(Opportunity op: [SELECT id, RecordTypeId FROM Opportunity WHERE id in :sOppSet]){
                    mOpp.put(op.id, op);
                }
            }
            sOppSet = null;
            
            //Check -- whether JP Opp or not
            Set<id> sPbEntry = new Set<id>();
            for(OpportunityLineItem oli: nList){
                if(mOpp.get(oli.OpportunityId).RecordTypeId == rtJpOpp.Id ){
                    lModTargetList.add(oli);
                    sPbEntry.add(oli.PricebookEntryId);
                }
            }
            System.debug('==========================①:' + sPbEntry);
            
            //Get pricebook name
            Map<id, PricebookEntry> mpb = new Map<id, PricebookEntry>([SELECT p.Id, p.Product2Id, p.Pricebook2.Name From PricebookEntry p Where id in :sPbEntry]);
            //create Map<YYYYMM, List<OpportunityLineItem>>
            Map<String, List<OpportunityLineItem>> mMontlyLineItems = new Map<String, List<OpportunityLineItem>>();
            //create Map<YYYYMM, List<product2Id>>
            Map<String, List<id>> mMontlyProducts = new Map<String, List<id>>();
            
            for(Integer i= 0; i < lModTargetList.size(); i++){
                OpportunityLineItem oli = lModTargetList[i];
                String tmpYYYYMM = mpb.get(oli.pricebookEntryId).Pricebook2.Name;
                if(!String.isBlank(tmpYYYYMM) && tmpYYYYMM.startsWith(sJP_PB_KEYWORD)){
                    
                    if(mMontlyLineItems.containsKey(tmpYYYYMM)){
                        mMontlyLineItems.get(tmpYYYYMM).add(oli);
                        mMontlyProducts.get(tmpYYYYMM).add(mpb.get(oli.pricebookEntryId).Product2Id);
                    }else{
                        List<OpportunityLineItem> lol = new List<OpportunityLineItem>();
                        List<id> lproductId = new List<id>();
                        lol.add(oli);
                        lproductId.add(mpb.get(oli.pricebookEntryId).Product2Id);
                        mMontlyLineItems.put(tmpYYYYMM,lol);
                        mMontlyProducts.put(tmpYYYYMM,lproductId);
                    }
                }else{
                    lModTargetList.remove(i);
                }
            }
            System.debug('==========================②:' + lModTargetList + '[' + lModTargetList.size() + ']');
            //Count pricebook kinds in this session         
            if(mMontlyLineItems.KeySet().size() > iMAX_YYYYMM_TYPE_CNT){
                throw new ATFE_Exception('複数の価格表が含まれています。明細更新時には価格表の種類を'+ String.valueof(iMAX_YYYYMM_TYPE_CNT) + '種類以下にしてください。');
            }
            
            //Get MontlyFixedPricebook
            List<Pricebook2> lFixedPB = [SELECT id, Name FROM  Pricebook2 WHERE Name in :mMontlyLineItems.keyset() and IsActive = true and Description= :sMONTLY_FIXED_PRICEBOOK_CODE];
            
            //FixedPriceMap -- Map<YYYYMM, FixedPricebookID>
            Map<String, id> mFixedPB = new Map<String, id>();
            for(Pricebook2 pb: lFixedPB){
                mFixedPB.put(pb.Name, pb.Id);
            }
            System.debug('==========================③:' + mFixedPB);
            
            //Get Goods-Montry-Fixedprice and create Map<YYYYMM-product2id, UnitPrice>
            Map<String, Decimal> mMontlyProductFixedPrice = new Map<String, Decimal>();
            for(String sYYYYMM: mMontlyLineItems.keySet()){
                
                Id iTargetMonthPbId = mFixedPB.get(sYYYYMM);
                if(iTargetMonthPbId != null){
                    List<PricebookEntry> lPbe = [SELECT id, Product2Id, UnitPrice FROM PricebookEntry WHERE IsActive=true and Product2Id in :mMontlyProducts.get(sYYYYMM) and Pricebook2Id=:iTargetMonthPbId ];
                    
                    for(PricebookEntry pbe: lPbe){
                        mMontlyProductFixedPrice.put(sYYYYMM+'-'+pbe.Product2Id, pbe.UnitPrice);
                    }
                }
            }
            System.debug('==========================④:' + mMontlyProductFixedPrice);
            
            for(OpportunityLineItem oli:lModTargetList){
                PricebookEntry pe = mpb.get(oli.PricebookEntryId);
                String sYYYYMM_productid = pe.Pricebook2.Name + '-' + pe.product2Id;
                oli.JP_FixedPrice__c = mMontlyProductFixedPrice.get(sYYYYMM_productid);
            }
        }
        catch(Exception e){
            iResult = -1;
            throw e;
        }
        
        return iResult;
        
    }
}