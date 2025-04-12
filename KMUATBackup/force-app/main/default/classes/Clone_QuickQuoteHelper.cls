public class Clone_QuickQuoteHelper
{
    
    public static boolean recurssion = false;
    
    public static void OriginalQuoteClone(list<SBQQ__Quote__c> triggernew)
    {
          

       
       map<ID,ID> Originalkeys = new map<ID,ID>();
       list<SBQQ__QuoteLine__c> qLines = new list<SBQQ__QuoteLine__c>(); 
       list<SBQQ__QuoteLine__c> qserviceLines = new list<SBQQ__QuoteLine__c>();  // sarvinder - new list for service quote line items
       list<SBQQ__Quote__c>  Quotes = new list<SBQQ__Quote__c>();
       String PricebookName = '';
       set<ID> productIds = new set<ID>();   
       set<ID> filterProductIds = new set<ID>();           
       list<SBQQ__QuoteLine__c> Quotelines = new list<SBQQ__QuoteLine__c>(); 
       
       map<ID,SBQQ__QuoteLine__c> OldtoNewQL = new map<ID,SBQQ__QuoteLine__c>(); // sarvinder - Old  quote line item ID to new quote line item mapping 
       
       
       set<ID> OldQuotIds = new set<ID>(); 
       list<SBQQ__Quote__c>  OldQuotes = new list<SBQQ__Quote__c>();
       map<ID,string> OldQuotPb = new map<ID,string>();
       for(SBQQ__Quote__c  oQuote: triggernew)
       {
           OldQuotIds.add(oQuote.Original_ID__c);
       }
       OldQuotes = [Select id, Quote_To_Pricebook_Name__c from SBQQ__Quote__c where id IN:OldQuotIds];
       for(SBQQ__Quote__c  oldQuot: OldQuotes )
       {
           OldQuotPb.put(oldQuot.id,oldQuot.Quote_To_Pricebook_Name__c);
       }
        
        
        
        for(SBQQ__Quote__c  oQuote: triggernew)
        {
           system.debug('### PLM value in quote trigger ###' + oQuote.ATFE_PLM_s__c);
            system.debug('### TESTING ::: oQuote.Quote_To_Pricebook_Name__c ###' + oQuote.Quote_To_Pricebook_Name__c);
            system.debug('### TESTING ::: oQuote.SBQQ__Account__r.ATFE_Price_Book__c ### ' +  oQuote.SBQQ__Account__r.ATFE_Price_Book__c);
            
             system.debug('### TESTING ::: old Quote oQuote.SBQQ__Account__r.ATFE_Price_Book__c ### ' + OldQuotPb.get(oQuote.Original_ID__c));
          // PricebookName = oQuote.Quote_To_Pricebook_Name__c;
          PricebookName  = OldQuotPb.get(oQuote.Original_ID__c);
          
           
   /*  if(oQuote.Quote_To_Pricebook_Name__c != oQuote.Pricebook_Nam__c){
         oQuote.addError('You can not clone this Quote With Products since Account PriceBook has been changed from' +' '+'"'+oQuote.Quote_To_Pricebook_Name__c+'"'+' '+ 'to' +' '+'"'+oQuote.Pricebook_Nam__c+'"');  //Kranthi
     }   */    
           system.debug('### oQuote.Original_ID__c ###' + oQuote.Original_ID__c );
            if(oQuote.Original_ID__c != null)
                {
                   Originalkeys.put(oQuote.Original_ID__c,oQuote.ID); 
                   SBQQ__Quote__c  tempQuote  = new SBQQ__Quote__c(ID=oQuote.ID,Original_ID__c = '');
                       Quotes.add(tempQuote);
                }
        }
        
          /*
              insert line groups
          */
          list<SBQQ__QuoteLineGroup__c> lineGroups = new list<SBQQ__QuoteLineGroup__c>();
          
          for(SBQQ__QuoteLineGroup__c linegroup : [SELECT ID,
                                                          Name,
                                                          SBQQ__Quote__c,
                                                          SBQQ__AdditionalDiscountRate__c,
                                                          Clone_From__c,
                                                          SBQQ__CustomerTotal__c,
                                                          SBQQ__Description__c,
                                                          SBQQ__EndDate__c,
                                                          SBQQ__ListTotal__c,
                                                          SBQQ__MarkupRate__c,
                                                          SBQQ__NetTotal__c,
                                                          SBQQ__Number__c,
                                                          SBQQ__Optional__c,
                                                          SBQQ__SolutionGroup__c,
                                                          SBQQ__QuoteProcess__c,
                                                          SBQQ__Source__c,
                                                          SBQQ__StartDate__c,
                                                          SBQQ__SubscriptionTerm__c
                                                    FROM SBQQ__QuoteLineGroup__c 
                                                    WHERE SBQQ__Quote__c IN:Originalkeys.keyset()
                                                    ORDER BY Name ])          
          {
              SBQQ__QuoteLineGroup__c  temp = linegroup.clone(false);                
                temp.SBQQ__Quote__c = Originalkeys.get(linegroup.SBQQ__Quote__c);  
                temp.Clone_From__c = ''+linegroup.ID;
                
                lineGroups.add(temp);                                                                                                
          }
          system.debug('### lineGroups.size() ###' + lineGroups.size() );
          if(lineGroups.size() > 0)
          {
              system.debug(':::: inserting lineGroups :::: '+ lineGroups );
              insert lineGroups;
          }
          
          map<ID,ID> lineGroupsClone = new map<ID,ID>();
          for(SBQQ__QuoteLineGroup__c   clGroup : lineGroups)
          {
              lineGroupsClone.put(clGroup.Clone_From__c ,clGroup.ID);
          }
          
          
          /*
              insert line groups
          */

                                  
        Map<String, Schema.SObjectField> fldObjMap = schema.SObjectType.SBQQ__QuoteLine__c.fields.getMap();
        List<Schema.SObjectField> fldObjMapValues = fldObjMap.values();
        
        String theQuery = 'SELECT ';
        for(Schema.SObjectField s : fldObjMapValues)
        {
           String theLabel = s.getDescribe().getLabel(); 
           String theName = s.getDescribe().getName();
                           
           theQuery += theName + ',';
        }
        
        // Trim last comma
        theQuery = theQuery.subString(0, theQuery.length() - 1);        
         Set<ID> keys = Originalkeys.keySet();               
        theQuery += ' ,SBQQ__Product__r.IsActive  FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c  IN :keys' ;                                                               
        
         Quotelines =  Database.query(theQuery);            
          for(SBQQ__QuoteLine__c oQlineitem : Quotelines )
          {
              if(oQlineitem.SBQQ__Product__r.IsActive)
              {
                  productIds.add(oQlineitem.SBQQ__Product__c);            
              }
              
          }
          List<Product2> prdt = new List<Product2>();
          prdt =  [Select ID,IsActive, (Select Id, Name, Pricebook2Id,Pricebook2.IsActive, Pricebook2.Name,Product2Id, IsActive From PricebookEntries WHERE IsActive = true ) From Product2 p WHERE ID IN: productIds];
          for(Product2 pr : prdt )  
          {
              for(pricebookEntry entry : pr.PricebookEntries)
              {
                  if(entry.Pricebook2.Name == PricebookName)
                  {
                    filterProductIds.add(pr.ID);
                  }
                  
              }  
          }  
          
          for(SBQQ__QuoteLine__c oQlineitem : Quotelines )
          {
              if(filterProductIds.contains(oQlineitem.SBQQ__Product__c)&& oQlineitem.SBQQ__Product__r.IsActive )
              {                 

                  SBQQ__QuoteLine__c  temp = oQlineitem.clone(false);
                  temp.SBQQ__Quote__c = Originalkeys.get(oQlineitem.SBQQ__Quote__c); 
                  temp.SBQQ__Group__c = lineGroupsClone.get(oQlineitem.SBQQ__Group__c);
                  OldtoNewQL.put(oQlineitem.id,temp);                     // sarvinder -  put old Quote line ID and new temp item.
                  if(oQlineitem.ATFE_Product_Family__c == 'PRODUCT')      // sarvinder - keep products and services separate as we need to insert products first to have IDs.                                                       
                      qLines.add(temp);
                  else
                      qserviceLines.add(temp);
              }
              
          }             
         system.debug(':::: inserting qLines :::: '+ qLines );    
          insert qLines;
          
          for(SBQQ__QuoteLine__c  Service_QLITEM: qserviceLines)         // sarvinder - loop through all services 
          {
              if(Service_QLITEM.SBQQ__RequiredBy__c!=null)                // sarvinder - if a service is dependent on a product line item
              {
                  SBQQ__QuoteLine__c  prodctQL_temp  = OldtoNewQL.get(Service_QLITEM.SBQQ__RequiredBy__c); // sarvinder - get the new product quote line item corresponding to old ID
                  system.debug('Old ID::'+ Service_QLITEM.SBQQ__RequiredBy__c);
                  system.debug('New ID::'+ prodctQL_temp.id);
                  Service_QLITEM.SBQQ__RequiredBy__c = prodctQL_temp.id; // sarvinder - replace the ID with new product quote line item id
              }
          }
           system.debug(':::: inserting qserviceLines:::: '+ qserviceLines);
          insert qserviceLines;
           
          if(Quotes.size() > 0)
          {             
              recurssion = true; 
              system.debug('### updating Quotes - 1 ### '+ Quotes);         
              update Quotes;  
              system.debug('### updating Quotes - 2 ### '+ Quotes);  
          }
          

    }


}