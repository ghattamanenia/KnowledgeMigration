public with sharing class JP_QuotationHeaderTriggerAction{

    /*----------------------------------------------見積書番号採番処理 START----------------------------------------------*/
    /*
    * 新規登録時見積書番号自動採番処理
    * @param Trigger.new => List<JP_QuotationHeader__c> listQH
    * @return void
    */
    public static void QuotationNoAutoNumbering(List<JP_QuotationHeader__c> listQH){

        //新規登録リスト
        List<JP_QuotationHeader__c> newList = new List<JP_QuotationHeader__c>();
        //コピー登録リスト
        List<JP_QuotationHeader__c> copyList = new List<JP_QuotationHeader__c>();
               
        for(JP_QuotationHeader__c qh : listQH){
            //新規登録レコード
            if(qh.JP_QuotationNo__c == null){
                newList.add(qh);
            //コピー登録レコード
            }else{
                copyList.add(qh);
            }
        }
        
        if(!newList.isEmpty()){
            newList = updateQuotationNoNew(newList);
        }
        
        if(!copyList.isEmpty()){
            copyList = updateQuotationNoCopy(copyList);
        }
        
        //変更値をセット
        for(JP_QuotationHeader__c qh : listQH ){
            //新規登録リストをInsertリストへセット
            for(JP_QuotationHeader__c newrec : newList){
                if(qh.Id == newrec.Id){
                    qh.JP_QuotationNo__c = newrec.JP_QuotationNo__c;
                }
            }
            //コピー登録リストをInsertリストへセット
            for(JP_QuotationHeader__c copyrec : copyList){
                if(qh.Id == copyrec.Id){
                    qh.JP_QuotationNo__c = copyrec.JP_QuotationNo__c;
                }
            }
            
        }
        
    }
    
    public static List<JP_QuotationHeader__c> updateQuotationNoNew(List<JP_QuotationHeader__c> listQH){

        JP_QuotationHeader__c firstRecQH = listQH[0];
        
        DateTime dtNow = System.Now();
        String jstYYMM = dtNow.format('yyMM', 'JST');

        integer seq = getNextQuotationNoSeq(jstYYMM);
        
        system.debug('***seq : ' + seq);
        system.debug('****listQH.size : ' + listQH.size());
        
        for(JP_QuotationHeader__c recQH : listQH){
            if(seq > 9999){
                //エラーメッセージ JP_QuotationNo over 9999
                recQH.JP_QuotationNo__c.addError(System.Label.JP_ErrorMessageQuotationHeaderOver9999);
            } else {
            
                String qn = jstYYMM + paddingLeftZero(seq, 4) + 'A';
                recQH.JP_QuotationNo__c = qn;
                seq++;
            }
        }
        
        return listQH;
    }
    
    public static List<JP_QuotationHeader__c> updateQuotationNoCopy(List<JP_QuotationHeader__c> listQH){
        for(JP_QuotationHeader__c recQH : listQH){
            String strPrefix;
            
            // YYYYMMDD + 連番  を取得
            if(recQH.JP_QuotationNo__c.length() == 11){
                strPrefix = recQH.JP_QuotationNo__c.substring(0,10);
            }else{
                strPrefix = recQH.JP_QuotationNo__c.substring(0,8);
            }

            // YYYYMMDD + 連番 の revision が最大であるレコードを取得
            JP_QuotationHeader__c rec = JP_QuotationHeaderDAO.getRecByQuotationNoMax(strPrefix);
            
            if(rec == null){
                //エラーメッセージ JP_QuotationNo Copy Not Exist
                recQH.JP_QuotationNo__c.addError(System.Label.JP_ErrorMessageQuotationHeaderCopyNotExist);
                continue;
            }

            // revision の文字コードを取得
            Integer revision = rec.JP_QuotationNo__c.charAt(8);

            revision++;

            if(revision > 90){
                // リビジョンが Z を超える場合
                //エラーメッセージ JP_QuotationNo over Z
                recQH.JP_QuotationNo__c.addError(System.Label.JP_ErrorMessageQuotationHeaderOverZ);                
            } else {
                String strRevision = String.fromCharArray( new List<integer> { revision } );
                recQH.JP_QuotationNo__c = strPrefix + strRevision;
            }
        }
        
        return listQH;
    }

    public static integer getNextQuotationNoSeq(String strYYYYMM){
        Integer seq = 0;

        JP_QuotationHeader__c rec = JP_QuotationHeaderDAO.getRecByQuotationNoMax(strYYYYMM);
        if(rec == null){
            seq = 1;
        } else {
            String maxQuotationNo = rec.JP_QuotationNo__c;
            seq = Integer.valueOf(maxQuotationNo.substring(4,8)) + 1;
        }
        
        return seq;
    }
    
    /**
     * パッディング：左ゼロ埋め
     * @param n 数値
     * @param len 桁数（数値の桁を含める）
     * @return 
     */
    public static String paddingLeftZero(Integer n, Integer len) {
        Integer nlen = n.format().length();
        if(nlen >= len) return String.valueOf(n);
        String s = '';
        for(Integer i=0, l=len-nlen; i<l; i++) {
            s += '0';
        }
        return s + String.valueOf(n);
    }    
    /*----------------------------------------------見積書番号採番処理 END----------------------------------------------*/

    /*----------------------------------------------見積基本共通入力チェック処理 START--------------------------------------------*/
    /*
    * 見積基本共通入力チェック処理
    * @param Trigger.new[i] => ListJP_QuotationHeader__c qh
    * @return boolean isError
    */
    public static Boolean headerCommonValidation(JP_QuotationHeader__c qh){
            
            //エラー有無フラグ
            Boolean isError = false;
                        
            //総計：ブランクチェック、0チェック、正負チェック
            if(qh.JP_TotalAmount__c == null){
                qh.JP_TotalAmount__c.addError(JP_Const.ERR_MESSAGE_TOTAL_AMOUNT_NULL);
                isError = true;
            }
            if(qh.JP_TotalAmount__c != null){
                if(qh.JP_TotalAmount__c == 0){
                    qh.JP_TotalAmount__c.addError(JP_Const.ERR_MESSAGE_TOTAL_AMOUNT_ZERO);
                    isError = true;
                }
                if(qh.JP_TotalAmount__c < 0){
                    qh.JP_TotalAmount__c.addError(JP_Const.ERR_MESSAGE_TOTAL_AMOUNT_MINUS);
                    isError = true;
                }                
            }
            
            //見積代理店コード：ブランクチェック
            if(qh.JP_QuotationDistCD__c == null || String.isBlank(qh.JP_QuotationDistCD__c)){
                qh.JP_QuotationDistCD__c.addError(JP_Const.ERR_MESSAGE_QUOTATION_DIST_CD);
                isError = true;
            }
            
            //見積有効日数：ブランクチェック
            if(qh.JP_QuotationEffectiveTerm__c == null || String.isBlank(qh.JP_QuotationEffectiveTerm__c)){
                qh.JP_QuotationEffectiveTerm__c.addError(JP_Const.ERR_MESSAGE_QUOTATION_EFFECTIVE_TERM);
            }
            
            //エラー有無結果
            return isError;
              
    }
    /*----------------------------------------------見積基本共通入力チェック処理 END----------------------------------------------*/
    
    /*----------------------------------------------承認プロセス判定処理 START----------------------------------------------*/
    /*
    * 承認プロセス判定処理
    * @param Trigger.new => List<JP_QuotationHeader__c> listQH
    * @return void
    */
     public static void getApprovalProcessNo(List<JP_QuotationHeader__c> listQH){
        system.debug('■getApprovalProcessNo');
        String TOUROKUGAI_Z = JP_Const.TOUROKUGAI_Z;
        //String QUOT_STATUS_MISHOUNIN = JP_Const.QUOTATION_STATUS_UNAPPROVE;
        Boolean attkFlg;                        // ATTK製品担当フラグ
        Boolean partnerFlg;                     // パートナー製品担当フラグ
        Boolean maintenanceFlg;                 // 保守製品担当フラグ
        Set<ID> qhIds = new Set<ID>();          // 【見積基本】.[ID]のSet
        Set<String> keys = new Set<String>();   // 【見積基本】.[JP_ApprovalProcessKey__c]のSet
        // Key：【見積基本】.[Id]  Value：List<JP_QuotationDetail__c>
        Map<ID,List<JP_QuotationDetail__c>> qdMap = new Map<ID,List<JP_QuotationDetail__c>>();
        // Key:【見積基本】.[JP_ApprovalProcessKey__c]    Value：承認プロセス番号
        Map<String, String> processNoMap = new Map<String, String>();
        
        // 「承認ステータスが未申請」　かつ　「仮保存フラグが立っていない」　かつ　「トリガースキップフラグが立っていない」見積基本のIDのSetを作成
        for(JP_QuotationHeader__c qh : listQH){
        system.debug('********ステータス*******' + qh.JP_QuotationStatus__c);
        system.debug('********仮保存フラグ*******' + qh.JP_PreSave__c );
        system.debug('********トリガスキップフラグ*******' + qh.JP_TriggerSkipFLG__c );
            if(qh.JP_PreSave__c != true 
                && qh.JP_TriggerSkipFLG__c != true){
                if(!qhIds.contains(qh.Id)){
                    qhIds.add(qh.Id);
                }
            }
        }
        
        // 見積基本のIDのSetを条件に、見積基本と見積明細のリレーションを取得
        qdMap = JP_QuotationDetailDAO.getChildrenByParentIds(qhIds);
        for(JP_QuotationHeader__c qh : listQH){

            if(qh.JP_PreSave__c != true 
                && qh.JP_TriggerSkipFLG__c != true){
                //見積基本毎に初期化を行う
                attkFlg = false;
                partnerFlg = false;
                maintenanceFlg = false;
                qh.JP_QuotationApprovalProcessNo__c = ''; //【金】API参照名変更しました
                qh.JP_ApprovalProcessKey__c = '';
                qh.JP_ChkPreReleaseCD__c = '';
                qh.JP_ChkQuotationExpiryDateCD__c = '';
                qh.JP_ChkTotalAmountCD__c = '';
                qh.JP_ChkWholeSaleCD__c = '';
                qh.JP_ChkkProductResponsibleCD__c = '';
                qh.JP_ChkLimitDiscountCD__c = '';
                qh.JP_ChkRegisteredProductCD__c = '';
                qh.JP_ChkDiscountMsgATKK__c = '-';
                qh.JP_ChkDiscountMsgPartner__c = '-';
                qh.JP_ChkDiscountMsgWarranty__c = '-';
            
                // 見積有効期限判定
                if(Integer.valueOf(qh.JP_QuotationEffectiveTerm__c) <= 90){
                    system.debug('*****E1');
                    qh.JP_ChkQuotationExpiryDateCD__c = 'E1';
                }else if(Integer.valueOf(qh.JP_QuotationEffectiveTerm__c) >= 120){
                    system.debug('*****E2');
                    qh.JP_ChkQuotationExpiryDateCD__c = 'E2';
                }
                
                // 総計判定
                if(qh.JP_TotalAmount__c < 3000000){
                    system.debug('*****A1');
                    qh.JP_ChkTotalAmountCD__c = 'A1';
                }else if(qh.JP_TotalAmount__c >= 3000000 && qh.JP_TotalAmount__c < 10000000){
                    system.debug('*****A2');
                    qh.JP_ChkTotalAmountCD__c = 'A2';
                }else{
                    system.debug('*****A3');
                    qh.JP_ChkTotalAmountCD__c = 'A3';
                }
            
                //見積基本に紐付く見積明細の存在チェック
                if(qdMap.containsKey(qh.Id)){
                    //見積基本に紐付く見積明細のListを取得
                    List<JP_QuotationDetail__c> qdList = qdMap.get(qh.Id);
                    
                    // 見積基本に紐付く見積明細のListでループ処理
                    for(JP_QuotationDetail__c qd : qdList){
                        
                        // 仕切5%減がnullの場合0と判断して判定を行う
                        if(qd.JP_5PercentDiscount__c == null){
                            qd.JP_5PercentDiscount__c = 0;
                        }
                        /**
                         * 下記の条件を満たす場合は各項目の判定処理を行う
                         * ============================================================
                         * ATKK製品フラグ（atkkFlg）がfalse
                         * OR
                         * パートナー製品フラグ（partnerFlg）がfalse
                         * OR
                         * 保守製品フラグ（maintenanceFlg）がfalse
                         * OR
                         * 製品見積.仕切チェックコード（JP_ChkWholeSaleCD__c）がB4以外
                         * OR
                         * 製品見積.値引限度額チェックコード（JP_ChkLimitDiscountCD__c）がC3以外
                         * ============================================================
                         */
                         system.debug('◆◆◆attkFlg : ' + attkFlg);
                         system.debug('◆◆◆partnerFlg : ' + partnerFlg);
                         system.debug('◆◆◆maintenanceFlg : ' + maintenanceFlg);
                         system.debug('◆◆◆qh.JP_ChkWholeSaleCD__c : ' + qh.JP_ChkWholeSaleCD__c);
                         system.debug('◆◆◆qh.JP_ChkLimitDiscountCD__c : ' + qh.JP_ChkLimitDiscountCD__c);
                        if(attkFlg != true || partnerFlg != true || maintenanceFlg != true || qh.JP_ChkWholeSaleCD__c != 'B4' || qh.JP_ChkLimitDiscountCD__c != 'C3'){

                            // 製品見積.仕切チェックコード（JP_ChkWholeSaleCD__c）がB4の場合はスキップ）
                            if(qh.JP_ChkWholeSaleCD__c != 'B4'){
                                /**
                                 * 下記の条件を満たす場合はB1
                                 * （特別仕切単価が仕切単価以上
                                 * OR
                                 * 特別仕切単価がnull
                                 * OR
                                 * 特別仕切単価が0円）
                                 * AND
                                 * （製品見積.仕切チェックコード（JP_ChkWholeSaleCD__c）がnull
                                 */
                                if(qd.JP_SpecialUnitPrice__c >= qd.JP_UnitPrice__c || qd.JP_SpecialUnitPrice__c == null || qd.JP_SpecialUnitPrice__c == 0 || qd.JP_ProductCatalogCode__c == TOUROKUGAI_Z){
                                    if(String.isEmpty(qh.JP_ChkWholeSaleCD__c)){
                                        system.debug('*****B1');
                                        qh.JP_ChkWholeSaleCD__c = 'B1';
                                    }
                                }
                                /**
                                 * 特別仕切単価が0円より大きい
                                 * AND
                                 * 特別仕切単価が仕切単価より安い
                                 * AND
                                 * 特別仕切単価が仕切5%減以上
                                 */
                                else if(qd.JP_SpecialUnitPrice__c >= qd.JP_5PercentDiscount__c){
                                    /**
                                     * 下記の条件を満たす場合はB2
                                     * （製品見積.仕切チェックコード（JP_ChkWholeSaleCD__c）がnull
                                     *  OR
                                     *  製品見積.仕切チェックコード（JP_ChkWholeSaleCD__c）がB1）
                                     */
                                    if(String.isEmpty(qh.JP_ChkWholeSaleCD__c) || qh.JP_ChkWholeSaleCD__c == 'B1'){
                                        system.debug('*****B2');
                                        qh.JP_ChkWholeSaleCD__c = 'B2';
                                    }
                                    /**
                                     * 下記の条件を満たす場合はB4
                                     * （製品見積.仕切チェックコード（JP_ChkWholeSaleCD__c）がB3
                                     */
                                    else if(qh.JP_ChkWholeSaleCD__c == 'B3'){
                                        system.debug('*****B4');
                                        qh.JP_ChkWholeSaleCD__c = 'B4';
                                    }
                                }
                                /**
                                 * 特別仕切単価が0円より大きい
                                 * AND
                                 * 特別仕切単価が仕切単価より安い
                                 * AND
                                 * 特別仕切単価が仕切5%減より安い
                                 */
                                else if(qd.JP_SpecialUnitPrice__c < qd.JP_5PercentDiscount__c){
                                    /**
                                     * 下記の条件を満たす場合はB3
                                     * （製品見積.仕切チェックコード（JP_ChkWholeSaleCD__c）がnull
                                     *  OR
                                     *  製品見積.仕切チェックコード（JP_ChkWholeSaleCD__c）がB1）
                                     */
                                    if(String.isEmpty(qh.JP_ChkWholeSaleCD__c) || qh.JP_ChkWholeSaleCD__c == 'B1'){
                                        system.debug('*****B3');
                                        qh.JP_ChkWholeSaleCD__c = 'B3';
                                    }
                                    /**
                                     * 下記の条件を満たす場合はB4
                                     * （製品見積.仕切チェックコード（JP_ChkWholeSaleCD__c）がB2
                                     */
                                    else if(qh.JP_ChkWholeSaleCD__c == 'B2'){
                                        system.debug('*****B4');
                                        qh.JP_ChkWholeSaleCD__c = 'B4';
                                    }
                                }
                            }
                                
                            // 値引限度額判定（既にC3であった場合はスキップ）
                            if(qh.JP_ChkLimitDiscountCD__c != 'C3'){
                                /** 
                                 * 下記の条件を満たす場合C1となる
                                 * 特別仕切単価が値引限度額以上
                                 * OR
                                 * 特別仕切単価が0円
                                 * OR
                                 * 特別仕切単価が仕切単価以上
                                 */
                                if(qd.JP_SpecialUnitPrice__c >= qd.JP_UnitPrice__c 
                                    || qd.JP_SpecialUnitPrice__c == 0
                                    || qd.JP_OverLimitDiscount__c != true)
                                {
                                    /** 
                                     * 下記の条件を満たす場合、複合条件としてC3となる
                                     * ============================================================
                                     * 製品見積.値引限度額チェックコード（JP_ChkLimitDiscountCD__c）の値がC2
                                     * AND
                                     * 特別仕切単価が仕切単価より安い
                                     * AND
                                     * 特別仕切単価が仕切5%減以上
                                     * ============================================================
                                     * 上記の条件を満たさない場合はC1となる
                                     */ 
                                     system.debug('***** qd.JP_SpecialUnitPrice__c : ' + qd.JP_SpecialUnitPrice__c);
                                     system.debug('****** qd.JP_5PercentDiscount__c : ' + qd.JP_5PercentDiscount__c);
                                    if((qd.JP_SpecialUnitPrice__c >= qd.JP_5PercentDiscount__c) && (qd.JP_SpecialUnitPrice__c < qd.JP_UnitPrice__c) && (qd.JP_ProductCatalogCode__c != TOUROKUGAI_Z)){
                                        // 製品見積.値引限度額チェックコード（JP_ChkLimitDiscountCD__c）の値がC2
                                        if(qh.JP_ChkLimitDiscountCD__c == 'C2'){
                                            system.debug('*****C3');
                                            qh.JP_ChkLimitDiscountCD__c = 'C3';
                                        }
                                        // 製品見積.値引限度額チェックコード（JP_ChkLimitDiscountCD__c）の値がnullもしくはC1
                                        else
                                        {
                                            system.debug('*****C1');
                                            qh.JP_ChkLimitDiscountCD__c = 'C1';
                                        }
                                    }
                                    else
                                    {
                                        if(qh.JP_ChkLimitDiscountCD__c != 'C2'){
                                            system.debug('*****C1');
                                            qh.JP_ChkLimitDiscountCD__c = 'C1';
                                        }
                                    }
                                }
                                /** 
                                 * 下記の条件を満たす場合C2となる
                                 * 特別仕切単価が値引限度額より安い（値引限度額超）
                                 * AND
                                 * 特別仕切単価が0円より大きい
                                 * AND
                                 * 特別仕切単価が仕切単価より安い
                                 */
                                else
                                {
                                    /** 
                                     * 下記の条件を満たす場合、複合条件としてC3となる
                                     * ============================================================
                                     * 製品見積.値引限度額チェックコード（JP_ChkLimitDiscountCD__c）の値がC1
                                     * AND
                                     * 特別仕切単価が仕切単価より安い
                                     * AND
                                     * 特別仕切単価が仕切5%減以上
                                     * ============================================================
                                     * 上記の条件を満たさない場合はC2となる
                                     */ 
                                    if((qd.JP_SpecialUnitPrice__c >= qd.JP_5PercentDiscount__c) && (qd.JP_SpecialUnitPrice__c < qd.JP_UnitPrice__c) && (qd.JP_ProductCatalogCode__c != TOUROKUGAI_Z)){
                                        // 製品見積.値引限度額チェックコード（JP_ChkLimitDiscountCD__c）の値がC1
                                        if(qh.JP_ChkLimitDiscountCD__c == 'C1'){
                                            system.debug('*****C3');
                                            qh.JP_ChkLimitDiscountCD__c = 'C3';
                                        }
                                        // 製品見積.値引限度額チェックコード（JP_ChkLimitDiscountCD__c）の値がnullもしくはC2
                                        else
                                        {
                                            system.debug('*****C2');
                                            qh.JP_ChkLimitDiscountCD__c = 'C2';
                                        }
                                    }
                                    else
                                    {
                                        system.debug('*****C2');
                                        qh.JP_ChkLimitDiscountCD__c = 'C2';
                                    }
                                }
                            }
                            
                            // 承認グループ判定
                            /** 
                             * 下記の条件を満たす場合、該当する製品化部門のフラグをtrueにする
                             * 特別仕切単価が0円より高い
                             * AND
                             * 特別仕切単価が通常仕切単価より安い
                             * AND
                             * (
                             * 特別仕切単価が仕切5%減より安い(B3)
                             * OR
                             * 特別仕切単価が値引限度額よりも安い（値引限度額超）(C2)
                             * )
                             */
                            if(qd.JP_SpecialUnitPrice__c > 0 && qd.JP_SpecialUnitPrice__c < qd.JP_UnitPrice__c){
                                if(qd.JP_SpecialUnitPrice__c < qd.JP_5PercentDiscount__c
                                   || qd.JP_OverLimitDiscount__c == true){
                                    if(qd.JP_AppGroupID__c == 'G1' && attkFlg != true){
                                        attkFlg = true;
                                    }else if(qd.JP_AppGroupID__c == 'G2' && partnerFlg != true){
                                        partnerFlg = true;
                                    }else if(qd.JP_AppGroupID__c == 'G3' && maintenanceFlg != true){
                                        maintenanceFlg = true;
                                    }
                                }
                            }
                        }
                        
                        // 登録外製品判定（既にD2であった場合はスキップ）
                        if(qh.JP_ChkRegisteredProductCD__c != 'D2'){
                            if(qd.JP_ProductCode__c != null){
                                system.debug('*****D1');
                                qh.JP_ChkRegisteredProductCD__c = 'D1';
                            }else{
                                if(qd.JP_ProductCatalogCode__c == TOUROKUGAI_Z){
                                    system.debug('*****D2');
                                    qh.JP_ChkRegisteredProductCD__c = 'D2';
                                }
                            }
                        }
                        
                        // リリース前製品判定
                        if(qh.JP_ChkPreReleaseCD__c != 'F2'){
                            if(qd.JP_PreRelease__c != true){
                                system.debug('*****F1');
                                qh.JP_ChkPreReleaseCD__c = 'F1';
                            }else{
                                system.debug('*****F2');
                                qh.JP_ChkPreReleaseCD__c = 'F2';
                            }
                        }
                    }
                    
                    // 承認グループ判定
                    if(attkFlg || partnerFlg || maintenanceFlg){
                        if(attkFlg){
                            system.debug('*****G1');
                            qh.JP_ChkkProductResponsibleCD__c += 'G1';
                            qh.JP_ChkDiscountMsgATKK__c = '●';
                        }
                        if(partnerFlg){
                            system.debug('*****G2');
                            qh.JP_ChkkProductResponsibleCD__c += 'G2';
                            qh.JP_ChkDiscountMsgPartner__c = '●';
                        }
                        if(maintenanceFlg){
                            system.debug('*****G3');
                            qh.JP_ChkkProductResponsibleCD__c += 'G3';
                            qh.JP_ChkDiscountMsgWarranty__c = '●';
                        }
                    }
                    
                    // 各チェックコードを連結して見積基本に保持する
                    qh.JP_ApprovalProcessKey__c =   qh.JP_ChkTotalAmountCD__c + 
                                                    qh.JP_ChkWholeSaleCD__c + 
                                                    qh.JP_ChkLimitDiscountCD__c + 
                                                    qh.JP_ChkRegisteredProductCD__c + 
                                                    qh.JP_ChkQuotationExpiryDateCD__c + 
                                                    qh.JP_ChkPreReleaseCD__c;
                    if(qh.JP_ChkkProductResponsibleCD__c != ''){
                        qh.JP_ApprovalProcessKey__c += qh.JP_ChkkProductResponsibleCD__c;
                    }
                    
                    system.debug('*******' + qh.JP_ApprovalProcessKey__c + '*******');
                    if(!keys.contains(qh.JP_ApprovalProcessKey__c)){
                        keys.add(qh.JP_ApprovalProcessKey__c);
                    }
                }
            }
        }
        
        // チェックコードを連結したキーを条件に、承認プロセス番号を取得
        processNoMap = JP_ApprovalProcess_DAO.getApprovalProcessNo(keys);
        
        for(JP_QuotationHeader__c qh : listQH){
            if(processNoMap.containsKey(qh.JP_ApprovalProcessKey__c)){
                system.debug('★承認プロセス番号：' + processNoMap.get(qh.JP_ApprovalProcessKey__c));
               qh.JP_QuotationApprovalProcessNo__c = processNoMap.get(qh.JP_ApprovalProcessKey__c); 
            }
        }
    }
    
    /*----------------------------------------------承認プロセス判定処理 END----------------------------------------------*/

    /*----------------------------------------------承認プロセス判定結果チェック処理 START--------------------------------------------*/
    /*
    * 承認プロセス判定結果チェック処理
    * @param 
    * @return Boolean isError
    */
    public static Boolean processNoExistCheck(List<JP_QuotationHeader__c> qhList){
        //エラー有無確認フラグ
        Boolean isError = false;

        for(JP_QuotationHeader__c qh : qhList){
            if(qh.JP_PreSave__c != true && qh.JP_TriggerSkipFLG__c != true){    
                if(qh.JP_QuotationApprovalProcessNo__c == null || String.isBlank(qh.JP_QuotationApprovalProcessNo__c)){
                    qh.addError(JP_Const.ERR_MESSAGE_APPROVAL_PROCESS_NO);
                    isError = true;
                }
            }
        }
        
        //エラー有無
        return isError;        
    }
    /*----------------------------------------------承認プロセス判定結果チェック処理 END--------------------------------------------*/
    
    /*----------------------------------------------承認申請中プロセスNo変更禁止処理 START----------------------------------------------*/
    /*
    * 承認申請中プロセスNo変更禁止処理
    * @param Trigger.oldMap、Trigger New => Map<Id,JP_QuotationHeader__c> oldMap、List<JP_QuotationHeader__c> qhList
    * @return Boolean isError
    */
    public static Boolean processNoNotChangeForRequest(Map<Id,JP_QuotationHeader__c> oldMapQH,List<JP_QuotationHeader__c> qhList){
        //エラー有無確認フラグ
        Boolean isError = false;
        
        for(JP_QuotationHeader__c qh : qhList){
            if(qh.JP_PreSave__c != true && qh.JP_TriggerSkipFLG__c != true){    
                if(JP_Const.QUOT_STATUS_SHINSEUTYU_SET.contains(qh.JP_QuotationStatus__c)){
                    if(oldMapQH.get(qh.Id).JP_QuotationApprovalProcessNo__c != null && qh.JP_QuotationApprovalProcessNo__c != null){
                        if(!(oldMapQH.get(qh.Id).JP_QuotationApprovalProcessNo__c.equals(qh.JP_QuotationApprovalProcessNo__c))){
                             qh.JP_QuotationApprovalProcessNo__c.addError(JP_Const.ERR_MESSAGE_PROCESS_NO_NOT_CHANGE);
                             isError = true;
                         }
                    }
                }
            }
        }
        
        //エラー有無
        return isError;
        
    }
    /*----------------------------------------------承認申請中プロセスNo変更禁止処理 END------------------------------------------------*/
    /*----------------------------------------------承認プロセスNo別入力チェック処理 START---------------------------------------------*/
    /*
    * 承認プロセスNo別入力チェック処理
    * @param Trigger.New => List<JP_QuotationHeader__c> qhList
    * @return Boolean isError
    */
    public static Boolean processNoValidation(List<JP_QuotationHeader__c> qhList){
        //エラー有無確認
        Boolean isError = false;
        
        for(JP_QuotationHeader__c qh : qhList){
            if(qh.JP_PreSave__c != true && qh.JP_TriggerSkipFLG__c != true){
                if(qh.JP_QuotationApprovalProcessNo__c != null){
                    //最終承認者='取締役'        
                    if(JP_Const.PROCESS_NO_SET_TORISHIMARIYAKU.contains(qh.JP_QuotationApprovalProcessNo__c)){
                        //商談番号ブランクチェック
                        if(qh.JP_ZaikoTeian__c == false && (qh.JP_OpportunityNo__c == null || String.isBlank(qh.JP_OpportunityNo__c))){
                            qh.JP_OpportunityNo__c.addError(JP_Const.ERR_MESSAGE_OPPORTUNITY_NO);
                            isError = true;
                        }
                        //納期　ブランクチェック
                        if(qh.JP_DeliveryDateForApproval__c == null || String.isBlank(qh.JP_DeliveryDateForApproval__c)){
                            qh.JP_DeliveryDateForApproval__c.addError(JP_Const.ERR_MESSAGE_DELIVERYDATE);
                            isError = true;
                        }
                        //値引金額の根拠：★　ブランクチェック
                        if(qh.JP_DiscountReason__c == null || String.isBlank(qh.JP_DiscountReason__c)){
                            qh.JP_DiscountReason__c.addError(JP_Const.ERR_MESSAGE_DISCOUNT_REASON);
                            isError = true;
                        }
                        //特化による今後の案件の展開、メリットなど★　ブランクチェック
                        if(qh.JP_BusinessPotential__c == null || String.isBlank(qh.JP_BusinessPotential__c)){
                            qh.JP_BusinessPotential__c.addError(JP_Const.ERR_MESSAGE_BUSINESS_POTENCIAL);
                            isError = true;
                        }
                    }
                    //最終承認者='製品担当者'
                    if(JP_Const.PROCESS_NO_SET_SEIHINTANTO.contains(qh.JP_QuotationApprovalProcessNo__c)){
                        //商談番号★　ブランクチェック
                        if(qh.JP_ZaikoTeian__c == false && (qh.JP_OpportunityNo__c == null || String.isBlank(qh.JP_OpportunityNo__c))){
                            qh.JP_OpportunityNo__c.addError(JP_Const.ERR_MESSAGE_OPPORTUNITY_NO);
                            isError = true;
                        }
                        //E/U会社名　ブランクチェック
                        if(qh.JP_E_U_CompanyName__c == null || String.isBlank(qh.JP_E_U_CompanyName__c)){
                            qh.JP_E_U_CompanyName__c.addError(JP_Const.ERR_MESSAGE_E_U_COMPANYNAME);
                            isError = true;
                        }            
                        //流通　ブランクチェック
                        if(qh.JP_Distributor__c == null || String.isBlank(qh.JP_Distributor__c)){
                            qh.JP_Distributor__c.addError(JP_Const.ERR_MESSAGE_DISTRIBUTOR);
                            isError = true;
                        }                                                        
                        //納期　ブランクチェック
                        if(qh.JP_DeliveryDateForApproval__c == null || String.isBlank(qh.JP_DeliveryDateForApproval__c)){
                            qh.JP_DeliveryDateForApproval__c.addError(JP_Const.ERR_MESSAGE_DELIVERYDATE);
                            isError = true;
                        }
                        //納入経路 ブランクチェック
                        if(qh.JP_DeliveryRoute__c == null || String.isBlank(qh.JP_DeliveryRoute__c)){
                            qh.JP_DeliveryRoute__c.addError(JP_Const.ERR_MESSAGE_DELIVERY_ROUTE);
                            isError = true;
                        }                        
                        //案件概要　ブランクチェック
                        if(qh.JP_OpportunitySummary__c == null || String.isBlank(qh.JP_OpportunitySummary__c)){
                            qh.JP_OpportunitySummary__c.addError(JP_Const.ERR_MESSAGE_OPPORTUNITY_SUMMARY);
                            isError = true;
                        }                                    
                        //コンペ情報の詳細　ブランクチェック
                        if(qh.JP_CompetitionInfoDetail__c == null || String.isBlank(qh.JP_CompetitionInfoDetail__c)){
                            qh.JP_CompetitionInfoDetail__c.addError(JP_Const.ERR_MESSAGE_COMPETITION_INFO_DETAIL);
                            isError = true;
                        }                                                
                        //値引金額の根拠：★　ブランクチェック
                        if(qh.JP_DiscountReason__c == null || String.isBlank(qh.JP_DiscountReason__c)){
                            qh.JP_DiscountReason__c.addError(JP_Const.ERR_MESSAGE_DISCOUNT_REASON);
                            isError = true;
                        }            
                        //特化よる今後の案件の展開、メリットなど★　ブランクチェック
                        if(qh.JP_BusinessPotential__c == null || String.isBlank(qh.JP_BusinessPotential__c)){
                            qh.JP_BusinessPotential__c.addError(JP_Const.ERR_MESSAGE_BUSINESS_POTENCIAL);
                            isError = true;
                        }
                    }
                }
            }
         }
         
         //エラー有無結果
         return isError;
    }
    /*----------------------------------------------承認プロセスNo別入力チェック処理 END----------------------------------------------*/
    
    /*----------------------------------------------承認ステップユーザ初期化処理 START--------------------------------------------*/
    /*
    * 承認ステップユーザ初期化処理
    * @param Trigger.oldMap => Map<Id,JP_QuotationHeader__c> oldMapQH, Trigger.New => List<JP_QuotationHeader__c> qhList
    * @return 
    */
    public static void stepUserReset(Map<Id,JP_QuotationHeader__c> oldMapQH,List<JP_QuotationHeader__c> qhList){
        for(JP_QuotationHeader__c qh : qhList){
            if(qh.JP_QuotationApprovalProcessNo__c != null && oldMapQH.get(qh.Id).JP_QuotationApprovalProcessNo__c != null){
                if(!(qh.JP_QuotationApprovalProcessNo__c.equals(oldMapQH.get(qh.Id).JP_QuotationApprovalProcessNo__c))){
                    qh.JP_SectionChief__c = null;
                    qh.JP_Manager__c= null;
                    qh.JP_GeneralManager__c = null;
                    qh.JP_Director__c = null;
                    qh.JP_Step0Status__c = null;
                    qh.JP_Step1Approver__c = null;
                    qh.JP_Step1exec__c = false;
                    qh.JP_Step1Skip__c = false;
                    qh.JP_Step1Status__c = null;
                    qh.JP_Step1type__c = null;
                    qh.JP_Step2Approver__c = null;
                    qh.JP_Step2exec__c = false;
                    qh.JP_Step2Skip__c = false;
                    qh.JP_Step2Status__c = null;
                    qh.JP_Step2type__c = null;
                    qh.JP_Step3Approver__c = null;
                    qh.JP_Step3exec__c = false;
                    qh.JP_Step3Skip__c = false;
                    qh.JP_Step3Status__c = null;
                    qh.JP_Step3type__c = null;
                    qh.JP_Step4Approver__c = null;
                    qh.JP_Step4exec__c = false;
                    qh.JP_Step4Skip__c = false;
                    qh.JP_Step4Status__c = null;
                    qh.JP_Step4type__c = null;
                    qh.JP_Step5Approver__c = null;
                    qh.JP_Step5exec__c = false;
                    qh.JP_Step5Skip__c = false;
                    qh.JP_Step5type__c = null;
                    qh.JP_Step6Approver__c = null;
                    qh.JP_Step6exec__c = false;
                    qh.JP_Step6Skip__c = false;
                    qh.JP_Step6Status__c = null;
                    qh.JP_Step6type__c = null;
                }
            }
        }
    }    
    /*----------------------------------------------承認ステップユーザ初期化処理 END----------------------------------------------*/
}