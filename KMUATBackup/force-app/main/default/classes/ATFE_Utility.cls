public with sharing class ATFE_Utility {
    public static boolean isFutureUpdate;
    
    //method to check if the user passed in has the region(s) passed in within their Price Book Region field  
    public static Boolean validateUserPriceBookRegion(User pCurrentUser, Set<String> pValidRegions) {
		Boolean hasValidRegion = false;
    	String[] regionsList;
    	//Price_Book_Region__c is a multi-select so we need to store it's values in a list 
    	//If the user's Price_Book_Region__c field is not null then we can call .split(;) on it to separate it into a list, if the field is null then we set
    	//regionsList to an empty list 
		regionsList = pCurrentUser.Price_Book_Region__c != null ? pCurrentUser.Price_Book_Region__c.split(';') : new String[]{};
		//loop through the user's price book regions (if there are any), and check to see if one of them is a valid regions
		if (regionsList.size() > 0) {
			for (String region : regionsList) {
				if(pValidRegions.contains(region)) {
					hasValidRegion = true;
				}
			}
		}
		return hasValidRegion;
    }
}