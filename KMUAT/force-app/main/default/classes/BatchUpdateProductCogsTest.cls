/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This is the test class to test the BatchUpdateOpportunityProductCogs apex class.
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author            FusionGS
* @version           1.0
* @createDate        2023-March-02
* @systemLayer       Apex Service
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* v1.0             FusionGS
* YYYY-MMM-DD      2023-March-02
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
@isTest
public class BatchUpdateProductCogsTest {
    @isTest
    static void testUpdateProductCogs() {
        User testSystemAdmin = ATFE_TestMethodUtility.getTestUserWithProfileAndRole('System Administrator', 'ATI');
        insert testSystemAdmin;
       // user u = new user();
        //u=[select id from user where profile.name='System Administrator' and isactive=true limit 1];
        system.runas(testSystemAdmin){
            
            List<Product2> listproduct = new list<Product2>();
            for(Integer i=0; i<500;i++){
                Product2 product = new Product2(Name = 'Test Product'+i, ATFE_Cost__c = i);
                listproduct.add(product);
            }
            database.insert(listproduct);
            system.debug('*****'+listproduct.size());
            
            
            List<PricebookEntry> listPricebookEntry = new list<PricebookEntry>();
            Id pbeId = Test.getStandardPricebookId();
            for(Product2 p: [select id from Product2]){
                 PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pbeId, Product2Id = p.Id, UnitPrice = 100, IsActive = true);
                listPricebookEntry.add(pbe);
            }
            database.insert(listPricebookEntry);
            
            
            Id APACRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('APAC_Accounts').getRecordTypeId();
            Id NARecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('ATI Accounts').getRecordTypeId();
            Id EMEARecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('EMEA Accounts').getRecordTypeId();
            Id CSARecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Envigilant Account').getRecordTypeId();

            List<Account> listacc = new List<Account>();
            Account EMEAAcc = new Account(Name='Test Account',
                                  Recordtypeid=EMEARecordTypeId,
                                  Region__c='EMEA',
                                  Sub_Region__c='Middle East',
                                  ATFE_SalesOrgName__c='Middle East',
                                  ATFE_AccountType__c='Partner',
                                  BillingCountry='India',
                                  BillingCity = 'billing city',
                                  BillingStreet = 'billing street',
                                  BillingPostalCode = 'billing postal code',
                                  BillingState = 'TN');
            Account NAAcc = new Account(Name='Test Account',
                                  Recordtypeid=NARecordTypeId,
                                  Region__c='NA',
                                  Sub_Region__c='USA',
                                  ATFE_SalesOrgName__c='Channel',
                                  ATFE_AccountType__c='Partner',
                                  BillingCountry='United States',
                                  BillingCity = 'billing city',
                                  BillingStreet = 'billing street',
                                  BillingPostalCode = 'billing postal code',
                                  BillingState = 'TX');
            Account APACAcc = new Account(Name='Test APAC Account',
                                  Recordtypeid=APACRecordTypeId,
                                  Region__c='APAC',
                                  Sub_Region__c='China',
                                  ATFE_SalesOrgName__c='China',
                                  ATFE_AccountType__c='Partner',
                                  BillingCountry='China',
                                  BillingCity = 'billing city',
                                  BillingStreet = 'billing street',
                                  BillingPostalCode = 'billing postal code',
                                  BillingState = 'HK');
           Account CSAcc = new Account(Name='Test CSA Account',
                                  Recordtypeid=CSARecordTypeId,
                                  Region__c='CSA',
                                  Sub_Region__c='South America',
                                  ATFE_SalesOrgName__c='Brazil',
                                  ATFE_AccountType__c='Partner',
                                  BillingCountry='India',
                                  BillingCity = 'billing city',
                                  BillingStreet = 'billing street',
                                  BillingPostalCode = 'billing postal code',
                                  BillingState = 'TN'); 
            listacc.add(EMEAAcc);
            listacc.add(NAAcc);
            listacc.add(APACAcc);
            listacc.add(CSAcc);
            insert listacc;   
            
            List<Opportunity> listopp = new List<Opportunity>();
            Id EMEAaccid = [select id, name from account where Region__c='EMEA' limit 1].Id;
            Id NAaccid = [select id, name from account where Region__c='NA' limit 1].Id;
            Id APACaccid = [select id, name from account where Region__c='APAC' limit 1].Id;
            Id CSAaccid = [select id, name from account where Region__c='CSA' limit 1].Id;
            Opportunity EMEAopp = new Opportunity(Name = 'Test EMEAOpportunity', Accountid=EMEAaccid,StageName = 'Prospect/Qualification', CloseDate = Date.today().addDays(30),Required_Delivery_Date__c =Date.today().addDays(60));
            listopp.add(EMEAopp);
            Opportunity NAopp = new Opportunity(Name = 'Test NAOpportunity', Accountid=NAaccid,StageName = 'Prospect/Qualification', CloseDate = Date.today().addDays(30),Required_Delivery_Date__c =Date.today().addDays(60));
            listopp.add(NAopp);
            Opportunity APACopp = new Opportunity(Name = 'Test APACOpportunity', Accountid=APACaccid,StageName = 'Prospect/Qualification', CloseDate = Date.today().addDays(30),Required_Delivery_Date__c =Date.today().addDays(60));
            listopp.add(APACopp);
            Opportunity CSAopp = new Opportunity(Name = 'Test CSAOpportunity', Accountid=CSAaccid,StageName = 'Prospect/Qualification', CloseDate = Date.today().addDays(30),Required_Delivery_Date__c =Date.today().addDays(60));
            listopp.add(CSAopp);
            insert listopp;
            
            
            
            list<OpportunityLineItem> listopplineitem = new list<OpportunityLineItem>();
            
            OpportunityLineItem EMEAoppProduct = new OpportunityLineItem(OpportunityId = listopp[0].Id, PricebookEntryId = listPricebookEntry[0].Id, Quantity = 1, UnitPrice = 100);
            listopplineitem.add(EMEAoppProduct);
            OpportunityLineItem NAoppProduct = new OpportunityLineItem(OpportunityId = listopp[1].Id, PricebookEntryId = listPricebookEntry[0].Id, Quantity = 1, UnitPrice = 100);
            listopplineitem.add(NAoppProduct);
            OpportunityLineItem APACoppProduct = new OpportunityLineItem(OpportunityId = listopp[2].Id, PricebookEntryId = listPricebookEntry[0].Id, Quantity = 1, UnitPrice = 100);
            listopplineitem.add(APACoppProduct);
            OpportunityLineItem CSAoppProduct = new OpportunityLineItem(OpportunityId = listopp[3].Id, PricebookEntryId = listPricebookEntry[0].Id, Quantity = 1, UnitPrice = 100);
            listopplineitem.add(CSAoppProduct);
            insert  listopplineitem;
            Test.startTest();
            // Create Quote
            Id EMEAOppid = [select id, name from Opportunity where Accountid=:EMEAaccid limit 1].Id;
            Id NAOppid = [select id, name from Opportunity where  Accountid=:NAaccid limit 1].Id;
            Id APACOppid = [select id, name from Opportunity where Accountid=:APACaccid limit 1].Id;
            Id CSAOppid = [select id, name from Opportunity where Accountid=:CSAaccid limit 1].Id;
            list<SBQQ__Quote__c> Quotes = new list<SBQQ__Quote__c>();
            Quotes.add(new SBQQ__Quote__c(ATFE_Quote_Name__c = 'EMEA Quote', ATFE_SPQ_Approved__c=false,SBQQ__Opportunity2__c=EMEAOppid,SBQQ__Account__c=EMEAaccid));
            Quotes.add(new SBQQ__Quote__c(ATFE_Quote_Name__c = 'NA Quote', ATFE_SPQ_Approved__c=false,SBQQ__Opportunity2__c=NAOppid,SBQQ__Account__c=NAaccid));
            Quotes.add(new SBQQ__Quote__c(ATFE_Quote_Name__c = 'APAC Quote', ATFE_SPQ_Approved__c=false,SBQQ__Opportunity2__c=APACOppid,SBQQ__Account__c=APACaccid));
            Quotes.add(new SBQQ__Quote__c(ATFE_Quote_Name__c = 'CSA Quote', ATFE_SPQ_Approved__c=false,SBQQ__Opportunity2__c=CSAOppid,SBQQ__Account__c=CSAaccid));
            ATFE_PLMUpdateOnQuickQuoteHelper.DoNotRunATFE_SBBQQuoteLineTrigger =true;
            insert Quotes;
         
        
            // Create Quote Line Items
            
            List<SBQQ__QuoteLine__c> QuoteLinesToCreate = new list<SBQQ__QuoteLine__c>();
            QuoteLinesToCreate.add(new SBQQ__QuoteLine__c(SBQQ__Product__c=listproduct[0].Id,SBQQ__Quantity__c=200,MSRP_Price__c=5008,SBQQ__Quote__c=Quotes[0].Id));
            //QuoteLinesToCreate.add(new SBQQ__QuoteLine__c(SBQQ__Product__c=listproduct[1].Id,SBQQ__Quantity__c=200,MSRP_Price__c=5090,SBQQ__Quote__c=Quotes[1].Id));
            //QuoteLinesToCreate.add(new SBQQ__QuoteLine__c(SBQQ__Product__c=listproduct[2].Id,SBQQ__Quantity__c=200,MSRP_Price__c=5007,SBQQ__Quote__c=Quotes[2].Id));
            //QuoteLinesToCreate.add(new SBQQ__QuoteLine__c(SBQQ__Product__c=listproduct[3].Id,SBQQ__Quantity__c=200,MSRP_Price__c=5005,SBQQ__Quote__c=Quotes[3].Id));
            //QuoteLinesToCreate.add(new SBQQ__QuoteLine__c(SBQQ__Product__c=listproduct[4].Id,SBQQ__Quantity__c=200,MSRP_Price__c=50005,SBQQ__Quote__c=Quotes[0].Id));
            //QuoteLinesToCreate.add(new SBQQ__QuoteLine__c(SBQQ__Product__c=listproduct[5].Id,SBQQ__Quantity__c=200,MSRP_Price__c=5003,SBQQ__Quote__c=Quotes[1].Id));
            //QuoteLinesToCreate.add(new SBQQ__QuoteLine__c(SBQQ__Product__c=listproduct[6].Id,SBQQ__Quantity__c=200,MSRP_Price__c=5002,SBQQ__Quote__c=Quotes[2].Id));
            //QuoteLinesToCreate.add(new SBQQ__QuoteLine__c(SBQQ__Product__c=listproduct[7].Id,SBQQ__Quantity__c=200,MSRP_Price__c=5002,SBQQ__Quote__c=Quotes[3].Id));
            ATFE_PLMUpdateOnQuickQuoteHelper.DoNotRunATFE_SBBQQuoteLineTrigger =true;
            insert QuoteLinesToCreate;
            test.stopTest();
            // Product update
            List<Product2> listproductupdate = new list<Product2>();
            for(Product2 pu: [select id from Product2 limit 500]){
                Product2 Productupdate = new Product2();
                Productupdate.id = pu.id;
                Productupdate.ATFE_Cost__c = 200;
                listproductupdate.add(Productupdate);
            }
            ATFE_PLMUpdateOnQuickQuoteHelper.DoNotRunATFE_SBBQQuoteLineTrigger =true;
            update listproductupdate;
            // To Cover the Product Trigger
            Product2 pupdate = [select id,Name from Product2 limit 1];
            pupdate.Name='Testing';
            update pupdate;
        }
    }
}