/***********************************************************************
* Name               : HCA_CaseCloseController                         *
* Description        : JusticeServer - Case Close Screen               *
* Created By         : Techbridge                                      *        
************************************************************************/
public class HCA_CaseCloseController{
    
    public Case caseRecord {get;set;}
    public String caseId;
    public List<CaseStatus> statusList {get;set;}
    public List<SelectOption> statusOption {get;set;}
    public String selectedStatus {get;set;}
    public String monetaryId;
    public String nonMonetaryId;
    public Integer monetaryCounter {get;set;}
    public Integer nonMonetaryCounter {get;set;}
    public Boolean showProblemScreen{get;set;}
    public Boolean showCaseScreen{get;set;}
    public List<Problem__c> problemList {get;set;}
    
    /***************************************************************************
    *@Description : This is the contructor                                     *
    *@Params      : ApexPages.StandardController controller                    *
    *@Return      : Void                                                       *    
    ****************************************************************************/
    public HCA_CaseCloseController(ApexPages.StandardController controller){
        showProblemScreen = true;
        showCaseScreen = false;
        caseId = ApexPages.currentPage().getParameters().get('id');

        //GET CASE STATUS PICKLIST VALUES
        Map<String,String> statusValueLabelMap = new Map<String,String>();
        Schema.DescribeFieldResult fieldResult = Case.Status.getDescribe();
        List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry v : values) {
            statusValueLabelMap.put(v.getValue(),v.getLabel());
        }
        
        String caseQuery;
        caseQuery = 'SELECT ';
        for(Schema.FieldSetMember fSetMem : SObjectType.Case.FieldSets.JS01__Close_Case_Details.getFields()) {
            caseQuery += fSetMem.getFieldPath() + ',';
        }
        for(Schema.FieldSetMember fSetMem : SObjectType.Case.FieldSets.Close_Case_Summary.getFields()) {
            caseQuery += fSetMem.getFieldPath() + ',';
        }
        caseQuery = caseQuery.removeEnd(',');
        caseQuery = caseQuery + ',IsClosed,Status,CaseNumber,Contact.Name';
        //caseQuery += ',(SELECT Id, Contact__c,Case__c,Contact__r.Pro_Bono_Portal_Status__c, Status__c FROM Resource_Assignments__r)';
        caseQuery += ',(SELECT Id, Name, RecordType.Name,Problem__c,Outcome_Type__c,Outcome__c,Eligibility_Outcome_Detail__c,Service_Outcome_Detail__c,Referred_To__c,Referred_To_Other__c,Outcome_Comment_Notes__c,Dollar_Amount_for_Revenue_Recovery__c,Highest_Level_of_Appeal__c,Outcome_of_Appeal__c,Expedited__c FROM Problems__r)';
        caseQuery += ' FROM Case WHERE Id =: caseId LIMIT 1 FOR UPDATE';
        
        /************************************* EXECUTE QUERY  *******************************/             
        
