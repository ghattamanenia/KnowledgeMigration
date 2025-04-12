Public class BusinessHour{
    public static boolean skipCaseComment= false;
   public static void updatCase(List<Case> CaseList,boolean flagstatus){
       
   try{
    List<Case> casesToUpsert = new List<Case>();
    List<Case> p1cases = new List<Case>();
   List<Case> caseWithoutHW = new List<Case>();
   List<ID> caseIds = new List<ID>();
   List<Entitlement> entitlementlst = new List<Entitlement>();
   List<Id> entitlementIdsOnCases = new List<Id>();
   Map<Case, Id> caseEntTemplate = new Map<Case, Id>();
   Id hoursId = [select id from Businesshours where name = 'Standard(24x7)'].Id;
   list<EntitlementPrioritysettings__c> lstCustomSettings = EntitlementPrioritysettings__c.getAll().values();
   //list<BusinessHour__c> lstbusinessHour = BusinessHour__c.getAll().values();
   //list<CustomerTimeZone__c> lsttimezone = CustomerTimeZone__c.getAll().values(); 
   system.debug('### lstCustomSettings ::=> ###' + lstCustomSettings );
   //system.debug('### lstbusinessHour ::=> ###' + lstbusinessHour );
   //system.debug('### lsttimezone ::=> ###' + lsttimezone );
   system.debug('### CaseList ###' + CaseList);
   
   Map<string,id> BhrsNametoId = new  Map<string,id>();
   
   List<BusinessHours> Bhrs = [SELECT Id,IsActive,Name FROM BusinessHours where IsActive = true] ;
   for(BusinessHours BH : Bhrs ){
       if(!BhrsNametoId.containsKey(BH.Name) )
           BhrsNametoId.put(BH.Name,BH.Id);
   
   }
   
   for(Case c: CaseList){
        if(c.Hw_Asset_Name__c != null){
            entitlementIdsOnCases.add(c.EntitlementId);
            casesToUpsert.add(c);
        }
        else{
            caseWithoutHW.add(c);
        } 
        p1cases.add(c);
    }
    system.debug('@@@@@@@@@@caseWithoutHW:@@@@@@@@@@' + caseWithoutHW);
    if(caseWithoutHW.size()>0){
  
        for(case c : caseWithoutHW){
            for(EntitlementPrioritysettings__c ep : lstCustomSettings){
            
                if( c.AccountRegion__c == ep.Region__c){
                    caseEntTemplate.put(c,(Id)ep.EntitlementId__c);
                    system.debug('***true');
                    system.debug('ep.EntitlementId__c::' + (Id)ep.EntitlementId__c);
                  }
            }
        }
    }
    
    system.debug('caseEntTemplate size:' + caseEntTemplate.size());
    system.debug('caseEntTemplate keyset:' + caseEntTemplate.keySet());
    Map<Case,Entitlement> caseTemplate = new Map<Case,Entitlement>();
    List<EntitlementTemplate>  productEntileMent = new List<EntitlementTemplate>();
    if(caseEntTemplate.size()>0 && flagstatus){
        for(Case cases :  caseEntTemplate.keySet()){
            system.debug('caseEntTemplate Id1:->' + caseEntTemplate.get(cases));
            productEntileMent = [Select Type, Term, slaprocessid , Name,BusinessHoursId From EntitlementTemplate where Id = : caseEntTemplate.get(cases)]; 
            system.debug('caseEntTemplate Id2:' + caseEntTemplate.get(cases));
            system.debug('productEntileMent:' + productEntileMent);
            date d=system.today();
            date d1=d.adddays(productEntileMent[0].term);
            entitlement ent= new entitlement(name=productEntileMent[0].Name,Region__c=cases.Account.Region__c,accountid=cases.accountid,Term_Days__c=productEntileMent[0].term,startdate=d,enddate=d1,slaprocessid=productEntileMent[0].slaprocessid,BusinessHoursid=productEntileMent[0].BusinessHoursId);
            entitlementlst.add(ent);
            caseTemplate.put(cases,ent);
        }
    } 
    system.debug('caseTemplate' + caseTemplate);  
    if(entitlementlst.size()>0)
        database.insert(entitlementlst,false);
    if(caseTemplate.size()>0){
        for(case cas :  caseTemplate.keySet()){
            cas.EntitlementId= caseTemplate.get(cas).Id;
            if(cas.AccountSubregion__c !=null){
                //for(CustomerTimeZone__c ctz :lsttimezone){
                  //  if(cas.AccountSubregion__c == ctz.TimeZoneId__c)
                   //     cas.BusinessHoursId = (Id)ctz.BusinesshourId__c;
                        
                //}
               string timezoneName =  GetTimezone(cas.AccountSubregion__c);
               system.debug('## timezonekey returned ##  ' + timezoneName );
               cas.BusinessHoursId = BhrsNametoId.get(timezoneName);                   
               system.debug('## cas.BusinessHoursId ## ' + cas.BusinessHoursId);
                   
                
            }
        }
            //system.debug('caseTemplate.get(cas).BusinessHoursId' + caseTemplate.get(cas).BusinessHoursId);
                   
        }
    
  /*  for(Entitlement ee : entitlementlst){
                if(cas.EntitlementId == ee.Id)
                    cas.BusinessHoursId = caseTemplate.get(cas).BusinessHoursId;
            }  */
      system.debug('casesToUpsert ::' + casesToUpsert);  
      //system.debug('lsttimezone::' + lsttimezone);
      if(casesToUpsert.size()>0){
        for(case c1 : casesToUpsert){
            if(c1.AccountSubregion__c !=null){
                /*for(CustomerTimeZone__c ctz :lsttimezone){
                    if(c1.AccountSubregion__c == ctz.TimeZoneId__c){
                        c1.BusinessHoursId = (Id)ctz.BusinesshourId__c;
                         system.debug('assigned business hour -- 1::' +  c1.BusinessHoursId);  
                        }
                        
                }*/
                string timezoneName =  GetTimezone(c1.AccountSubregion__c);
               system.debug('## timezonekey returned --casesToUpsert  ##  ' + timezoneName );
               c1.BusinessHoursId = BhrsNametoId.get(timezoneName);                   
               system.debug('## cas.BusinessHoursId --casesToUpsert  ## ' + c1.BusinessHoursId);
            } 
        } 
    }
     system.debug('p1cases::' + p1cases);
    if(p1cases.size()>0){
        for(case c : p1cases){
                if(c.Priority== 'P1' && c.AccountRegion__c == 'NA') {
                        c.BusinessHoursId=hoursId;
                }
                else{
                 system.debug('AccountSubregion__c ::' + c.AccountSubregion__c);
                    if(c.AccountSubregion__c !=null){
                       /* for(CustomerTimeZone__c ctz :lsttimezone){
                            if(c.AccountSubregion__c == ctz.TimeZoneId__c){
                                c.BusinessHoursId = (Id)ctz.BusinesshourId__c;
                                 system.debug('assigned business hour -- 2::' +  c.BusinessHoursId);  
                                
                                }
                        
                        }*/
                        
                         string timezoneName =  GetTimezone(c.AccountSubregion__c);
                         system.debug('## timezonekey returned -- p1cases  ##  ' + timezoneName );
                         c.BusinessHoursId = BhrsNametoId.get(timezoneName);                   
                         system.debug('## cas.BusinessHoursId -- p1cases  ## ' + c.BusinessHoursId);
                    
                } 
            }
        }
    }
    }catch(Exception ex){}  
  }   

public static void updateBusinessHourNotifications(list<Case> triggerNew){
        string dateTimeFormat = 'MM/dd/yyyy HH:mm'; 
        BusinessHours corpBH;
        string tzsid;
        try{
            for(Case c : triggerNew){
                if(c.BusinessHoursId !=null){
                    corpBH = [select Id, TimeZoneSidKey from BusinessHours where Id = : c.BusinessHoursId limit 1];
                    tzsid = corpBH.TimeZoneSidKey;
                    DateTime dt = system.now();
                    string ss = dt.format('yyyy-MM-dd HH:mm:ss',tzsid);
                    system.debug (dt);
                    String s = ss.substring(11,13);
                    system.debug('**hour'+s);
                    integer ii = integer.valueof(s);
                    DateTime dt1 = datetime.valueOfGmt(ss);
                    integer hou = dt1.hour();
                    system.debug('**hour1'+hou + ii);
                    c.Time_Difference__c = (integer)hou - ii;
                    system.debug (dt.format('yyyy-MM-dd HH:mm:ss',tzsid) + '    ->   ' + tzsid);
                    //c.RMA_Time_Calculation__c= BusinessHours.add(corpBH.Id, dt, 0); 
                    //c.RMA_Time_Calculation__c= datetime.valueof(ss); 
                    c.RMA_Time_Calculation__c = datetime.valueOfGmt(ss);
                    system.debug('***'+ c.RMA_Time_Calculation__c);
                }
            }
        }catch(exception ex){}  
    }
/*******************************************************************************************************************************/
// This function take the timezoneid returned by google and return the time zone difference from GMT as a string e.g. (GMT-07:00)
/*******************************************************************************************************************************/
    private static string GetTimezone(string timezoneKey){    
        TimeZone tz =  TimeZone.getTimeZone(timezoneKey); // create salesforce Timezone instance from timezoneid
        System.debug('tz: ' + tz);
        System.debug('Display name: ' + tz.getDisplayName());
        integer hr = 0,min = 0,rslt = 0; 
        string dattime = string.valueof(datetime.now()); // This function return the date time of GMT
        datetime dt = datetime.valueOfGMT(dattime); // This function converts the GMT time to localtime and as a salesforce datetime class's Instance
        system.debug('##local date time is ##' + dt);
        integer milliSecsHr = 1000*60*60; // milliseconds in an hour : min*sec*milliseconds 
        integer milliSecsMIn = 1000*60; // milliseconds in a Min : sec*milliseconds 
        rslt = math.mod(tz.getOffset(dt),(milliSecsHr)) ; // extract time above proper hours 
        hr = tz.getOffset(dt)/(milliSecsHr); // get hours
        if(rslt != 0){
         min = (rslt < 0) ? ((rslt*-1)/(milliSecsMIn )) : (rslt/(milliSecsMIn));     // extract minutes
        }
        string GMToffset;
        if(hr<0){
            hr = hr*-1;
            GMToffset = ((string.valueof(hr).length() > 1) ? ('-' + string.valueof(hr) + ':' ) : ('-0'+string.valueof(hr)+':')); // create time when difference is negative e.g. (GMT-07:00)
        }else{
            GMToffset = ((string.valueof(hr).length() > 1) ? ('+' + string.valueof(hr) + ':' ) : ('+0'+string.valueof(hr)+':'));// create time when difference is positive e.g. (GMT+07:00)
        }
        
        GMToffset = ((string.valueof(min).length() > 1) ? (GMToffset + string.valueof(min) ): (GMToffset + '0' + string.valueof(min) )); 
        GMToffset = '(GMT' + GMToffset + ')';
        system.debug(GMToffset ); 
        return GMToffset;
    }
}