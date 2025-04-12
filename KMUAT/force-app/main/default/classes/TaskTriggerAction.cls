public with sharing class TaskTriggerAction {
	/*
    * 見積基本ToDo削除禁止処理
    * @param List<Task>
    * @return 
    */
    public static void deleteActivityHistory(List<Task> oldList){
		// プロファイル名：システム管理者
		String systemadmin = JP_Const.SYSTEM_ADMIN;
		// プロファイル名：JP_SｙstemAdministrator
		String JP_systemadmin = JP_Const.JP_SYSTEM_ADMIN;
		// エラーメッセージ
		String ErrMsg = system.Label.JP_ErrorMessageDeleteActivityHistory;
		// ログインユーザのプロファイルIDを取得
		String profileId = UserInfo.getProfileId();
		// プロファイルIDからプロファイルの名称を取得
		String profileName = ProfileDAO.getRecById(profileId).Name;
		
		for(Task todo : oldList){
			// タスクの関連先のIDを取得
			Id whatId = todo.WhatId;
			if(whatId != null){
				// 関連先のIDからオブジェクトタイプを取得
				Schema.sObjectType entityType = whatId.getSObjectType();
				// 関連先が【製品見積】、かつ、プロファイルが【システム管理者】」と【JP_SystemAdministrator】のどちらでもない場合エラー
				if(entityType == JP_QuotationHeader__c.sObjectType){
					if(profileName != systemadmin && profileName != JP_systemadmin){
						todo.addError(ErrMsg);
					}
				}
			}
		}
    }
}