public /*with sharing*/ class  SFChatterFileAdminController {

    

   public PageReference nextPage;
   public Integer currentPage {get;set;}
   public Integer lastPage {get;set;}  
   public Integer TotalPages{get;set;}
   public Integer PageNumber{get;set;} 
   
   public String getpageinfo (){
       return 'Page ' + PageNumber + ' of ' + TotalPages;
   } 
   
   public boolean showtable {get;set;}

   public String error {get;set;}  


   private Integer total_size;     
   private Integer index = 0;
   private Integer blockSize = 5;
   set<string> AllRelTag{get;set;}  
   public String searchtag{get;set;}
   public string CVTitleselected{get; set;} 
   public ContentVersion CVselected{get; set;} 
   public id CVidselected{get; set;}
   public List<FileWrapper> FileList{get; set;}
   
   public String setFileId {
        get;
        // *** setter is NOT being called ***
        set {
            setFileId = value;
            System.debug('value: '+value);
        }
    }
    
    private void setpageTotal(){
                if (math.mod(total_size, blockSize) == 0) {
                    TotalPages  = total_size/blockSize;
                } 
                else {
                    TotalPages  = total_size/blockSize+ 1;
                } 
              }
    private void setpagenum(){
        PageNumber = index/blockSize+ 1;
    }  

    public SFChatterFileAdminController() {
        try {
            
            showtable = false;
            AllRelTag = new set<string>(); 
           // userId = UserInfo.getUserId();
           // user = [SELECT Id, AccountId, ContactId from user where Id =: UserInfo.getUserId()];
           // ContId = user.ContactId;
            
         string searchtxt ;
         string indexval;
         indexval =   ApexPages.currentPage().getParameters().get('indexval');
         searchtxt = ApexPages.currentPage().getParameters().get('searchtxt');
         if(searchtxt == '' || searchtxt == null)
             searchtag = '';
         else
             searchtag = searchtxt;
        if(indexval == null || indexval == ''){
            index = 0;
            currentPage = 1;
            }
         else{
             index = integer.ValueOf(indexval );
             currentPage = index + 1;
             }
         searchfilesactions();
             
            
            
        }
        catch (Exception ex) {
            error = ex.getMessage();  
            System.debug('The following exception has occurred : ' + ex.getMessage());
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Error:' + ex.getMessage());
            ApexPages.addMessage(myMsg);        
        }
    }

    public void ShowFiles() {
           index = 0;
           currentPage = 1;
    }
    
    public void searchfiles(){
     index = 0;
     searchfilesactions();
    
    }
    public void searchfilesactions(){
       
        showtable = false;  
        total_size = 0;
        lastPage  = 0;
       
         
        
        string searhstrng = '%'+searchtag+'%';
        system.debug('searhstrng  ::: ->' + searhstrng ); 
        
        AllRelTag.clear();
        List<FileTag__c> AllTags = [SELECT DocumentID__c FROM FileTag__c where tag__r.tag__c like :searhstrng  ];
        system.debug('sarvinder All tags are::' + AllTags );
        for(FileTag__c ft : AllTags ){
           AllRelTag.add(ft.DocumentID__c);
           if(!showtable ){
               showtable = true;
               system.debug('updating show table --- 1::: doc if found' + ft.DocumentID__c);
             }
        }
        
        List<ContentDocument> AllRelCD = [Select id,Title from ContentDocument where Title like :searhstrng LIMIT 50000 ];
        for(ContentDocument CD : AllRelCD ){
           AllRelTag.add(CD.id);
           if(!showtable ){
               showtable = true;
               system.debug('updating show table --- 2::: doc if found' + CD.id);   
           }
        }
        
        system.debug('sarvinder All tags- 2 are::' + AllTags );
        
        total_size = AllRelTag.size(); 
        system.debug('total size:::' + total_size );
         lastPage = (math.mod(total_size, blockSize )==0)?((total_size/blockSize )):((total_size/blockSize )+1);
         system.debug('last page:::' + lastPage  );
        if(!showtable ){
             system.debug('Error: Could not find the text entered in any tag or file name. Please refine your search tag.'); 
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'INFO: Could not find the text entered in any tag or file name. Please refine your search text.');
             ApexPages.addMessage(myMsg);
            return;
            
          }
       setpageTotal();
       setpagenum();
        system.debug('AllRelTag ::' + AllRelTag);
    }
    
   public pagereference EditTags(){
   
        string docname;
        List<FileTag__c> FT = new List<FileTag__c>();
        List<ContentVersion> CV = new List<ContentVersion>();
        FT = [select documentid__c, document_name__c, tag__r.tag__c from FileTag__c where documentid__c = :setFileId];
        CV = [SELECT id,ContentDocumentId,Title FROM ContentVersion where ContentDocumentId=:setFileId order by versionnumber desc limit 1];
        
         if(FT.Size()>0){
            docname = FT[0].document_name__c;
         }else if(CV.Size()>0){
            docname = CV[0].Title;
         }else
            docname = '--[Permission denied]--';
        
        pagereference pg = new pagereference ('/apex/EditChatterFileTags?fileid='+setFileId);
        pg.getParameters().put('FileName', docname );
        pg.getParameters().put('searchtxt', searchtag);
        pg.getParameters().put('indexval', string.valueof(index));
       
       return pg;
   }
   
   
   
    
    
    public List<FileWrapper> getFiles() {
        //if(FileList == null) {
        FileList = null;
        FileList = new List<FileWrapper>();
        
        //system.debug('AllRelTag ::' + AllRelTag);
        list<string> TagList = new List<string>();
        TagList.addAll(AllRelTag); 
        integer x = index+blockSize; 
        
        system.debug('block size total get::' + x);
        system.debug('index get::' + index);
        system.debug('TagList.size::' + TagList.size());
        system.debug('TagList ::' + TagList);
            
        for(integer i=index;i<(x);i++){
            if(i<TagList.size()){
                string tg = TagList[i];
                FileList.add(new FileWrapper(tg));
            }
        }
       
                
        system.debug('FileList size :: ' + FileList.size());
        system.debug('FileList is :: ' + FileList);
        return FileList;
    }
    
    public class FileWrapper {

        public ContentVersion CV{get; set;}
        public String  docname{get; set;}
        public id relCVid{get; set;} 
        public id reldocid{get; set;}
        public String tags{get; set;}
        public Boolean selected {get; set;}
        
        public FileWrapper(id fileid) {
            tags = null; 
            List<FileTag__c> FT = new List<FileTag__c>();
            List<ContentVersion> CV = new List<ContentVersion>();
            List<ContentDocument> CD = new List<ContentDocument>();
            FT = [select documentid__c, document_name__c, tag__r.tag__c from FileTag__c where documentid__c = :fileid];
            system.debug('fileid:::' + fileid  );
            CV = [SELECT id,ContentDocumentId,Title FROM ContentVersion where ContentDocumentId=:fileid order by versionnumber desc limit 1];
            //if(CV.size()!=0){
               // CD = [SELECT id,Title FROM ContentDocument where Id=:fileid ];
                //system.debug('CV  title:::: ' + CV );
                for(FileTag__c f_tag : FT ){
                    if(tags == null)
                        tags = f_tag.tag__r.tag__c ;
                    else
                        tags = tags + ',' + f_tag.tag__r.tag__c; 
                }
               reldocid = fileid;
               if(FT.Size()>0){
                   docname = FT[0].document_name__c;
               }else if(CV.Size()>0){
                   docname = CV[0].Title;
               }else
                    docname = '--[Permission denied]--';
               // relCVid = CV[0].id;
           // }
            //reldocid = CD.Id;
        }
    }
    
   

   

    /* Pagination methods starts */
    public void beginning() { //user clicked beginning
          index = 0;
          setpagenum();
    }
    public void previous() { //user clicked previous button
          index = index - blockSize;
          setpagenum();
    }
    public void next() { //user clicked next button
          index = index + blockSize;
          setpagenum();
    }
    public void end() { //user clicked end
        index = (math.mod(total_size, blockSize) == 0)?((total_size - blockSize)-1):(total_size - math.mod(total_size, blockSize));
        system.debug('index set ::'+ index  );
       
        setpagenum();
       
    }
    public Boolean getprev() { 
        //this will disable the previous and beginning buttons
        if (index > 0) return false; else return true;
    }
    public Boolean getnxt() { //this will disable the next and end buttons
        if (index + blockSize< total_size) return false; else return true;
    }
    public Integer getTotal_size() {
        return total_size;
    }
   
   
   
    /* Pagination ends */
}