public  class ATFE_PLMUpdateOnQuickQuoteHelper {

public static boolean DoNotRunATFE_SBBQQuoteLineTrigger = false;

public static void updateQuickQuotePLMOnInsert(Set<Id> quoteIds)
{
        updatePLM(quoteIds,null);
        if(!Test.IsRunningTest())
            updatePLM2(quoteIds,null);
            updatePLM3(quoteIds,null);
}

public static void updateQuickQuotePLMAysncOnDelete(Set<Id> quoteIds,Set<Id> qliIds){
    updatePLM(quoteIds,qliIds);
    if(!Test.IsRunningTest())
        updatePLM2(quoteIds,qliIds);
        updatePLM3(quoteIds,qliIds);
}

/* ------------------------------------------ NA / CSA --------------------------------------------------
 --------------------------------------------------------------------------------------------------------*/

public static void updatePLM(Set<Id> quoteIds,Set<Id> qliIds)
{

        Map<String,ATFE_ProductTypePLM__c> plmMap = ATFE_ProductTypePLM__c.getAll();
        List<SBQQ__Quote__c> quotesToUpdate = new List<SBQQ__Quote__c>();

        String plmOwners = '' , plmOwners2 = '' ;
        List<String> ownerList , ownerList2  ;
        Set<String> plmsSet , plmsSet2 ;    
     
        List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
         quoteList = [select ATFE_PLM_s__c ,SBQQ__NetAmount__c,Quote_To_Region__c,(select id ,SPQ_Discount__c,sbqq__Discount__c , ATFE_Product_Type__c from SBQQ__LineItems__r where id not in :qliIds) from SBQQ__Quote__c where id in :quoteIds   ];
        for(SBQQ__Quote__c quote : quoteList ){
            plmOwners = '';
 
            ownerList = new List<String>();
            ownerList2 = new List<String>();
            plmsSet  = new Set<String>();   
            plmsSet2 = new Set<String>();
             
        if ( quote.Quote_To_Region__c == 'NA' || quote.Quote_To_Region__c == 'CSA' ) {
            for(SBQQ__QuoteLine__c qli : quote.SBQQ__LineItems__r){
                
                if(qli.ATFE_Product_Type__c != null && plmMap.containsKey(qli.ATFE_Product_Type__c))
                {                    
                    String str = plmMap.get(qli.ATFE_Product_Type__c).ATFE_Product_Owner__c ;
                     String strmang = plmMap.get(qli.ATFE_Product_Type__c).PLM_Management__c ;
                    if(!plmsSet.contains(str))
                    {
                        ownerList.add(str);
                        plmsSet.add(str);
                    }
                    if(!plmsSet2.contains(strmang))
                    {
                        ownerList2.add(strmang);
                        plmsSet2.add(strmang);
                    } 
                  
                }
                    
            }
            SBQQ__Quote__c quoteObj = new  SBQQ__Quote__c(id = quote.id ); 
             if(ownerList != null && ownerList.size() > 0){
                    ownerList.sort();
                    for(String str : ownerList){
                        plmOwners += str ;
                        plmOwners += ',';
                    }
                    plmOwners = plmOwners.trim();
                    plmOwners = plmOwners.subString(0,plmOwners.length() - 1);
                    System.debug('plmOwners:'+plmOwners);
                    quoteObj.ATFE_PLM_s__c = plmOwners;
                    
            }  
            if(ownerList2 != null && ownerList2.size() > 0){
                    ownerList2.sort();
                    for(String strmang : ownerList2){
                        plmOwners2 += strmang ;
                        plmOwners2 += ',';
                    }
                    plmOwners2 = plmOwners2.trim();
                    plmOwners2 = plmOwners2.subString(0,plmOwners2.length() - 1);
                    System.debug('plmOwners2 :'+ plmOwners2 );
                    quoteObj.ATFE_PLM_Managements__c = plmOwners2 ;
                    
            }
            else 
                quoteObj.ATFE_PLM_s__c = 'None';
             
            quotesToUpdate.add(quoteObj);
            
            If (quoteObj.ATFE_PLM_s__c == 'None'){
            
                  quoteObj.ATFE_PLM_Managements__c = 'None' ;
                  
               }
            }
        }
        if(quotesToUpdate != null && quotesToUpdate.size() > 0)
            update quotesToUpdate ;  
                           
  }

