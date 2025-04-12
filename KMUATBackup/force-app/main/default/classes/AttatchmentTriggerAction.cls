public with sharing class AttatchmentTriggerAction {
     /*
    * 見積基本添付ファイル削除禁止処理
    * @param List<Attachment>
    * @return 
    */
    public static void deleteAttachment(List<Attachment> oldList){
        // プロファイル名：システム管理者
        String systemadmin = JP_Const.SYSTEM_ADMIN;
        // プロファイル名：JP_SｙstemAdministrator
        String JP_systemadmin = JP_Const.JP_SYSTEM_ADMIN;
        // エラーメッセージ
        String ErrMsg = system.Label.JP_ErrorMessageDeleteAttachment;
        
        // ログインユーザのプロファイルIDを取得
        String profileId = UserInfo.getProfileId();
        // プロファイルIDからプロファイルの名称を取得
        String profileName = ProfileDAO.getRecById(profileId).Name;
        
        for(Attachment att : oldList){
            // 添付ファイルの関連先のIDを取得
            Id parentId = att.ParentId;
            // 関連先のオブジェクトタイプを取得
            Schema.sObjectType entityType = parentId.getSObjectType();
            // 関連先が【製品見積】、かつ、プロファイルが【システム管理者】」と【JP_SystemAdministrator】のどちらでもない場合エラー
            if(entityType == JP_QuotationHeader__c.sObjectType){
                if(profileName != systemadmin && profileName != JP_systemadmin){
                    att.addError(ErrMsg);
                }
            }
            // 関連先が【注文書管理】、かつ、プロファイルが【システム管理者】」と【JP_SystemAdministrator】のどちらでもない場合エラー
            if(entityType == JP_Order010PurchaseOrder__c.sObjectType){
                if(profileName != systemadmin && profileName != JP_systemadmin){
                    att.addError(ErrMsg);
                }
            }
            // 関連先が【注文書登録指示】、かつ、プロファイルが【システム管理者】」と【JP_SystemAdministrator】のどちらでもない場合エラー
            if(entityType == JP_Order020RegistrationRequest__c.sObjectType){
                if(profileName != systemadmin && profileName != JP_systemadmin){
                    att.addError(ErrMsg);
                }
            }
            // 関連先が【注文書登録指示SS】、かつ、プロファイルが【システム管理者】」と【JP_SystemAdministrator】のどちらでもない場合エラー
            if(entityType == JP_Order036SS__c.sObjectType){
                if(profileName != systemadmin && profileName != JP_systemadmin){
                    att.addError(ErrMsg);
                }
            }
        }
    }
}