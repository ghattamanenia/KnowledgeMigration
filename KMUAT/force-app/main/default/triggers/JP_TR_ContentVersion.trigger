trigger JP_TR_ContentVersion on ContentVersion (after insert) {
    //====================
    // トリガ実行クラス
    //====================
    JP_CL_ContentVersionTrg trgCon = new JP_CL_ContentVersionTrg();

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            trgCon.onAtertInsert(Trigger.new);
        }
    }
}