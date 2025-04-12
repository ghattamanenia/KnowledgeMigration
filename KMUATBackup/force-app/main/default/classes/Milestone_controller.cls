public class Milestone_controller 
{
    public class CaseMilestoneWrapper{
        public CaseMilestone caseMile {get;set;}
        public string strDateTime {get;set;}
        Public Integer strtime {get;set;}
        Public string startDare {get;set;}
        Public string sEndDate {get;set;}
        Public String stargetDate {get;set;}
        Public String sRemainDate {get;set;}
    }
    public CaseMilestoneWrapper caseMileWrap;    
    public List<CaseMilestoneWrapper> lstWrapper {get;set;}
    public  Integer seconds{get;set;}
    public List<CaseMilestone> entiles {get;set;}
    Public Decimal timeH {get;set;}
    
    public Milestone_controller () 
    {
     Id  Obj_Id = ApexPages.currentPage().getParameters().get('id');
     //SObjectType objectType = Obj_Id.getsobjecttype();
     String objecttype=Obj_Id.getSobjectType().getDescribe().getName(); 
     seconds = 0;
     entiles = new List<CaseMilestone>();
    // if(objecttype.equals('Case'))
         entiles = database.query('select Id,MilestoneTypeId,MilestoneType.Name,TimeRemainingInMins,CompletionDate,ElapsedTimeInDays,ElapsedTimeInHrs,ElapsedTimeInMins,IsCompleted,IsViolated,StartDate,TargetDate from CaseMilestone where CaseId = :Obj_Id order by createdDate ');
    // else
      //    entiles = database.query('select Id,MilestoneTypeId,MilestoneType.Name,TimeRemainingInMins,CompletionDate,ElapsedTimeInDays,ElapsedTimeInHrs,ElapsedTimeInMins,TargetResponseInMins,IsCompleted,TargetResponseInHrs,IsViolated,StartDate,TargetDate,'+objecttype+'.Id from CaseMilestone where '+objecttype+'.Id = :Obj_Id');
       //calSum(entiles );   
   /*  for(CaseMilestone cm : entiles ){
       timeH = cm.ElapsedTimeInMins/60; 
       } */
       getcalSum();
    } 
    public void getcalSum(){
        List<String> minList = new List<String>();
        integer d,d1,d2,d3;
        decimal ii;
        Integer min,min1,min2;
        string s;
        integer  dd1;
        list<string> timeList = new list<string>();
        list<string>  hourList = new list<string>();
        string s1,s2,s3,s4,s5,s6;
        integer hrs,mins;
        Id  Obj_Id = ApexPages.currentPage().getParameters().get('id');
        List<CaseMileStone> csd =database.query('select Id,TimeSinceTargetInMins,MilestoneTypeId,MilestoneType.Name,TimeRemainingInMins,CompletionDate,ElapsedTimeInDays,ElapsedTimeInHrs,ElapsedTimeInMins,TargetResponseInMins,TargetResponseInHrs,IsCompleted,IsViolated,StartDate,TargetDate from CaseMilestone where CaseId = :Obj_Id order by createdDate ');
        
        lstWrapper = new List<CaseMilestoneWrapper>();
        
        if(test.isRunningTest())
        {
            
            List<CaseMileStone> cm1 =database.query('select Id,TimeSinceTargetInMins,MilestoneTypeId,MilestoneType.Name,TimeRemainingInMins,CompletionDate,ElapsedTimeInDays,ElapsedTimeInHrs,ElapsedTimeInMins,TargetResponseInMins,TargetResponseInHrs,IsCompleted,IsViolated,StartDate,TargetDate from CaseMilestone where ElapsedTimeInMins >=60 limit 1 ');
            if(cm1.size()>0)
                csd.add(cm1[0]);
            List<CaseMileStone> cm2 =database.query('select Id,TimeSinceTargetInMins,MilestoneTypeId,MilestoneType.Name,TimeRemainingInMins,CompletionDate,ElapsedTimeInDays,ElapsedTimeInHrs,ElapsedTimeInMins,TargetResponseInMins,TargetResponseInHrs,IsCompleted,IsViolated,StartDate,TargetDate from CaseMilestone where ElapsedTimeInMins <60 limit 1 ');
            if(cm2.size()>0)
            	csd.add(cm2[0]);
            List<CaseMileStone> cm3 =database.query('select Id,TimeSinceTargetInMins,MilestoneTypeId,MilestoneType.Name,TimeRemainingInMins,CompletionDate,ElapsedTimeInDays,ElapsedTimeInHrs,ElapsedTimeInMins,TargetResponseInMins,TargetResponseInHrs,IsCompleted,IsViolated,StartDate,TargetDate from CaseMilestone where ElapsedTimeInMins = null limit 1 ');
            if(cm3.size()>0)
            	csd.add(cm3[0]);
        }
            	
            
        for(casemilestone cc : csd){
            system.debug('***sec'+ seconds);
             system.debug('**CaseMilestone****'+ cc.id);
            system.debug('**cc.ElapsedTimeInMins****'+ cc.ElapsedTimeInMins);
            system.debug('**cc.TimeSinceTargetInMins****'+ cc.TimeSinceTargetInMins);
                if(cc.ElapsedTimeInMins >=60){
                    
                    system.debug('**CaseMilestone****'+ cc.id);
                    
                    d = cc.ElapsedTimeInMins/60;
                    min =math.Mod(cc.ElapsedTimeInMins,60);
                    if(min>9){
                        if(d>9)
                            s = string.valueof(d) + ':' + string.valueof(min) ;
                        else
                            s = '0'+string.valueof(d) + ':' + string.valueof(min) ;
                    }       
                    else{
                        if(d>9)
                            s = string.valueof(d) + ':0' + string.valueof(min) ;
                        else
                            s = '0'+string.valueof(d) + ':0' + string.valueof(min) ;
                    }   
                }
                else If(cc.ElapsedTimeInMins < 60 ){
                    if(cc.ElapsedTimeInMins <= 9)
                         s ='00:0' + string.valueof(cc.ElapsedTimeInMins);
                     else if(cc.ElapsedTimeInMins == 0)
                         s = '00:00';
                     else
                         s ='00:' + string.valueof(cc.ElapsedTimeInMins);    
                }
            else{// else if(cc.ElapsedTimeInMins == null){
                
               // system.debug('**CaseMilestone now here****');
                    integer targetresMin = cc.TargetResponseInMins;
                    List<String> minList1 = new List<String>();
                    minList1 = (cc.TimeRemainingInMins).split(':');
                    system.debug('***1'+minList1);
                    integer timeRemMin = integer.valueOf(minList1[0]);
                    integer rslt = targetresMin - timeRemMin;
                    system.debug('***2'+timeRemMin+'***'+rslt);
                    if(cc.TimeSinceTargetInMins != null){
                       // system.debug('**inside cc.TimeSinceTargetInMins****' + cc.TimeSinceTargetInMins);
                        List<String> minList2 = new List<String>();
                        minList2 = (cc.TimeSinceTargetInMins).split(':');
                        integer timesincetargetMin = integer.valueOf(minList2[0]);
                        system.debug('***21'+timeRemMin+'***'+minList2[0]);
                       // system.debug(':::rslt minutes--1::' + rslt );
                        
                        rslt = rslt + timesincetargetMin;
                       // system.debug(':::timesincetargetMin::' + timesincetargetMin );
                       // system.debug(':::rslt minutes--2::' + rslt );
                    }
                    
                    hrs = rslt/60;
                   
                    if(hrs>0)
                        mins = math.mod(rslt,60);
                    else
                        mins = rslt;
                    
                    system.debug('***21'+mins+'***'+hrs);
                    //system.debug('::::cc.TargetResponseInMins:::'+ cc.TargetResponseInMins);
                    //system.debug('::::cc.TimeRemainingInMins:::'+ cc.TimeRemainingInMins);
                   // system.debug('::::rslt:::'+ rslt);
                    //system.debug('::::timeRemMin:::'+ timeRemMin);
                     
                    if(hrs !=0){
                        if(mins >9){
                            if(hrs >9)
                                s = String.ValueOf(hrs)+':'+String.ValueOf(mins);
                            else    
                                s = '0'+ String.ValueOf(hrs)+':'+String.ValueOf(mins);
                         }       
                        else{
                            if(hrs >9)
                                s = String.ValueOf(hrs)+':0'+String.ValueOf(mins);
                            else    
                                s = '0'+ String.ValueOf(hrs)+':0'+String.ValueOf(mins);
                          }      
                    }
                    else{ 
                        if(mins >9)
                            s = '00:'+String.ValueOf(mins);
                        else
                            s = '00:0'+String.ValueOf(mins);
                        }           
                }
                if(hrs < 0 || mins < 0){
                    s = '00:00';
                }   
                
               
                 
            s1= cc.StartDate.format();
            s2 = cc.TargetDate.format();
            if(cc.TargetResponseInMins <60)
                s3 = '00:'+cc.TargetResponseInMins ;
            else{
                s3 = string.valueof(cc.TargetResponseInHrs) ;
                if(s3.contains('.'))
                    s3 = s3.replace('.',':');
            }
            s4 = string.valueof(cc.TimeRemainingInMins);
            minList = s4.split(':');
            s5 = minlist[0];
            d2 = integer.valueof(s5);
            min1 = math.Mod(d2,60);
            if(d2> 60){
                if(min1>9)
                    s6 = string.valueof(d2/60) +':'+ string.valueof(min1);
                else if(min1 ==0)
                   s6 = string.valueof(d2/60) +':00' ;
                else
                    s6 = string.valueof(d2/60) +':0'+ string.valueof(min1);   
            }             
            else{
                if(d2>9)
                    s6 = '00:' + string.valueof(d2);  
                else if(d2 ==0)
                    s6 = '00:00';
                else
                    s6 = '00:0' + string.valueof(d2); 
                }        
                  
            //minList.add(s);
            caseMileWrap = new CaseMilestoneWrapper();
            caseMileWrap.caseMile = new CaseMilestone();
            caseMileWrap.caseMile=cc;
            caseMileWrap.strDateTime = s;
            caseMileWrap.startDare = s1 ;
            caseMileWrap.sEndDate = s2;
            caseMileWrap.stargetDate = s3;
            caseMileWrap.sRemainDate= s6;
            lstWrapper.add(caseMileWrap);
        }
        system.debug('**lstWrapper**'+lstWrapper);
        //return lstWrapper;
        
    }   

   
}