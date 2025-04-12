@isTest(SeeAllData=true)
private class Test_JP_GenericWithoutDAO {
    
    static testMethod void testinsertRec1() {
		JP_GenericWithoutDAO.insertRec(new Account(Name = 'Test Account'));
    }
    
    static testMethod void testinsertRec2() {
        try {
			JP_GenericWithoutDAO.insertRec(new Opportunity(StageName = 'Closed/Lost - APAC'));
        } catch (DmlException de) {
			//何もしない
        }
    }
}