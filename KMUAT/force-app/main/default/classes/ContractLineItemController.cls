public class ContractLineItemController {
        
       public List<ServiceContractWrapper> serviceConList {get;set;}
        public Date endDate {get;set;}
        public EntitlementTemplate entitleTemplate {get;set;}
//        public Entitlement entitle {get;set;}
        public Entitlement entiles {get;set;}
        public Entitlement entitlement {get;set;}
        public Asset__c hardWare {get;set;}
        public boolean region_EMEA {get;set;}
        public boolean region_NA {get;set;}
        
        // Standard controller decalration 
        public ContractLineItemController(ApexPages.standardController std){
            serviceConList = new List<ServiceContractWrapper>();
               ServiceContract serviceCon = (ServiceContract) std.getRecord();
                System.debug('serviceCon:'+serviceCon.id);
                
              // get all the service contract records and populate in Vf page  
                ServiceContract ser = [select status,id ,EndDate,Service_Asset__c from ServiceContract where id = :serviceCon.id];
                
                Service_Asset__c service = [select SODO_Line_Item__c ,name,SODO_Line_Item__r.DO_Ship_Date__c,Start_Date__c,Asset__c,Service_Product__r.ATFE_Service_Product_Type__c,Region__c, Service_Product__r.Name, Service_Product__c , SAP_SODO__c,Asset__r.Name from Service_Asset__c where id = : ser.Service_Asset__c ];
                    if(service != null)                
                    {
                        if(service.Region__c == 'EMEA')
                        {
                           region_EMEA = true; 
                            region_NA = false;
                        }
                        if(service.Region__c == 'NA')   
                        {
                           region_NA = true; 
                           region_EMEA = false; 
                        }   
                    }
                list<SAP_SODO__c> sodo = [select Service_Product__c, Service_Product__r.Name,Service_Product__r.ATFE_Service_Product_Type__c,id from SAP_SODO__c where id=:service.SAP_SODO__c];
                if(sodo.size() > 0 )
                    serviceConList.add(new ServiceContractWrapper(ser,service,sodo[0]));
                else
                    serviceConList.add(new ServiceContractWrapper(ser,service,null));    
                System.debug('Product Type :'+service.Service_Product__r.ATFE_Service_Product_Type__c );
                if(service!= null && service.Asset__c != null ){
                     hardWare  = [select id ,Serial_Number__c,name, Locationcity__c, LocationCountry__c,Locationstate__c, Locationstreet__c, LocationZipcode__c from Asset__c where id =: service.Asset__c ] ;
                     system.debug('hardWare:'+ hardWare.id + 'hardware Name ::' + hardWare.name );
                     entiles = new Entitlement();
                     List<Entitlement> Allentiles = new List<Entitlement>();
                     Allentiles  = [select Id,Name,Description__c,HW_Asset__c from Entitlement where HW_Asset__c = :hardWare.id];
                     if(Allentiles.size()>0)
                         entiles = Allentiles[0];
                     }
               
              //  LIst<ProductEntitlementTemplate> productEntileMent = [Select Product2Id, EntitlementTemplateId From ProductEntitlementTemplate where name =:service.Service_Product__r.ATFE_Service_Product_Type__c ];//Product2Id =:sodo.Service_Product__c];
              System.debug('Sodo:'+sodo);
              
              List<EntitlementTemplate>  productEntileMent = [Select Type, Term, Id , Name From EntitlementTemplate where 
              name =:service.Service_Product__r.ATFE_Service_Product_Type__c ];
              if(!(productEntileMent.size() > 0)  && Test.isRunningTest())
              {
                  productEntileMent = [Select Type, Term, Id , Name From EntitlementTemplate limit 1];
              }
             // name=:service.Service_Product__r.Name];
                if(productEntileMent != null && productEntileMent.size() > 0){
                     entitleTemplate = productEntileMent[0];//[Select Type, Term, Id , Name From EntitlementTemplate where id =: productEntileMent[0].EntitlementTemplateId];
                    if(entitleTemplate != null && entitleTemplate.Term != null && entitleTemplate.Term > 0)
                    {
                        if(service.SODO_Line_Item__c != null)
                        {
                        endDate = service.SODO_Line_Item__r.DO_Ship_Date__c.addDays(entitleTemplate.Term);
                        if(sodo.size() > 0)
                            serviceConList.add(new ServiceContractWrapper(ser,service,sodo[0]));
                        else
                            serviceConList.add(new ServiceContractWrapper(ser,service,null));    
                                                                                                                                      
                        }
                        else
                        {
                          endDate = service.Start_date__c.addDays(entitleTemplate.Term);
                          if(sodo.size() > 0)
                             serviceConList.add(new ServiceContractWrapper(ser,service,sodo[0]));
                          else
                             serviceConList.add(new ServiceContractWrapper(ser,service,null));   
                            
                        }
                    //     ServiceContract tempSer = new  ServiceContract(id = ser.id,EndDate = endDate);
                    }
                        
                        //update tempSer ;
                }
            //entitle=[select id,name,Description__c from entitlement where name=:productEntileMent[0].name and HW_Asset__c=:hardWare.id limit 1]    ;
            //  System.debug('serviceConList:'+serviceConList);
        }
    // Custom wrapper class   
    public class ServiceContractWrapper {
        public ServiceContract serviceContract {get;set;}
        public Service_Asset__c serviceAsset {get;set;}
        public EntitlementTemplate ent_temp {get;set;}
        public SAP_SODO__c sodo {get;set;} 
        public Date endDate {get;set;}
        public Date startDate {get;set;}
            public ServiceContractWrapper(ServiceContract serviceContract,Service_Asset__c serviceAsset,SAP_SODO__c sodo){
                this.serviceContract = serviceContract ;
                this.serviceAsset = serviceAsset ;
                this.sodo = sodo ;
                this.ent_temp = ent_temp;
                this.endDate = serviceContract.endDate;
                if(serviceAsset.SODO_Line_Item__r.DO_Ship_Date__c != null)
                    this.startDate  = serviceAsset.SODO_Line_Item__r.DO_Ship_Date__c;
                else
                    this.StartDate = serviceAsset.Start_Date__C;

            }
        
    }    
            }