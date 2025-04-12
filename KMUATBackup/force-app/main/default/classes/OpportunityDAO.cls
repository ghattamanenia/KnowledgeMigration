public with sharing class OpportunityDAO {
	 public static Opportunity getRecById(Id oppId){
        return [SELECT 
                        Id
                        ,Name
                        ,Description
                        ,CloseDate
                        ,StageName
                        ,Probability
                        ,Amount
                        ,JP_QuoteId__c
                        ,Pricebook2Id
                        ,ATFE_OppID__c
                        ,Account.Name
                        ,JP_DistributionChannels__c
                        ,JP_Distribution__c
                        //20200703 ALLIEDTELESIS-440 terrasky add start
                        ,AccountId
                        ,CampaignId
                        ,CurrencyIsoCode
                        ,ForecastCategoryName
                        ,JP_AdptionMaker__c
                        ,JP_AtkkAccuracy__c
                        ,JP_BANTC_01_Budget__c
                        ,JP_BANTC_02_Authority__c
                        ,JP_BANTC_03_Needs__c
                        ,JP_BANTC_04_TimeFrame__c
                        ,JP_BANTC_05_Competitor__c
                        ,JP_CampaignSalesOpportunity__c
                        ,JP_DMG__c
                        ,JP_DayOfTender__c
                        ,JP_DeleteFlag__c
                        ,JP_DirectTouchDegree__c
                        ,JP_DirectorVisited__c
                        ,JP_DistributorAccuracy__c
                        ,JP_DivisionHistory__c 
                        ,JP_EnduserPrefecture__c
                        ,JP_FailedOfferCompany__c
                        ,JP_FailedOfferDetails__c
                        ,JP_FailedOfferReason__c
                        ,JP_FinalMailSendTime__c
                        ,JP_Finance__c
                        ,JP_GiDate__c
                        ,JP_MailFlag__c
                        ,JP_MaintenanceQuoteId__c
                        ,JP_MaintenanceTrace__c
                        ,JP_OpportunitySource__c
                        ,JP_OrderDate__c
                        ,JP_ParentOPP_ID__c
                        ,JP_Rank__c
                        ,JP_SDN_Notes__c
                        ,JP_SPMSCooperationdate__c
                        ,JP_SpecialServiceForMembers__c
                        ,JP_Tags__c
                        ,JP_TenderingProject__c
                        ,JP_TraceGroup__c
                        ,JP_WinningBidders__c
                        ,JP_isJapan__c
                        ,RecordTypeId
                        //,TerritoryId 
                        ,Type
                        ,JP_TargetDistributorCode__c
                        //20200703 ALLIEDTELESIS-440 terrasky add end
                        ,JP_DirectRank__c //20201222 ALLIEDTELESIS-453 terrasky add
                        ,JP_ReasonNoOppLineItem__c //20210121 ALLIEDTELESIS-453 terrasky add
                        ,OriginalQuote__c            //20220311 ALLIEDTELESIS-462 terrasky add
                		//,JP_CopyableClosedOpportunity__c//20241025 ALLIEDTELESIS-510 terrasky add →　20241206 semba update
                        ,JP_Project__c //20241206 semba add
                        ,JP_ProjectNo__c //20241206 semba add
                		//20250212 semba add start
						,JP_Partner1__c
                		,JP_Partner2__c
                		,JP_Partner3__c
                		,JP_Partner4__c
                		,JP_Partner5__c
                		//20250212 semba sdd end
                  FROM 
                        Opportunity 
                  WHERE 
                        Id =:oppId
            ];
      }
}