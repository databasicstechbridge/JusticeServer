/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class SaveCaseClientWebService {
    global SaveCaseClientWebService() {

    }
    global static String DoSaveCaseCallout(String caseJSON) {
        return null;
    }
    global static String buildRequest(Case caseRecord, String status, String contactId) {
        return null;
    }
    global static String convertId(String inputId) {
        return null;
    }
global class AdversePartyWrap {
    global String FirstName;
    global String LastName;
    global String SF_Id;
    global String Type;
    global String URL;
    global AdversePartyWrap(String Type, String FirstName, String LastName, String SF_Id, String URL) {

    }
}
global class casewrap {
    global List<JS01.SaveCaseClientWebService.AdversePartyWrap> AdversePartyList;
    global String Category;
    global String ClientAddress;
    global String ClientName;
    global String ExternalOverview;
    global String Location;
    global String SF_CaseIdentifier;
    global String SF_ContactId;
    global String SF_LegalProviderIdentifier;
    global String SF_Status;
    global String SF_URL;
    global String SpecialRequirements;
    global String Title;
    global String VolunteerEmail;
    global casewrap(String SF_LegalProviderIdentifier, String SF_CaseIdentifier, String ExternalOverview, String SpecialRequirements, String Category, String Location, String ClientName, String ClientAddress, String Title, String SF_Status, String SF_URL, String SF_ContactId, String VolunteerEmail, List<JS01.SaveCaseClientWebService.AdversePartyWrap> AdversePartyList) {

    }
}
}
