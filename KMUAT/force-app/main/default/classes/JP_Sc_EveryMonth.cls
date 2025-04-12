global class JP_Sc_EveryMonth implements Schedulable{
    global void execute(SchedulableContext sc){
        // 3か月前の価格表を無効化
        JP_Sc.disablePriceBook2();
    }
}