/**
 * SOヘッダの孫SO明細を取得するためのクラス
 */
public with sharing class JP_SO_Detail{

    private Final JP_RequestInformation__c so;
    public List<JP_SO_Detail__c> sodList {get; set;}
    
    public JP_SO_Detail(ApexPages.StandardController controller) {
        this.so = (JP_RequestInformation__c)controller.getRecord();
        this.sodList = getSod(this.so.Id);
    }

    // SOヘッダの孫SO明細を取得
    public static List<JP_SO_Detail__c> getSod(Id recId){

        List<JP_SO_Detail__c> sodList = new List<JP_SO_Detail__c>();

        sodList = [SELECT Id, Name, CreatedDate,
                          JP_SO_Item_Common4__c,     // SO明細コメント共通4
                          JP_Subtotal__c,            // 小計
                          JP_Management_No__r.Id,    // 親管理番号ID
                          JP_Management_No__r.Name   // 親管理番号名
                     FROM JP_SO_Detail__c
                    WHERE JP_Management_No__r.JP_SO_Header__c = :recId
                 ORDER BY JP_Management_No__c];

        return sodList;
    }
}