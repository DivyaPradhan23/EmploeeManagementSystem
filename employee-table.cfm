<cfparam name="form.sKeyword" default="">
<cfparam name="form.sortColumn" default="EmpId">
<cfparam name="form.sortOrder" default="ASC">
<cfparam name="form.alphabet" default="">
<cfset alphabet = trim(form.alphabet)>

<cfset validColumns = "EmpId,Name,Email,MobileNo">

<!--- Safety: Allow only valid columns --->
<cfif NOT listFindNoCase(validColumns, sortColumn)>
    <cfset sortColumn = "EmpId">
</cfif>

<cfif sortOrder NEQ "ASC" AND sortOrder NEQ "DESC">
    <cfset sortOrder = "ASC">
</cfif>

<cfquery name="rs" datasource="#Application.ds#">
    SELECT 
        e.EmpId,
        e.Name,
        e.Email,
        e.MobileNo
    FROM Employees e
    WHERE 1=1

    <!--- Search filter --->
    <cfif trim(sKeyword) NEQ "">
        AND (
            e.Name LIKE <cfqueryparam value="%#sKeyword#%" cfsqltype="cf_sql_varchar">
            OR e.Email LIKE <cfqueryparam value="%#sKeyword#%" cfsqltype="cf_sql_varchar">
            OR e.MobileNo LIKE <cfqueryparam value="%#sKeyword#%" cfsqltype="cf_sql_varchar">
        )
    </cfif>

    <cfif trim(alphabet) NEQ "" AND alphabet NEQ "ALL">
        AND e.Name LIKE <cfqueryparam value="#alphabet#%" cfsqltype="cf_sql_varchar">
    </cfif>

    ORDER BY #sortColumn# #sortOrder#
</cfquery>



<table border="1" class="table table-bordered table-striped tlblist">
<thead>
<tr>
    <th onclick="sortTable('EmpId')">Emp Id</th>
    <th onclick="sortTable('Name')">Name</th>
    <th onclick="sortTable('Email')">Email</th>
    <th onclick="sortTable('MobileNo')">Mobile No</th>
    <th width="15%" class="text-center">ACTION</th>
</tr>
</thead>

<tbody>
<cfoutput query="rs">
<tr>
    <td>#EmpId#</td>
    <td>#Name#</td>
    <td>#Email#</td>
    <td>#MobileNo#</td>
    <td class="text-center">
        <button type="button" class="btn btn-info btn-xs"
            onClick="editEmployee('#EmpId#')">Update</button>

        <button type="button" class="btn btn-danger btn-xs"
            onClick="deleteEmployee('#EmpId#')">Delete</button>
    </td>
</tr>
</cfoutput>

<cfif rs.recordCount EQ 0>
<tr>
    <td colspan="5" class="text-center">No Records Found</td>
</tr>
</cfif>

</tbody>
</table>
