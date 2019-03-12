/***************************************************************************
* Name               : ReOpenCaseController                            	   *
* Description        : JusticeServer - Case ReOpenScreen           	   	   *
* Created By         : Techbridge                                          *        
****************************************************************************/

public class ReOpenCaseController {

    public Case caseRecord {get;set;}
    public String caseId;
    
    /***************************************************************************
    *@Description : This is the contructor                                     *
    *@Params      : ApexPages.StandardController controller                    *
    *@Return      : Void                                                       *    
    ****************************************************************************/
    public ReOpenCaseController(ApexPages.StandardController controller){
        caseId = ApexPages.currentPage().getParameters().get('id');
        caseRecord = [SELECT Id,Reason_Re_Opened__c,Status,Re_Opened_By__c FROM Case WHERE Id =: caseId];
    }
    
    /***************************************************************************
    *@Description : This is the SAVE Button action                             *
    *@Params      : Void								                       *
    *@Return      : Void                                                       *    
    ****************************************************************************/
    public PageReference save(){
        PageReference pageRef;
        try{
            caseRecord.Status = 'Re-Opened';
            caseRecord.Re_Opened_By__c = userinfo.getUserId();
            update caseRecord;
            
            pageRef = new PageReference('/'+caseRecord.Id);
            pageRef.setRedirect(true);
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error at Line : '+ e.getLineNumber() + ', Error Message : ' +  e.getMessage()));    
        }
        return pageRef;
    }
    
    /***************************************************************************
    *@Description : This is the CANCEL Button action                           *
    *@Params      : Void								                       *
    *@Return      : Void                                                       *    
    ****************************************************************************/
    public PageReference cancel(){
        PageReference pageRef;
        pageRef = new PageReference('/'+caseRecord.Id);
        pageRef.setRedirect(true);
        
        return pageRef;
    }
}//End of Class