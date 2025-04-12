/**
 * An apex page controller that exposes the Community site forgot password functionality
 */
public /*with sharing*/ class CustomerCommunityForgotPwdController {
    public String username {get; set;}   
    public String error{get;set;}

    public CustomerCommunityForgotPwdController() {}

    public PageReference forgotPassword() {

        if(username == '') {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'User Name: Value is required.')); 
            return null;  
        }

        try {
            user UserNeedPass = [select id from user where username =: username];
            if(UserNeedPass.id != null) {
                System.resetPassword(UserNeedPass.id, true); 
            } else {
                //return new PageReference('/CustomerCommunityForgotPwdNotFound');
            }  
        } catch(Exception ex) {
            error = 'The following exception has occurred selecting user: ' + ex.getMessage(); 

            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, error)); 
            return null; 
        }
        return new PageReference('/Support/CustomerCommunityForgotPwdConfirm');
    }

    public PageReference BackPage() {
        return new PageReference('/Support/CustomerCommunityHome');
    }
}
/* 
*Per Salesforce, this should also work after published
* https://help.salesforce.com/apex/HTViewSolution?urlname=Why-are-my-External-Community-Users-not-getting-their-password-reset-emails&language=en_US
*
public with sharing class CustomerCommunityForgotPwdController {
    public String username {get; set;}   
       
    public CustomerCommunityForgotPwdController () {}
    
    public PageReference forgotPassword() {
        try {
            Site.forgotPassword(username);
        }   
        catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage()));
            return null;
        }
        return new PageReference('/CustomerCommunityForgotPwdConfirm');
    }
}
*/