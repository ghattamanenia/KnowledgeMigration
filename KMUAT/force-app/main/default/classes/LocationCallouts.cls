public class LocationCallouts {
     public static boolean skipcallout = false;
    
     @future (callout=true)  // future method needed to run callouts from Triggers
      static public void getLocation(List<Id> AccountIds){
      list<BusinessHour__c > lstbusinessHour = BusinessHour__c.getAll().values();
      List<Account> accounts = new List<Account>();
      List<Account> updatedaccounts = new List<Account>();
        // gather account info
        accounts = [SELECT BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet FROM Account WHERE id In :AccountIds];
        system.debug('###accounts###' + accounts);
        // create an address string
        for(Account a : Accounts){
            String address = '';
           // if (a.BillingStreet != null)
             //   address += a.BillingStreet +', ';   // commented billing street as many accounts have invalid billing street
            if (a.BillingCity != null)
                address += a.BillingCity +', ';
            if (a.BillingState != null)
                address += a.BillingState +' ';
           // if (a.BillingPostalCode != null)
             //   address += a.BillingPostalCode +', '; // commented billing postal code as many accounts have invalid billing postal code
            if (a.BillingCountry != null)
                address += a.BillingCountry;
     
             system.debug('address is::' +address ) ;
            address = EncodingUtil.urlEncode(address, 'UTF-8');
            
            //string My_Key = 'AIzaSyA5D-Ys-le483Uy7-FFLnO5zBf5VPu8SsY';
            string AlliedTelesis_Key = 'AIzaSyDIKR6kovEQYbQRsbCu8yArX03yy6liwnk';
     
            // build callout
            Http h = new Http();
            HttpRequest req = new HttpRequest();
           // req.setEndpoint('http://maps.googleapis.com/maps/api/geocode/json?address='+address+'&sensor=false');
            req.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?key='+AlliedTelesis_Key+'&address='+address+'&sensor=false');
             
            req.setMethod('GET');
            req.setTimeout(60000);
     
            try{
                // callout
                system.debug('### req ###' + req);
                HttpResponse res;
                if(!Test.IsRunningTest())
                    res = h.send(req);
     
                
                // parse coordinates from response
                JSONParser parser;
                if(Test.IsRunningTest())
                    parser = JSON.createParser('[{"location" : {"lat" : 37.42291810, "lng" : -122.08542120}}]');
                else
                    parser = JSON.createParser(res.getBody());
                
               
                //system.debug('#### response body ####'+ res.getBody() );
                system.debug('#### parser ####'+ parser );
                
                double lat = null;
                double lon = null;
                double offset = null;
                double daylightsaving = null;
                string timezone = null;
                string timezneid = null;
                while (parser.nextToken() != null) {
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                        (parser.getText() == 'location')){
                           parser.nextToken(); // object start
                           while (parser.nextToken() != JSONToken.END_OBJECT){
                               String txt = parser.getText();
                               system.debug('::TKEN::' + txt);
                               parser.nextToken();
                               if (txt == 'lat')
                                   lat = parser.getDoubleValue();
                               else if (txt == 'lng')
                                   lon = parser.getDoubleValue();
                           }
     
                    }
                }
     
                // update coordinates if we get back
                if (lat != null){
                   // a.Location__Latitude__s = lat;
                    //a.Location__Longitude__s = lon;
                    //update a;
                    string timstmp;// = '1331161200';
                    Datetime dt = Datetime.now();
                    Long seconds = ((dt.getTime())/1000);
                    timstmp = String.valueOf(seconds);
                    
                     system.debug('timestamp now ::' + timstmp );
                    // build callout
            Http h1 = new Http();
            HttpRequest req1 = new HttpRequest();
           // req.setEndpoint('http://maps.googleapis.com/maps/api/geocode/json?address='+address+'&sensor=false');
            req1.setEndpoint('https://maps.googleapis.com/maps/api/timezone/json?location='+lat+','+lon+'&timestamp='+timstmp+'&sensor=false&key='+AlliedTelesis_Key);
            req1.setMethod('GET');
            req1.setTimeout(60000);
            
                        try
                        {
                            // callout
                            HttpResponse res1;
                            if(!Test.isRunningTest())
                                res1 = h1.send(req1);
                 
                            // parse coordinates from response
                             JSONParser parser1;
                            if(Test.isRunningTest())
                               parser1 = JSON.createParser('{"dstOffset" : 3600,"rawOffset" : -28800,"status" : "OK","timeZoneId" : "America/Los_Angeles","timeZoneName" : "Pacific Daylight Time" }');
                            else
                                parser1 = JSON.createParser(res1.getBody());
                            
                             //system.debug('::nextbody::' + res1.getBody() );
                            
                            while (parser1.nextToken() != null) {
                                string newtxt = parser1.getText();
                                system.debug('newtxt value is::' + newtxt );
                                if(newtxt == 'dstOffset')
                                {
                                    system.debug(':: inside dstoffset::');
                                    parser1.nextToken();
                                    offset = parser1.getDoubleValue();
                                    system.debug('Day light saving is::' + offset );
                                  //  parser1.nextToken();
                                  break;
                                }
                              }
                              while (parser1.nextToken() != null) {
                                string newtxt = parser1.getText();
                                system.debug('newtxt value is::' + newtxt );
                                if(newtxt == 'rawOffset')
                                {
                                    system.debug(':: inside dstoffset::');
                                    parser1.nextToken();
                                    daylightsaving = parser1.getDoubleValue();
                                    system.debug('Day light saving is::' + daylightsaving );
                                  //  parser1.nextToken();
                                  break;
                                }
                              }
                 
                           
                                while (parser1.nextToken() != null) {
                                string newtxt = parser1.getText();
                                system.debug('newtxt value is::' + newtxt );
                                if(newtxt == 'timeZoneId')
                                {
                                    system.debug(':: inside dstoffset::');
                                    parser1.nextToken();
                                    timezone = parser1.gettext();
                                    system.debug('Day light saving is::' + timezone );
                                  //  parser1.nextToken();
                                  break;
                                }
                              }
                              while (parser1.nextToken() != null) {
                                string newtxt = parser1.getText();
                                system.debug('newtxt value is::' + newtxt );
                                if(newtxt == 'timeZoneName')
                                {
                                    system.debug(':: inside dstoffset::');                                   
                                    parser1.nextToken();
                                    timezneid = parser1.gettext();
                                    system.debug('Day light saving is::' + timezneid );
                                    skipcallout = true;
                                               a.new_Test_field__c = 'Some Info about Account\'s address. timestamp:'+ timstmp+' \nTimeZone offset is: ' +  (offset/3600) + ' Hrs GMT.\nDay light saving offset: ' + (daylightsaving/3600) + '\nlattitude is :' + lat + '\nLongitude is :' + lon;  
                                               a.Account_Location__Latitude__s = lat;
                                               a.Account_Location__Longitude__s = lon;
                                               decimal ssoffset = offset/3600 + daylightsaving/3600 ;
                                               system.debug('***ssoffset '+ ssoffset );
                                               /*for(BusinessHour__c bh : lstbusinessHour){
                                                 if(bh.offset__c == ssoffset)
                                                    a.Business__c  = bh.Account_Time_Zone__c +' '+ timezneid + ' ('+ timezone + ')';
                                                }*/
                                                
                                                a.Business__c  = timezneid + ' ('+ timezone + ')'; 
                                                a.TimeZoneName__c =  timezone ;
                                              /* for(CustomerTimeZone__c bh : lstbusinessHour){
                                                 if(timezone == bh.TimeZoneId__c)
                                                    a.Business__c  = bh.Account_Time_Zone__c;
                                                }   */
                                              // update a;
                                              updatedaccounts.add(a);
                                  //  parser1.nextToken();
                                  break;
                                }
                              }
                            
                         }
                        catch (Exception e) {
                        }
                }
            } catch (Exception e) {
            }
        }
        system.debug('### updated Accounts ###' + updatedaccounts);
        if(!test.isrunningTest())
        update updatedaccounts;
    } 
}