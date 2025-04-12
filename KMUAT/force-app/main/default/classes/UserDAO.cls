public with sharing class UserDAO {
    public static String getUserName(String uID){
        User u =  [select Name from User where Id = :uId];
        return u.Name;
    }
    
    public static Set<String> getUserByGroupId(Set<String> groupIds){
        List<GroupMember> gmList = [select UserOrGroupId from GroupMember where GroupId IN :groupIds];
        for(GroupMember gm : gmList){
            if(!groupIds.contains(gm.UserOrGroupId)){
                groupIds.add(gm.UserOrGroupId);
            }
        }
        
        return groupIds;
    }
}