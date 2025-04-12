/**
 * 来月のシフトを作成するスケジュールクラス
 */
global class JP_Sc_Shift implements Schedulable{
    global void execute(SchedulableContext sc){

        Integer thisYear = Date.today().year();
        Integer nextMonth = Date.today().month()+1;
        Date startDate = Date.newInstance(thisYear, nextMonth, 1);
        Date endDate = Date.newInstance(thisYear, nextMonth+1, 0);

        JP_CreateShift.specifiedPeriodUser(StartDate, endDate, '');
        
    }
}