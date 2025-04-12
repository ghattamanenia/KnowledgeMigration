public without sharing class JP_QuotationHeaderDAO {

    public static JP_QuotationHeader__c getRecByQuotationNoMax(String strPrefix){
        
        String strLike = strPrefix + '%';
        JP_QuotationHeader__c[] rec = [SELECT JP_QuotationNo__c From JP_QuotationHeader__c
          WHERE JP_QuotationNo__c LIKE :strLike ORDER BY JP_QuotationNo__c DESC LIMIT 1];
        
        if(rec.size() > 0){
            return rec[0];
        } else {
            return null;
        }
    }

    public static List<JP_QuotationHeader__c> getRecByQuotationNo(String qNo){
        
        return [SELECT 
                Id
            From 
                JP_QuotationHeader__c
            WHERE 
                JP_QuotationNo__c = :qNo];
    }
    
    public static JP_QuotationHeader__c getRecById(Id recId){
        JP_QuotationHeader__c[] rec = [SELECT
            Id,
            Name,
            JP_QuotationNo__c,
            JP_QuotationStatus__c,
            CreatedDate,
            LastModifiedDate,
            JP_PlannedDeliveryDate__c,
            JP_QuoteOutputDate__c,
            JP_QuotationExpireDate__c,
            JP_PaymentCondition__c,
            JP_QuotationEffectiveTerm__c,
            JP_DiscountAmount__c,
            JP_UnitPrice__c,
            JP_TotalAmount__c,
            JP_QuotationActive__c,
            JP_PreSave__c,
            JP_QuotationContact__c,
            JP_QuotationDistCD__c,
            JP_Postcode__c,
            JP_Company__c,
            JP_Adress1__c,
            JP_Department1__c,
            JP_Adress2__c,
            JP_Department2__c,
            JP_Building__c,
            JP_LastName__c,
            JP_Title__c,
            JP_TelNo__c,
            JP_FaxNo__c,
            JP_ATKK_Postcode__c,
            JP_Outside__c,
            JP_ATKK_Address1__c,
            JP_Inside__c,
            JP_ATKK_Address2__c,
            JP_OutMailAddress__c,
            JP_ATKK_Building__c,
            JP_InMailAddress__c,
            JP_atkkTellNo__c,
            JP_atkkFaxNo__c,
            JP_QuotationCondition__c,
            JP_OpportunityNo__c,
            JP_E_U_CompanyName__c,
            JP_Distributor__c,
            JP_DeliveryRoute__c,
            JP_DeliveryDateForApproval__c,
            JP_OpportunitySummary__c,
            JP_DiscountReason__c,
            JP_BusinessPotential__c,
            JP_OtherRequestReason__c,
            JP_DistributorCode__c,
            JP_ATKK_Company__c,
            JP_CompetitionInfoDetail__c,
            JP_TotalStandardAmount__c,
            JP_atkkDepartment1__c,
            JP_ProServiceQuotationFlag__c,
            JP_Step0Status__c,
            JP_Step1Approver__c,
            JP_Step1exec__c,
            JP_Step1Skip__c,
            JP_Step1Status__c,
            JP_Step1type__c,
            JP_Step2Approver__c,
            JP_Step2exec__c,
            JP_Step2Skip__c,
            JP_Step2Status__c,
            JP_Step2type__c,
            JP_Step3Approver__c,
            JP_Step3exec__c,
            JP_Step3Skip__c,
            JP_Step3Status__c,
            JP_Step3type__c,
            JP_Step4Approver__c,
            JP_Step4exec__c,
            JP_Step4Skip__c,
            JP_Step4Status__c,
            JP_Step4type__c,
            JP_Step5Approver__c,
            JP_Step5exec__c,
            JP_Step5Skip__c,
            JP_Step5Status__c,
            JP_Step5type__c,
            JP_Step6Approver__c,
            JP_Step6exec__c,
            JP_Step6Skip__c,
            JP_Step6Status__c,
            JP_Step6type__c,
            JP_QuotationApprovalProcessNo__c,
            JP_SectionChief__c,
            JP_Manager__c,
            JP_GeneralManager__c,
            JP_Director__c,
            JP_Applicant__c, 
            JP_OpportunityNumber__c,
            JP_QuotationDistCD__r.JP_Price_List_Type__c,
            JP_InputUnitPrice__c,   //20151015 追加
            JP_AutoSumFlg__c,       //20151218 追加
            JP_ZaikoTeian__c,       //20160113 追加
            JP_AllowMixOfPriceYearMonth__c, //20160205 追加
            JP_PriceYearMonth__c, //20170403 追加
            JP_Price_List_Type__c,      //20170925 追加
//            ,JP_ExtendExpirationDate__c   //20180530 追加
            JP_EstimatesExpirationDate__c   //20180619 追加
        From
            JP_QuotationHeader__c
        Where
            Id = :recId LIMIT 1];
        
        if(rec.size() > 0){
            return rec[0];
        } else {
            return null;
        }
    }
    
    public static JP_QuotationHeader__c getRecByIdUseFieldSet(Id recId){
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : SObjectType.JP_QuotationHeader__c.FieldSets.CopyItemToQuotation.getFields()) {
            query += f.getFieldPath() + ', ';
        }
        
        query += 'Id, JP_QuotationDistCD__r.JP_Price_List_Type__c, JP_QuotationDistCD__r.JP_MainDistributorCode__c, ';
        // 20170626 追加
        query += 'JP_QuotationDistCD__r.JP_QuotationCreatableFlag__c, JP_QuotationDistCD__r.JP_DistributorActiveFlag__c, JP_QuotationDistCD__r.JP_EffectiveFlagForMainDistributor__c ';
        query += 'FROM JP_QuotationHeader__c ';
        query += 'where Id = \'' + recId + '\' ';
        query += 'LIMIT 1';
        
        system.debug('★query : ' + query);
        return Database.query(query);
    }
    
    public static JP_QuotationHeader__c getQuoteOutPutDate(Id qhId){
        JP_QuotationHeader__c qh = new JP_QuotationHeader__c();
        qh = [SELECT 
                    Id
                    ,JP_ApprovedDateTime__c
                    ,JP_QuoteOutputDate__c
                    ,JP_QuotationNo__c              //20190801 追加
                    ,JP_QuotationStatus__c          //20190801 追加
                    ,JP_OpenPrice__c                //20190801 追加
                    ,JP_DisplayCorporationSeal__c   //20190801 追加
                    ,JP_RoundingSalesTax__c         //20190801 追加
                    ,JP_IncludingSalesTax__c        //20190801 追加
                    ,JP_SalesTaxRate__c             //20190801 追加
                FROM 
                    JP_QuotationHeader__c 
                WHERE 
                    Id = :qhId LIMIT 1];
        return qh;
    }
    
}