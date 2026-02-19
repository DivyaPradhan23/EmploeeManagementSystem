<cfparam name="form.sKeyword" default="">
<cfset sKeyword = trim(form.sKeyword)>

<!--- Get distinct first letters --->
<cfquery name="rsAlpha" datasource="#Application.ds#">
    SELECT DISTINCT UPPER(LEFT(Name,1)) AS FirstLetter
    FROM Employees
    WHERE 1=1
    <cfif sKeyword NEQ "">
        AND (
            Name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#sKeyword#%">
            OR Email LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#sKeyword#%">
        )
    </cfif>
</cfquery>

<cfset availableLetters = ValueList(rsAlpha.FirstLetter)>

<cfoutput>
<cfloop from="65" to="90" index="i">
    <cfset letter = Chr(i)>
    <cfif ListFindNoCase(availableLetters, letter)>
        <a href="javascript:void(0);"
           onclick="filterByAlphabet('#letter#')"
           style="margin-right:12px; font-weight:bold; color:black; text-decoration:none;">
           #letter#
        </a>
    <cfelse>
        <span style="margin-right:10px; color:grey;">
            #letter#
        </span>
    </cfif>
</cfloop>
<a href="javascript:void(0);"
   onclick="filterByAlphabet('')"
   style="margin-right:12px; font-weight:bold; color:black; text-decoration:none;">
   ALL
</a>


</cfoutput>
