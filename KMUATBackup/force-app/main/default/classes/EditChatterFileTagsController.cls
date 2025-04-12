public /*with sharing*/ class EditChatterFileTagsController {

    public string file_id{get;set;}
    public list<id> selectedTagstoRm {get;set;}
    public list<id> selectedTagstoAdd {get;set;}
    public list<id> selectedTags{get;set;}
    public string FileName{get;set;}
    public String AdditionalTags{get;set;}
    
    public boolean ShowRemoveBtn{get;set;}
    public boolean ShowAddBtn{get;set;}
    
    private string indexvalue;
    private string searchvalue;
    
    /***************************Multiselect******************************/
    List<FileTag__c> originalvaluesToRm;
    Public List<id> leftselected{get;set;}
    Public List<id> rightselected{get;set;}
    Set<FileTag__c> leftvalues = new Set<FileTag__c>();
    Set<FileTag__c> rightvalues = new Set<FileTag__c>();
    Map<ID, FileTag__c> FileTagMap{get;set;} 
    
    
    List<Tag__c> originalvaluesToAdd;
    Public List<id> leftselectedAdd{get;set;}
    Public List<id> rightselectedAdd{get;set;}
    Set<Tag__c> leftvaluesAdd = new Set<Tag__c>();
    Set<Tag__c> rightvaluesAdd = new Set<Tag__c>();
    Map<ID, Tag__c> TagMapAdd{get;set;} 
     
    /********************************************************************/
   
    
    
    public EditChatterFileTagsController () {
       file_id =  ApexPages.currentPage().getParameters().get('FileId');
       indexvalue =   ApexPages.currentPage().getParameters().get('indexval');
       searchvalue= ApexPages.currentPage().getParameters().get('searchtxt');
       //ContentVersion  CVupdate = [SELECT id,ContentDocumentId,Title FROM ContentVersion where ContentDocumentId=:file_id ];
       //FileName = CVupdate.Title;
       FileName =  ApexPages.currentPage().getParameters().get('FileName');
       selectedTagstoRm  = new list<id>(); 
       selectedTagstoAdd = new list<id>();
       //AdditionalTags = new 
       
       /////////////////////////////////////
       initializeSel2Rm();
       initializeSel2Add();
      
       //////////////////////////////////////
    }
    
    
   
    public void initializeSel2Rm(){
    
       originalvaluesToRm = new List<FileTag__c>();
       originalvaluesToRm = [SELECT Id,DocumentID__c,Tag__r.tag__c,tag__c FROM FileTag__c where DocumentID__c = :file_id ];
        system.debug('originalvaluesToRm::' + originalvaluesToRm);
       leftselected = new List<id>();
       rightselected = new List<id>();
       leftvalues.addAll(originalvaluesToRm);
       rightvalues.clear();
       
       FileTagMap = new Map<ID, FileTag__c>();
       FileTagMap.putAll(originalvaluesToRm );
        ShowRemoveBtn = true;
    
    }  
    
    public void showAddButton(){
      
        ShowAddBtn = true;
        system.debug(':::ShowAddBtn ::' + ShowAddBtn );
        AdditionalTags.trim();
        system.debug(':::rightvaluesAdd.size::' + rightvaluesAdd.size());
        system.debug(':::AdditionalTags.length::' + AdditionalTags.length());
        if((rightvaluesAdd.size() != 0) || (AdditionalTags.length() != 0)){
             ShowAddBtn = false;
             
             
        }
        
         system.debug(':::ShowAddBtn ::' + ShowAddBtn );
    }
    
     public void initializeSel2Add(){
    
       originalvaluesToAdd = new List<Tag__c>();
       
       List<ID> AdreadyAddedTags = new List<ID>();
       
       for(FileTag__c ft : originalvaluesToRm ){
           AdreadyAddedTags.add(ft.tag__c);
       }
       originalvaluesToAdd  = [SELECT Id,name,tag__c FROM Tag__c where Id NOT IN :AdreadyAddedTags];
       
       leftselectedAdd = new List<id>();
       rightselectedAdd = new List<id>();
       leftvaluesAdd.addAll(originalvaluesToAdd);
       rightvaluesAdd.clear();
       
       TagMapAdd = new Map<ID, Tag__c>();
       TagMapAdd.putAll(originalvaluesToAdd);
       
       ShowAddBtn = true;
    
    }   
   
   public List<SelectOption> getAllFileTags(){
     List<SelectOption> Tags = new List<SelectOption>();
     
     List<FileTag__c> AllFileTags = [SELECT DocumentID__c,Id,Tag__r.tag__c FROM FileTag__c where DocumentID__c = :file_id ];
     
         for(FileTag__c tg : AllFileTags ){
            
             Tags.add(new SelectOption(tg.id,tg.Tag__r.tag__c));
         }
     return Tags;
        
    }
    
    public List<SelectOption> getAllTags(){
     List<SelectOption> Tags = new List<SelectOption>();
     
     List<Tag__c> AllTags = [SELECT Id,name,tag__c FROM Tag__c ];
     
         for(Tag__c tg : AllTags ){
            
             Tags.add(new SelectOption(tg.id,tg.tag__c));
         }
     return Tags;
        
    }
    
    public void RemoveTags(){
         //List<FileTag__c> AllFileTagstoRmv = [SELECT Id FROM FileTag__c where id IN :selectedTagstoRm ];
         List<FileTag__c> AllFileTagstoRmv = new List<FileTag__c>();
         system.debug('All tags to remove size:::' + rightvalues);
         if(rightvalues.size()>0) {
             AllFileTagstoRmv.addAll(rightvalues);
             delete AllFileTagstoRmv;
             initializeSel2Rm();
              initializeSel2Add();
         }else{
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No tag has been selected for removal.');
             ApexPages.addMessage(myMsg); 
             return;
         }
       
    }
    
    public void AddTags(){
        
        list<FileTag__c> newfileTags = new list<FileTag__c>();
       List<Tag__c> AllSelectedTags = new List<Tag__c>();//[SELECT Id,name,Tag__c FROM Tag__c where id IN :selectedTagstoAdd];
       AllSelectedTags.addAll(rightvaluesAdd );
        system.debug('selectedTagstoAdd :::' + selectedTagstoAdd);
        system.debug('AllSelectedTags  :::' + AllSelectedTags  );
        system.debug('AllSelectedTags size :::' + AllSelectedTags.size()  );
         for(Tag__c Tg: AllSelectedTags ){
             newfileTags.add(new FileTag__c(DocumentID__c=file_id ,Document_name__c=FileName ,Tag__c = Tg.id  ) );
              system.debug('newfileTags :::' + newfileTags  );
         } 
         
         system.debug('newfileTags --- 1 :::' + newfileTags );
         List<Tag__c> newtags = new List<Tag__c>();
         List<String> Alltags = new List<String>();
         AdditionalTags.trim();
         system.debug('AdditionalTags length:::' + AdditionalTags.length());
         if(AdditionalTags.length() > 0  ){
             Alltags = AdditionalTags.split(',');
             }
         system.debug('Alltags :::' + Alltags );
         system.debug('Alltags size:::' + Alltags.size() );
         for(string onetag : Alltags ){
               if(onetag.length() > 0 ){
                        system.debug('adding onetag ::: ' + onetag );
                        NewTags.add(new Tag__c(tag__c = onetag ));
                    }
         }
         if(NewTags.size()>0){
          try{
             insert NewTags;
             system.debug('NewTags :::' + NewTags);
             
             }catch (Exception ex) {
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Error creating new tags:' + ex);
                 ApexPages.addMessage(myMsg); 
                 return;
             }
         }
         
         for(Tag__c Tg: NewTags){
             newfileTags.add(new FileTag__c(DocumentID__c=file_id ,Document_name__c=FileName, Tag__c = Tg.id  ) );
         } 
          system.debug('newfileTags --- 2 :::' + newfileTags );
         if(newfileTags.size()>0){
            
             try{
              insert newfileTags;
             system.debug('NewTags :::' + NewTags);
             
             }catch (Exception ex) {
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Error adding new tags to this file:' + ex);
                 ApexPages.addMessage(myMsg); 
                 return;
             }
         }else{
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'No tag has been selected/added for addition to this file.');
             ApexPages.addMessage(myMsg); 
             return;
         }
          system.debug('newfileTags --- 3 :::' + newfileTags );
          AdditionalTags = null;
          initializeSel2Rm();
          initializeSel2Add();
    }
   /*******************************************************************************************/
   /************************************For MultiSelect****************************************/
   /*******************************************************************************************/
    
   
   
    public List<SelectOption> getunSelectedValuesToRm(){
    
        List<SelectOption> options = new List<SelectOption>();
        List<FileTag__c> tempList = new List<FileTag__c>();
        tempList.addAll(leftvalues);
        tempList.sort();
        for(FileTag__c unSel2Rm : tempList)
            options.add(new SelectOption(unSel2Rm.id,unSel2Rm.tag__r.tag__c));
        return options;
    }
   
    public List<SelectOption> getSelectedValuesToRm(){
        List<SelectOption> options1 = new List<SelectOption>();
        List<FileTag__c> tempList = new List<FileTag__c>();
        tempList.addAll(rightvalues);
        
        if(tempList.size()>0)
            ShowRemoveBtn = false; 
        else
            ShowRemoveBtn = true; 
            
        tempList.sort();
        for(FileTag__c Sel2Rm : tempList)
            options1.add(new SelectOption(Sel2Rm.id,Sel2Rm.tag__r.tag__c));
        return options1;
    }
    
    public PageReference selectclickToRm(){
        rightselected.clear();
        for(id sel : leftselected){
        system.debug('sel:: ' + sel );
            FileTag__c tmp = new FileTag__c();
             tmp  = FileTagMap.get(sel);
            leftvalues.remove(tmp);
            rightvalues.add(tmp);
        }
        return null;
    }
    
    public PageReference unselectclickToRm(){
        leftselected.clear();
        for(id unSel : rightselected){
             FileTag__c tmp = new FileTag__c();
             tmp  = FileTagMap.get(unSel);
            rightvalues.remove(tmp);
            leftvalues.add(tmp);
        }
        return null;
    }
    //--------------Add PickList---------------------------------------------------//
    
   
       
    public List<SelectOption> getunSelectedValuesToAdd(){
    
        List<SelectOption> options = new List<SelectOption>();
        List<Tag__c> tempList = new List<Tag__c>();
        tempList.addAll(leftvaluesAdd);
        tempList.sort();
        for(Tag__c unSel2Add : tempList)
            options.add(new SelectOption(unSel2Add.id,unSel2Add.tag__c ));
        return options;
    }
   
    public List<SelectOption> getSelectedValuesToAdd(){
        List<SelectOption> options1 = new List<SelectOption>();
        List<Tag__c> tempList = new List<Tag__c>();
        tempList.addAll(rightvaluesAdd);
         boolean moreTag = false;
        if(AdditionalTags != null){
            AdditionalTags.trim();
            if(AdditionalTags.length()>0)
                moreTag = true;
         }
            
        
        if((tempList.size()>0) || (moreTag == true))
            ShowAddBtn = false;
        else
            ShowAddBtn = true;
            
        tempList.sort();
        for(Tag__c Sel2Add : tempList)
            options1.add(new SelectOption(Sel2Add.id,Sel2Add.tag__c));
        return options1;
    }
    
    public PageReference selectclickToAdd(){
        rightselectedAdd.clear();
        for(id sel : leftselectedAdd){
        system.debug('sel:: ' + sel );
            Tag__c tmp = new Tag__c();
             tmp  = TagMapAdd.get(sel);
            leftvaluesAdd.remove(tmp);
            rightvaluesAdd.add(tmp);
        }
        return null;
    }
    
    
    public PageReference unselectclickToAdd(){
        leftselectedAdd.clear();
        for(id unSel : rightselectedAdd){
             Tag__c tmp = new Tag__c();
             tmp  = TagMapAdd.get(unSel);
            rightvaluesAdd.remove(tmp);
            leftvaluesAdd.add(tmp);
        }
        return null;
    }
   
    /*******************************************************************************************/
    
    public pagereference DoneTagging(){
        pagereference pg = new pagereference ('/apex/SFChatterFileAdmin');
        
        pg.getParameters().put('searchtxt', searchvalue);
        pg.getParameters().put('indexval', indexvalue);
        
        return pg;
    }
    
    

}