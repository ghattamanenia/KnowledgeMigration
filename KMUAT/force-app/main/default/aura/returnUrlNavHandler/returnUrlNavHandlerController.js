({
   invoke : function(component, event, helper) {
      var returnUrl = helper.createReturnUrl(component);
      // Return back
      window.open(returnUrl, '_self');
   }
})