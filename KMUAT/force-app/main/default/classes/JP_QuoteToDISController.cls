public with sharing class JP_QuoteToDISController {

    public String datestr {get; set;}
    public String quotationNo {get; set;}
      
    public JP_QuoteToDISController(ApexPages.StandardController stdController) {

        Id recId = stdController.getRecord().Id;
        JP_QuotationHeader__c quote = [
            SELECT Id, Name, JP_QuotationNo__c, JP_QuotationCondition__c, JP_EstimatesExpirationDate__c
            FROM JP_QuotationHeader__c
            WHERE Id =:recId];

        this.quotationNo = quote.JP_QuotationNo__c;
        
        this.datestr = '';
        if (quote.JP_EstimatesExpirationDate__c != null){
            this.datestr = dateformat(quote.JP_EstimatesExpirationDate__c);
        }

        List<JP_QuoationChangesEexpirationDate__c> list_qced = [
            SELECT Name, JP_QuotationExpireDate__c, JP_QuotationExpireDateTranslation__c
            FROM JP_QuoationChangesEexpirationDate__c
            WHERE JP_QuotationHeader__c = :recId
            ORDER BY JP_QuotationExpireDate__c DESC];
        if (list_qced.size() > 0){
            JP_QuoationChangesEexpirationDate__c qced = list_qced.get(0);
            this.quotationNo = qced.Name;
            this.datestr = dateformat(qced.JP_QuotationExpireDateTranslation__c);
        }
        
    }

    public static string dateformat(String dstr){

        if (dstr == null){
            return '';
        }
        String regex1 = '(\\d+)年 ?(\\d+)月 ?(\\d+)日';
        Pattern pt = Pattern.compile(regex1);
        Matcher matcher = pt.matcher(dstr);
        if(matcher.find()){
            String all = matcher.group(0);
            String y = matcher.group(1);
            String m = matcher.group(2);
            String d = matcher.group(3);
            dstr = y.leftpad(4,'0') + m.leftpad(2,'0')+ d.leftpad(2,'0');
        }
        return dstr;

    }
    
}