        System.debug('************** caseQuery' + caseQuery );
        try{
            caseRecord = Database.Query(caseQuery);
            if(caseRecord.JS01__Date_Case_Closed__c == null){
                caseRecord.JS01__Date_Case_Closed__c = System.today();
            }
            statusOption = new List<SelectOption>();
            if(!caseRecord.isClosed){
                statusOption.add(new SelectOption('','--None--'));
            }else{
                if(statusValueLabelMap.containsKey(caseRecord.Status) && statusValueLabelMap.get(caseRecord.Status) != null ){
                    statusOption.add(new SelectOption(caseRecord.Status,statusValueLabelMap.get(caseRecord.Status)));
                }
            }
            if(caseRecord.Problems__r.size() > 0){
                problemList = caseRecord.Problems__r;
            }
            
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An unexpected error occurred while fetching Case data. Kindly contact Support.'));    
        }  
    }
    
    /***************************************************************************
    *@Description : This method is used to get Case Status Values  that are    * 
    *               - Closed                                                   *
    *@Params      : void                                                       *
    *@Return      : List<SelectOption>                                         *    
    ****************************************************************************/
    public List<SelectOption> getStatusValues(){
        statusList = [SELECT ApiName,MasterLabel,SortOrder FROM CaseStatus WHERE IsClosed = true ORDER BY SortOrder];
        if(statusList != null){
            if(!statusList.isEmpty()){
                for(CaseStatus statusValue : statusList){
                    if(caseRecord.isClosed){
                        if(statusValue.ApiName != caseRecord.Status){
                            statusOption.add(new SelectOption(statusValue.ApiName, statusValue.MasterLabel));
                        }
                    }else{
                         statusOption.add(new SelectOption(statusValue.ApiName, statusValue.MasterLabel));
                    }
                }
            }
        } 
        return statusOption; 
    }
    
    /***************************************************************************
    *@Description : This method delets row from Non Monetary table             * 
    *@Params      : void                                                       *
    *@Return      : void                                                       *    
    ****************************************************************************/
    public PageReference save(){
        PageReference pageRef;
        Boolean showFieldReqdError = false;
        try{
            //CASE
            List<Case> caseRecords = [SELECT 
                                            Id, Subject, Contact.FirstName, JS01__Pro_Bono_Portal_Status__c, JS01__External_Overview__c, JS01__Special_Requirements__c, 
                                            JS01__Client_Type__c, 
                                            Contact.LastName,Account.Name, Contact.MailingStreet, Contact.MailingCity, Contact.MailingState, Contact.MailingPostalCode, 
                                            Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingPostalCode,   
                                            (SELECT Id, JS01__Contact__c,JS01__Case__c,JS01__Contact__r.JS01__Pro_Bono_Portal_Status__c, JS01__Status__c FROM JS01__Resource_Assignments__r)
                                       FROM 
                                            Case 
                                        WHERE 
                                            Id =: caseRecord.Id LIMIT 1];
            //UPDATE RESOURCE ASSIGNMENT STATUS
            if(caseRecord.JS01__Resource_Assignments__r.size() > 0){
                CloseResourceAssignmentsRelatedToCase(caseRecord.JS01__Resource_Assignments__r,'','');
            }
            if(selectedStatus != null){
                caseRecord.Status = selectedStatus;     
                caseRecord.JS01__Pro_Bono_Portal_Status__c = 'Completed';
                caseRecord.JS01__Date_Case_Closed__c = System.Today();            
            }
            
            for(Schema.FieldSetMember fSetMem :  SObjectType.Case.FieldSets.Close_Case_Summary.getFields()) {
                if(fSetMem.getFieldPath() != 'General_Comments__c' && (caseRecord.get(fSetMem.getFieldPath())) == null){
                    if(caseRecord.General_Comments__c == null){
                        showFieldReqdError = true;
                    }
                }
            }
            if(showFieldReqdError){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please enter value in first 3 fields or General Comments in Case Summary Section'));
            }
            if(!showFieldReqdError){
                update problemList;
                update caseRecord;
                pageRef = new PageReference('/'+caseRecord.Id);
                pageRef.setRedirect(true);
            }

        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error at Line : '+ e.getLineNumber() + ', Error Message : ' +  e.getMessage()));    
        }
        return pageRef;
    }   
    
    /***************************************************************************
    *@Description : This method is used to CLOSE RESOURCE ASSIGNMENT           *
    *@Params      : Void                                                       *
    *@Return      : Void                                                       *    
    ****************************************************************************/
    public static void CloseResourceAssignmentsRelatedToCase(List<JS01__Resource_Assignment__c> assignmentsRelatedToCase,string comments,string reason){
        System.Debug('2222>>>>'+assignmentsRelatedToCase);
        Set<String> contactIds = new Set<String>();
        if(assignmentsRelatedToCase.size() > 0){
            for(JS01__Resource_Assignment__c ra : assignmentsRelatedToCase){
                System.Debug('3333>>>>'+ra.JS01__Contact__c);
                if(ra.JS01__Contact__c != null){
                    contactIds.add(ra.JS01__Contact__c);
                }
            }
        }
        
        if(assignmentsRelatedToCase.size() > 0){
            for(JS01__Resource_Assignment__c ra : assignmentsRelatedToCase){
                System.debug(ra.JS01__Contact__c + '!!!!' + (ra.JS01__Contact__c != null && (ra.JS01__Status__c == 'Pending_Acceptance' || ra.JS01__Status__c == 'Active')));
                if(ra.JS01__Contact__c != null && (ra.JS01__Status__c == 'Pending_Acceptance' || ra.JS01__Status__c == 'Active')){
                    ra.JS01__Status__c = 'Closed';
                    if(!String.IsBlank(comments))
                        ra.JS01__Closing_Comments__c = comments;
                    if(!String.IsBlank(reason))
                        ra.JS01__Reason_for_Closing__c = reason;
                }
            }
            update assignmentsRelatedToCase;
        }
    }
   
    /***************************************************************************
    *@Description : This is the NEXT Button action                             *
    *@Params      : Void                                                       *
    *@Return      : Void                                                       *    
    ****************************************************************************/
    public PageReference next(){
        showProblemScreen = false;
        showCaseScreen = true;
        return null;
    } 
    
    /***************************************************************************
    *@Description : This is the PREVIOUS Button action                         *
    *@Params      : Void                                                       *
    *@Return      : Void                                                       *    
    ****************************************************************************/
    public PageReference previous(){
        showProblemScreen = true;
        showCaseScreen = false;
        return null;
    }  
    
    /***************************************************************************
    *@Description : This is the CANCEL Button action                           *
    *@Params      : Void                                                       *
    *@Return      : Void                                                       *    
    ****************************************************************************/
    public PageReference cancel(){
        PageReference pageRef = new PageReference('/'+caseRecord.Id);
        pageRef.setRedirect(true);
        return pageRef;
    } 
}//End of Class