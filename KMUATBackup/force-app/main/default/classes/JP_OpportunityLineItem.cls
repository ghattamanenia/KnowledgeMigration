/**
 * 商談商品を取得するためのクラス
 */
public with sharing class JP_OpportunityLineItem{

    private Final Opportunity opp;

    public class JP_OLI{
      public String c_date {get; set;}
      public Integer amount {get; set;}
    }

    public List<JP_OLI> oliList {get; set;}
    
    public JP_OpportunityLineItem(ApexPages.StandardController controller) {
        this.opp = (Opportunity)controller.getRecord();
        this.oliList = getOliList(this.opp.Id);
    }

    // 完了予定日毎の金額合計を取得
    public static List<JP_OLI> getOliList(Id recId){
        List<OpportunityLineItem> oliList = [
            SELECT 
            Id,
            TotalPrice,
            JP_CompletionScheduled__c
        FROM
            OpportunityLineItem
        WHERE
            OpportunityId = :recId
        ];

        Map<String, Integer> map1 = new Map<String, Integer> {};

        String c_date;
        Integer amount;
        for (OpportunityLineItem oli : oliList){
            c_date = String.valueOf(oli.JP_CompletionScheduled__c);
            amount = Integer.ValueOf(oli.TotalPrice);
            if(map1.containskey(c_date)){
                map1.put(c_date, map1.get(c_date) + amount);
            }else{
                map1.put(c_date, amount);
            }
        }

        List<JP_OLI> ret_oliList = new List<JP_OLI>();
        JP_OLI oli;

        for (String key : map1.keySet()){
            oli = new JP_OLI();
            oli.c_date = key;
            oli.amount = map1.get(key);
            ret_oliList.add(oli);
        }

        return ret_oliList;
    }
}