({
	doInit : function(component, event, helper) {
		helper.helperDoInit(component, event);
	},
	
    doCheck : function(component, event, helper) {
		helper.helperDoChack(component, event);
	},
    
    doCreateNew : function(component, event, helper) {
		helper.helperCreateNew(component, event);
	},

    doCreateUpdate : function(component, event, helper) {
		helper.helperCreateUpdate(component, event);
	}
})