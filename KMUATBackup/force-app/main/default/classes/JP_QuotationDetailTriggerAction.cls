public class JP_QuotationDetailTriggerAction{

    //エラーメッセージ数
    private static Integer errMessageCount = 0; 

    /*
    * 見積明細共通入力チェック
    * @param JP_QuotationDetail__c newRec
    * @return void
    */
    public static void detailCommonValidation (JP_QuotationDetail__c newRec){
        System.debug('エラーカウントは？⇒'+errMessageCount);
        if(errMessageCount < 5){
            if(errMessageCount < 5){
                //商品コード：ブランクチェック
                if(newRec.JP_ProductCatalogCode__c == null || String.isBlank(newRec.JP_ProductCatalogCode__c)){
                    newRec.addError('No.'+String.valueof(newRec.JP_DetailsNo__c)+'：'+JP_Const.ERR_MESSAGE_PRODUCT_CATALOG_CODE);
                    errMessageCount += 1;
                }
            }
            if(errMessageCount < 5){
                //商品名：コメント以外の時にブランクチェック
                if(newRec.JP_ProductCatalogCode__c != JP_Const.COMMENT_HYPHEN){
                    if(newRec.JP_ProductName__c == null || String.isBlank(newRec.JP_ProductName__c)){
                        newRec.addError('No.'+String.valueof(newRec.JP_DetailsNo__c)+'：'+JP_Const.ERR_MESSAGE_PRODUCT_NAME);
                        errMessageCount += 1;
                    }
                }
            }
            if(errMessageCount < 5){    
                //順：ブランクチェック
                if(newRec.JP_Sort__c == null){
                    newRec.addError('No.'+String.valueof(newRec.JP_DetailsNo__c)+'：'+JP_Const.ERR_MESSAGE_DETAIL_SORT);
                    errMessageCount += 1;
                }
            }
            //数量：コメント以外のときブランク、0、正負チェック
            if(newRec.JP_ProductCatalogCode__c != JP_Const.COMMENT_HYPHEN){
                if(errMessageCount < 5){
                    //ブランクチェック
                    if(newRec.JP_Quantity__c == null){
                        newRec.addError('No.'+String.valueof(newRec.JP_DetailsNo__c)+'：'+JP_Const.ERR_MESSAGE_QUANTITY_NULL);
                        errMessageCount += 1;
                    }
                }
                if(errMessageCount < 5){
                    if(newRec.JP_Quantity__c != null){
                        //0チェック
                        if(newRec.JP_Quantity__c == 0){
                            newRec.addError('No.'+String.valueof(newRec.JP_DetailsNo__c)+'：'+JP_Const.ERR_MESSAGE_QUANTITY_ZERO);
                            errMessageCount += 1;
                        }
                    }
                }
                if(errMessageCount < 5){
                    //正負チェック
                    if(newRec.JP_Quantity__c < 0){
                        newRec.addError('No.'+String.valueof(newRec.JP_DetailsNo__c)+'：'+JP_Const.ERR_MESSAGE_QUANTITY_MINUS);
                        errMessageCount += 1;
                    }
                }
            }
                
                //仕切率：コメント以外のとき正負チェック
                if(newRec.JP_ProductCatalogCode__c != JP_Const.COMMENT_HYPHEN){
                    if(errMessageCount < 5){                        
                        if(newRec.JP_WholeSaleRate__c != null){
                            if(newRec.JP_WholeSaleRate__c < 0){
                                newRec.addError('No.'+String.valueof(newRec.JP_DetailsNo__c)+'：'+JP_Const.ERR_MESSAGE_WHOLE_SALE_RATE);
                                errMessageCount += 1;
                            }
                        }
                    }    
                }
                
                //単価：コメント以外のときかつ仕切率へ値が設定されているときにブランク、正負チェック
                if(newRec.JP_ProductCatalogCode__c != JP_Const.COMMENT_HYPHEN && newRec.JP_WholeSaleRate__c != null){
                    if(errMessageCount < 5){
                        //ブランクチェック
                        if(newRec.JP_UnitPrice__c == null){
                            newRec.addError('No.'+String.valueof(newRec.JP_DetailsNo__c)+'：'+JP_Const.ERR_MESSAGE_UNIT_PRICE_NULL);
                            errMessageCount += 1;
                        }
                    }
                    if(errMessageCount < 5){
                        if(newRec.JP_UnitPrice__c != null){
                            //正負チェック
                            if(newRec.JP_UnitPrice__c < 0){
                                newRec.addError('No.'+String.valueof(newRec.JP_DetailsNo__c)+'：'+JP_Const.ERR_MESSAGE_UNIT_PRICE_MINUS);
                                errMessageCount += 1;
                            }
                        }
                    }
                }
                
                //特別仕切率：コメント以外のとき正負チェック
                if(errMessageCount < 5){
                    if(newRec.JP_ProductCatalogCode__c != JP_Const.COMMENT_HYPHEN){
                        if(newRec.JP_SpecialWholeSaleTRate__c != null){
                            if(newRec.JP_SpecialWholeSaleTRate__c < 0){
                                newRec.addError('No.'+String.valueof(newRec.JP_DetailsNo__c)+'：'+JP_Const.ERR_MESSAGE_SPECIAL_WHOLE_SALE_T_RATE);
                                errMessageCount += 1;
                            }
                        }       
                    }
                }
                
                //特別仕切単価：コメント以外のときかつ特別仕切単価に値が設定されているときにブランク、0、正負チェック
                if(newRec.JP_ProductCatalogCode__c != JP_Const.COMMENT_HYPHEN && newRec.JP_SpecialWholeSaleTRate__c != null && newRec.JP_SpecialWholeSaleTRate__c != 0 ){
                    //ブランクチェック
                    if(errMessageCount < 5){
                        if(newRec.JP_SpecialUnitPrice__c == null){
                            newRec.addError('No.' + String.valueOf(newRec.JP_DetailsNo__c) + ':' + JP_Const.ERR_MESSAGE_SPECIAL_UNIT_PRICE_NULL);
                            errMessageCount += 1;
                        }
                    }
                    if(newRec.JP_SpecialUnitPrice__c != null){
                        //0チェック
                        if(errMessageCount < 5){
                            if(newRec.JP_SpecialUnitPrice__c == 0){
                                newRec.addError('No.'+String.valueof(newRec.JP_DetailsNo__c)+'：'+JP_Const.ERR_MESSAGE_SPECIAL_UNIT_PRICE_ZERO);
                                errMessageCount += 1;
                            }
                        }            
                        //正負チェック
                        if(errMessageCount < 5){
                            if(newRec.JP_SpecialUnitPrice__c < 0){
                                newRec.addError('No.'+String.valueof(newRec.JP_DetailsNo__c)+'：'+JP_Const.ERR_MESSAGE_SPECIAL_UNIT_PRICE_MINUS);
                                errMessageCount += 1;
                            }
                        }
                    }            
                }
                
                //値引限度額：コメント、登録外製品以外のとき正負チェック
                if(errMessageCount < 5){
                    if(newRec.JP_ProductCatalogCode__c != JP_Const.COMMENT_HYPHEN && newRec.JP_ProductCatalogCode__c != JP_Const.TOUROKUGAI_Z){
                        if(newRec.JP_DiscountLimitPrice__c != null){
                            if(newRec.JP_DiscountLimitPrice__c < 0){
                                newRec.addError('No.'+String.valueof(newRec.JP_DetailsNo__c)+'：'+JP_Const.ERR_MESSAGE_DISCOUNT_LIMIT_PRICE);
                                errMessageCount += 1;
                            }
                        }
                    }
                }
                
                //仕切5%減：コメント、登録外製品以外のとき正負チェック
                if(errMessageCount < 5){
                    if(newRec.JP_ProductCatalogCode__c != JP_Const.COMMENT_HYPHEN && newRec.JP_ProductCatalogCode__c != JP_Const.TOUROKUGAI_Z){        
                        if(newRec.JP_5PercentDiscount__c != null){
                            if(newRec.JP_5PercentDiscount__c < 0){
                               newRec.addError('No.'+String.valueof(newRec.JP_DetailsNo__c)+'：'+JP_Const.ERR_MESSAGE_5PERCENT_DISCOUNT);
                               errMessageCount += 1;
                            }
                        }
                    }
                }
                    
                //仕切単価×数量：コメント以外のときブランク、正負チェック
                if(newRec.JP_ProductCatalogCode__c != JP_Const.COMMENT_HYPHEN){
                    //ブランクチェック
                    if(errMessageCount < 5){
                        if(newRec.JP_WholeSalePriceMulQuantity__c == null){
                            newRec.addError('No.'+String.valueof(newRec.JP_DetailsNo__c)+'：'+JP_Const.ERR_MESSAGE_WHOLE_SALEPRICE_MUL_QUANTITY_NULL);
                            errMessageCount += 1;
                        }
                    }
                    if(newRec.JP_WholeSalePriceMulQuantity__c != null){
                        //正負チェック
                        if(errMessageCount < 5){
                            if(newRec.JP_WholeSalePriceMulQuantity__c < 0){
                                newRec.addError('No.'+String.valueof(newRec.JP_DetailsNo__c)+'：'+JP_Const.ERR_MESSAGE_WHOLE_SALEPRICE_MUL_QUANTITY_MINUS);
                                errMessageCount += 1;
                            }
                        }
                    }
                }
                
                //特別仕切単価×数量：コメント以外のとき正負チェック
                if(newRec.JP_ProductCatalogCode__c != JP_Const.COMMENT_HYPHEN && newRec.JP_SpecialWholeSaleTRate__c != null && newRec.JP_SpecialWholeSaleTRate__c != 0){      
                    //ブランクチェック
                    if(errMessageCount < 5){
                        if(newRec.JP_SpecialUnitPriceMulQuantity__c == null){
                            newRec.addError('No.'+String.valueof(newRec.JP_DetailsNo__c)+'：'+JP_Const.ERR_MESSAGE_SPECIAL_UNIT_PRICE_MUL_QUANTITY_NULL);
                            errMessageCount += 1;
                        }
                    }
                    if(newRec.JP_SpecialUnitPriceMulQuantity__c != null){
                        //正負チェック
                        if(errMessageCount < 5){
                            if(newRec.JP_SpecialUnitPriceMulQuantity__c < 0){
                                newRec.addError('No.'+String.valueof(newRec.JP_DetailsNo__c)+'：'+JP_Const.ERR_MESSAGE_SPECIAL_UNIT_PRICE_MUL_QUANTITY_MINUS);
                                errMessageCount += 1;
                            }
                        }
                    }                
                }
                
                //差額(通常-特化)：コメント以外のときブランク、正負チェック
                if(newRec.JP_ProductCatalogCode__c != JP_Const.COMMENT_HYPHEN && newRec.JP_SpecialWholeSaleTRate__c != null && newRec.JP_SpecialWholeSaleTRate__c != 0){
                    //ブランクチェック
                    if(errMessageCount < 5){
                        if(newRec.JP_StandardMinusSpecial__c == null){
                            newRec.addError('No.'+String.valueof(newRec.JP_DetailsNo__c)+'：'+JP_Const.ERR_MESSAGE_STANDARD_MINUS_SPECIAL_NULL);
                            errMessageCount += 1;
                        }
                    }
                    if(newRec.JP_StandardMinusSpecial__c != null){
                        //正負チェック
                        // ATKKの依頼でコメントして止める
                        //if(errMessageCount < 5){
                        //    if(newRec.JP_StandardMinusSpecial__c < 0 ){
                        //        newRec.addError('No.'+String.valueof(newRec.JP_DetailsNo__c)+'：'+JP_Const.ERR_MESSAGE_STANDARD_MINUS_SPECIAL_MINUS);
                        //        errMessageCount += 1;
                        //    }
                        //}
                    }
                }
                
                //確定金額：コメント以外のときブランク、正負チェック
                if(newRec.JP_ProductCatalogCode__c != JP_Const.COMMENT_HYPHEN){
                    //ブランクチェック
                    if(errMessageCount < 5){
                        if(newRec.JP_DeterminedAmount__c == null){
                            newRec.addError('No.'+String.valueof(newRec.JP_DetailsNo__c)+'：'+JP_Const.ERR_MESSAGE_DETERMINED_ACCOUNT_NULL);
                            errMessageCount += 1;
                        }
                    }
                    if(newRec.JP_DeterminedAmount__c != null){
                        if(errMessageCount < 5){
                            if(newRec.JP_DeterminedAmount__c < 0){
                                newRec.addError('No.'+String.valueof(newRec.JP_DetailsNo__c)+'：'+JP_Const.ERR_MESSAGE_DETERMINED_ACCOUNT_MINUS);
                                errMessageCount += 1;
                            }
                        }
                    }
                }
                
                //価格年月：コメントおよび登録外製品以外のときブランクチェック
                if(newRec.JP_ProductCatalogCode__c != JP_Const.COMMENT_HYPHEN && newRec.JP_ProductCatalogCode__c != JP_Const.TOUROKUGAI_Z){
                    //ブランクチェック
                    if(errMessageCount < 5){
                        if(newRec.JP_PriceYearMonth__c == null || String.isBlank(newRec.JP_PriceYearMonth__c)){
                            newRec.addError('No.'+String.valueof(newRec.JP_DetailsNo__c)+'：'+JP_Const.ERR_MESSAGE_PRICE_YEAR_MONTH);
                            errMessageCount += 1;
                        }
                    }
                }
                
                
                //承認グループID：コメントおよび登録外製品以外のときブランクチェック
                if(newRec.JP_ProductCatalogCode__c != JP_Const.COMMENT_HYPHEN && newRec.JP_ProductCatalogCode__c != JP_Const.TOUROKUGAI_Z){
                    //ブランクチェック
                    if(errMessageCount < 5){
                        if(newRec.JP_AppGroupID__c == null || String.isBlank(newRec.JP_AppGroupID__c)){
                            newRec.addError('No.'+String.valueof(newRec.JP_DetailsNo__c)+'：'+JP_Const.ERR_MESSAGE_APP_GROUP_ID);
                            errMessageCount += 1;
                        }
                    }
                }
                            
        }
    }
    
    /*
    * 親見積取得
    * @param JP_QuotationDetail__c detailRec
    * @return ID headerID
    */
    public static ID getHeaderID (JP_QuotationDetail__c detailRec){ 
        return detailRec.JP_QuotationHeader__c;
    } 

}