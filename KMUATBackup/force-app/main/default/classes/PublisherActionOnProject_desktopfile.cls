global with sharing class PublisherActionOnProject_desktopfile {

    private final SObject parent;
    public ContentVersion CV{get; set;}
   // private set<string> AllRelTag{get; set;}
    //=====================================================
    // sarvinder:: variable
    //=====================================================
    public Attachment attach {get;set;}
    public  Milestone1_Project__c par_prjt{get;set;}
    public FeedItem post {get;set;}
    public List<ID> TagSelected {get;set;}
    public boolean isSaveSuccess{get; set;}
    public String AdditionalTags{get;set;}
    //=====================================================
    
    //=====================================================
    // sarvinder:: not all below are required
    //=====================================================
    public ContentVersion CVselected{get; set;} 
    public string CVTitleselected{get; set;} 
    public id CVidselected{get; set;} 
    //=====================================================
    
    /***************************Multiselect declaration start******************************/
    List<Tag__c> originalvalues;
    Public List<id> leftselected{get;set;}
    Public List<id> rightselected{get;set;}
    Set<Tag__c> leftvalues = new Set<Tag__c>();
    Set<Tag__c> rightvalues = new Set<Tag__c>();
    Map<ID, Tag__c> TagMap{get;set;} 
    
    /***************************Multiselect end  ******************************/
    
   
    ////////////////////////////////////////////////////////////////
    public String lastError {get; set;}
    public boolean showSalesforceFileSection{get;set;}
    public boolean showDesktopFileSection{get;set;}
    public boolean showSalesforcePost{get;set;}
    public boolean showOptions{get;set;}
    ////////////////////////////////////////////////////////////////
    
    public PublisherActionOnProject_desktopfile(ApexPages.StandardController controller) {
        par_prjt= new Milestone1_Project__c();
        parent = (Milestone1_Project__c)controller.getRecord();
        
        isSaveSuccess =  false;
       
        par_prjt = [Select id,name from Milestone1_Project__c where id = :Parent.Id];
        CV = new ContentVersion();
        attach = new Attachment();
        post = new FeedItem();
        TagSelected = new List<ID>();
       
       initializeSel2Add();
       //AllRelTag = new set<string>(); 
       
       //List<FileTag__c> AllTags = [SELECT DocumentID__c FROM FileTag__c /*where tag__r.name like '%le%'*/ ];
       //for(FileTag__c ft : AllTags ){
         //  AllRelTag.add(ft.DocumentID__c);
       //}
        system.debug('value of showDesktopFileSection in controller   ::' + showDesktopFileSection    );
       system.debug('value of showDesktopFileSection in controller ::' + showSalesforceFileSection );
    }
    
     
    
     public void updatepostdata() {
       //  Blob AttachmentData = attach.body;
       //  string AttachmentName = attach.name;
         
        // system.debug('AttachmentName ::' + AttachmentName );
         
         
     
     }
      
    public PageReference createpost() {
    string AllTagsAdded = '';
          try {
            List<Tag__c> NewTags = new List<Tag__c>();
            List<Tag__c> AllSelectedTags = new List<Tag__c>();
            List<FileTag__c> AllFileTags = new  List<FileTag__c>();
            post.ParentId = par_prjt.id;
            post.type = 'ContentPost';
            system.debug('we are here' + attach );
            post.ContentData = attach.body;
            post.ContentFileName = attach.name;
            post.Title = attach.name;
            
            if(attach.body == null || attach.name == null )
            {
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please select a file to Post.' ));
                return null;
            }
            
            insert post;
            
         
            system.debug('post details are::' + post);
            system.debug('post RelatedRecordId  details are::' + post.RelatedRecordId );
            system.debug('AdditionalTags:::' + AdditionalTags);
            
            List<String> Alltags = AdditionalTags.split(',');
           system.debug('Alltags :::' + Alltags );
            
            for(string onetag : Alltags ){
                if(onetag.length()>0)
                    NewTags.add(new Tag__c(Tag__c = onetag ));
            }
           List<Tag__c> prjctTag = new List<Tag__c>();
           prjctTag = [Select id,Name,tag__c from tag__c where tag__c = :par_prjt.Name] ;
           
           if(prjctTag.size() == 0 )
               NewTags.add(new Tag__c(Tag__c = par_prjt.Name));
           
           if(NewTags.size()>0) 
               insert NewTags;
            // NewTags.add(new Tag__c(Tag__c = par_prjt.Name));
            system.debug(':::TagSelected :::' +TagSelected);
            AllSelectedTags = [Select id,Name,tag__c from Tag__c where id IN :TagSelected];
            system.debug(':::AllSelectedTags :::' +AllSelectedTags );
            if(prjctTag.size() != 0)
                AllSelectedTags.addAll(prjctTag);
                
            AllSelectedTags.addAll(NewTags);
            
             // change the above line and use wizard..... that way is more reliable .doing everything this way is vunerable and contentversiona and post are not tightly coupled uptill this point
            ContentVersion CV = [SELECT id,ContentDocumentId,Description,FirstPublishLocationId,Title FROM ContentVersion where FirstPublishLocationId = :post.ParentId and Title = :post.Title order by createddate desc limit 1];
            Utils.setRunFileSync();
            update CV; // This result in sharing the file with System admins using Trigger FileTag_Sync
           
            system.debug('AllSelectedTags  ::' + AllSelectedTags );
            
           
            for(Tag__c tag : AllSelectedTags ){
                AllFileTags.add(new FileTag__c(DocumentID__c=CV.ContentDocumentId,Document_Name__c = CV.Title, Tag__c= tag.id));
                
                if(AllTagsAdded.length()>0)
                    AllTagsAdded = AllTagsAdded+','+tag.tag__c;
                else
                   AllTagsAdded = tag.tag__c;
            }
            
            if(AllFileTags.size()>0) 
                insert AllFileTags;
            system.debug('All file tags are::' + AllFileTags); 
            // Add all new and old tags in new custom object file to tag relationg
            
            // Send the user to the detail page for the new account.
           //PageReference reload = new PageReference('/apex/'+par_prjt.id);
          // reload.setRedirect(true);
         // return reload ;
         
         } catch(DmlException e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Creating Feed:' + e ));
                return null;
          } 
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'File ' + attach.name + ' has been succesfully tagged as [ '+ AllTagsAdded + ' ] and posted to this Project.Please click "Refresh Feed" to refresh the feed posts.' ));
        TagSelected = null;
        AdditionalTags = null;
        
        post = new FeedItem();
        CV = new ContentVersion();
        attach = new Attachment();
        return null;
    }  

    public List<SelectOption> getAllTags(){
     List<SelectOption> Tags = new List<SelectOption>();
     List<Tag__c> prjctTag = new List<Tag__c>();
     List<Tag__c> AllTags = new List<Tag__c>();
     prjctTag = [Select id,Name,tag__c from tag__c where tag__c = :par_prjt.Name] ;
           
     if(prjctTag.size() == 0 )
         AllTags = [Select id,Name,Tag__c from Tag__c ];
     else
         AllTags = [Select id,Name,Tag__c from Tag__c where id !=:prjctTag[0].id ];
     
         for(Tag__c tg : AllTags ){
            
             Tags.add(new SelectOption(tg.id,tg.tag__c));
         }
     return Tags;
        
    }
 
   public void initializeSel2Add(){
    
       List<Tag__c> prjctTag = new List<Tag__c>();
       originalvalues = new List<Tag__c>();
      
       prjctTag = [Select id,Name,tag__c from tag__c where tag__c = :par_prjt.Name] ;
           
         if(prjctTag.size() == 0 )
             originalvalues = [Select id,Name,Tag__c from Tag__c ];
         else
             originalvalues = [Select id,Name,Tag__c from Tag__c where id !=:prjctTag[0].id ];
             
       leftselected = new List<id>();
       rightselected = new List<id>();
       leftvalues.addAll(originalvalues);
       rightvalues.clear();
       
       TagMap = new Map<ID, Tag__c>();
       TagMap.putAll(originalvalues );
        
    
    } 
    
    public List<SelectOption> getunSelectedValues(){
    
        List<SelectOption> options = new List<SelectOption>();
        List<Tag__c> tempList = new List<Tag__c>();
        tempList.addAll(leftvalues);
        tempList.sort();
        for(Tag__c unSel2Add : tempList)
            options.add(new SelectOption(unSel2Add.id,unSel2Add.tag__c ));
        return options;
    }
   
   
    public List<SelectOption> getSelectedValues(){
        List<SelectOption> options1 = new List<SelectOption>();
        List<Tag__c> tempList = new List<Tag__c>();
        tempList.addAll(rightvalues);
        tempList.sort();
        for(Tag__c Sel2Add : tempList)
            options1.add(new SelectOption(Sel2Add.id,Sel2Add.tag__c));
        return options1;
    }
    
    public PageReference selectclick(){
        rightselected.clear();
        for(id sel : leftselected){
        system.debug('sel:: ' + sel );
            Tag__c tmp = new Tag__c();
             tmp  = TagMap.get(sel);
            leftvalues.remove(tmp);
            rightvalues.add(tmp);
        }
        return null;
    }
    
    
    public PageReference unselectclick(){
        leftselected.clear();
        for(id unSel : rightselected){
             Tag__c tmp = new Tag__c();
             tmp  = TagMap.get(unSel);
            rightvalues.remove(tmp);
            leftvalues.add(tmp);
        }
        return null;
    }
   

}