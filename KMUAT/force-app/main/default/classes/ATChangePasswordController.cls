public with sharing class ATChangePasswordController {
    @AuraEnabled
    public static void changePassword(String currentPassword, String newPassword, String verifyNewPassword) {
        if (String.isBlank(currentPassword) || String.isBlank(newPassword) || String.isBlank(verifyNewPassword)) {
            throw new AuraHandledException('Please provide all required fields.');
        }
        else{
            // Use the Site.changePassword method
         Site.changePassword(newPassword, verifyNewPassword, currentPassword);
        }
    }
}