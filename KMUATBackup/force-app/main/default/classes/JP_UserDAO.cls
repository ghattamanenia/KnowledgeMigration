public class JP_UserDAO {
    // 20210407 商談自動作成処理 terrasky add start
    /**
     * ユーザー情報を取得する。
     * @param Id ID
     * @return User
     */
    public static List<User> getUserInfo(Id userId) {
        List<User> user = [SELECT Id, IsActive FROM User WHERE Id =:userId];
        return user;
    }
    // 20210407 商談自動作成処理 terrasky add end
}