public class JP_TestUtilContract {


    
    // 契約情報作成
    public static JP_ContractInformation__c createContractInformation(Account acc){
        JP_ContractInformation__c contractInfo = new JP_ContractInformation__c();
        contractInfo.JP_Company__c = acc.Id;
        contractInfo.JP_Agency__c = acc.Id;

        insert contractInfo;
        return contractInfo;
    }
    
    // 管理番号作成
    public static JP_Management_No__c createManagementNo(JP_ContractInformation__c contractInfo, User user){
        JP_Management_No__c managementNo = new JP_Management_No__c();
        managementNo.JP_Contract_No__c = contractInfo.Id;
        managementNo.JP_Sales_Reference__c = user.Id;
        managementNo.JP_User_Name__c = 'お客様名';
        managementNo.JP_User_Address__c = 'Tokyo';
        managementNo.JP_StaYmd__c = Date.Today();
        managementNo.JP_EndYmd__c = Date.Today();
        managementNo.JP_Claim_Name__c = '代理店名';
        managementNo.JP_Service_Type__c = 'Net.AMF_ライト';
        managementNo.JP_Status__c = '更新'; 
        insert managementNo;
        return managementNo;
    }
    
    // アラートメール作成
    public static JP_AlertMail__c CreatealertMail(Id recId){
        String StrRecId = recId;
        JP_AlertMail__c alertMail = new JP_AlertMail__c();
        if(StrRecId .startsWith('a2p')){
            alertMail.JP_Management_No__c = recId;
        }else if(StrRecId .startsWith('a2o')){
            alertMail.JP_MachineInformation__c = recId;
        }
        alertMail.JP_Type__c = '社内向け';
        alertMail.JP_EmailAddress__c = 'rimina@allied-telesis.co.jp';
        alertMail.JP_Template__c = 'JP_Contract_Sales';
        alertMail.JP_Timing__c = '90日前';
        alertMail.JP_ShouldSend__c = true;
        insert alertMail;
        return alertMail;
    }

    // SO作成
    public static JP_RequestInformation__c CreateSo(JP_Management_No__c ManagementNo){
        
        JP_RequestInformation__c so = new JP_RequestInformation__c();
        so.JP_Management_Number__c = ManagementNo.Id;
        so.JP_DocumentType__c = 'ZMN';
        so.JP_SalesOrg__c = '1022';
        so.JP_Gi_Date__c = Date.Today();
        insert so;
        return so;
    }

    // SO明細
    public static JP_SO_Detail__c CreateSod(JP_Management_No__c ManagementNo){
        
        JP_SO_Detail__c wk = new JP_SO_Detail__c();
        wk.JP_Management_No__c = ManagementNo.Id;
        wk.JP_Qty__c = 1;
        wk.JP_Price__c = 1;

        insert wk;
        return wk;
    }

    // PO作成
    public static JP_ConsignmentInformation__c CreatePo(JP_Management_No__c ManagementNo){
        
        JP_ConsignmentInformation__c po = new JP_ConsignmentInformation__c();
        po.JP_Management_No__c = ManagementNo.Id;

        insert po;
        return po;
    }

    // PO明細
    public static JP_PO_Detail__c CreatePod(JP_ConsignmentInformation__c po){
        
        JP_PO_Detail__c pod = new JP_PO_Detail__c();
        pod.JP_Price__c = 1;
        pod.JP_Qty__c = 1;
        pod.JP_CostCenter__c = '12345';
        pod.JP_Order__c = '123456789012';
        pod.JP_Req_Delivery_Date__c = date.Today();
        pod.JP_PO_Header__c = po.Id;

        insert pod;
        return pod;
    }

    // 契約顧客
    public static JP_Matter__c CreateMatter(Contact con){
        
        JP_Matter__c matter = new JP_Matter__c();
        matter.Name = 'test';
        matter.JP_Client__c = con.Id;
        
        insert matter;
        return matter;
    }

    // 顧客
    public static Contact CreateCon(Account acc){
        
        Contact con = new Contact();
        con.LastName = 'test';
        con.AccountId = acc.Id;
        con.MailingCountry = 'Japan';//2024/01/22 仙波追記
        
        insert con;
        return con;
    }

    // Net.Monitor
    public static JP_Net_Monitor__c CreateNet_Monitor(){
        
        JP_Net_Monitor__c Net_Monitor = new JP_Net_Monitor__c();
        Net_Monitor.Name = 'test';
        
        insert Net_Monitor;
        return Net_Monitor;
    }

    // 契約機器
    public static JP_MachineInformation__c CreateMachineInformation(JP_ContractInformation__c contractInfo){
        
        JP_MachineInformation__c MachineInformation = new JP_MachineInformation__c();
        MachineInformation.Name = 'test';
        MachineInformation.JP_ContractNo__c = contractInfo.Id;
        
        insert MachineInformation;
        return MachineInformation;
    }

    // アライド光
    public static JP_Allied_Hikari__c CreateAlliedHikari(){
        
        JP_Allied_Hikari__c wk = new JP_Allied_Hikari__c();
        wk.Name = 'test';
        
        insert wk;
        return wk;
    }

    // CyberSecurity
    public static JP_Net_CyberSecurity__c CreateNetCyber(JP_ContractInformation__c contractInfo){
        
        JP_Net_CyberSecurity__c wk = new JP_Net_CyberSecurity__c();
        wk.Name = 'test';
        wk.JP_Contract_No__c = contractInfo.Id;
        
        insert wk;
        return wk;
    }

}