public with sharing class PriceBookEntryDAO {
	public static Map<String,PriceBookEntry> getRecMapById(SET<String> pricebookentries){
		system.debug('■■■■■■■■■■ PriceBookEntryDAO ■■■■■■■■■■');
		system.debug('***** pricebookentries : ' + pricebookentries);
        Map<String,PriceBookEntry> pbeMap = new Map<String,PriceBookEntry>();
        
        List<PriceBookEntry> pbeList =  [SELECT 
						                        id,
						                        Name,
						                        PriceBook2Id
						                FROM 
						                      PriceBookEntry 
						                WHERE 
						                      Id IN :pricebookentries
						            	];
    	for(PriceBookEntry pbe : pbeList){
    		system.debug('***** PriceBookEntryId : ' + pbe.Id);
    		if(!pbeMap.containsKey(pbe.Id)){
    			pbeMap.put(pbe.Id,pbe);
    		}
    	}
    	
    	return pbeMap;
	}
	
	public static List<PriceBookEntry> getOtherProduct(ID pricebookId){
		return [select 
					Id 
				from 
					PriceBookEntry 
				where 
					PriceBook2Id = :pricebookId
				and
					Product2.Name = 'その他商品'
				and
					IsActive = true
				];
	}
}