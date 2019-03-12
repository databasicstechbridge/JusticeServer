<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Hours_Population</fullName>
        <field>Hours__c</field>
        <formula>VALUE(
IF(
	TEXT(FLOOR((End_Time__c - Start_Time__c)*24))
	&amp;&quot;.&quot;&amp;
	IF(
		ROUND(MOD((End_Time__c - Start_Time__c)*1440,60),0) &gt; 9,
		TEXT(ROUND(MOD((End_Time__c - Start_Time__c)*1440,60),0)),
		&quot;0&quot;&amp; TEXT(ROUND(MOD((End_Time__c - Start_Time__c)*1440,60),0))
	) = &quot;0.0&quot;,
	&quot;0.00&quot;,
	TEXT(FLOOR((End_Time__c - Start_Time__c)*24))
	&amp;&quot;.&quot;&amp;
	IF(
		ROUND(MOD((End_Time__c - Start_Time__c)*1440,60)*(100/60),0) &gt; 9,
		TEXT(ROUND(MOD((End_Time__c - Start_Time__c)*1440,60)*(100/60),0)),
		&quot;0&quot;&amp; TEXT(ROUND(MOD((End_Time__c - Start_Time__c)*1440,60)*(100/60),0))
	)
)
)</formula>
        <name>Hours Population</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Hour Population</fullName>
        <actions>
            <name>Hours_Population</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>(ISCHANGED(  Hours__c ) || ISCHANGED( Start_Time__c ) ||  ISCHANGED( End_Time__c ) || ISNEW()) &amp;&amp; NOT(ISNULL(Start_Time__c )) &amp;&amp; NOT(ISNULL(End_Time__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
