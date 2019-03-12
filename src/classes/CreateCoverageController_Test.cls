/***********************************************************************
* Name               : CreateCoverageController_Test                   *
* Description        : JusticeServer - Case Close Screen               *
* Created By         : Techbridge                                      *        
************************************************************************/
@isTest
private class CreateCoverageController_Test {

    private static User userObj;
    private static User userObj2;
    private static Case caseRecord;
    private static Account accountRecord;
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
            
            Account accountRecord = new Account();
            accountRecord.Name = 'Tech Bridge';
            accountRecord.BillingStreet = 'Test Street';
            accountRecord.BillingPostalcode = '000000';
            accountRecord.JS01__Referral_Partner__c = true;
            accountRecord.Phone = '1111111111';
            
            insert accountRecord;
            
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
            
            String relatedPartyRelatedRecordTypeId;
            
            if(Schema.SObjectType.JS01__Related_Party__c.getRecordTypeInfosByName().containsKey(System.Label.JS01.RelatedPartyRelatedRecordType)
            	&& Schema.SObjectType.JS01__Related_Party__c.getRecordTypeInfosByName()!= null ){
            	relatedPartyRelatedRecordTypeId = Schema.SObjectType.JS01__Related_Party__c.getRecordTypeInfosByName().get(System.Label.JS01.RelatedPartyRelatedRecordType).getRecordTypeId();
        	}
        
            JS01__Related_Party__c rParty = new JS01__Related_Party__c();
            rParty.JS01__Case__c = caseRecord.Id;
            rParty.JS01__Contact__c = contactRecord.Id;
            rParty.JS01__Organization__c = accountRecord.Id;
            rParty.RecordTypeId = relatedPartyRelatedRecordTypeId;
            
            insert rParty;
        }
    } 
    
    /******************************************************************************
    *@Description : This method tests CreateCoverage Controller                   *
    *@Params      : void                                                          *
    *@Return      : void                                                          *    
    *******************************************************************************/
    public static testMethod void testCreateCoverageController(){
        init();
        System.runAs(userobj2){ 
        Test.StartTest();
            
            //Set page and pass parameters
            PageReference pageRef = Page.CreateCoverage;
            Test.setCurrentPage(pageRef);
        
            ApexPages.currentPage().getParameters().put('caseId',caseRecord.Id);    
            ApexPages.StandardController sc = new ApexPages.standardController(caseRecord);
            CreateCoverageController jccc = new CreateCoverageController(sc);
            jccc.save();
            jccc.cancel();
            
        Test.StopTest();
        } 
    }
}//End of Class