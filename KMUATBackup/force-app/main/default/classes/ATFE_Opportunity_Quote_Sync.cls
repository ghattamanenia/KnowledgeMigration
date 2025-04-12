public with sharing class ATFE_Opportunity_Quote_Sync {
@future 
    public static void SyncOpportunityQuote (ID quoteID, ID oppID){     
        Try {
            Opportunity opp = [Select ID from Opportunity where ID = :oppID];
            
            // Begin syncing Quote with Opportunity. Same as pressing the "Start Sync" button on Quote layout
            opp.SyncedQuoteId = quoteID;
            
            update opp;
        }
        catch (Exception e) {
            system.debug('exception found in OpportunityQuoteSync: ' + e);    
        }
    }
}