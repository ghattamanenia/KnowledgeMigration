trigger JP_TR_ContentDocument on ContentDocument (before delete) {
    //====================
    // トリガ実行クラス
    //====================
    JP_CL_ContentDocumentTrg trgCon = new JP_CL_ContentDocumentTrg();

    if (Trigger.isBefore) {
        if (Trigger.isDelete) {
            trgCon.onBeforDelete(Trigger.old);
        }
    }
}