public class contractPriceclass
{

    public static boolean stopRecurssion = false;

    public static void updateContract(set<ID> contractIds)
    {
    
        List<Contract> ContractsToUpdate = new List<Contract>();
        List<SBQQ__ContractedPrice__c> cpList = new List<SBQQ__ContractedPrice__c>();  
        Map<String,ATFE_ProductTypePLM__c> plmMap = ATFE_ProductTypePLM__c.getAll();   
        String plmOwners = '' , plmOwners2 = '' , APACplmOwners = '' , APACplmOwners2 = '' ;
        List<String> ownerList , ownerList2 ,APACownerList , APACownerList2 ;
        Set<String> plmsSet , plmsSet2 ,APACplmsSet , APACplmsSet2 ;                   
        
        map<ID,double> Total_PriceMap = new map<ID,double>();  
        map<ID,double> Total_PriceBookPriceMap = new map<ID,double>();  
        map<ID,double> Total_MSRPPriceMap = new map<ID,double>(); 
        map<ID,double> Total_FinancialCOGMap = new map<ID,double>(); 
        
        map<ID,double> Product_Total_PriceMap = new map<ID,double>();  
        map<ID,double> Product_Total_PriceBookPriceMap = new map<ID,double>();  
        map<ID,double> Product_Total_MSRPPriceMap = new map<ID,double>(); 
        
        map<ID,double> Service_Total_PriceMap = new map<ID,double>();  
        map<ID,double> Service_Total_PriceBookPriceMap = new map<ID,double>();  
        map<ID,double> Service_Total_MSRPPriceMap = new map<ID,double>(); 
        
        map<ID,double> X_Series_Count_Map = new map<ID,double>(); 
                
        
        
      for(AggregateResult q : [select Sales_Contract__c ,sum(SBQQ__Price__c),sum(PriceBook_Price__c),sum(ATFE_MSRP_Price__c),sum(ATFE_COGS__c) from SBQQ__ContractedPrice__c  where Sales_Contract__c IN :contractIDs group by Sales_Contract__c ])
      {
          Total_PriceMap.put((Id)q.get('Sales_Contract__c'),(Double)q.get('expr0'));
          Total_PriceBookPriceMap.put((Id)q.get('Sales_Contract__c'),(Double)q.get('expr1'));          
          Total_MSRPPriceMap.put((Id)q.get('Sales_Contract__c'),(Double)q.get('expr2'));
          Total_FinancialCOGMap.put((Id)q.get('Sales_Contract__c'),(Double)q.get('expr3'));         
          
      }
      
      for(AggregateResult q : [select Sales_Contract__c ,sum(SBQQ__Price__c),sum(PriceBook_Price__c),sum(ATFE_MSRP_Price__c) from SBQQ__ContractedPrice__c  where Sales_Contract__c IN :contractIDs AND  ATFE_Product_Family__c =: 'PRODUCT'  group by Sales_Contract__c ])
      {
          Product_Total_PriceMap.put((Id)q.get('Sales_Contract__c'),(Double)q.get('expr0'));
          Product_Total_PriceBookPriceMap.put((Id)q.get('Sales_Contract__c'),(Double)q.get('expr1'));          
          Product_Total_MSRPPriceMap.put((Id)q.get('Sales_Contract__c'),(Double)q.get('expr2'));                    
      }
      
      for(AggregateResult q : [select Sales_Contract__c ,sum(SBQQ__Price__c),sum(PriceBook_Price__c),sum(ATFE_MSRP_Price__c) from SBQQ__ContractedPrice__c  where Sales_Contract__c IN :contractIDs AND  ATFE_Product_Family__c =: 'SERVICE'  group by Sales_Contract__c ])
      {
          Service_Total_PriceMap.put((Id)q.get('Sales_Contract__c'),(Double)q.get('expr0'));
          Service_Total_PriceBookPriceMap.put((Id)q.get('Sales_Contract__c'),(Double)q.get('expr1'));          
          Service_Total_MSRPPriceMap.put((Id)q.get('Sales_Contract__c'),(Double)q.get('expr2'));                    
      }
      
      for(AggregateResult q : [select Sales_Contract__c ,count(ID) from SBQQ__ContractedPrice__c  where Sales_Contract__c IN :contractIDs AND  ATFE_Product_Type__c =: 'X Series' group by Sales_Contract__c ])
      {
          X_Series_Count_Map.put((Id)q.get('Sales_Contract__c'),(Double)q.get('expr0'));                  
      }
      


     cpList = [select id ,
                      SBQQ__Price__c, 
                      ATFE_Product_Type__c 
               from 
                      SBQQ__ContractedPrice__c 
               where Sales_Contract__c  in :contractIds];

                                      
      for(Contract o : [Select Id, 
                                ATFE_PLM_s__c,
                                ATFE_Total_Price__c,
                                ATFE_Total_PriceBook_Price__c,
                                ATFE_Total_MSRP_Price__c,
                                ATFE_TotalProduct_MSRP_Price__c,
                                ATFE_Total_Product_PriceBook_Price__c,
                                ATFE_Total_Product_Price__c,
                                ATFE_Total_Service_MSRP_Price__c,
                                ATFE_Total_Service_Price__c,
                                ATFE_Total_Service_PriceBook_Price__c,  
                                ATFE_Total_Financial_COGS__c,
                                Product_Group__c,
                                Sales_Contract_Region__c                              
                         FROM  Contract 
                         where Id IN :contractIDs ])
      {
            Double p1 = Total_PriceMap.get(o.Id);
                o.ATFE_Total_Price__c = p1;            
            Double p2 = Total_PriceBookPriceMap.get(o.Id);
                o.ATFE_Total_PriceBook_Price__c = p2;            
            Double p3 = Total_MSRPPriceMap.get(o.Id);
                o.ATFE_Total_MSRP_Price__c = p3;
            Double p10 = Total_FinancialCOGMap.get(o.Id);
                o.ATFE_Total_Financial_COGS__c = p10;
             
             Double p4 = Product_Total_PriceMap.get(o.Id);
                o.ATFE_Total_Product_Price__c = p4;            
            Double p5 = Product_Total_PriceBookPriceMap.get(o.Id);
                o.ATFE_Total_Product_PriceBook_Price__c = p5;            
            Double p6 = Product_Total_MSRPPriceMap.get(o.Id);
                o.ATFE_TotalProduct_MSRP_Price__c = p6;
                
            Double p7 = Service_Total_PriceMap.get(o.Id);
                o.ATFE_Total_Service_Price__c = p7;            
            Double p8 = Service_Total_PriceBookPriceMap.get(o.Id);
                o.ATFE_Total_Service_PriceBook_Price__c = p8;            
            Double p9 = Service_Total_MSRPPriceMap.get(o.Id);
                o.ATFE_Total_Service_MSRP_Price__c = p9;
                
            Double p11 = X_Series_Count_Map.get(o.Id);
                o.Product_Group__c = p11;
             
           // Update PLM code   

           /* ---------------------------------------------- ATI --------------------------------------------------
              --------------------------------------------------------------------------------------------------------*/
           if(o.Sales_Contract_Region__c =='NA' || o.Sales_Contract_Region__c =='CSA' ){
             plmOwners = '';
             ownerList = new List<String>();
             ownerList2 = new List<String>();
             plmsSet  = new Set<String>();   
             plmsSet2 = new Set<String>(); 
           
           
            for(SBQQ__ContractedPrice__c  cp : cpList )
            {         
                                     
                if(cp.ATFE_Product_Type__c != null && plmMap.containsKey(cp.ATFE_Product_Type__c))
                {      
                    system.debug('@@@entereing into cplist');                               
                    if( cp.SBQQ__Price__c  >= 0 )                     
                    {
                    system.debug('@@@entereing into cplist2'); 
                    system.debug('@@@plmMap'+plmMap);
                        String str = plmMap.get(cp.ATFE_Product_Type__c).ATFE_Product_Owner__c ; 
                        String strmang = plmMap.get(cp.ATFE_Product_Type__c).PLM_Management__c ;   
                        system.debug('@@@str'+str);
                        system.debug('@@@strmang'+strmang);                    
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
            }   
            
             system.debug('## ownerList  NA ##' + ContractsToUpdate);    
             system.debug('@@@ownerList'+ownerList);         
                if(ownerList != null && ownerList.size() > 0)
                {
                    ownerList.sort();
                    for(String str : ownerList)
                    {
                        plmOwners += str ;
                        plmOwners += ',';                        
                    }
                    plmOwners = plmOwners.trim();
                    plmOwners = plmOwners.subString(0,plmOwners.length() - 1); 
                    system.debug('@@@@@ plmOwners'+plmOwners);                                   
                    o.ATFE_PLM_s__c = plmOwners;
                    
            }
            else 
            {               
               o.ATFE_PLM_s__c = 'None';  
            }  
            
              system.debug('## ownerList2 NA ##' + ContractsToUpdate);   
                if(ownerList2 != null && ownerList2.size() > 0){
                    ownerList2.sort();
                    for(String strmang : ownerList2){
                        plmOwners2 += strmang ;
                        plmOwners2 += ',';
                    }
                    plmOwners2 = plmOwners2.trim();
                    plmOwners2 = plmOwners2.subString(0,plmOwners2.length() - 1);
                    System.debug('plmOwners2:'+plmOwners2);
                    o.ATFE_PLM_Managements__c = plmOwners2;
                    
            } 
            else
            {
                 o.ATFE_PLM_Managements__c = 'None';
            }                           
            ContractsToUpdate.add(o);
            system.debug('## ContractsToUpdate NA AND CSA ##' + ContractsToUpdate);
          }
          
          /* ---------------------------------------------- EMEA --------------------------------------------------
              --------------------------------------------------------------------------------------------------------*/
           if(o.Sales_Contract_Region__c =='EMEA' ){
             plmOwners = '';
             ownerList = new List<String>();
             ownerList2 = new List<String>();
             plmsSet  = new Set<String>();   
             plmsSet2 = new Set<String>(); 
           
           
            for(SBQQ__ContractedPrice__c  cp : cpList )
            {         
                                     
                if(cp.ATFE_Product_Type__c != null && plmMap.containsKey(cp.ATFE_Product_Type__c))
                {      
                    system.debug('@@@entereing into cplist');                               
                    if( cp.SBQQ__Price__c  >= 0 )                     
                    {
                    system.debug('@@@entereing into cplist2'); 
                    system.debug('@@@plmMap'+plmMap);
                        String str = plmMap.get(cp.ATFE_Product_Type__c).EMEA_Product_Owner__c; 
                        String strmang = plmMap.get(cp.ATFE_Product_Type__c).EMEA_PLM_Management__c;   
                        system.debug('@@@str'+str);
                        system.debug('@@@strmang'+strmang);                    
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
            }   
            
             system.debug('## ownerList  NA ##' + ContractsToUpdate);    
             system.debug('@@@ownerList'+ownerList);         
                if(ownerList != null && ownerList.size() > 0)
                {
                    ownerList.sort();
                    for(String str : ownerList)
                    {
                        plmOwners += str ;
                        plmOwners += ',';                        
                    }
                    plmOwners = plmOwners.trim();
                    plmOwners = plmOwners.subString(0,plmOwners.length() - 1); 
                    system.debug('@@@@@ plmOwners'+plmOwners);                                   
                    o.ATFE_PLM_s__c = plmOwners;
                    
            }
            else 
            {               
               o.ATFE_PLM_s__c = 'None';  
            }  
            
              system.debug('## ownerList2 NA ##' + ContractsToUpdate);   
                if(ownerList2 != null && ownerList2.size() > 0){
                    ownerList2.sort();
                    for(String strmang : ownerList2){
                        plmOwners2 += strmang ;
                        plmOwners2 += ',';
                    }
                    plmOwners2 = plmOwners2.trim();
                    plmOwners2 = plmOwners2.subString(0,plmOwners2.length() - 1);
                    System.debug('plmOwners2:'+plmOwners2);
                    o.ATFE_PLM_Managements__c = plmOwners2;
                    
            } 
            else
            {
                 o.ATFE_PLM_Managements__c = 'None';
            }                           
            ContractsToUpdate.add(o);
            system.debug('## ContractsToUpdate NA AND CSA ##' + ContractsToUpdate);
          }
        /* ---------------------------------------------- APAC --------------------------------------------------
        --------------------------------------------------------------------------------------------------------*/ 
       if(o.Sales_Contract_Region__c =='APAC'){ 
       
        APACownerList = new List<String>();
        APACownerList2 = new List<String>();
        APACplmsSet  = new Set<String>();   
        APACplmsSet2 = new Set<String>();
        
            for(SBQQ__ContractedPrice__c  cp : cpList )
            {                               
                if(cp.ATFE_Product_Type__c != null && plmMap.containsKey(cp.ATFE_Product_Type__c))
                {                                    
                    if( cp.SBQQ__Price__c  >= 0 )                     
                    {
                        String APACstr = plmMap.get(cp.ATFE_Product_Type__c).ATFE_Product_Owner__c ; 
                        String APACstrmang = plmMap.get(cp.ATFE_Product_Type__c).PLM_Management__c ;                        
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
            }                
                if(APACownerList != null && APACownerList.size() > 0)
                {
                    APACownerList.sort();
                    for(String APACstr : APACownerList)
                    {
                        APACplmOwners += APACstr ;
                        APACplmOwners += ',';                        
                    }
                    APACplmOwners = APACplmOwners.trim();
                    APACplmOwners = APACplmOwners.subString(0,APACplmOwners.length() - 1);                                      
                    o.APAC_PLM__c = APACplmOwners;
                    
            }
            else 
            {               
               o.APAC_PLM__c = 'None';  
            }  
                if(APACownerList2 != null && APACownerList2.size() > 0){
                    APACownerList2.sort();
                    for(String APACstrmang : APACownerList2){
                        APACplmOwners2 += APACstrmang ;
                        APACplmOwners2 += ',';
                    }
                    APACplmOwners2 = APACplmOwners2.trim();
                    APACplmOwners2 = APACplmOwners2.subString(0,APACplmOwners2.length() - 1);
                    System.debug('APACplmOwners2:'+APACplmOwners2);
                    o.APAC_PLM_Management__c = APACplmOwners2;
                    
            } 
            else
            {
                 o.APAC_PLM_Management__c = 'None';
            }                           
            ContractsToUpdate.add(o);
            
        }       
       } 
         system.debug('## ContractsToUpdate NA, CSA and APAC ##' + ContractsToUpdate);                      
         if(ContractsToUpdate.size() > 0)
         {
             stopRecurssion = true;
             update ContractsToUpdate;
         }
        
      
    }    
}