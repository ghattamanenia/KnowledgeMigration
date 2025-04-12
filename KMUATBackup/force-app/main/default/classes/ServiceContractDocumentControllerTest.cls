@isTest (seeAllData=true)
public class ServiceContractDocumentControllerTest
{
    public static testmethod void testm()
    {
        //Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
        
        // Create Account 
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('ATI Accounts').getRecordTypeId();
        Account acc = new Account();
        acc.Name='Test Account';
        acc.RecordTypeId=devRecordTypeId;
        acc.Region__c='NA';
        acc.ATFE_AccountType__c='End Customer';
        acc.ATFE_VerticalMarketInit__c='Defense';
        acc.Website='www.csc.com';
        acc.OCRINCEASE__OCR_AccountId__c ='xyz';
        insert acc;
        
        Contact con = new Contact();
        con.LastName='Test';
        con.Email='neha@mgail.com';
        con.AccountId=acc.Id;
        insert con;
        
        // Create Product
        list<Product2> products = new list<Product2>();
        products.add(new Product2(Name='Test Product1f',Family='SERVICE',Description='Lightwight product - of king for the nation'));
        products.add(new Product2(Name='Test Product2ff'));
        insert products;
        
         Pricebook2 standardPB = new Pricebook2();
        standardPB=[select id from Pricebook2 where isStandard=true];
        
        list<PricebookEntry> standardPrice = new list<PricebookEntry>();
        standardPrice.add(new PricebookEntry(Pricebook2Id = standardPB.Id, CurrencyIsoCode='USD', Product2Id =products[0].Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false));
        standardPrice.add(new PricebookEntry(Pricebook2Id = standardPB.Id, CurrencyIsoCode='USD', Product2Id =products[1].Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false));
        insert standardPrice;
        
        Service_Asset__c sa= new Service_Asset__c();
        sa.Service_Product__c=products[0].Id;
        sa.Account__c=acc.Id;
        insert sa;
        
        
        servicecontract sc = new servicecontract();
        sc.Name='Test contract';
        sc.AccountId=acc.Id;
        sc.ContactId=con.Id;
        sc.Service_Asset__c=sa.Id;
        insert sc;
        
        system.debug('@@@@sc'+sc);
        /*
        sa.Service_Contract__c=sc.Id;
        update sa; */
        
        ApexPages.currentpage().getParameters().put('Id',sc.Id);
        
        ApexPages.StandardController stdc = new ApexPages.StandardController(sc);
        system.debug('@@@@stdc'+stdc);
        ServiceContractDocumentController scd = new ServiceContractDocumentController(stdc);
        
        
        ServiceContractDocumentWrap scdw = new ServiceContractDocumentWrap('','','','',system.today(),system.today()+2);
        
        
        
    }
}