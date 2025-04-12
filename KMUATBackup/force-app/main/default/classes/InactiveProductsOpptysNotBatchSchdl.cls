global class InactiveProductsOpptysNotBatchSchdl implements schedulable
{
    global void execute(SchedulableContext sc)
    {
        Id i=database.executebatch(new InactiveProductsOpptysNotificationBatch(),100);
    }
}