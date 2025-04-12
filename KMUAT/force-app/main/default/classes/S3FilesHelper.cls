public with sharing class S3FilesHelper {
    //Get configuration for AWS SDK
    
    @AuraEnabled
    public static Config getConfig(Id recordId) {

        String obj = recordId.getsobjecttype().getDescribe().getName();

        sObject sob = Database.query('SELECT Id FROM ' + obj + ' WHERE Id =: recordId LIMIT 1');

        String s3Prefix = obj + '/' + recordId;
        

        Amazon_S3__mdt metadata = [
            SELECT Id, 
                Bucket_Sandbox__c,
                Bucket__c,
                Access_Key_Id__c,
                Secret_Access_Key__c,
                Region__c,
                Region_Sandbox__c
            FROM Amazon_S3__mdt 
            WHERE DeveloperName = 'Amazon_S3_Integration'
        ];

        Organization org = [SELECT IsSandbox FROM Organization LIMIT 1];

        if (
            s3Prefix == null 
            || s3Prefix == ''
            || metadata.Bucket__c == null
            || metadata.Bucket__c == ''
            || metadata.Bucket_Sandbox__c == null
            || metadata.Bucket_Sandbox__c == ''
        ) {
            throw new AuraHandledException('Missing Config');
        }

        return new Config(
            metadata.Access_Key_Id__c,
            metadata.Secret_Access_Key__c,
            org.IsSandbox ? metadata.Region_Sandbox__c : metadata.Region__c,
            org.IsSandbox ? metadata.Bucket_Sandbox__c : metadata.Bucket__c,
            s3Prefix
        );
    }

    public class Config {
        @AuraEnabled
        public String accessKeyId {get;set;}
        @AuraEnabled
        public String secretAccessKey {get;set;}
        @AuraEnabled
        public String region {get;set;}
        @AuraEnabled
        public String bucket {get;set;}
        @AuraEnabled
        public String prefix {get;set;}
    
        config(
            String accessKey,
            String secretKey,
            String r,
            String b,
            String pre
        ) {
            accessKeyId = accessKey;
            secretAccessKey = secretKey;
            region = r;
            bucket = b;
            prefix  = pre;
        }
        config() {}
    }
    
    // Code for Inserting the file

    @AuraEnabled
    public static Id createSoftwareRecord(
        String fileName, 
        String fileKey, 
        String fileUrl, 
        Long fileSize,
        String etag, 
        Date createdDate,
        Id recId) {
        system.debug('****Recrodid'+recId);
        Software_File__c softwareRecord = new Software_File__c();
        if(recId!=null){
            softwareRecord = new Software_File__c(
            Id=recId,
            Name = fileName,
            File_Key__c = fileKey,
            Uploaded_File_URL__c = fileUrl,
            File_Description__c = 'File uploaded to AWS S3',
            Download_Available__c = true,
            Content_Detail__c = 'Size: ' + fileSize + ' bytes',
            File_Status__c='Loaded',
            File_ID__c = etag,
            Loaded_Date__c=createdDate,
            Last_Uploaded__c = createdDate,
            File_Size_bytes__c=fileSize
        );
        update softwareRecord;
        }
        else{
            softwareRecord = new Software_File__c(
                Name = fileName,
                File_Key__c = fileKey,
                Uploaded_File_URL__c = fileUrl,
                File_Description__c = 'File uploaded to AWS S3',
                Download_Available__c = true,
                Content_Detail__c = 'Size: ' + fileSize + ' bytes',
                File_Status__c='Loaded',
                File_ID__c = etag,
                Loaded_Date__c=createdDate,
                Last_Uploaded__c = createdDate,
                File_Size_bytes__c=fileSize
        );
        insert softwareRecord; 
        }
       
        return softwareRecord.Id;
    }

    @AuraEnabled(cacheable=true)
    public static Software_File__c getSoftwareFile(Id recordId) {
        try {
            Set<Id> catalogIdSet = new Set<Id>();
            Set<Id> firmwareIdSet = new Set<Id>();
            Set<Id> softwareFileIdSet = new Set<Id>();

            List<User> loggedInUser = [SELECT Id, AccountId FROM User WHERE Id = :UserInfo.getUserId()];
            if (!loggedInUser.isEmpty()) {
                for (Entitle_Line_Item__c eachELI : [
                    SELECT Catalog_Item__c 
                    FROM Entitle_Line_Item__c 
                    WHERE Entitle_Account__r.Account__c = :loggedInUser[0].AccountId
                    limit 5000
                ]) {
                    catalogIdSet.add(eachELI.Catalog_Item__c);
                }
                
                // Directly check if the recordId is associated through Software_File_Allocation__c
                   List<Software_File_Allocation__c> relatedAllocations = [
                        SELECT Id 
                        FROM Software_File_Allocation__c 
                        WHERE Software__c = :recordId AND Firmware__c IN (
                            SELECT Firmware__c 
                            FROM Catalog_Line_Item__c 
                            WHERE Catalog_Item__c IN :catalogIdSet)
                        LIMIT 1
                  ];

                // Check if the recordId exists in the softwareFileIdSet
                if (relatedAllocations.size()>0) {
                    // Query the Software_File__c record
                    Software_File__c softwareFile = [
                        SELECT Id, File_Key__c 
                        FROM Software_File__c 
                        WHERE Id = :recordId 
                        LIMIT 1
                    ];
                    return softwareFile; // Return the full record
                }
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return null; // Return null if no valid record is found
    }

}