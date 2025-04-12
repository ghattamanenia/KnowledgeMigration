@isTest
private class Test_AttachmentTriggerAction {

    static testMethod void testAttachmentTriggerAction() {
    	Profile profile = [Select Id, Name From Profile Where Name = 'JP_SalesUser' Limit 1];
        User user = new User(
                  Lastname = 'tstest'
                , Username = 'tstest@terrasky.atkk.co.jp'
                , Email = 'tstest@terrasky.atkktesting'
                , ProfileId = profile.Id
                , Alias = 'tstest'
                , TimeZoneSidKey = UserInfo.getTimeZone().getID()
                , LocaleSidKey = UserInfo.getLocale()
                , EmailEncodingKey = 'UTF-8'
                , LanguageLocaleKey = 'ja'
                , JP_DeptCode__c = '00001'
        );
        insert user;
        
        DateTime dtNow = System.Now();
        
        String jstYYYYMM = dtNow.format('yyyyMM','JST');
        List<JP_QuotationDistributor__c> distributorList = JP_TestUtil.Create_JP_QuotationDistributor();
        JP_QuotationHeader__c rec = new JP_QuotationHeader__c();
        rec.JP_QuotationStatus__c = JP_Const.QUOTATION_STATUS_UNAPPROVE;
        rec.JP_PreSave__c = false;
        rec.JP_TriggerSkipFLG__c = true;
        rec.JP_QuotationEffectiveTerm__c = '30';
        rec.JP_TotalAmount__c = 30000;
        rec.JP_QuotationDistCD__c = distributorList[0].Id;
        rec.ownerId = user.Id;
        insert rec;
        
        Attachment attach = new Attachment();
       	attach.Name = 'Test';
       	Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=rec.Id;
        insert attach;


        Test.startTest();
       	system.runAs(user){
       		try{
	       		delete attach;
       		}catch(Exception e){
       			system.debug('◆◆◆e.getMessage() : ' + e.getMessage() + ' ◆◆◆');
       			Boolean expectedExceptionThrown = e.getMessage().contains(system.Label.JP_ErrorMessageDeleteAttachment) ? true : false;
       			system.assertEquals(expectedExceptionThrown, true);
       		}
       	}

        Test.stopTest();
    }
}