 /* ---------------------------------------------- APAC -------------------------------------------------
 --------------------------------------------------------------------------------------------------------  */
  
  
  public static void updatePLM2(Set<Id> quoteIds,Set<Id> qliIds)
{

        Map<String,ATFE_ProductTypePLM__c> plmMap = ATFE_ProductTypePLM__c.getAll();
        List<SBQQ__Quote__c> APACquotesToUpdate = new List<SBQQ__Quote__c>();

        String APACplmOwners = '' , APACplmOwners2 = '' ;
        List<String> APACownerList , APACownerList2  ;
        Set<String> APACplmsSet , APACplmsSet2 ;   
     
        List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
         quoteList = [select APAC_PLM__c ,SBQQ__NetAmount__c,Quote_To_Region__c,(select id ,SPQ_Discount__c,sbqq__Discount__c , ATFE_Product_Type__c from SBQQ__LineItems__r where id not in :qliIds) from SBQQ__Quote__c where id in :quoteIds   ];
        for(SBQQ__Quote__c quote : quoteList ){
            APACplmOwners = '';
 
            APACownerList = new List<String>();
            APACownerList2 = new List<String>();
            APACplmsSet  = new Set<String>();   
            APACplmsSet2 = new Set<String>();
             
        if ( quote.Quote_To_Region__c == 'APAC' ) {
            for(SBQQ__QuoteLine__c qli : quote.SBQQ__LineItems__r){
                
                if(qli.ATFE_Product_Type__c != null && plmMap.containsKey(qli.ATFE_Product_Type__c))
                {                    
                    String APACstr = plmMap.get(qli.ATFE_Product_Type__c).APAC_Product_Owner__c ;
                     String APACstrmang = plmMap.get(qli.ATFE_Product_Type__c).APAC_PLM_Management__c ;
                    if(!APACplmsSet.contains(APACstr))
                    {
                        APACownerList.add(APACstr);
                        APACplmsSet.add(APACstr);
                    }
                    if(!APACplmsSet2.contains(APACstrmang))
                    {
                        APACownerList2.add(APACstrmang);
                        APACplmsSet2.add(APACstrmang);
                    } 
                  
                }
                    
            }
            SBQQ__Quote__c quoteObj = new  SBQQ__Quote__c(id = quote.id ); 
             if(APACownerList != null && APACownerList.size() > 0){
                    APACownerList.sort();
                    for(String APACstr : APACownerList){
                        APACplmOwners += APACstr ;
                        APACplmOwners += ',';
                    }
                    APACplmOwners = APACplmOwners.trim();
                    APACplmOwners = APACplmOwners.subString(0,APACplmOwners.length() - 1);
                    System.debug('APACplmOwners:'+APACplmOwners);
                    quoteObj.APAC_PLM__c = APACplmOwners;
                    
            }  
            if(APACownerList2 != null && APACownerList2.size() > 0){
                    APACownerList2.sort();
                    for(String APACstrmang : APACownerList2){
                        APACplmOwners2 += APACstrmang ;
                        APACplmOwners2 += ',';
                    }
                    APACplmOwners2 = APACplmOwners2.trim();
                    APACplmOwners2 = APACplmOwners2.subString(0,APACplmOwners2.length() - 1);
                    System.debug('APACplmOwners2 :'+ APACplmOwners2 );
                    quoteObj.APAC_PLM_Management__c = APACplmOwners2 ;
                    
            }
            else 
                quoteObj.APAC_PLM__c = 'None';
             
            APACquotesToUpdate.add(quoteObj);
            
            If (quoteObj.APAC_PLM__c == 'None'){
            
                  quoteObj.APAC_PLM_Management__c = 'None' ;
                  
               }
            }
        }
        if(APACquotesToUpdate != null && APACquotesToUpdate.size() > 0)
            update APACquotesToUpdate ;  
                           
  } 
  
