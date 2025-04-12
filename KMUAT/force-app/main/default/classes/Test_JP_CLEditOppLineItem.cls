/*******************
Description: This cord is a test cord of JP_CLEditOppLineItem.
Developer: Hitachi Solutions, Ltd.
Date Created: 12/3/2010
Date Modified: 5/16/2012
*****************/
/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 *
 * 2010/12/03----Coverage:79%
 */
@isTest
private class Test_JP_CLEditOppLineItem {

    static testMethod void JP001() {
        
        // preparation -
        Product2 pr = new Product2(Name='TEST', ProductCode='990-0000-000' , JP_SalesOrganization__c='2' , JP_DistributionChannel__c='3' , JP_Division__c='4' , JP_Connectionkey__c='990-0000-000_2_3_4');
        insert pr;
        
        List<Pricebook2> pbL = new List<Pricebook2>();
        Pricebook2 pbSS = new Pricebook2(Name='JP 2000/01', Description='SS');
        pbL.add(pbSS);
        Pricebook2 pbA1 = new Pricebook2(Name='JP 2000/01', Description='A1');
        pbL.add(pbA1);
        insert pbL;
        
        
        //テスト用価格準備 -
        List<PricebookEntry> pbeL = new List<PricebookEntry>();
        
        //標準価格を準備 -
        //Pricebook2 pbFixedPriceList = [SELECT id FROM Pricebook2 WHERE IsStandard=true];
        Id pbFixedPriceList = Test.getStandardPricebookId();//ALLIEDTELESIS-568 terrasky D.Ariga add
        System.debug(pbFixedPriceList);
        //PricebookEntry pbeFixP = new PricebookEntry(pricebook2Id=pbFixedPriceList.id, Product2Id=pr.id, UnitPrice=12000, CurrencyIsoCode='JPY', IsActive=true);
        PricebookEntry pbeFixP = new PricebookEntry(pricebook2Id=pbFixedPriceList, Product2Id=pr.id, UnitPrice=12000, CurrencyIsoCode='JPY', IsActive=true);//ALLIEDTELESIS-568 terrasky D.Ariga add
        insert pbeFixP;
        
        //月別標準価格を準備 -
        PricebookEntry pbeMntlyFixP = new PricebookEntry(pricebook2Id=pbSS.id, Product2Id=pr.id, UnitPrice=10000, CurrencyIsoCode='JPY', IsActive=true);
        pbeL.add(pbeMntlyFixP);
        
        //仕切価格を登録 -
        PricebookEntry pbeDscntP = new PricebookEntry(pricebook2Id=pbA1.id, Product2Id=pr.id, UnitPrice=8000, CurrencyIsoCode='JPY', IsActive=true);
        pbeL.add(pbeDscntP);
        
        insert pbeL;
        
        
        //Accountを準備 -
        List<RecordType> RecordTypeList = [select ID from RecordType where SObjectType ='Account' and DeveloperName ='JP_AccountsBeforeCleansing'];
        
        Account ac01 = new Account(Name='TEST-ACC', recordtypeId=RecordTypeList[0].id, Website='http://testtest');
        ac01.BillingCountry = 'Japan';
        insert ac01;
        
        //商談を準備 -
        RecordType rt = [SELECT id FROM RecordType WHERE SobjectType='opportunity' AND DeveloperName='JP_Opportunity'];
        
        Opportunity opp01 = new Opportunity(Name='TEST-OPP', recordtypeId=rt.Id, AccountId=ac01.id, Pricebook2Id=pbA1.id, StageName='Prospect/Qualification - APAC', CloseDate=Date.newInstance(2000, 12, 31), CurrencyIsoCode='JPY',amount =1000,JP_OrderDate__c=Date.newInstance(2000, 12, 31),JP_AtkkAccuracy__c='半々',JP_DistributorAccuracy__c='半々',JP_OppMailAilias__c='test@test.test.test',JP_MailFlag__c=false);
        
        Test.startTest();
        insert opp01;
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId=opp01.id, PricebookEntryId=pbeDscntP.id, UnitPrice=7000, Quantity=1);
        insert oli;
        
        Test.stopTest();
    }
}