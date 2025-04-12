public with sharing class OpportunityHistoryController
{
    list<OpportunityFieldHistory> OppFieldHistories {get;set;}
    Set<Id> OppOwnerIds = new set<Id>();
    public list<OppHistoryWrap> OppHistWrapRecs {get;set;}
    public date startdate {get;set;}
    public date enddate {get;set;}
    public datetime startdatetime {get;set;}
    public datetime enddatetime {get;set;}
    public set<Id> OppIds;
    public map<Id,set<string>> OppIdProdNameset = new Map<Id,set<string>>();
    
    public OpportunityHistoryController()
    {
        integer startnumber=-100;
        integer endnumber=0;
        for(string s:label.OpportunityHistoryController.split(';'))
        {
            if(startnumber==-100)
            startnumber=Integer.valueof(s.trim());
            else
            endnumber=Integer.valueof(s.trim());
            
        }
        startdate =system.today()-startnumber;
        enddate=system.today()-endnumber;
        startdatetime= DateTime.newInstance(startdate.year(),startdate.month(),startdate.day());
        enddatetime=DateTime.newInstance(enddate.year(),enddate.month(),enddate.day());
        OppIds=new set<Id>();
        system.debug('@@@@startdatetime---->'+startdatetime);
        system.debug('@@@@@enddatetime---->'+enddatetime);
        OppFieldHistories = new list<OpportunityFieldHistory >();
        OppHistWrapRecs= new list<OppHistoryWrap>();
        
        for(string str:label.OppOwnerIdsForReport.split(';'))
        {
            OppOwnerIds.add(str);
        }
        
        system.debug('@@@@@OppOwnerIds---->'+OppOwnerIds);
        
       for(OpportunityFieldHistory ofs:[SELECT Id,Opportunity.Name,Opportunity.Account.Name, NewValue, OldValue, OpportunityId, Field,CreatedDate,CreatedBy.Name,Opportunity.amount FROM OpportunityFieldHistory where Field='Probability' and Opportunity.OwnerId IN :OppOwnerIds and CreatedDate>=:startdatetime and CreatedDate<=:enddatetime])
       {
          OppFieldHistories.add(ofs);
          OppIds.add(ofs.OpportunityId);
          
       }
      
       for(OpportunityLineItem oli:[select Id,Product2Id,Product2.Name,OpportunityId from OpportunityLineItem where OpportunityId IN :OppIds])
       {
            set<string> sets = new set<string>();
            if(OppIdProdNameset.keyset().contains(oli.OpportunityId))
            {
                sets=OppIdProdNameset.get(oli.OpportunityId);
            }
            sets.add(oli.product2.Name);
            OppIdProdNameset.put(oli.OpportunityId,sets);
       }    

        system.debug('@@@@@OppIdProdNameset---->'+OppIdProdNameset);
        
        for(OpportunityFieldHistory oflh:OppFieldHistories)
        {
            string strng='';
            if(OppIdProdNameset.keyset().contains(oflh.OpportunityId))
            {
                for(string s:OppIdProdNameset.get(oflh.OpportunityId))
                {
                    strng=strng+s+',';
                }
                strng=strng.substring(0,strng.length()-1);
                
            }
            
            system.debug('@@@@strng--->'+strng);
            
            OppHistWrapRecs.add(new OppHistoryWrap(oflh,strng));
        }
        
        system.debug('@@@@@OppHistWrapRecs---->'+OppHistWrapRecs);
        
    }
    
    public pagereference download()
    {
        PageReference pg = new PageReference('/apex/OppHistoryReportPageDownload');
        return pg;
    }
    
    
    public class OppHistoryWrap
    {
        public string Products {get;set;}
        public OpportunityFieldHistory oh {get;set;}
        
        public OppHistoryWrap(OpportunityFieldHistory ofh,string prds)
        {
            Products=prds;
            oh=ofh;
            
        }
    }
}