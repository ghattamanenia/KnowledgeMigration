/**
 * TestClass JP_RestClass
 */

@IsTest
private class JP_RestClassTest {
    @isTest static void testGetRec() {
        
        Test.startTest();
        List<SObject> result = JP_RestClass.getRec('SELECT Id FROM Account LIMIT 1');
        Test.stopTest();
    }
}