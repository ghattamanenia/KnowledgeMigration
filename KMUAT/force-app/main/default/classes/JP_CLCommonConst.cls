public class JP_CLCommonConst {
    public static Set<Id> PROFILENAME() {
        Set<Id> profileIds = new Set<Id>();
        List<String> profileNames = new List<String>{'JP_Logi','JP_CS'};
        List<Profile> profiles = [Select ID from Profile where Name IN: profileNames];
        for(Profile tmpProf : Profiles) {
            profileIds.add(tmpProf.Id);
        }
        return profileIds;
    }
    public static Set<Id> PROFILENAME_ALLJP() {
        Set<Id> profileIds = new Set<Id>();
        List<Profile> profiles = [Select ID from Profile where Name LIKE 'JP_%'];
        for(Profile tmpProf : Profiles) {
            profileIds.add(tmpProf.Id);
        }
        return profileIds;
    }
    public static final String SELECTEDLISTVALUE_USER = 'ユーザ';
    public static final String SELECTEDLISTVALUE_GROUP = 'グループ';
    public static final String OPPORTUNITYTEAMMEMBERROLEOUT = 'Outside Sales';
    public static final String OPPORTUNITYTEAMMEMBERROLEIN = 'Inside Sales';
    public static final String MAILSUBJECT = '案件情報 【{0}】';  
    public static final String MAILTEXT = '関係各位 \n'+
                                          '\n'+
                                          '　　　{0}/{1}＠{2} \n'+
                                          '\n'+
                                          '下記案件情報をご連絡致します。 \n'+
                                          '\n'+
                                          'SFDC商談：{3}\n'+
                                          '\n'+
                                          '情報をお持ちの方はご連絡をお願い致します。 \n'+
                                          '------------------------------------------------------- \n'+
                                          ' 1. 案件ID　　　　　　　　：{4} \n'+
                                          ' 2. ユーザ名　　　　　　　：{5} \n'+
                                          ' 3. 商談名　　　　　　　　：{6} \n'+
                                          ' 4. 機器トレース(フェーズ)：{7} \n'+
                                          ' 5. 都道府県　　　　　　　：{8} \n'+
                                          ' 6. ユーザURL 　　　　　　：{9} \n'+
                                          ' 7. 業種　　　　　　　　　：{10} \n'+
                                          ' 8. 代理店　　　　　　　　：{11} \n'+
                                          ' 9. メンバシップ　　　　　：{12} \n'+
                                          '10. 商流　　　　　　　　　：{13} \n'+
                                          '11. 機種　　　　　　　　　：WEB参照 \n'+
                                          '12. 金額　　　　　　　　　：{14} \n'+ 
                                          '13. 保守トレース　　　　　：{15} \n'+
                                          '14. ランク　　　　　　　　：{16} \n'+
                                          '15. 確度　　　　　　　　　：\n'+
                                          '16. 競合　　　　　　　　　：WEB参照 \n'+
                                          '17. 案件確定日　　　　　　：{19} \n'+
                                          '18. 売上日　　　　　　　　：{20} \n'+
                                          '19. 説明　　　　　　　　　：{21} \n'+
                                          '-------------------------------------------------------  \n';
    public static final String TRANSMAILSUBJECT = '{0}TransReport ({1}) {2} {3}様';
    public static final String TRANSMAILTEXT = 'TO：{0}　様 \n'+
                                               'CC：拠点関係各位、関連各位 \n'+
                                               'FR：{1} \n'+
                                               '　　（承認：{2}） \n'+
                                               '\n'+
                                               '■{3} {4}\n'+
                                               '\n'+
                                               '==顧客情報== \n'+
                                               '【会社名】{5} \n'+
                                               '【 氏名 】{6} 様 \n'+
                                               '\n'+
                                               '==SFDCリード== \n'+
                                               '{7} \n'+
                                               'リードから活動履歴の「件名」をクリックし、ToDo情報からトランスの内容を確認してください。 \n'+
                                               'トランス情報を確認後、ToDo情報画面の右上「名前」からリードに戻ってください。 \n'+
                                               'リード画面の「取引の開始」をクリックし、商談にするか否かを選択し 必要情報を入力の上、「取引の開始」を完了してください。 \n'+
                                               '\n'+
                                               '以上、宜しくお願い致します。\n';
}