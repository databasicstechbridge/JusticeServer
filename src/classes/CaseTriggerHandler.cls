/******************************************************************
* Name               : CaseCloseController                        *
* Description        : JusticeServer - Case Close Screen          *
* Created By         : Techbridge                                 *        
*******************************************************************/
public class CaseTriggerHandler{
	
    /***************************************************************************
    *@Description : This method is used to handle after insert scenario		   * 
    *@Params      : void                                                       *
    *@Return      : List<Case> caseList, Map<Id, Case> oldCaseMap              *    
    ****************************************************************************/
    public static void afterInsertHandler(List<Case> caseList, Map<Id, Case> oldCaseMap){
        CaseTriggerUtility.createRelatedParties(caseList, oldCaseMap, true, false);
    }
    
    /***************************************************************************
    *@Description : This method is used to handle after update scenario    	   * 
    *@Params      : void                                                       *
    *@Return      : List<Case> caseList, Map<Id, Case> oldCaseMap              *    
    ****************************************************************************/
    public static void afterUpdateHandler(List<Case> caseList, Map<Id, Case> oldCaseMap){
        CaseTriggerUtility.createRelatedParties(caseList, oldCaseMap, false, true);
    }
}//End of Class