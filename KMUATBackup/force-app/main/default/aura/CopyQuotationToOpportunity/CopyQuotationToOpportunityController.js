({
    doInit : function(component, event, helper) {
        helper.getQuotationHeader(component);
    },
    copyQuotation: function (component, event, helper) {
        var quoId = component.get ("v.recordId");
        var oppId = component.get ("v.opportunity");
    
        var action = component.get ("c.doCopy");
        action.setParams ({"quoId": quoId, "oppId": oppId});
        action.setCallback (this, function (response) {
            var state = response.getState ();
            
            if (state === "SUCCESS") {
                var retVal = response.getReturnValue ();
                
                if (retVal.message) {
                    helper.showError (component, retVal.message);
                } else {
                    var urlEvent = $A.get ("e.force:navigateToURL");
                    urlEvent.setParams ({"url": retVal.url});
                    urlEvent.fire ();
                }
            } else {
                console.log (state);
                
                var errors = response.getError ();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log ("Error message: " + errors[0].message);
                    }
                } else {
                    console.log ("Unknown error");
                }
            }            
        });
        
        $A.enqueueAction (action);
    }
})