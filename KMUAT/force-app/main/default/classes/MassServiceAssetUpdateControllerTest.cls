@isTest(seealldata=true)
public class MassServiceAssetUpdateControllerTest
{
    public static testmethod void testm()
    {
        
       //Channelinsight.CI_TEST_TestUtils.createBaseInstallData();
        // Create Account
        Account ac = new Account();
        ac.Name='Test Account';
        ac.ATFE_Active__c=true;
        ac.Region__c='NA';
        ac.Sub_Region__c='USA';
        ac.ATFE_AccountType__c='End Customer';
        ac.ATFE_SalesOrgName__c='Aviation-Defense-Federal';
        //ac.Partner_Status__c='Silver';
        ac.ATFE_VerticalMarketInit__c='Government';
        ac.Website='www.csc.com';
        insert ac;
        system.debug('@@@@ac'+ac.Id); 
        
        // Create Product
        list<Product2> products = new list<Product2>();
        products.add(new Product2(Name='Test Product1',Family='SERVICE'));
        products.add(new Product2(Name='Test Product2',Family='SERVICE'));
        insert products;
        
        list<Pricebook2> pb = new list<Pricebook2>();
        pb=[select id,Name from Pricebook2 where Name='APAC DIST (USD)'];
        
        // Create price book entry
       
        
        Pricebook2 standardPB = new Pricebook2();
        standardPB=[select id from Pricebook2 where isStandard=true];
        
        list<PricebookEntry> standardPrice = new list<PricebookEntry>();
        standardPrice.add(new PricebookEntry(Pricebook2Id = standardPB.Id, CurrencyIsoCode='USD', Product2Id =products[0].Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false));
        standardPrice.add(new PricebookEntry(Pricebook2Id = standardPB.Id, CurrencyIsoCode='USD', Product2Id =products[1].Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false));
        insert standardPrice;
        
         list<Pricebookentry> pricebookentries = new list<Pricebookentry>();
        pricebookentries.add(new Pricebookentry(UnitPrice=2000,Pricebook2Id=pb[0].id,Product2Id=products[0].Id,IsActive=true,UseStandardPrice = false));
        pricebookentries.add(new Pricebookentry(UnitPrice=3000,Pricebook2Id=pb[0].id,Product2Id=products[1].Id,IsActive=true,UseStandardPrice = false));
        
        insert pricebookentries;
        
        
        list<Service_Asset__c> servAssts = new list<Service_Asset__c>();
        
        servAssts.add(new Service_Asset__c(Service_Product__c=products[0].Id,Start_Date__c=system.today(),End_Date__c=system.today()+3,Purchase_Information__c='test'));
        servAssts.add(new Service_Asset__c(Service_Product__c=products[1].Id,Start_Date__c=system.today(),End_Date__c=system.today()+3,Purchase_Information__c='test'));
        // servAssts.add(new Service_Asset__c(Service_Product__c=products[2].Id,Start_Date__c=system.today(),End_Date__c=system.today()+3,Purchase_Information__c='test'));
        insert servAssts;
        
        system.debug('@@@@servAssts'+servAssts);
        Test.startTest();
        
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(servAssts);
        stdSetController.setSelected(servAssts);
        MassServiceAssetUpdateController ext = new MassServiceAssetUpdateController(stdSetController);
        Test.setCurrentPage(Page.Mass_Service_Asset_Update);
        ext.massUpdate();
        Test.stopTest();
        

        
        
    }
}