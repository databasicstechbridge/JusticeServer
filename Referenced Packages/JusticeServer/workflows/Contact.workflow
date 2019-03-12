<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_UserId_on_Contact</fullName>
        <field>UserId__c</field>
        <formula>User__c</formula>
        <name>Update UserId on Contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update UserId on Contact</fullName>
        <actions>
            <name>Update_UserId_on_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.User__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This workflow updates the Unique Text Field : UserId with the Id of the User in User__c so as to avoid multiple contacts being associated to one User.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
