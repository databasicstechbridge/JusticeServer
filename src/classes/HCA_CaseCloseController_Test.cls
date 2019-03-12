/***********************************************************************
* Name               : HCA_CaseCloseController_Test                    *
* Description        : JusticeServer - Case Close Screen               *
* Created By         : Techbridge                                      *        
************************************************************************/
@isTest
private class HCA_CaseCloseController_Test {

    private static User userObj;
    private static User userObj2;
    private static Case caseRecord;
    private static Contact contactRecord;
    private static JS01__Benefits__c monetaryRecord;
    private static JS01__Benefits__c nonMonetaryRecord;
    private static JS01__Hours__c hourRecord;
    private static JS01__Resource_Assignment__c resAss;
    private static JS01__Resource_Assignment__c resAss1;
    
    /***************************************************************************
    *@Description : This is a method initialises test data                     *
    *@Params      : void                                                       *
    *@Return      : void                                                       *    
    ****************************************************************************/
    private static void init(){
        
        userobj = new User();
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        userobj.alias = 'standt1';
        userobj.email = 'sysadminuser@testorg.com';
        userobj.emailencodingkey = 'UTF-8'; 
        userobj.lastname = 'Testing'; 
        userobj.languagelocalekey = 'en_US'; 
        userobj.Username = system.now().millisecond()+'@techbridge.org';
        userobj.CommunityNickname = system.now().millisecond()+'ASC';
        userobj.TimeZoneSidKey = 'GMT';
        userobj.localesidkey ='en_US';
        userobj.ProfileId = adminProfile.Id;
        
        insert userobj;
        
        System.runAs(userobj){ 
            contactRecord = new Contact();
            contactRecord.FirstName = 'FirstName';
            contactRecord.LastName = 'LastName';
            contactRecord.birthdate = System.today().addYears(-20);
            contactRecord.JS01__Social_Security_Number__c ='1234';
            contactRecord.MailingPostalCode = '000000';
            
            insert contactRecord;
            
            userobj2 = new User();
            userobj2.alias = 'standt1';
            userobj2.email = 'sysadminuser@testorg.com';
            userobj2.emailencodingkey = 'UTF-8'; 
            userobj2.lastname = 'Testing'; 
            userobj2.languagelocalekey = 'en_US'; 
            userobj2.Username = system.now().millisecond()+'@techbridge.org';
            userobj2.CommunityNickname = system.now().millisecond()+'ASC';
            userobj2.TimeZoneSidKey = 'GMT';
            userobj2.localesidkey ='en_US';
            userobj2.JS01__contact_ID__c = contactRecord.Id;
            userobj2.ProfileId = adminProfile.Id;
            
            insert userobj2;
            
            caseRecord = new Case();
            caseRecord.Origin = 'Email';
            caseRecord.Status = 'New';
            
            insert caseRecord;
            
            String monetaryId;
            String nonMonetaryId;
            
            //GET MONETARY RECORD TYPE ID
            if(Schema.SObjectType.JS01__Benefits__c.getRecordTypeInfosByName().containsKey(System.Label.JS01.BenefitsMonetaryRecordType)
                && Schema.SObjectType.JS01__Benefits__c.getRecordTypeInfosByName()!= null ){
                monetaryId = Schema.SObjectType.JS01__Benefits__c.getRecordTypeInfosByName().get(System.Label.JS01.BenefitsMonetaryRecordType).getRecordTypeId();
            }
            
            //GET NON - MONETARY RECORD TYPE ID
            if(Schema.SObjectType.JS01__Benefits__c.getRecordTypeInfosByName().containsKey(System.Label.JS01.BenefitsNonMonetaryRecordType)
                && Schema.SObjectType.JS01__Benefits__c.getRecordTypeInfosByName()!= null ){
                nonMonetaryId = Schema.SObjectType.JS01__Benefits__c.getRecordTypeInfosByName().get(System.Label.JS01.BenefitsNonMonetaryRecordType).getRecordTypeId();
            }
            
            monetaryRecord = new JS01__Benefits__c();
            monetaryRecord.JS01__Case__c = caseRecord.Id;
            monetaryRecord.RecordTypeId = monetaryId;
            
            insert monetaryRecord;
            
            nonMonetaryRecord = new JS01__Benefits__c();
            nonMonetaryRecord.JS01__Case__c = caseRecord.Id;
            nonMonetaryRecord.RecordTypeId = nonMonetaryId;
            
            insert nonMonetaryRecord;
            
            resAss = new JS01__Resource_Assignment__c();
            resAss.JS01__Case__c = caseRecord.Id;
            resAss.JS01__Contact__c = contactRecord.Id;
            resAss.JS01__Status__c = 'Active';
            
            insert resAss;
            
            resAss1 = new JS01__Resource_Assignment__c();
            resAss1.JS01__Case__c = caseRecord.Id;
            resAss1.JS01__Contact__c = contactRecord.Id;
            resAss1.JS01__Status__c = 'Pending_Acceptance';
            
            insert resAss1;
            
            hourRecord = new JS01__Hours__c();
            hourRecord.JS01__Case__c = caseRecord.Id;
            hourRecord.JS01__Contact__c = contactRecord.Id;
            
            insert hourRecord;
            
            JS01__JS_Webservice_Settings__c setting = new JS01__JS_Webservice_Settings__c();
            setting.Name = 'Close Volunteer';
            setting.JS01__Username__c = 'test';
            setting.JS01__Password__c = 'test';
            setting.JS01__Endpoint__c = 'http://test.com';
            
            insert setting;
                       
            Problem__c problem = new Problem__c();
            problem.Case__c = caseRecord.Id;
            problem.Family_Member__c = contactRecord.Id;
            
            insert problem;
        }
    } 
    
    /******************************************************************************
    *@Description : This method tests case close Controller                       *
    *@Params      : void                                                          *
    *@Return      : void                                                          *    
    *******************************************************************************/
    public static testMethod void testCaseCloseController(){
        init();
        System.runAs(userobj2){ 
        Test.StartTest();
            
            //Set page and pass parameters
            PageReference pageRef = Page.HCA_CaseClose;
            Test.setCurrentPage(pageRef);
        
            ApexPages.currentPage().getParameters().put('id',caseRecord.Id);    
            ApexPages.StandardController sc = new ApexPages.standardController(caseRecord);
            HCA_CaseCloseController jccc = new HCA_CaseCloseController(sc);
            jccc.monetaryCounter = 0;
            jccc.nonMonetaryCounter = 0;
            jccc.getStatusValues();
            jccc.selectedStatus = 'Closed';
            jccc.save();
            HCA_CaseCloseController.CloseResourceAssignmentsRelatedToCase(new List<JS01__Resource_Assignment__c>{resAss,resAss1},'','');
            jccc.next();
            jccc.previous();
            jccc.cancel();
            
            
        Test.StopTest();
        } 
    }
}//End of Class