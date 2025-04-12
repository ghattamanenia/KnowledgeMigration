@isTest (seeAllData=true)
public class ServiceAssetMassUpdateCTRLTest
{
    public static testMethod void testM()
    {
        Test.startTest();
        user u = new user();
        u=[select id from user where profile.name='System Administrator' and isactive=true limit 1];
        
       // Channelinsight.CI_TEST_TestUtils.createBaseInstallData();  Neha commented for model n package uninstallation
        // Create Account
        Account ac = new Account();
        ac.Name='Test Account';
        ac.ATFE_Active__c=true;
        ac.Region__c='NA';
        ac.Sub_Region__c='USA';
        ac.ATFE_AccountType__c='End Customer';
        ac.ATFE_SalesOrgName__c='Aviation-Defense-Federal';
        ac.Partner_Status__c='Silver';
        ac.ATFE_VerticalMarketInit__c='Government';
        ac.Website='www.csc.com';
        insert ac;
        system.debug('@@@@ac'+ac.Id);
        
        // Create Product
        list<Product2> products = new list<Product2>();
        products.add(new Product2(Name='Test Product1',ATFE_ProdAvailCode__c='EOS',family='SERVICE',ATFE_Service_Product_Type__c='NCA-1'));
        products.add(new Product2(Name='Test Product1',family='SERVICE',ATFE_Service_Product_Type__c='NCA-1'));
        products.add(new Product2(Name='Test Product2',family='SERVICE',ATFE_Service_Product_Type__c='NCA-1'));
        insert products;
        
         // Create price book entry
       
        
        Pricebook2 standardPB = new Pricebook2();
        standardPB=[select id from Pricebook2 where isStandard=true];
        
        list<PricebookEntry> standardPrice = new list<PricebookEntry>();
        standardPrice.add(new PricebookEntry(Pricebook2Id = standardPB.Id, CurrencyIsoCode='USD', Product2Id =products[0].Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false));
        standardPrice.add(new PricebookEntry(Pricebook2Id = standardPB.Id, CurrencyIsoCode='USD', Product2Id =products[1].Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false));
        insert standardPrice;
        
        
        List<Service_Asset__c> SAsToInsert = new List<Service_Asset__c>();
        SAsToInsert.add(new Service_Asset__c(Service_Product__c=products[0].Id,Account__c=ac.Id,Start_Date__c=system.today()));
        SAsToInsert.add(new Service_Asset__c(Service_Product__c=products[1].Id,Account__c=ac.Id,Start_Date__c=system.today()));
        insert SAsToInsert;
        /*
        SAsToInsert[0].Start_Date__c =system.today()+1;
        SAsToInsert[0].End_Date__c  = system.today()+1;
        SAsToInsert[0].Purchase_Information__c='Test';
        
        SAsToInsert[1].Start_Date__c =system.today()+1;
        SAsToInsert[1].End_Date__c  = system.today()+1;
        SAsToInsert[1].Purchase_Information__c='Test';
         */
        
        ApexPages.currentPage().getParameters().put('id',ac.Id);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(SAsToInsert);
        stdSetController.setSelected(SAsToInsert);
        ServiceAssetMassUpdateCTRL sam= new ServiceAssetMassUpdateCTRL(stdSetController);
        sam.saMassupdate.Start_Date__c =system.today()+1;
        sam.saMassupdate.End_Date__c  =system.today()+1;
        sam.saMassupdate.Purchase_Information__c ='Test';
        
        sam.onload();
        sam.Save(); 
        
        
    }
}