public class CustomerCommunityUserAccountController{
    public String firstName {get; set;}
    public String lastName {get; set;}
    public String email {get; set;}
    public String password {get; set;}
    public String communityNickname {get; set;}
    public String error {get; set;}
    
    public CustomerCommunityUserAccountController() {
        try {
            firstName = UserInfo.getFirstName();
            lastName = UserInfo.getLastName();
            email = UserInfo.getUserEmail();
        }
        catch (Exception ex) {
            error = ex.getMessage();
        }
    }
    
    
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
        return new PageReference('/CustomerCommunityLoggedIn');   
    }
    
    public PageReference ChangePassword() {
        return new PageReference('/CustomerCommunityChangePassword');   
    }
    
    public PageReference EditAccount() {
        return new PageReference('/CustomerCommunityUserAccountEdit');   
    }
}