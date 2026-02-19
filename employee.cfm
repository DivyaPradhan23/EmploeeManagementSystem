<cfparam name="form.sKeyword" default="">
<cfset SearchString = "&sKeyword=#sKeyword#">

<!DOCTYPE html>
<html>
<head>
	<cfinclude template="nav-meta.cfm">

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

	<script language="javascript">

		var currentSortColumn = "EmpId";
		var currentSortOrder = "ASC";
		var currentAlphabet = "";

		function loadTable()
		{
			var keyword = $("#sKeyword").val();

			$.ajax({
				url: "employee-table.cfm",
				type: "POST",
				data: {
					sKeyword: keyword,
					sortColumn: currentSortColumn,
					sortOrder: currentSortOrder,
					alphabet: currentAlphabet
				},
				success: function(res){
					$("#tableContainer").html(res);
					loadAlphabets();
				}
			});
		}

		function sortTable(column)
		{
			if(currentSortColumn == column)
			{
				currentSortOrder = (currentSortOrder == "ASC") ? "DESC" : "ASC";
			}
			else
			{
				currentSortColumn = column;
				currentSortOrder = "ASC";
			}

			loadTable();
		}

		function searchEmployee()
		{
			var keyword = $("#sKeyword").val().trim();

			if(keyword == "")
			{
				alert("Please provide value to search");
				return false;
			}

			loadTable();
		}

		function filterByAlphabet(letter)
		{
			currentAlphabet = letter;
			loadTable();
		}

		function loadAlphabets()
		{
			$.ajax({
				url: "employee-alphabet.cfm",
				type: "POST",
				data: {
					sKeyword: $("#sKeyword").val()
				},
				success: function(res){
					$("#alphabetContainer").html(res);
				}
			});
		}


		function deleteEmployee(EmpId)
            {
                if(confirm("Are you sure want to delete record?"))
                {
                    $("#EmpId").val(EmpId);
                    $("#process").val("D");

                    $.ajax({
                        url: "employee-save.cfm",
                        type: "POST",
                        data: $("#frmedit").serialize(),
                        success: function(res){
                            $("#process").val("A");   // reset
							loadTable();
                        },
                        error: function(err){
                            alert("Error occurred");
                            console.log(err.responseText);
                        }
                    });
                }
            }

		
		function editEmployee(EmpId)
        {
            var url = "employee-update.cfm";
            $("#EmpId").val(EmpId);

            $.ajax({
                type: "POST",
                url: url,
                data: $("#frmedit").serialize(),
                success: function(result){
                    $("#div-edit").html(result);
                    $("#mod-edit").modal('show');
                },
                error: function(err){
                    console.log(err.responseText);
                    alert("Error loading edit page");
                }
            });
        }

		
		function saveEditEmployee()
		{
			var name = $("input[name='Name']").val().trim();
			var email = $("input[name='Email']").val().trim();
			var mobile = $("input[name='MobileNo']").val().trim();

			var nameRegex = /^[A-Za-z ]+$/;
			var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
			var mobileRegex = /^[0-9]{10}$/;

			// Name validation
			if(name == ""){
				alert("Name cannot be blank");
				return false;
			}
			if(!nameRegex.test(name)){
				alert("Name should contain only alphabets and spaces");
				return false;
			}

			// Email validation
			if(email == ""){
				alert("Email cannot be blank");
				return false;
			}
			if(!emailRegex.test(email)){
				alert("Please enter valid email");
				return false;
			}

			// Mobile validation
			if(mobile == ""){
				alert("Mobile number cannot be blank");
				return false;
			}
			if(!mobileRegex.test(mobile)){
				alert("Mobile number must be 10 digits");
				return false;
			}

			var fData = new FormData(document.getElementById("frmdata"));

			$.ajax({
				url: "employee-save.cfm",
				type: "POST",
				data: fData,
				dataType: "json",
				cache: false,
				contentType: false,
				processData: false,
				success: function(res){
					alert(res.message);
					if(res.status == "1"){
						$("#mod-edit").modal("hide");
						loadTable();
					}
				},
				error: function(){
					alert("Error occurred while saving");
				}
			});

			return false;
		}
		function exportExcel()
		{
			var keyword = $("#sKeyword").val();

			window.location.href = "employee-export.cfm?sKeyword=" + encodeURIComponent(keyword);
		}


	</script>
</head>
<body>
	<div class="wrapper">
		<div class="content-wrapper">
		<!-- Content Header (Page header) -->
		<cfoutput>
		<section class="content-header" style="padding-top:20px;">
			<h1 align="center">Employee Management System <small></small></h1>
		</section>
		
		</cfoutput>
		<!-- Main content -->
		<section class="content">
			<div class="box box-primary">
				<div class="box-header" style="border-bottom:1px  #aeaeae; padding-bottom:15px; padding-top:40px;">
					<cfoutput>
					<form method="post" name="frmedit" id="frmedit" autocomplete ="off">
						<input type="hidden" id="EmpId" name="EmpId" value="0">
						<input type="hidden" id="process" name="process" value="A">					
					</form>
					
					<form name="frmsearch" id="frmsearch" onsubmit="return false;">
					<table class="tlbsearch tlbpadding" border="0">
						<tr>
							<td width="5%"></td><td width="20%"><input type="text" name="sKeyword" id="sKeyword" class="form-control" value="#encodeForHTML(sKeyword)#"></td>
							<td align="left"><button type="button" class="btn btn-info btn-sm" onclick="searchEmployee()"><i class="fa fa-search"></i> Search </button></td>
						</tr>
					</table>
					</form>
					</cfoutput>
				</div>

				<div class="mb-3 text-center" style="margin-top:20px;" id="alphabetContainer">
					<cfinclude template="employee-alphabet.cfm">
				</div>
				<div class="box-body" style="padding:40px;">
					<div id="tableContainer">
						<cfinclude template="employee-table.cfm">
					</div>
				</div>
			</section>
			<div class="text-right mt-3 mr-5">
				<button type="button" class="btn btn-primary btn-sm"  onClick="editEmployee(0)">
					<i class="fa fa-plus"></i> Add New Employee
				</button> 
				<button type="button" class="btn btn-success btn-sm" onclick="exportExcel()">
					Export to Excel
				</button>	
			</div>

		<!-- /.content -->
		</div> <!-- content-wrapper -->
	
		<div id="div-edit"></div>
	</div> <!-- wrapper -->

</body>
</html>
