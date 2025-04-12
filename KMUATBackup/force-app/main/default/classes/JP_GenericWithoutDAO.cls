public without sharing class JP_GenericWithoutDAO {
	/*
	 * INSERTを実行します
	 * @param INSERT対象のsObjectレコード
	 * @throws Exception INSERTに失敗した場合
	 */
	public static void insertRec(sObject obj) {
		// execute
        insertRecs(new List<sObject>{obj});
	}
    
	/*
	 * INSERTを実行します(LIST)
	 * @param INSERT対象のsObjectレコード
	 * @throws Exception INSERTに失敗した場合
	 */
	public static void insertRecs(List<sObject> objList) {
		// execute
		if (objList != NULL && !objList.isEmpty()) {
			try {
				insert objList;
			} catch (DmlException de) {
				throw de;
			}
		}
	}
}