trigger Case_NewUser_Registration on Case (before update) {
 
     Case_Reg_NewUser.RegUser(trigger.new, Trigger.oldMap);   
}