trigger ATFE_SingleQuote on Quote (before insert, after insert) {
/*   
   User u = [select Profile.Name from User where id = :userinfo.getUserId()];
      if(u.Profile.Name.startsWith('NA') || u.Profile.Name.startsWith('EMEA') || u.Profile.Name == 'System Administrator'){  
    //Info: Only allow one quote per Opportunity.
    Opportunity opp = null;
    
    if (Trigger.isBefore) {  
        //for(quote q :Trigger.New){    
        //  //Get the Opportunity name and quotes if any attached to it.
        //  opp = [Select Name, (Select Id From Quotes) From Opportunity o where Id = :q.OpportunityId];    
        //      
        //  //If Opportunity has a quote attached to it, display the error message.
        //  if(opp.Quotes.size()>0){
        //      q.addError('The opportunity: <i>'+opp.Name+'</i> already has one quote attached to it. You cannot have more than one quote for an Opportunity.<br/>Please contact your system administrator for further assistance.');
        //  }
        //}
    }
    
    if (Trigger.isAfter) {
        // Begin syncing Quote with Opportunity. Same as pressing the "Start Sync" button on Quote layout
        Try {
            ATFE_Opportunity_Quote_Sync.SyncOpportunityQuote(Trigger.New[0].Id, Trigger.New[0].OpportunityId);        
        }
        catch (Exception e) {
            system.debug('exception found in singleQuoteTrigger: ' + e);    
        }   
      }
    }*/
  }