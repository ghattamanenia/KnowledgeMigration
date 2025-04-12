global class JP_Sc_User implements Schedulable{
    global void execute(SchedulableContext sc){

        //ユーザ無効化
        JP_User.disableUser();
    }
}