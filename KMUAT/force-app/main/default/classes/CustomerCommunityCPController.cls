public class CustomerCommunityCPController{
    
    public String oldpassword {get; set;}
    public String password {get; set;}
    public String confirmpassword {get; set;}
    
    public CustomerCommunityCPController() {}
    
    // Code we will invoke on page load.
    public PageReference forwardToCustomAuthPage() {

        if((UserInfo.getUserType() == 'Guest') || (Test.IsRunningTest() && UserInfo.getUserType() == 'Standard')){
            return new PageReference('/CustomerCommunityHome');
        }
        else{
            return null;
        }
    }
    
    public PageReference BackPage() {
        return new PageReference('/CustomerCommunityUserAccount');   
    }
    public PageReference Save() {
        if(oldpassword == '' || password == '' || confirmpassword == '') {
            if(oldpassword == '')
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Old Password: Value is required.')); 
            if(password == '')
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'New Password: Value is required.')); 
            if(confirmpassword == '')
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Confirm New Password: Value is required.'));             
            return null;  
        }
        return Site.changePassword(password, confirmpassword, oldpassword); 
        
        //return new PageReference('/CustomerCommunityUserAccount');   
    }
}