public without sharing class JP_CL_ContentDocumentLinkTrg {
    public static final String KBN_INSERT = '1';
    public static final String KBN_DELETE = '2';
    //public static List<String> mailExtensionList = new List<String>();

    //static {
    //    mailExtensionList = System.Label.CDL011_DFN_0002.split(',');
    //}

    /**
    * After Insert 処理
    * @param newList Trigger.new
    * @return なし
    **/
    public void onAfterInsert(List<ContentDocumentLink> newList){
        // ★該当トリガーは1件のみ処理できる★
        // 対象ToDoオブジェクトのContentDocumentLinkList取得
        List<ContentDocumentLink> sObjectContentDocumentLinkList = getSObjectContentDocumentLinkList(newList);
        if (sObjectContentDocumentLinkList.isEmpty()) {
            return;
        }

        // 該当ToDoオブジェクト更新処理
        updateTask(sObjectContentDocumentLinkList, KBN_INSERT);
    }

    /**
    * After Delete 処理
    * @param oldList Trigger.old
    * @return なし
    **/
    public void onAfterDelete(List<ContentDocumentLink> oldList){
        // ★該当トリガーは1件のみ処理できる★
        // 対象ToDoオブジェクトのContentDocumentLinkList取得
        List<ContentDocumentLink> sObjectContentDocumentLinkList = getSObjectContentDocumentLinkList(oldList);
        if (sObjectContentDocumentLinkList.isEmpty()) {
            return;
        }

        // 該当ToDoオブジェクト更新処理
        updateTask(sObjectContentDocumentLinkList, KBN_DELETE);
    }

    /**
    * 添付ファイルを新規、レコードから削除する場合、対象ToDoオブジェクトのContentDocumentLinkList取得
    * @param newOldList 添付ファイルを新規する場合、Trigger.new；添付ファイルをレコードから削除する場合、Trigger.old
    * @return ContentDocumentLinkのリスト
    **/
    private List<ContentDocumentLink> getSObjectContentDocumentLinkList(List<ContentDocumentLink> newOldList) {
        List<ContentDocumentLink> contentDocumentLinkList = new List<ContentDocumentLink>();
        for (SObject item : newOldList) {
            ContentDocumentLink cdLink = (ContentDocumentLink)item;
            if (cdLink.LinkedEntityId.getSObjectType() == Task.getSObjectType()) {
                contentDocumentLinkList.add(cdLink);
            }
        }

        return contentDocumentLinkList;
    }

    /**
    * 添付ファイルを新規、レコードから削除する場合、該当ToDoオブジェクト更新処理
    * @param contentDocumentLinkList 添付ファイルを新規する場合、ファイルタイプはメールタイプのContentDocumentLinkList；添付ファイルをレコードから削除する場合、対象ToDoオブジェクトのContentDocumentLinkList
    * @param shoriKbn 処理区分＝'1'、添付ファイルを新規用の業務オブジェクト更新処理；処理区分＝'2'、添付ファイルをレコードから削除用の業務オブジェクト更新処理
    * @return なし
    **/
    private void updateTask(List<ContentDocumentLink> contentDocumentLinkList,String shoriKbn) {
        // 件数
        Integer cnt;
        // ToDoレコードIdを取得する
        Id TaskId = contentDocumentLinkList.get(0).LinkedEntityId;
        // ContentDocumentIdを取得する
        Id contentDocumentId = contentDocumentLinkList.get(0).ContentDocumentId;
        // ToDoオブジェクト更新の多端末制御処理
        Task TaskDataLock = [ 
            SELECT
                Id,
                JP_AttachmentFlag__c //添付ファイル有り
            FROM
                Task //ToDoオブジェクト
            WHERE
                Id = :TaskId //ToDoレコードId
            FOR  UPDATE];

        // 添付ファイルを新規する場合
        if (shoriKbn == KBN_INSERT) {
            // アップロード後、メールタイプな添付ファイル有無確認
            cnt = [
                SELECT
                    count()
                FROM
                    ContentDocumentLink
                WHERE
                        LinkedEntityId  = :TaskId]; 
                   // AND ContentDocument.FileExtension IN :CL_ContentDocumentLinkTrg.mailExtensionList];
        }
        // ToDoレコードから削除するの場合
        else if (shoriKbn == KBN_DELETE) {
            // 削除後、メールタイプな添付ファイル有無確認
            cnt = [
                SELECT
                    count()
                FROM
                    ContentDocumentLink
                WHERE
                        LinkedEntityId  = :TaskId 
                    AND ContentDocumentId != :contentDocumentId];
                    //AND ContentDocument.FileExtension IN :CL_ContentDocumentLinkTrg.mailExtensionList];
        }

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