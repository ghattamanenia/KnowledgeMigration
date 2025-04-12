public with sharing class PriceBookDAO {
	public static List<PriceBook2> getPriceBookThisMonth(String price_list_type, String priceyearmonth){
		system.debug('　■■■■■■■■■■ getPriceBookThisMont ■■■■■■■■■■');

     	return  [select 
 					Id 
     			from 
     				PriceBook2 
 				where 
 					Name = :priceyearmonth 
 				and 
 					IsActive = true
 				and
 					Description = :price_list_type
 				limit 1
 				];
	}
}