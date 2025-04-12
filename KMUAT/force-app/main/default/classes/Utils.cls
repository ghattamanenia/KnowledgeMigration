global class Utils {

    private static boolean blnAlreadyDone = false;
    
    private static boolean blncontractpriceUpdated = false;
    
    public static boolean DoNotRunContractpriceTrigger = false;
    
    public static boolean  DoNotRunContractTrigger = false;
    
    public static boolean  DoNotRun_entitlementTrigger = false;
    public static boolean warrantyCreated = false;
    

    
    private static boolean bRunFileSyncTrigger = false;
    
    public static boolean hasCPupdated(){ 
        return blncontractpriceUpdated ;
    }
    
    public static void setCPupdated() {
        blncontractpriceUpdated = true; 
    }
    
    public static boolean hasAlreadyDone(){ 
        return blnAlreadyDone;
    }
    
    public static void setAlreadyDone() {
        blnAlreadyDone = true;  
    }
    
    public static void forceResetAlreadyDone() {
        blnAlreadyDone = false; 
    }
    public static void setRunFileSync() {
        bRunFileSyncTrigger = true;  
    }
     public static void UnsetRunFileSync() {
        bRunFileSyncTrigger = false;  
    }
    public static boolean shouldRunFileSync(){ 
        return bRunFileSyncTrigger;
    }
}