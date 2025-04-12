public with sharing class ProfileDAO {

	/*
	* システム管理者プロファイル取得処理
	* @param
	* @return Proile
	*/
	public static Profile getRecById(String profileId){
		return [select Id,Name from Profile where Id = :profileId];
	}

}