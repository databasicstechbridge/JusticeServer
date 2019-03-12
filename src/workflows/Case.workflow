<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>JS01__Case_Closed_Mailing_City</fullName>
        <field>JS01__Mailing_City_as_of_Case_Closed__c</field>
        <formula>Contact.MailingCity</formula>
        <name>Case Closed Mailing City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>JS01__Case_Closed_Mailing_Country</fullName>
        <field>JS01__Mailing_Country_as_of_Case_Closed__c</field>
        <formula>Contact.MailingCountry</formula>
        <name>Case Closed Mailing Country</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>JS01__Case_Closed_Mailing_State</fullName>
        <field>JS01__Mailing_State_as_of_Case_Closed__c</field>
        <formula>Contact.MailingState</formula>
        <name>Case Closed Mailing State</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>JS01__Case_Closed_Mailing_Street</fullName>
        <field>JS01__Mailing_Street_as_of_Case_Closed__c</field>
        <formula>Contact.MailingStreet</formula>
        <name>Case Closed Mailing Street</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>JS01__Case_Closed_Mailing_Zip</fullName>
        <field>JS01__Mailing_Zip_as_of_Case_Closed__c</field>
        <formula>Contact.MailingPostalCode</formula>
        <name>Case Closed Mailing Zip</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Subject</fullName>
        <field>Subject</field>
        <formula>JS01__Client_Name__c &amp;&quot; &quot;&amp;

IF(
   ISBLANK(JS01__Date_of_Intake__c),
   TEXT(DATEVALUE(CreatedDate)),
   TEXT(JS01__Date_of_Intake__c)
)</formula>
        <name>Update Subject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>JS01__Case Closed Mailing City</fullName>
        <actions>
            <name>JS01__Case_Closed_Mailing_City</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.MailingCity</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>JS01__Case Closed Mailing Country</fullName>
        <actions>
            <name>JS01__Case_Closed_Mailing_Country</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.MailingCountry</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>JS01__Case Closed Mailing State</fullName>
        <actions>
            <name>JS01__Case_Closed_Mailing_State</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.MailingState</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>JS01__Case Closed Mailing Street</fullName>
        <actions>
            <name>JS01__Case_Closed_Mailing_Street</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.MailingStreet</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>JS01__Case Closed Mailing Zip</fullName>
        <actions>
            <name>JS01__Case_Closed_Mailing_Zip</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.MailingPostalCode</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Case Subject</fullName>
        <actions>
            <name>Update_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
