@IsTest
public class ATChangePasswordControllerTest {
    @IsTest
    static void testChangePassword() {
        // Create a test user
        User testUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' and isActive=true LIMIT 1];
        System.runAs(testUser) {
            Test.startTest();
            // Call the changePassword method with valid credentials
            ATChangePasswordController.changePassword('oldPassword', 'newPassword', 'erifyNewPassword');
            Test.stopTest();
        }
    }

    @isTest
    static void testChangePassword_BlankFields() {
        Test.startTest();

        // Test for blank currentPassword
        Exception caughtException1;
        try {
            ATChangePasswordController.changePassword('', 'newPass123!', 'newPass123!');
        } catch (Exception e) {
            caughtException1 = e;
        }
        System.assertNotEquals(null, caughtException1, 'Exception expected for blank currentPassword.');

        // Test for blank newPassword
        Exception caughtException2;
        try {
            ATChangePasswordController.changePassword('currentPass123', '', 'newPass123!');
        } catch (Exception e) {
            caughtException2 = e;
        }
        System.assertNotEquals(null, caughtException2, 'Exception expected for blank newPassword.');

        // Test for blank verifyNewPassword
        Exception caughtException3;
        try {
            ATChangePasswordController.changePassword('currentPass123', 'newPass123!', '');
        } catch (Exception e) {
            caughtException3 = e;
        }
        System.assertNotEquals(null, caughtException3, 'Exception expected for blank verifyNewPassword.');

        Test.stopTest();
    }
}