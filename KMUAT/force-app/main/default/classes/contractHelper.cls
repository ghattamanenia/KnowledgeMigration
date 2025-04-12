public class contractHelper
{

    public static boolean recurssionflag = false;
    public static boolean contractNameRecurssion = false;

    public static void updateContracts(list<contract> triggernew)
    {
        
         set<ID> accIDs = new set<ID>();
         set<ID> conIDs = new set<ID>();
         list<contract> OldContracts = new list<contract>();
             
        for(Contract oContract: triggernew)
        {            
            if(oContract.AccountID != null && oContract.Active_Contract__c == true)
            {
                accIDs.add(oContract.AccountID);
                conIDs.add(oContract.ID);
            }
        }
        
        
        for(Contract oCon : [SELECT ID,Active_Contract__c,CurrencyIsoCode FROM Contract  WHERE ID  NOT IN: conIDs AND  AccountID IN: accIDs AND Active_Contract__c = true])
        {
            OldContracts.add(new Contract(ID=ocon.Id,Active_Contract__c = false));
        }
       
        if(OldContracts.size() > 0)
        {
            recurssionflag = true;
            update OldContracts;
        }
        
        
     }
     
     public static void updateContractName(list<contract> triggernew,map<ID,Contract> triggernewmap)
     {
       set<ID> accIDs = new set<ID>();
       list<contract> contracts = new list<contract>();
       
         
       for(Contract oCon : triggernew)
       {
             accIDs.add(oCon.AccountID);
       }  
        
       list<Account> accs = [Select ID, Name,CurrencyIsoCode, (select Id,Name from Contracts ORDER BY CreatedDate ) from Account where ID IN: accIDs];
       
       system.debug('::accs::' + accs );
       for(Account a : accs)
       {
           for(Contract oCon : triggernew)
           {
               if(oCon.AccountID == a.Id)
               {
                   system.debug('::size ::'+a.contracts.size()); 
                   for(Integer b = 0; b < (a.contracts.size() + 1); b++)
                   {
                       Integer count = b+1;
                       string cname = a.Name + ' Sales Contract ' + count;
                       
                       system.debug('::old oCon::'+oCon.Name); 
                       oCon.Name = cname;
                       oCon.CurrencyIsoCode = a.CurrencyIsoCode;
                       system.debug('::new oCon::'+oCon.Name);  
                   }
               
               }
           
           }
  
     }
   }
}