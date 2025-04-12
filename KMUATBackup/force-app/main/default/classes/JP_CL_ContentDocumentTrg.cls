public without sharing class JP_CL_ContentDocumentTrg {
    /**
    * Before Delete 処理
    * @param oldList Trigger.old
    * @return なし
    **/
    public void onBeforDelete(List<ContentDocument> oldList){
        // ★該当トリガーは1件のみ処理できる★
        //ContentDocumentの処理対象を取得する
        ContentDocument cDocument = (ContentDocument)Trigger.old.get(0);
        // ContentDocumentLinkデータを取得する
        List<ContentDocumentLink> contentDocumentLinkAllList = [
            SELECT
                Id,
                LinkedEntityId,
                ContentDocumentId
            FROM
                ContentDocumentLink
            WHERE
                ContentDocumentId  = :cDocument.Id];

        // ToDoオブジェクト対象データ取得
        List<ContentDocumentLink> contentDocumentLinkList = new List<ContentDocumentLink>();
        for (SObject item : contentDocumentLinkAllList) {
            ContentDocumentLink cdLink = (ContentDocumentLink)item;
                if (cdLink.LinkedEntityId.getSObjectType() == Task.getSObjectType()) {
                    contentDocumentLinkList.add(cdLink);
            }
        }
        if (contentDocumentLinkList.isEmpty()) {
            return;
        }

        // ToDoレコードIdを取得する
        Id TaskId = contentDocumentLinkList.get(0).LinkedEntityId;

        // ToDoオブジェクト更新の多端末制御処理
        Task TaskDataLock = [
            SELECT
                Id,
                JP_AttachmentFlag__c
            FROM
                Task
            WHERE
                Id = :TaskId
            FOR  UPDATE];

        // 削除後、メールタイプな添付ファイル有無確認
        Integer cnt = [
            SELECT
                count()
            FROM
                ContentDocumentLink
            WHERE
                    LinkedEntityId  = :TaskId 
                AND ContentDocumentId != :cDocument.Id];
                //AND ContentDocument.FileExtension IN :CL_ContentDocumentLinkTrg.mailExtensionList];

        // ToDoレコードを更新する
        if (cnt == 0 && TaskDataLock.JP_AttachmentFlag__c != False) {
            Task ts = new Task();
            ts.Id = TaskId;
            ts.JP_AttachmentFlag__c = False;

            update ts;
        } else if(cnt != 0 && TaskDataLock.JP_AttachmentFlag__c != True) {
            Task ts = new Task();
            ts.Id = TaskId;
            ts.JP_AttachmentFlag__c = True;

            update ts;
        }
    }    
}