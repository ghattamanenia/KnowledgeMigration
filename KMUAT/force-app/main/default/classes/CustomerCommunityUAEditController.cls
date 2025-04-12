public class CustomerCommunityUAEditController{
    public String firstName {get; set;}
    public String lastName {get; set;}
    public String email {get; set;}
    public String password {get; set;}
    public String confirmPassword {get; set;}
    public String communityNickname {get; set;}
    public String error {get; set;}
    
    public CustomerCommunityUAEditController() {
        firstName = UserInfo.getFirstName();
        lastName = UserInfo.getLastName();
        email = UserInfo.getUserEmail();
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
        return new PageReference('/CustomerCommunityUserAccount');   
    }
    
    public PageReference Save() {
        try {
            /* Update User */
            User usr = [Select Id, ContactId from User where Id =: UserInfo.getUserId()];
            usr.FirstName = firstname;
            usr.LastName = lastname;
            usr.Email = email;
            update usr;
            
            /* Update Contact */
            if(usr != null)
            {
                Contact con = [SELECT Id FROM Contact WHERE Id =: usr.ContactId];
                con.FirstName = firstname;
                con.LastName = lastname;
                con.Email = email;
                update con;
            }
        }
        catch(Exception ex) {
            error = ex.getMessage();
            System.debug('The following exception has occurred when updating Account Detail ' + ex.getMessage());
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error updating Account Detail:' + ex.getMessage());
            ApexPages.addMessage(myMsg);
        }

        return new PageReference('/CustomerCommunityUserAccount');   
    }
}