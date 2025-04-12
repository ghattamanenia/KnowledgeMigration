public class JP_CreateOpportunityForLightning {
// 20210407 商談事象作成処理 terrasky add Start
    @AuraEnabled
    public static JP_Management_No__c getManagementNo(Id recordId) {
        // 画面表示している管理番号情報返却
        JP_Management_No__c managementNo = JP_ManagementNoDAO.getManagementNo(recordId);
        if (String.isNotEmpty(managementNo.JP_User_Address__c) && 
        	null == getPrefectures(managementNo.JP_User_Address__c)) {
            // 入力規則の判別用にデータ設定
	        managementNo.JP_User_Address__c = 'NoPrefectures';
        }
        return managementNo;
    }
    
    @AuraEnabled
    public static Map<String, String> createNew(Id recordId) {
        Map<String, String> opportunity = createOpportunity(recordId, true);
        // 画面表示している管理番号情報返却
        return opportunity;
    }
    
    @AuraEnabled
    public static Map<String, String> createUpdate(Id recordId) {
        Map<String, String> opportunity = createOpportunity(recordId, false);
        // 画面表示している管理番号情報返却
        return opportunity;
    }
    
    /*
     * 商談を作成する。
     * @param レコードId
     * @param isNew true：新規ボタン押下、false：更新ボタン押下
     * @return Opportunity
     */
    private static Map<String, String> createOpportunity(Id recordId, Boolean isNew) {
        // 管理番号情報を取得
        JP_Management_No__c managementNo = JP_ManagementNoDAO.getManagementNo(recordId);
        
        // 契約番号情報を取得
        JP_ContractInformation__c contractInformation = JP_ContractInformationDAO.getContractInformation(ManagementNo.JP_Contract_No__c);

		// 担当営業のユーザ情報取得
        List<User> userList = JP_UserDAO.getUserInfo(managementNo.JP_Sales_Reference__c);

        Map<String, String> retVal = new Map<String, String>();
		Opportunity opportunity = new Opportunity();
        try {
            // 商談作成
            opportunity = createOpp(managementNo, contractInformation, userList, isNew);
            // パートナー作成（契約代理店と会社が一致している場合は作成しない）
            if (contractInformation.JP_Company__c != contractInformation.JP_Agency__c) {
                createtPartner(contractInformation.JP_Agency__c, opportunity.Id);
            }
            // 商談チーム作成（担当営業が無効の場合登録しない）
            if (userList.size() != 0 && userList[0].IsActive) {
                createtOpportunityTeamMember(userList[0].Id, opportunity.Id);
            }
            
            // 管理番号情報更新
            managementNo.JP_Opportunity__c = opportunity.Id;
            update managementNo;

            // 返却値に商談ID設定
            retVal.put('opportunityId', opportunity.Id);

        } catch(Exception ex) {
            retVal.put('message', 'エラーが発生しました。システム管理者に連絡してください。' + ex.getMessage());
            return retVal;
        }
        return retVal;
    }

    /**
     * 商談情報を登録する。
     * @param 管理番号情報
     * @param 契約番号情報
     * @param 担当営業のユーザ情報
     * @return 商談情報
     */
    private static Opportunity createOpp(JP_Management_No__c managementNo, JP_ContractInformation__c contractInformation, List<User> userList, Boolean isNew) {
        Opportunity opportunity = new Opportunity();
        opportunity.Name = getOppOrDes(managementNo, false);
		opportunity.AccountId = contractInformation.JP_Company__c;
        opportunity.OwnerId = getOwner(userList);
        opportunity.Amount = managementNo.JP_SO_Total__c;
        opportunity.CloseDate = getEndDate(managementNo.JP_StaYmd__c);
        opportunity.JP_OrderDate__c = getEndDate(managementNo.JP_StaYmd__c);
        opportunity.JP_Distribution__c = managementNo.JP_Claim_Name__c;
        opportunity.JP_DistributionChannels__c = getDistributionChannels(contractInformation);
        opportunity.Type = getType(isNew);
        opportunity.JP_OpportunitySource__c = getOpportunitySource(isNew);
        opportunity.JP_EnduserPrefecture__c = getPrefectures(managementNo.JP_User_Address__c);
        opportunity.Description = getOppOrDes(managementNo, true);
        opportunity.StageName = getStageName(isNew);
        opportunity.JP_ReasonNoOppLineItem__c = JP_Const.RESPONS_NO_OPP_AUTO;
        opportunity.JP_DirectRank__c = getDirectRank(isNew);
        opportunity.RecordTypeId = JP_Const.RECORD_TYPE_JP_Opportunity;
        insert opportunity;
        return opportunity;
	}
    
    /**
     * パートナー情報を登録する。
     * @param AccountToId 代理店
     * @param OpportunityId 商品Id
     */
    private static void createtPartner(Id accountToId, Id opportunityId) {
        Partner partner = new Partner();
        partner.AccountToId = accountToId;
        partner.Role = JP_Const.PARTNER_ROLE_OTHER;
        partner.OpportunityId = opportunityId;
        insert partner;
    }
    
    /**
     * 商談チームメンバーを登録する。
     * @param userId 担当営業
     * @param OpportunityId 商品Id
     */
    private static void createtOpportunityTeamMember(Id userId, Id opportunityId) {
        OpportunityTeamMember opportunityTeamMember = new OpportunityTeamMember();
        opportunityTeamMember.UserId = userId;
        opportunityTeamMember.TeamMemberRole = JP_Const.TEAM_MEMBER_ROLE_OUT;
        opportunityTeamMember.OpportunityAccessLevel = JP_Const.OPP_ACCESS_LEVEL_REFER_UP;
        opportunityTeamMember.OpportunityId = opportunityId;
        JP_GenericWithoutDAO.insertRec(opportunityTeamMember);
    }
    
    /**
     * 商談または説明の登録値を返却する。
     * @param isDes true:説明、false：商談
     * @return 商談または説明の登録値
     */
    private static String getOppOrDes(JP_Management_No__c managementNo, Boolean isDes) {
        String result = JP_Const.ADD_WORD;
        result += nullToBlank(managementNo.JP_User_Name__c);
        result += '_';
        result += nullToBlank(managementNo.JP_Service_Type__c);
        if (isDes) {
            // 説明の時のみ、契約番号を追加
            result += '_';
            result += managementNo.JP_Contract_No__r.Name;
		}
        result += '_';
        result += managementNo.Name;
        return result;
    }

    /**
     * 所有者の登録値を返却する。
     * @param sales 担当営業
     * @return 所有者の登録値
     */
    private static Id getOwner(List<User> userList) {
        // 担当営業が無効の場合は、ログインユーザ
        if (userList.size() != 0 && userList[0].IsActive) {
            return userList[0].Id;
        } else {
            return UserInfo.getUserId();
        }
    }
 
    /**
     * 日付登録値を取得する。
     * @param staYmd 契約期間（開始）
     * @return 契約期間（開始）の月末日
     */
    private static Date getEndDate(Date staYmd) {
        return Date.newInstance(staYmd.year(), staYmd.month() + 1, 0);
    }

    /**
     * 流通の登録値を返却する。
     * @param contractInformation 契約番号情報
     * @return 流通の登録値
     */
    private static String getDistributionChannels(JP_ContractInformation__c contractInformation) {
		Account account = JP_AccountDAO.getAccountName(contractInformation.JP_Agency__c);
        if (contractInformation.JP_Company__c == contractInformation.JP_Agency__c) {
			return JP_Const.CONPANY_NAME_SAME_SET;
        } else if (JP_const.CONPANY_NAME_DIS.equals(account.Name)) {
			return JP_Const.CONPANY_NAME_DIS_SET;
        } else if (JP_Const.CONPANY_NAME_SIT.equals(account.Name)) {
			return JP_Const.CONPANY_NAME_SIT_SET;
        } else if (JP_Const.CONPANY_NAME_SBB.equals(account.Name)) {
			return JP_Const.CONPANY_NAME_SBB_SET;
        } else if (JP_Const.CONPANY_NAME_OTS.equals(account.Name)) {
			return JP_Const.CONPANY_NAME_OTS_SET;
        } else if (JP_Const.CONPANY_NAME_STL.equals(account.Name)) {
			return JP_Const.CONPANY_NAME_STL_SET;
		}
        return JP_Const.CONPANY_NAME_ANOTHER_SET;
    }
    
    /**
     * 種別の登録値を返却する。
     * @param isNew true：新規ボタン押下、false：更新ボタン押下
     * @return 種別の登録値
     */
    private static String getType(Boolean isNew) {
        if (isNew) {
            return JP_Const.TYPE_NEW;
        } else {
            return JP_Const.TYPE_UPDATE;
		}
    }
    
    /**
     * 契機の登録値を取得する。
     * @param isNew true：新規ボタン押下、false：更新ボタン押下
     * @return 契機の登録値
     */
    private static String getOpportunitySource(Boolean isNew) {
        if (isNew) {
            return JP_Const.OPP_SOURCE_NEW;
        } else {
            return JP_Const.OPP_SOURCE_UPDATE;
		}
	}
    
    /**
     * エンド都道府県の登録値を取得する。
     * @param userAddress お客様住所
     * @return 都道府県
     */
    private static String getPrefectures(String userAddress) {
        String prefectures = '';
        // 文字数取得
        Integer length = userAddress.length();
        if (length == 3) {
            // 3文字の場合
            prefectures = userAddress.substring(0, 3);
        } else if (length >= 4) {
            if ('県'.equals(userAddress.substring(3, 4))) {
                prefectures = userAddress.substring(0, 4);
            } else {
                prefectures = userAddress.substring(0, 3);
            }
        }

        // 当道府県確認
        if (JP_Const.PREFECTURES_ALL.contains(prefectures)) {
            return prefectures;
        }
		return null;        
    }
      
    /**
     * フェーズの登録値を取得する。
     * @param isNew true：新規ボタン押下、false：更新ボタン押下
     * @return フェーズの登録値
     */
    private static String getStageName(Boolean isNew) {
        if (isNew) {
            return JP_Const.STAGE_EARNINGS;
        } else {
            return JP_Const.STAGE_SUGGESTION;
		}
	}
      
    /**
     * 直接入力ランクの登録値を取得する。
     * @param isNew true：新規ボタン押下、false：更新ボタン押下
     * @return 直接入力ランクの登録値
     */
    private static String getDirectRank(Boolean isNew) {
        if (isNew) {
            return JP_Const.JP_DIRECT_RANK_A_AUTO;
        } else {
            return JP_Const.JP_DIRECT_RANK_D_AUTO;
		}
	}

    /**
     * nullを空文字変換する。
     * @param target 変換対象文字列
     */
    private static String nullToBlank(String target) {
        if (String.isBlank(target)) {
            return '';
        }
        return target;
	}
// 20210407 商談事象作成処理 terrasky add End
}