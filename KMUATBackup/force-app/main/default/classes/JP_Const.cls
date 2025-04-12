public class JP_Const {

    /*---------------------------------Const---------------------------------*/
    //プロファイル名：システム管理者
    public static final String SYSTEM_ADMIN = system.Label.System_Administrator_ProfileName;
    //プロファイル名：JP_SystemAdministrator
    public static final String JP_SYSTEM_ADMIN = system.Label.JP_SystemAdministrator_ProfileName;
    //プロファイル名：JP_SalesUser
    public static final String JP_SALES_USER = system.Label.JP_SalesUser_ProfileName;
    //見積番号の重複チェック用
    public static final String DUPLICATE_VALUE = 'DUPLICATE_VALUE';
    //見積基本の承認ステータス
    public static final String QUOTATION_STATUS_APPROVE = System.Label.JP_Status_APPROVED;
    public static final String QUOTATION_STATUS_UNAPPROVE = System.Label.JP_Status_UnAPPROVED;
    //見積明細の商品コード==コメント時
    public static final String COMMENT_HYPHEN = '-';
    //見積明細の商品コード==登録外製品時
    public static final String TOUROKUGAI_Z = '****'; 
    //見積基本の見積状態=='未承認'
    public static final String QUOT_STATUS_MISHOUNIN = System.Label.JP_Status_UnAPPROVED;
    //見積基本の見積状態=='承認済';
    public static final String QUOT_STATUS_SHOUNINZUMI = System.Label.JP_Status_APPROVED;
    //見積基本の見積状態：申請中の各ステータス
    public static final Set<String> QUOT_STATUS_SHINSEUTYU_SET = new Set<String>{System.Label.JP_Status_RequestInspection,System.Label.JP_Status_RequestDirector,System.Label.JP_Status_RequestGeneralManager,System.Label.JP_Status_RequestManager,System.Label.JP_Status_RequestSectionChief,System.Label.JP_Status_RequestPrerelease};
    //見積基本の承認プロセスNo：最終承認=取締役
    public static final Set<String> PROCESS_NO_SET_TORISHIMARIYAKU = new Set<String>{'5','24'};
    //見積基本の承認プロセスNo：最終承認=製品担当
    public static final Set<String> PROCESS_NO_SET_SEIHINTANTO = new Set<String>{'6',
                                                                                 '7',
                                                                                 '8',
                                                                                 '9',
                                                                                 '10',
                                                                                 '11',
                                                                                 '12',
                                                                                 '13',
                                                                                 '14',
                                                                                 '15',
                                                                                 '16',
                                                                                 '17',
                                                                                 '18',
                                                                                 '19',
                                                                                 '25',
                                                                                 '26',
                                                                                 '27',
                                                                                 '28',
                                                                                 '29',
                                                                                 '30',
                                                                                 '31',
                                                                                 '32',
                                                                                 '33',
                                                                                 '34',
                                                                                 '35',
                                                                                 '36',
                                                                                 '37',
                                                                                 '38'
                                                                                };

    // 製品見積項目API参照名：課長
    public static final String SECTION_CHIEF = 'JP_SectionChief';
    // 製品見積項目API参照名：部長
    public static final String MANAGER = 'JP_Manager';
    // 製品見積項目API参照名：本部長
    public static final String GENERAL_MANAGER = 'JP_GeneralManager';
    // 製品見積項目API参照名：取締役
    public static final String DIRECTOR = 'JP_Director';
//20210126 ALLIEDTELESIS-453 terrasky add start
    // 直接入力ランク：A
    public static final String JP_DIRECT_RANK_A = 'A';
    // 直接入力ランク：B
    public static final String JP_DIRECT_RANK_B = 'B';
    // 直接入力ランク：C
    public static final String JP_DIRECT_RANK_C = 'C';
    // 直接入力ランク：D
    public static final String JP_DIRECT_RANK_D = 'D';

    // フェーズ：受注済み
    public static final String STAGENAME_BOOKINGFORECAST = 'Booking(Forecast) - APAC';
    // フェーズ：売上完了
    public static final String STAGENAME_CLOSEDWON = 'Closed/Won (Revenue) - APAC';
    // フェーズ：情報収集中
    public static final String STAGENAME_PROSPECTQUALIFICATION = 'Prospect/Qualification - APAC';

    // 商品なしの理由：関連情報と共にコピー(処理中)
    public static final String REASON_NO_OPP_LINE_ITEM_COPY = '関連情報と共にコピー(処理中)';
    // 商品なしの理由：製品見積_商談コピー(処理中)  alliedtelesis-462 add
    public static final String REASON_NO_OPP_LINE_COPY_QUO_TO_OPP = '製品見積_商談コピー(処理中)';
    
    // 確度：20%
    public static final Decimal PROBABILITY_20 = 20;
    
    // 売上予測分類：Pipeline
    public static final String FORECAST_CATEGORY_PIPELINE = 'Pipeline';

    // 明細区分
    public static final String QUOTATIONDETAILTYPE_NOTTOTALED = '集計外';
    public static final String QUOTATIONDETAILTYPE_MAINTENANCE = 'Net.Cover';
    public static final String QUOTATIONDETAILTYPE_DEVICE = '機器';
    // ALLIEDTELESIS-523 add start
    public static final String QUOTATIONDETAILTYPE_I_TEST = 'i-Test';
    public static final String QUOTATIONDETAILTYPE_NET_CAMPUS = 'Net.Campus';
    public static final String QUOTATIONDETAILTYPE_PRODUCT_SUBSCRIPTION = '製品サブスク';
    // ALLIEDTELESIS-523 add end

//20210126 ALLIEDTELESIS-453 terrasky add end
    // 20210407 商談事象作成処理 terrasky add Start
    public static final String RECORD_TYPE_JP_Opportunity = '012200000005vdtAAA';
    public static final String JP_DIRECT_RANK_A_AUTO = 'A';
    public static final String JP_DIRECT_RANK_D_AUTO = 'D';
    public static final String ADD_WORD = '自動作成_';
    public static final String CONPANY_NAME_DIS = 'ダイワボウ情報システム株式会社';
    public static final String CONPANY_NAME_SIT = 'シネックスジャパン株式会社';
    public static final String CONPANY_NAME_SBB = 'SB C&S株式会社';
    public static final String CONPANY_NAME_OTS = '株式会社 大塚商会';
    public static final String CONPANY_NAME_STL = 'サンテレホン株式会社';
    public static final String CONPANY_NAME_SAME_SET = 'E/U直販';
    public static final String CONPANY_NAME_DIS_SET = 'DIS';
    public static final String CONPANY_NAME_SIT_SET = 'SIT';
    public static final String CONPANY_NAME_SBB_SET = 'SBB';
    public static final String CONPANY_NAME_OTS_SET = 'OTS';
    public static final String CONPANY_NAME_STL_SET = 'STL';
    public static final String CONPANY_NAME_ANOTHER_SET = '5PI以外';
    public static final String TYPE_NEW = '新規(New)';
    public static final String TYPE_UPDATE = '継続 (Existing,Continuity)';
    public static final String OPP_SOURCE_NEW = '新規契約(契約DB)';
    public static final String OPP_SOURCE_UPDATE = '更新契約(契約DB)';
    public static final String STAGE_EARNINGS = '売上完了';
    public static final String STAGE_SUGGESTION = '提案実施';
    public static final String RESPONS_NO_OPP_AUTO = '契約DB_商談自動作成';
    public static final String PARTNER_ROLE_OTHER = 'その他';
    public static final String TEAM_MEMBER_ROLE_OUT = 'Outside Sales';
    public static final String OPP_ACCESS_LEVEL_REFER_UP = 'Edit';
    public static final String ERROR_MSG_OPP = '商談は既に作成されています。';
    public static final String ERROR_MSG_NO_INPUT_COMMON = '以下の項目は未入力です。';
    public static final String ERROR_MSG_NO_INPUT_STAYMD = '・契約期間（開始）';
    public static final String ERROR_MSG_NO_INPUT_CLAIMNAME = '・お客/代理店（請求書先）';
    public static final String ERROR_MSG_NO_INPUT_USERADDRESS = '・お客様住所';
    public static final List<String> PREFECTURES_ALL = new List<String>{
        '北海道', '青森県', '岩手県', '宮城県', '秋田県', '山形県', '福島県', '茨城県', '栃木県', '群馬県',
        '埼玉県', '千葉県', '東京都', '神奈川県', '新潟県', '富山県', '石川県', '福井県', '山梨県', '長野県',
        '岐阜県', '静岡県', '愛知県', '三重県', '滋賀県', '京都府', '大阪府', '兵庫県', '奈良県', '和歌山県',
        '鳥取県', '島根県', '岡山県', '広島県', '山口県', '徳島県', '香川県', '愛媛県', '高知県', '福岡県',
        '佐賀県', '長崎県', '熊本県', '大分県','宮崎県', '鹿児島県', '沖縄県'};
    // 20210407 商談事象作成処理 terrasky add End 
    /*---------------------------------Error Message---------------------------------*/
    /*
    * 見積書出力画面
    */
    public static final String ERR_URL_PARAMETER = '不正な画面遷移は禁止されています。';
    
    /*
    * プロセスNo変更禁止処理
    */
    public static final String ERR_MESSAGE_PROCESS_NO_NOT_CHANGE = '申請中はプロセスステップが変更されるような情報更新はできません。';
    
    /*
    * 見積基本：共通入力チェック
    */
    public static final String ERR_MESSAGE_TOTAL_AMOUNT_NULL = '総計へ値を設定してください。';
    public static final String ERR_MESSAGE_TOTAL_AMOUNT_ZERO = '総計へ0は設定できません。';
    public static final String ERR_MESSAGE_TOTAL_AMOUNT_MINUS = '総計へ負の値は設定できません。';
    public static final String ERR_MESSAGE_QUOTATION_DIST_CD = '見積代理店へ値を設定してください。';
    public static final String ERR_MESSAGE_QUOTATION_EFFECTIVE_TERM = System.Label.JP_ERR_MESSAGE_QUOTATION_EFFECTIVE_TERM;
    public static final String ERR_MESSAGE_APPROVAL_PROCESS_NO = System.Label.JP_ERR_MESSAGE_APPROVAL_PROCESS_NO;
    /*
    * 見積明細：共通入力チェック
    */
    public static final String ERR_MESSAGE_PRODUCT_CATALOG_CODE = '商品コードへ値を設定してください。';
    public static final String ERR_MESSAGE_PRODUCT_NAME = '商品名へ値を設定してください。';
    public static final String ERR_MESSAGE_DETAIL_NO = 'Noへ値を設定してください。';
    public static final String ERR_MESSAGE_DETAIL_SORT = '順へ値を設定してください。';
    public static final String ERR_MESSAGE_QUANTITY_NULL = '数量へ値を設定してください。';
    public static final String ERR_MESSAGE_QUANTITY_ZERO = '数量へ0は設定できません。';
    public static final String ERR_MESSAGE_QUANTITY_MINUS = '数量へ負の値は設定できません。';
    public static final String ERR_MESSAGE_WHOLE_SALE_RATE = '仕切率に負の値は設定できません。';
    public static final String ERR_MESSAGE_UNIT_PRICE_NULL = '単価へ値を設定してください。';
    public static final String ERR_MESSAGE_UNIT_PRICE_MINUS = '単価へ負の値は設定できません。';
    public static final String ERR_MESSAGE_SPECIAL_WHOLE_SALE_T_RATE = '特別仕切率へ負の値は設定できません。';
    public static final String ERR_MESSAGE_SPECIAL_UNIT_PRICE_NULL = '特別仕切単価へ値を設定してください。';
    public static final String ERR_MESSAGE_SPECIAL_UNIT_PRICE_ZERO = '特別仕切単価へ0は設定できません。';
    public static final String ERR_MESSAGE_SPECIAL_UNIT_PRICE_MINUS = '特別仕切単価へ負の値は設定できません。';
    public static final String ERR_MESSAGE_DISCOUNT_LIMIT_PRICE = '値引限度額へ負の値は設定できません。';
    public static final String ERR_MESSAGE_5PERCENT_DISCOUNT = '仕切5%減へ負の値は設定できません。';
    public static final String ERR_MESSAGE_WHOLE_SALEPRICE_MUL_QUANTITY_NULL = '仕切単価×数量へ値を設定してください。';
    public static final String ERR_MESSAGE_WHOLE_SALEPRICE_MUL_QUANTITY_MINUS = '仕切単価×数量へ負の値は設定できません。';    
    public static final String ERR_MESSAGE_SPECIAL_UNIT_PRICE_MUL_QUANTITY_NULL = '特別仕切単価×数量へ値を設定してください。';
    public static final String ERR_MESSAGE_SPECIAL_UNIT_PRICE_MUL_QUANTITY_MINUS = '特別仕切単価×数量へ負の値は設定できません。';
    public static final String ERR_MESSAGE_STANDARD_MINUS_SPECIAL_NULL ='差額(通常-特価)へ値を設定してください。'; 
    public static final String ERR_MESSAGE_STANDARD_MINUS_SPECIAL_MINUS = '差額(通常-特価)へ負の値は設定できません。';
    public static final String ERR_MESSAGE_DETERMINED_ACCOUNT_NULL = '確定金額へ値を設定してください。';
    public static final String ERR_MESSAGE_DETERMINED_ACCOUNT_MINUS = '確定金額へ負の値は設定できません。';
    public static final String ERR_MESSAGE_PRICE_YEAR_MONTH = '価格年月へ値を設定してください。';
    public static final String ERR_MESSAGE_APP_GROUP_ID = '承認グループIDへ値を設定してください。';
    /*
    * 承認プロセス別入力チェック
    */
    public static final String ERR_MESSAGE_OPPORTUNITY_NO = '商談番号★へ値を設定してください。';
    public static final String ERR_MESSAGE_DISCOUNT_REASON = '値引金額の根拠：★へ値を設定してください。';
    public static final String ERR_MESSAGE_BUSINESS_POTENCIAL = '特価による今後の案件の展開、メリットなど★へ値を設定してください。';
    public static final String ERR_MESSAGE_E_U_COMPANYNAME = 'E/U会社名へ値を設定してください。';
    public static final String ERR_MESSAGE_DELIVERY_ROUTE = '納入経路へ値を設定してください。';
    public static final String ERR_MESSAGE_OPPORTUNITY_SUMMARY = '案件概要へ値を設定してください。';
    public static final String ERR_MESSAGE_COMPETITION_INFO_DETAIL = 'コンペ情報へ値を設定してください。';
    public static final String ERR_MESSAGE_DISTRIBUTOR = '流通へ値を設定してください。';
    public static final String ERR_MESSAGE_DELIVERYDATE = '納期へ値を設定してください。';
    /*
    * 製品検索件数チェック
    */   
    public static final String ERR_MESSAGE_PRODUCT_NUMBER_IS_0 = '検索条件に該当する商品がありません。';
    public static final String ERR_MESSAGE_PRIDUCTS_IN_EXCESS_OF_501 = '見積明細は500件超えて追加できません。';
    public static final String ERR_MESSAGE_PRIDUCTS_IN_EXCESS_OF_2 = '商品更新は2件以上選択できません。';
    public static final String ERR_MESSAGE_NO_PRIDUCT_BE_SELECTED = '選択された商品はありません。';
    public static final String ERR_MESSAGE_NO_SEARCHING_CONDITION = '「製品コード」と「価格年月」どちらかを入力してください。';
    public static final String WARNING_MESSAGE_IS_SPECAIL_PRODUCT = 'は特殊代理店用製品です。対象代理店以外は見積禁止です。';
    public static final String WARNING_MESSAGE_IS_PISTOCK_PRODUCT = 'はPI在庫誘導製品です。対象代理店以外は見積禁止です。';
    
    /**
     * 承認者設定入力チェック
     */
    public static final String ERR_MESSAGE_STEP1APPROVER = 'STEP1の承認者を設定してください。';
    public static final String ERR_MESSAGE_STEP2APPROVER = 'STEP2の承認者を設定してください。';
    public static final String ERR_MESSAGE_STEP3APPROVER = 'STEP3の承認者を設定してください。';
    public static final String ERR_MESSAGE_STEP4APPROVER = 'STEP4の承認者を設定してください。';
    public static final String ERR_MESSAGE_STEP5APPROVER = 'STEP5の承認者を設定してください。';
    public static final String ERR_MESSAGE_STEP6APPROVER = 'STEP6の承認者を設定してください。';
    public static final String ERR_MESSAGE_SALES_OUT_APPROVER = System.Label.JP_ERR_MESSAGE_APPROVED_YOURSELF;
    
    /*
    * 見積商談コピー
    */
    public static final String ERR_MESSAGE_COPY_OPPORTUNITY = '見積明細に価格表が混在している為コピーできません';
    public static final String JP_QUOTE_COPY_MESSAGE_DISTRIBUTOR_INACTIVE = system.Label.JP_QuoteCopyMessageDistributorInactive;
    public static final String JP_QUOTE_COPY_MESSAGE_OVER_BRANCH_NUMBER = system.Label.JP_QuoteCopyMessageOverBranchNumber;
    
    /*
     * 見積有効期限変更
     */
    public static final String ERR_MESSAGE_EXPIRATION_DATE_1 = system.Label.JP_ExtendExpirationDate_Msg1;
    public static final String ERR_MESSAGE_EXPIRATION_DATE_2 = system.Label.JP_ExtendExpirationDate_Msg2;
    public static final String ERR_MESSAGE_EXPIRATION_DATE_3 = system.Label.JP_ExtendExpirationDate_Msg3;
    public static final String ERR_MESSAGE_EXPIRATION_DATE_4 = system.Label.JP_ExtendExpirationDate_Msg4;
    public static final String ERR_MESSAGE_EXPIRATION_DATE_5 = system.Label.JP_ExtendExpirationDate_Msg5;
    
}