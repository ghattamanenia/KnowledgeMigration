global class QuoteExpirationNotificationBatchSchdl implements schedulable
{
    global void execute(SchedulableContext sc)
    {
        Id i=database.executebatch(new QuoteExpirationNotificationBatch(),100);
    }
}