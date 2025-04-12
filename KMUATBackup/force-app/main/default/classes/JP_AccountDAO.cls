public class JP_AccountDAO {
    // 20210407 商談自動作成処理 terrasky add start
    /**
     * 名前を取得する。
     * @param Id ID
     * @return Account
     */
    public static Account getAccountName(Id accountId) {
        return [SELECT Name FROM Account WHERE Id =:accountId];
    }
    // 20210407 商談自動作成処理 terrasky add end
}