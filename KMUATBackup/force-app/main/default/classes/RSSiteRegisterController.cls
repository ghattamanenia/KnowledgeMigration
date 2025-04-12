public with sharing class RSSiteRegisterController {


    // PORTAL_ACCOUNT_ID is the account on which the contact will be created on and then enabled as a portal user.
    // you need to add the account owner into the role hierarchy before this will work - please see Customer Portal Setup help for more information.       
    
    
    public RSSiteRegisterController () {}
    
   /* public String firstname {get; set;}
    public String lastname {get; set;}
    public String phone {get; set;}
    public String username {get; set;}
    public String email {get; set;}
    public String password {get; set {password = value == null ? value : value.trim(); } }
    public String confirmPassword {get; set { confirmPassword = value == null ? value : value.trim(); } }
    public String communityNickname {get; set { communityNickname = value == null ? value : value.trim(); } }
    public String selectedAccount {get; set;}
    
    
    private boolean isValidPassword() {
        return password == confirmPassword;
    }
    
    
    public List<SelectOption> getAccountOptions() {
        
        List<SelectOption> retOptions = new List<SelectOption>();
        List<Account> accs = [select Id,Name from Account where ATFE_Active__c = true order by Name LIMIT 1000];
        
        for(Account a : accs) {
            
            retOptions.add(new SelectOption(a.Id,a.Name));
            
        }
        
        return retOptions;
    }
    
    public PageReference registerUser() {
        // it's okay if password is null - we'll send the user a random password in that case
        if (!isValidPassword()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.site.passwords_dont_match);
            ApexPages.addMessage(msg);
            return null;
        }
        User u = new User();
        u.Username = email;
        u.Email = email;
        u.CommunityNickname = email.substring(8);
        System.Debug('NICKNAME: '+u.CommunityNickname);
        u.FirstName = firstname;
        u.LastName = lastname;
        
        
        String accountId = selectedAccount;

       // IRSNewPortalUser execNPU = new RSDefaultNewPortalUser();
        
       // PageReference pr = execNPU.execute(u,accountId,password); 


       // return pr;
       return null;
    } */
    
}