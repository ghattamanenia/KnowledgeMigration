/**
 * Class CDM_OppMatching_Custom
 *
 * This class implement the CDM_IOppMatching interface to extend the Opportunity Matching logic with customer specific code.
 * Only POS that has already been matched using the package logic is available to be further refined with this logic.
 */
global without sharing class CDM_OppMatching_Custom  {
    
    /**
     * customOppMatching
     *
     * Adds logic to copy the Net Price and Quantity from the OLI to the POS when the POS is successfully matched.
     * Also preserves the CI Product information.
     */
    /*@future
    public static void customOppMatching(Set<Id> posToMatch)
    {
        }
    @future
    public static void customOppUnmatching(Set<Id> posToUnmatch)
    {
      }*/
      }