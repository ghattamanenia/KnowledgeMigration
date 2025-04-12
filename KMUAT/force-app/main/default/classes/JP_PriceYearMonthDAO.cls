/**
 * 価格年月のデータアクセスオブジェクトクラス
 */
public with sharing class JP_PriceYearMonthDAO {
    /**
     * 前月からの価格年月オブジェクトを取得します
     * @param priceListType priceListType
     * @return 前月からの価格年月オブジェクトリスト
     */
    public static List<JP_PriceYearMonth__c> selectFromPreviousMonth(String priceListType) {
        Integer yearMonth = Date.today().addMonths(-1).year() * 100 + Date.today().addMonths(-1).month();
        return
            [
            select
                Id,
                Name,
                JP_FormatedPriceYearMonth__c,
                JP_Price_List_Type__c,
                JP_PriceYearMonth__c,
                JP_UpsertKey__c
            From
                JP_PriceYearMonth__c
            where
                JP_Price_List_Type__c = :priceListType
            and
                JP_FormatedPriceYearMonth__c >= :yearMonth
            order by
                JP_FormatedPriceYearMonth__c asc
            ];
    }
}