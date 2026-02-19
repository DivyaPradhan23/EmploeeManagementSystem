
<cfparam name="form.process" default="">
<cfparam name="form.EmpId" default="0">
<cfparam name="form.Name" default="">
<cfparam name="form.Email" default="">
<cfparam name="form.MobileNo" default="">
<cfset PROCESS = form.process>
<cfset EmpId = form.EmpId>
<cfset Name = form.Name>
<cfset Email = form.Email>
<cfset MobileNo = form.MobileNo>


<!---<cfsetting enablecfoutputonly="yes">--->
<cfset output = StructNew()>
<cfif PROCESS eq "D">	
	<cftry>
		<cfquery name="rsData" datasource="#Application.ds#" >
			Delete from Employees
			Where 
			EmpId = <cfqueryparam cfsqltype="cf_sql_integer" value="#EmpId#">
		</cfquery>
	<cfcatch type="Database">
		<cfset output["status"]="0">
		<cfset output["message"]= "#cfcatch.Message# : #cfcatch.Detail#">
		<cfcontent type="application/json">
        <cfoutput>#serializeJSON(output)#</cfoutput>
        <cfabort>

	</cfcatch>
	</cftry>
	<cfset output["status"]="1">
	<cfset output["message"]="Delete Successfully">
</cfif>

<cfif PROCESS eq "A" OR PROCESS eq "M">

    <cfif trim(Name) eq "">
        <cfset output = {status="0", message="Name cannot be blank"}>
        <cfcontent type="application/json">
        <cfoutput>#serializeJSON(output)#</cfoutput>
        <cfabort>
    </cfif>

    <cfif NOT REFind("^[A-Za-z ]+$", Name)>
        <cfset output = {status="0", message="Name should contain only alphabets and spaces"}>
        <cfcontent type="application/json">
        <cfoutput>#serializeJSON(output)#</cfoutput>
        <cfabort>
    </cfif>

    <cfif trim(Email) eq "" OR NOT isValid("email", Email)>
        <cfset output = {status="0", message="Invalid Email"}>
        <cfcontent type="application/json">
        <cfoutput>#serializeJSON(output)#</cfoutput>
        <cfabort>
    </cfif>

    <cfif NOT REFind("^[0-9]{10}$", MobileNo)>
        <cfset output = {status="0", message="Mobile number must be 10 digits"}>
        <cfcontent type="application/json">
        <cfoutput>#serializeJSON(output)#</cfoutput>
        <cfabort>
    </cfif>

</cfif>

<cfif PROCESS eq "M">	
	
	<!--- Check duplicate --->
	<cftry>		
		<cfquery name="rsData" datasource="#Application.ds#" >
			SELECT 1 FROM Employees
			Where 
			Email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Email#">
			AND EmpId <> <cfqueryparam cfsqltype="cf_sql_integer" value="#EmpId#">
		</cfquery>
		
		<cfif rsData.recordcount gt 0>
			<cfset output["status"]="0">
			<cfset output["message"]= "Employee already exists with this Email, unable to Update">
			<cfcontent type="application/json">
			<cfoutput>#serializeJSON(output)#</cfoutput>
			<cfabort>
		</cfif>
	</cftry>
	<!---End Check duplicate --->	
	
	<cftry>
		<cfquery name="rsData" datasource="#Application.ds#" >
			update Employees 
			Set				
				Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Name#">,
				Email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Email#">,
				MobileNo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#MobileNo#">,
				ModifyTs = GetDate()
			Where
				EmpId = <cfqueryparam cfsqltype="cf_sql_integer" value="#EmpId#">
		</cfquery>
		<cfcatch type="Database">
			<cfset output["status"]="0">
			<cfset output["message"]= "Here #cfcatch.Message# : #cfcatch.Detail#">
			<cfcontent type="application/json">
			<cfoutput>#serializeJSON(output)#</cfoutput>
			<cfabort>
		</cfcatch>
	</cftry>
	<cfset output["status"]="1">
	<cfset output["message"]="Saved Successfully">
</cfif>

<cfif PROCESS eq "A">
	
	<!--- Check duplicate --->
	<cftry>		
		<cfquery name="rsData" datasource="#Application.ds#">
			SELECT 1 FROM Employees
			Where 
			Email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Email#">
		</cfquery>
		
		<cfif rsData.recordcount gt 0>
			<cfset output["status"]="0">
			<cfset output["message"]= "Employee already exists with this Email, unable to add">
			<cfcontent type="application/json">
			<cfoutput>#serializeJSON(output)#</cfoutput>
			<cfabort>
		</cfif>
		<cfcatch type="Database">
			<cfset output["status"]="0">
			<cfset output["message"]= "#cfcatch.Message# : #cfcatch.Detail#">
			<cfcontent type="application/json">
			<cfoutput>#serializeJSON(output)#</cfoutput>
			<cfabort>
		</cfcatch>
	</cftry>

	<cftry>
		<cfquery name="rsData" datasource="#Application.ds#" >
			insert into Employees
			(				
				Name,
				Email,
				MobileNo,
				CreateTs
			)

			Values
			(
				
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Name#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Email#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#MobileNo#">,
				GetDate()
				
			)
		</cfquery>
		<cfcatch type="Database">
			<cfset output["status"]="0">
			<cfset output["message"]= "#cfcatch.Message# : #cfcatch.Detail#">
			<cfcontent type="application/json">
			<cfoutput>#serializeJSON(output)#</cfoutput><cfabort>

		</cfcatch>
	</cftry>
	<cfset output["status"]="1">
	<cfset output["message"]="Saved Successfully">
</cfif>

<cfcontent type="application/json" reset="true">
<cfoutput>#serializeJSON(output)#</cfoutput>
