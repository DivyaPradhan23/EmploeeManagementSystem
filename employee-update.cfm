<cfparam name="EmpId" default="0">
<cfparam name="Process" default="A">

<style>
.modal-dialog {
    max-width: 550px;
}

.modal-content {
    border: 2px solid #2c3e50;
    border-radius: 0;
    box-shadow: none;
}

.modal-body {
    padding: 30px 40px;
}

.modal-body table th {
    font-weight: normal;
    padding-bottom: 20px;
}

.modal-body table td {
    padding-bottom: 20px;
}

.modal-content input {
    width: 80%;
    border: 2px solid #2c3e50;
    border-radius: 0;
}

.modal-footer {
    border-top: none;
    justify-content: center;
    padding-bottom: 25px;
}

.modal-content .btn-primary {
    background-color: #4e73df;
    border: none;
    padding: 6px 25px;
    border-radius: 0;
}
</style>


<cfif Val(EmpId) eq "0">
    <cfquery name="rs" datasource="#Application.ds#">
		 Select   null as Name, null as Email, null as MobileNo
    </cfquery>
<cfelse>
	<cfset Process = "M">
    <cfquery name="rs" datasource="#Application.ds#">
		Select Name,Email,MobileNo From Employees
		Where EmpId = <cfqueryparam cfsqltype="cf_sql_integer" value="#EmpId#">		
    </cfquery>
</cfif>
<cfoutput query="rs">

<form action="##" method="post"  enctype="multipart/form-data" name="frmdata" id="frmdata" onsubmit="return saveEditEmployee();" accept-charset="utf-8" autocomplete ="off">
<input type="hidden" id="EmpId" name="EmpId" value="#EmpId#" />
<input type="hidden" id="Process" name="Process" value="#Process#" />


<div class="modal" id="mod-edit" tabindex="-1">
<div class="modal-dialog">
<div class="modal-content">

<div class="modal-body">
    <table class="w-100">
        <tr>
            <th width="35%">Name:</th>
            <td>
                <input type="text" name="Name" value="#Name#">
            </td>
        </tr>
        <tr>
            <th>Email Id:</th>
            <td>
                <input type="text" name="Email" value="#Email#">
            </td>
        </tr>
        <tr>
            <th>Mobile No:</th>
            <td>
                <input type="text" name="MobileNo" value="#MobileNo#">
            </td>
        </tr>
    </table>
</div>

<div class="modal-footer">
    <button type="submit" class="btn btn-primary">Save</button>
</div>

</div>
</div>
</div>

</form>
</cfoutput>
