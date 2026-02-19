<cfparam name="url.sKeyword" default="">
<cfset sKeyword = trim(url.sKeyword)>

<!--- Get Data --->
<cfquery name="rs" datasource="#Application.ds#">
    SELECT 
        EmpId,
        Name,
        Email,
        MobileNo
    FROM Employees
    WHERE 1=1
    <cfif sKeyword NEQ "">
        AND (
            Name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#sKeyword#%">
            OR Email LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#sKeyword#%">
            OR MobileNo LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#sKeyword#%">
        )
    </cfif>
    ORDER BY EmpId
</cfquery>

<!--- Excel Response --->
<cfheader name="Content-Disposition" value="attachment; filename=Employee_Report.xls">
<cfcontent type="application/vnd.ms-excel">

<table border="1">
    <tr style="background-color:#d9edf7; font-weight:bold;">
        <td>Emp Id</td>
        <td>Name</td>
        <td>Email</td>
        <td>Mobile No</td>
    </tr>

    <cfoutput query="rs">
        <tr>
            <td>#EmpId#</td>
            <td>#Name#</td>
            <td>#Email#</td>
            <td>#MobileNo#</td>
        </tr>
    </cfoutput>
</table>
