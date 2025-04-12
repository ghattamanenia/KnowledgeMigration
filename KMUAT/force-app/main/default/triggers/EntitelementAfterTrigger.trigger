trigger EntitelementAfterTrigger on Entitlement (after insert,after update) 
{
    if(Utils.DoNotRun_entitlementTrigger){
     system.debug('##### returning entStartdate #### ');
     return;
     }
    if(EntitelementHelper.entitelemtUpdate == false)
    {
        EntitelementHelper.entitelementUpdate(trigger.newmap,trigger.oldmap);
    }   

}