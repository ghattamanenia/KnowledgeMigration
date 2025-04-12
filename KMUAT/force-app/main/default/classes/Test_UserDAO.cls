@isTest
private class Test_UserDAO {

    static testMethod void testgetUserName() {
		User usr = JP_TestUtil.Create_ApproverUser('A121_課長');
	
		Test.startTest();
		String uname = UserDao.getUserName(usr.Id);
		Test.stopTest();
    }
    
    static testmethod void testgetUserByGroupId(){
    	User usr = JP_TestUtil.Create_ApproverUser('A121_課長');
    	
    	Group g = new Group();
    	g.Name = 'TEST';
    	insert g;
    	
    	GroupMember gm = new GroupMember();
    	gm.GroupId = g.Id;
    	gm.UserOrGroupId = usr.Id;
    	insert gm;
    	
    	Set<String> groupIds = new Set<String>();
    	groupIds.add(g.Id);
    	
    	Test.startTest();
		Set<String> gset = UserDAO.getUserByGroupId(groupIds);
		Test.stopTest();
    }
}