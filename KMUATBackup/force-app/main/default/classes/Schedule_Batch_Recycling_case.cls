global class Schedule_Batch_Recycling_case implements Schedulable{
    global void execute(SchedulableContext sc) {
        Batch_Recycling_Case rL = new Batch_Recycling_Case ();
       database.executebatch(rL);
       system.abortJob(sc.getTriggerId());
    }
}