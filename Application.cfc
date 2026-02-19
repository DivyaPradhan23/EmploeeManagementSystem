<cfcomponent output="false">

    <cfset THIS.Name = "EmployeeManagementApp">
    <cfset THIS.SessionManagement = false>

    <cffunction name="onApplicationStart" returntype="boolean" output="false">
        <cfset Application.ds = "ems_ds">
        <cfreturn true>
    </cffunction>

</cfcomponent>