  /* --------------------------------------------- EMEA -------------------------------------------------
 --------------------------------------------------------------------------------------------------------  */
  
  
  public static void updatePLM3(Set<Id> quoteIds,Set<Id> qliIds)
{

        Map<String,ATFE_ProductTypePLM__c> plmMap = ATFE_ProductTypePLM__c.getAll();
        List<SBQQ__Quote__c> EMEAquotesToUpdate = new List<SBQQ__Quote__c>();

        String EMEAplmOwners = '' , EMEAplmOwners2 = '' ;
        List<String> EMEAownerList , EMEAownerList2  ;
        Set<String> EMEAplmsSet , EMEAplmsSet2 ; 
     
        List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
         quoteList = [select EMEA_PLM__c,EMEA_PLM_Management__c,SBQQ__NetAmount__c,Quote_To_Region__c,(select id ,SPQ_Discount__c,sbqq__Discount__c , ATFE_Product_Type__c from SBQQ__LineItems__r where id not in :qliIds) from SBQQ__Quote__c where id in :quoteIds   ];
        for(SBQQ__Quote__c quote : quoteList ){
            EMEAplmOwners = '';
 
            EMEAownerList = new List<String>();
            EMEAownerList2 = new List<String>();
            EMEAplmsSet  = new Set<String>();   
            EMEAplmsSet2 = new Set<String>();
             
        if ( quote.Quote_To_Region__c == 'EMEA') {
            for(SBQQ__QuoteLine__c qli : quote.SBQQ__LineItems__r){
                
                if(qli.ATFE_Product_Type__c != null && plmMap.containsKey(qli.ATFE_Product_Type__c))
                {                    
                    String EMEAstr = plmMap.get(qli.ATFE_Product_Type__c).EMEA_Product_Owner__c ;
                     String EMEAstrmang = plmMap.get(qli.ATFE_Product_Type__c).EMEA_PLM_Management__c ;
                    if(!EMEAplmsSet.contains(EMEAstr))
                    {
                        EMEAownerList.add(EMEAstr);
                        EMEAplmsSet.add(EMEAstr);
                    }
                    if(!EMEAplmsSet2.contains(EMEAstrmang))
                    {
                        EMEAownerList2.add(EMEAstrmang);
                        EMEAplmsSet2.add(EMEAstrmang);
                    } 
                  
                }
                    
            }
            SBQQ__Quote__c quoteObj = new  SBQQ__Quote__c(id = quote.id ); 
             if(EMEAownerList != null && EMEAownerList.size() > 0){
                    EMEAownerList.sort();
                    for(String EMEAstr : EMEAownerList){
                        EMEAplmOwners += EMEAstr ;
                        EMEAplmOwners += ',';
                    }
                    EMEAplmOwners = EMEAplmOwners.trim();
                    EMEAplmOwners = EMEAplmOwners.subString(0,EMEAplmOwners.length() - 1);
                    System.debug('EMEAplmOwners:'+EMEAplmOwners);
                    quoteObj.EMEA_PLM__c = EMEAplmOwners;
                    
            }  
            if(EMEAownerList2 != null && EMEAownerList2.size() > 0){
                    EMEAownerList2.sort();
                    for(String EMEAstrmang : EMEAownerList2){
                        EMEAplmOwners2 += EMEAstrmang ;
                        EMEAplmOwners2 += ',';
                    }
                    EMEAplmOwners2 = EMEAplmOwners2.trim();
                    EMEAplmOwners2 = EMEAplmOwners2.subString(0,EMEAplmOwners2.length() - 1);
                    System.debug('EMEAplmOwners2 :'+ EMEAplmOwners2 );
                    quoteObj.EMEA_PLM_Management__c = EMEAplmOwners2 ;
                    
            }
            else 
                quoteObj.EMEA_PLM__c = 'None';
             
            EMEAquotesToUpdate.add(quoteObj);
            
            If (quoteObj.EMEA_PLM__c == 'None'){
            
                  quoteObj.EMEA_PLM_Management__c = 'None' ;
                  
               }
            }
        }
        if(EMEAquotesToUpdate != null && EMEAquotesToUpdate.size() > 0)
            update EMEAquotesToUpdate ;                         
  }   
}