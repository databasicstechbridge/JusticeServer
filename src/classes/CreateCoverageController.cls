/***************************************************************************
* Name               : CreateCoverageController                            *
* Description        : JusticeServer - Coverage Creation Screen            *
* Created By         : Techbridge                                          *        
****************************************************************************/

public class CreateCoverageController{

    public String caseId;
    public string caseNumber {get;set;}
    public List<reltedPartyWrapper> relatedPartyWrapperList {get;set;}
    public Coverage__c newCoverageRecDummy {get;set;}
    public Boolean enableMedicare {get;set;}
    public Boolean enableMedicalGroup {get;set;}
    
    /***************************************************************************
    *@Description : This is the contructor                                     *
    *@Params      : ApexPages.StandardController controller                    *
    *@Return      : Void                                                       *    
    ****************************************************************************/
    public CreateCoverageController(ApexPages.StandardController controller){
        caseNumber = '';
        enableMedicare = false;
        enableMedicalGroup = false;
        caseId = ApexPages.currentPage().getParameters().get('caseId');
        Case caseRecord = new Case();
        caseRecord = [SELECT Id,CaseNumber,Status FROM Case WHERE Id =: caseId];
        if(caseRecord != null){
            caseNumber = caseRecord.CaseNumber;
        }
        
        string relatedParty_RecordTypeId = Schema.SObjectType.JS01__Related_Party__c.getRecordTypeInfosByName().get('Related Party').getRecordTypeId();
        List<JS01__Related_Party__c> relatedPartyList = new List<JS01__Related_Party__c>();
        relatedPartyList = [SELECT Id, JS01__Contact__c, JS01__Contact__r.FirstName, JS01__Contact__r.LastName FROM JS01__Related_Party__c WHERE JS01__Case__c =: caseId AND recordTypeId =: relatedParty_RecordTypeId];
        
        relatedPartyWrapperList = new List<reltedPartyWrapper>();
        for(JS01__Related_Party__c rp: relatedPartyList){
            string contactName = rp.JS01__Contact__r.FirstName + ' ' + rp.JS01__Contact__r.LastName;
            reltedPartyWrapper rpWrapperObj = new reltedPartyWrapper(rp.JS01__Contact__c, contactName);
            relatedPartyWrapperList.add(rpWrapperObj);
        }
        system.debug('### relatedPartyWrapperList: ' + relatedPartyWrapperList);
        
        newCoverageRecDummy = new Coverage__c();
    }

    /***************************************************************************
    *@Description : This is the CANCEL Button action                           *
    *@Params      : Void                                                       *
    *@Return      : Void                                                       *    
    ****************************************************************************/
    public PageReference cancel(){
        PageReference pageRef = new PageReference('/'+caseId);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    /***************************************************************************
    *@Description : This is the SAVE Button action                             *
    *@Params      : Void                                                       *
    *@Return      : Void                                                       *    
    ****************************************************************************/
    public PageReference save(){
        try{
            List<Coverage__c> coverageRecordInsertList = new list<Coverage__c>();
            Coverage__c newCoverageRec;
            for(reltedPartyWrapper rpw: relatedPartyWrapperList){
                if(rpw.selectBox == True){
                    System.debug('### rpw.contactName: ' + rpw.contactName + ' - ' + rpw.contactId);
                    newCoverageRec = new Coverage__c();
                    newCoverageRec.Health_Programs__c = newCoverageRecDummy.Health_Programs__c;
                    newCoverageRec.Medicare_Type_s__c = newCoverageRecDummy.Medicare_Type_s__c;
                    newCoverageRec.Exchange_Tier__c = newCoverageRecDummy.Exchange_Tier__c;
                    newCoverageRec.Managed_Care__c = newCoverageRecDummy.Managed_Care__c;
                    newCoverageRec.Family_Member__c = rpw.contactId;
                    newCoverageRec.Case__c = caseId;
                    coverageRecordInsertList.add(newCoverageRec);
                }
            }
            System.debug('### coverageRecordInsertList: ' + coverageRecordInsertList);
            insert coverageRecordInsertList;
            
            PageReference pageRef = new PageReference('/'+caseId);
            pageRef.setRedirect(true);
            return pageRef;
        }
        catch(exception e){
            System.debug('### message: ' + e.getMessage());
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Changes not saved.Please contact the administrator.'));
            return null;
        }
    }
    
    /***************************************************************************
    *@Description : This is the SAVE Button action                             *
    *@Params      : Void                                                       *
    *@Return      : Void                                                       *    
    ****************************************************************************/
    public void checkHealthProgram(){
        for(reltedPartyWrapper rpw : relatedPartyWrapperList){
            if(newCoverageRecDummy.Health_Programs__c == 'Medicare'){
                enableMedicare = true;
            }else{
                enableMedicare = false;
            }
        }
    }
    
    /***************************************************************************
    *@Description : This is the SAVE Button action                             *
    *@Params      : Void                                                       *
    *@Return      : Void                                                       *    
    ****************************************************************************/
    public void checkManagedCare(){
        for(reltedPartyWrapper rpw : relatedPartyWrapperList){
            if(newCoverageRecDummy.Managed_Care__c == 'Yes'){
                enableMedicalGroup = true;
            }else{
                enableMedicalGroup = false;
            }
        }
    }
    
    /**************************************************************************
    *                           ReltedPartyWrapper                            *
    ***************************************************************************/
    public class ReltedPartyWrapper {
        public String contactId {get;set;}
        public String contactName {get;set;}
        public Boolean selectBox {get;set;}
        
        /**************************** CONSTRUCTOR *****************************/
        public reltedPartyWrapper(String cId, String cName){
            selectBox = false;
            contactId = cId;
            contactName = cName;
        }  
    }     
}//End of Class