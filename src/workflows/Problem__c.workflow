<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Medicare_Part_D_Automatic_Enrollment</fullName>
        <field>Medicare_Type_Detail__c</field>
        <literalValue>Automatic Enrollment</literalValue>
        <name>Medicare Part D - Automatic Enrollment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Medicare Part D - Automatic Enrollment</fullName>
        <actions>
            <name>Medicare_Part_D_Automatic_Enrollment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Problem__c.Medicare_Type_s__c</field>
            <operation>includes</operation>
            <value>Part D</value>
        </criteriaItems>
        <description>If case includes Medicare Part D - mark as automatic enrollment</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
