trigger JP_TR_ContentDocumentLink on ContentDocumentLink (after insert,after delete) {
    //====================
    // トリガ実行クラス
    //====================
    JP_CL_ContentDocumentLinkTrg trgCon = new JP_CL_ContentDocumentLinkTrg();

    if (Trigger.isAfter) {
        // ToDoレコードに添付ファイルをアップロードする場合
        if (Trigger.isInsert) {
            trgCon.onAfterInsert(Trigger.new);
        }
        // ToDoレコードの添付ファイルをレコードから削除する場合
        else if (Trigger.isDelete) {
            trgCon.onAfterDelete(Trigger.old);
        }
    }
}