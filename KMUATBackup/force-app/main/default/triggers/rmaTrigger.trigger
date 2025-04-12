// we can identify cases created after 3pm for day
//next step either it is same day replacement or next day replacement.
//trigger rmaTrigger on Case (before Insert) {
trigger rmaTrigger on Case (before Insert,before update) { //updated by sarvinder- earlier only before insert

    List<RecordType> AllCaseRT = [SELECT Id, DeveloperName  FROM RecordType where Sobjecttype = 'Case'];
    Id  ATI_CaseID; 
    Id  ATI_UserRegCaseID; 
    Id  ATI_RMAChildCaseID;
    Id  ATI_RMAParentCaseID; 
    Id  JP_CaseID;
    for(RecordType CaseRT : AllCaseRT )
    {
        if(CaseRT.DeveloperName == 'ATI_Case')
            ATI_CaseID = CaseRT.ID;
        if(CaseRT.DeveloperName == 'ATI_Community_Registration')
            ATI_UserRegCaseID = CaseRT.ID;
        if(CaseRT.DeveloperName == 'ATI_RMA_Child_Case')
            ATI_RMAChildCaseID = CaseRT.ID;
        if(CaseRT.DeveloperName == 'ATI_RMA_Parent_Case')
            ATI_RMAParentCaseID = CaseRT.ID;
        if(CaseRT.DeveloperName == 'JP_Case')
            JP_CaseID = CaseRT.ID;    
    }
    
    List<Case> advancedCaseList = new List<case>();
    string ent;
    DateTime casecreateddate;//= system.now(); commented by sarvinder
    List<Case> CaseList = new List<case>();
    List<Entitlement> entitlementlst = new List<Entitlement>();
    List<Case> dueCaseList = new List<case>();
     list<RMARegionCases__c> lstCustomSettings = RMARegionCases__c.getAll().values();
     List<EntitlementTemplate> productEntileMent = [Select Id,Name,slaprocessid,BusinessHoursid,term from EntitlementTemplate where name = 'RMA'  Limit 1];
     system.debug('*** productEntileMent ***' + productEntileMent);
        datetime createddatetime ;
        if(trigger.isbefore){
            for(case c : trigger.new){
           // casecreateddate = c.createddate;
            system.debug('*** case Record ID ***'+ c.recordtypeId); 
            system.debug('*** RMAChildCaseID ***'+ ATI_RMAChildCaseID );
                if(c.recordtypeId == ATI_RMAChildCaseID /*'012m00000008TXc'*/){
                    CaseList.add(c);
                    if( c.Hw_Asset_Name__c!=null && c.Entitlementid == null){
                         if(productEntileMent.size() > 0){
                            for(EntitlementTemplate ee : productEntileMent){
                                system.debug('*** ee ***' + ee);
                                date d=system.today();
                               // date d1=d.adddays(15);
                                date d1=d.addYears(50);//sarvinder-updated as this is defualt RMA entitlement
                                entitlement e= new entitlement(name=ee.Name,Region__c=c.AccountRegion__C,accountid=c.AccountId,Term_Days__c=ee.term,startdate=d,enddate=d1,slaprocessid=ee.slaprocessid,BusinessHoursid=ee.BusinessHoursId);
                                entitlementlst.add(e);
                            }
                        }
                    }
                    else if(c.recordtypeId == ATI_RMAChildCaseID && c.Hw_Asset_Name__c == null){
                        if(c.Entitlementid != null)
                            c.Entitlementid = null;
                        if(c.Entitlementid == null)
                            c.RMA_Entitlement__c = null;
                
                    } 
                }
                  
            }   
            //HW_Asset__c=c.Hw_Asset_Name__c,
                if(entitlementlst.size()>0)
                    database.insert(entitlementlst,false);
                    // now it has either hardware asset or without hardware asset
   
                    for(Case  c : CaseList){
                    
                        if( c.createddate == null)
                            casecreateddate = system.now();
                        else
                            casecreateddate = c.createddate;
                        
                       for(Entitlement e : entitlementlst){
                            if(c.AccountId == e.AccountId){
                                system.debug('*** entitlement assigned ***' + e);
                                c.entitlementId = e.Id;
                            }
                        }
                        if(c.Hw_Asset_Name__c != null){
                            List<entitlement > entList = [Select Name from entitlement where HW_Asset__c= : c.Hw_Asset_Name__c ];
                            for(entitlement  s : entList){
                                if(s.name !='Default')
                                    ent = s.name;
                            }
                        }
                        system.debug('*** ### ent ### ***'+ ent);
                        if((c.AccountRegion__c == 'EMEA' || c.AccountRegion__c == 'CSA') && c.Hw_Asset_Name__c != null){
                                   
                                   c.RMA_Entitlement__c = 'Repair & Return';
                                  
                        }
                           system.debug('******** c.RMA_Entitlement__c ********* ' + c.RMA_Entitlement__c);     
                        for(RMARegionCases__c rmaCase : lstCustomSettings){
                               if(ent != null && ent != ''){
                               
                               system.debug('*** rmaCase.Region_Values__c ***'+ rmaCase.Region_Values__c);
                               system.debug('*** c.accountRegion__c ***' + c.accountRegion__c);
                               system.debug('*** rmaCase.Region__c ***'+ rmaCase.Region__c);
                               system.debug('*** rmaCase.RMA_Picklist_Value__c ***'+ rmaCase.RMA_Picklist_Value__c);
                                system.debug('*** c.accountRegion__c *** '+ c.accountRegion__c);
                                
                              
                                
                                if(ent.contains(rmaCase.Region_Values__c) && c.accountRegion__c.contains(rmaCase.Region__c)){
                                    system.debug('*** ####^^^^^ rmaCase.Region_Values__c' + rmaCase.Region_Values__c + ' '+ rmaCase.Region__c+ ' ' + rmaCase.RMA_Picklist_Value__c );
                                    c.RMA_Entitlement__c= rmaCase.RMA_Picklist_Value__c ;
                                    if(c.AccountRegion__c == 'NA'){
                                      system.debug('### chk Hour ###' + casecreateddate.hour());
                                        if(casecreateddate.hour()<13 )
                                           c.RMA_Milestone_Violation__c = false;
                                        else
                                           c.RMA_Milestone_Violation__c = true; 
                                    }
                                    else if(c.AccountRegion__c == 'EMEA' || c.AccountRegion__c == 'CSA'){
                                        if(casecreateddate.hour()<15 )
                                           c.RMA_Milestone_Violation__c = false;
                                        else
                                           c.RMA_Milestone_Violation__c = true; 
                                    }
                                    advancedCaseList.add(c);
                                }
                            }
                        }
                        
                        
                       if(c.RMA_Entitlement__c == 'Repair & Return'){
                                if(casecreateddate.hour()<15 )
                                   c.RMA_Milestone_Violation__c = false;
                                else
                                   c.RMA_Milestone_Violation__c = true; 
                       }
                    }
              /*  list<Id> hrdwarasstList = new list<Id>();   
                for(Case c : trigger.new){
                    hrdwarasstList.add(c.Hw_Asset_Name__c);
                    List<Entitlement> e = [Select Id, endDate,HW_Asset__c from Entitlement where HW_Asset__c In : hrdwarasstList and Name != 'Default' limit 1];
                    if(e.size()>0){
                        if(e[0].endDate > system.today()){
                            List<Entitlement> ee = [Select Id, endDate,HW_Asset__c from Entitlement where HW_Asset__c In : hrdwarasstList and Name = 'Default' limit 1];
                            if(ee.size()>0)
                                c.EntitlementId = ee[0].Id;
                        }   
                    }
                }  */  
                
            } 
            
                    
    }