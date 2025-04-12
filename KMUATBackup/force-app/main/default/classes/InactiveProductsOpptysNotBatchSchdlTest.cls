@isTest
public class InactiveProductsOpptysNotBatchSchdlTest
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
        insert acc;
        
        
        // Create 3 opportunities
        list<Opportunity> opptys = new list<Opportunity>();
        Id OppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('ATI Opportunity').getRecordTypeId();
        
        for(Integer i=1;i<=3;i++)
        Opptys.add(new Opportunity(RecordTypeId=OppRecordTypeId,AccountId=acc.Id,Name='Test'+i,ATFE_Opportunity_Type__c='Standard',CloseDate=system.today()+5,StageName='Prospect/Qualification',Required_Delivery_Date__c=system.today()+7,ForecastCategoryName='Pipeline',ATFE_Solution_Application__c='Business to Business (B2B)',ATFE_Competitor__c='Not Applicable',ATFE_Fulfillment__c='Direct'));
        
        if(!opptys.isempty())
        insert opptys;
        
        Id stdPriceBookRecId = Test.getStandardPricebookId();

        
        // Create two products with active 
        
        list<Product2> products = new list<Product2>();
        products.add(new Product2(Name='Test prod1',isactive=true,ProductCode='x',ATFE_NA__c=true));
        products.add(new Product2(Name='Test prod2',isactive=true,ProductCode='y',ATFE_NA__c=true));
        if(!products.isempty())
        insert products; 
        
        // Create price book entry for product 1
        
         
        PriceBookEntry stdPriceBookEntry1 = new PriceBookEntry();
        stdPriceBookEntry1.Product2Id=products[0].Id;
        stdPriceBookEntry1.Pricebook2Id=stdPriceBookRecId;
        stdPriceBookEntry1.UnitPrice=2000;
        stdPriceBookEntry1.IsActive=true;
        insert stdPriceBookEntry1;
        
        // Create price book entry for product 2
        
         
        PriceBookEntry stdPriceBookEntry2 = new PriceBookEntry();
        stdPriceBookEntry2.Product2Id=products[1].Id;
        stdPriceBookEntry2.Pricebook2Id=stdPriceBookRecId;
        stdPriceBookEntry2.UnitPrice=2000;
        stdPriceBookEntry2.IsActive=true;
        insert stdPriceBookEntry2;
        
        // Create 2 opportunity line items under each of these three opptys
        
        list<OpportunityLineItem> OpLineItems = new list<OpportunityLineItem>();
        
        for(Opportunity op:opptys)
        {
            
                OpLineItems.add(new OpportunityLineItem(UnitPrice=25,Quantity=2,OpportunityId=op.Id,ServiceDate=system.today(),PricebookEntryId =stdPriceBookEntry1.Id));
                OpLineItems.add(new OpportunityLineItem(UnitPrice=25,Quantity=2,OpportunityId=op.Id,ServiceDate=system.today(),PricebookEntryId =stdPriceBookEntry2.Id));
            
            
        }
        
        if(!opLineItems.isempty())
        insert OpLineItems;
        
         // update the products status to inactive
         
         Products[0].ATFE_ProdAvailCode__c='EOS';
         products[1].ATFE_ProdAvailCode__c='EOS';
         update products;
         
         
         
         // call the schedule class pertaining to batch class 
         
         InactiveProductsOpptysNotBatchSchdl iob = new InactiveProductsOpptysNotBatchSchdl();
         iob.execute(null);
         
    }
}