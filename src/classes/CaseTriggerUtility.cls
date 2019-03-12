/***********************************************************************
* Name               : HCA_CaseCloseController                         *
* Description        : JusticeServer - Case Close Screen               *
* Created By         : Techbridge                                      *        
************************************************************************/
public class CaseTriggerUtility{

	/***************************************************************************
    *@Description : This method is used Create Related Parties	  			   * 
    *@Params      : void                                                       *
    *@Return      : List<Case> caseList, Map<Id, Case> oldCaseMap              *    
    ****************************************************************************/
    public Static void createRelatedParties(List<Case> caseList,Map<Id,Case> oldCaseMap,Boolean insertOperation,Boolean updateOperation){
    	List<string> contactIdList = new List<string>();
    	List<string> caseIdList = new List<string>();
        
        for(case c: caseList){ 
            if(insertOperation){
                if(c.ContactId != null){
                    contactIdList.add(c.contactId); 
                    caseIdList.add(c.Id);
                }
            }
            else if(updateOperation){
                if(c.ContactId != null && c.ContactId != oldCaseMap.get(c.Id).ContactId){
                    contactIdList.add(c.contactId); 
                    caseIdList.add(c.Id);               
                }
            }      
        }
        System.debug('### contactIdList: ' + contactIdList);
        
        if(contactIdList.size() > 0){
            List<JS01__Related_Party__c> relatedPartyList = new List<JS01__Related_Party__c>();
            relatedPartyList = [SELECT 
            							Id, JS01__Contact__c, JS01__Case__c FROM JS01__Related_Party__c 
            						WHERE 
                                		JS01__Contact__c IN : contactIdList 
                            		AND JS01__Case__c IN: caseIdList];
            
            Set<string> uniqueKeySet = new Set<string>();
            
            for(JS01__Related_Party__c rp: relatedPartyList){
                string uniqueKey = rp.JS01__Case__c + '_' + rp.JS01__Contact__c;
                uniqueKeySet.add(uniqueKey);
            }
            System.debug('### uniqueKeySet: ' + uniqueKeySet);  
            
            String relatedPartyRecordTypeId = Schema.SObjectType.JS01__Related_Party__c.getRecordTypeInfosByName().get('Related Party').getRecordTypeId();
            List<JS01__Related_Party__c> relatedPartyInsertList = new List<JS01__Related_Party__c>();
            
            for(Case c: caseList){
                String uniqueKey = c.Id + '_' + c.contactId;
                
                if(!uniqueKeySet.contains(uniqueKey)){
                    JS01__Related_Party__c rpNewObj = new JS01__Related_Party__c();
                    rpNewObj = createRPInstance(c.Id, c.contactId, relatedPartyRecordTypeId);
                    relatedPartyInsertList.add(rpNewObj);
                }
            }
            System.debug('### relatedPartyInsertList: ' + relatedPartyInsertList); 
            
            if(relatedPartyInsertList.size() > 0){
                insert relatedPartyInsertList;
            }
        }
    }
    
    /***************************************************************************
    *@Description : This method is used Create Related Party Instance 		   * 
    *@Params      : void                                                       *
    *@Return      : List<Case> caseList, Map<Id, Case> oldCaseMap              *    
    ****************************************************************************/
    public static JS01__Related_Party__c createRPInstance (String caseId,String contactId,String rtId ){
        
        JS01__Related_Party__c rpNew = new JS01__Related_Party__c();
        rpNew.JS01__Contact__c = contactId;
        rpNew.JS01__Case__c = caseId;
        rpNew.Relationship__c = 'Self';
        rpNew.recordTypeId = rtId;
        
        return rpNew;
    }                    
}//End of Class