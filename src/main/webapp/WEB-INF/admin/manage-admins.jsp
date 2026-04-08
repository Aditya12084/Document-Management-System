<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
            rel="stylesheet"
            integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB"
            crossorigin="anonymous"
    />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.3/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/2.3.7/css/dataTables.bootstrap5.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/2.3.7/js/dataTables.js"></script>
    <script src="https://cdn.datatables.net/2.3.7/js/dataTables.bootstrap5.js"></script>
    <style>
        #example_wrapper{
            background-color: white;
            background-color: white;
            padding: 10px;
            border-radius: 5px;
        }
    </style>
</head>
<body style="background-color: rgba(0, 0, 0, .1);">
<%@ include file="../common/sidebar.jsp"%>
<div class="modal fade" id="createAdminModal" tabindex="-1" aria-labelledby="createAdminModal" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="createAdminModal">
                    Create Admin
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form id="create-admin-form" method="POST">
                <div class="modal-body">
                    <div class="mb-3">
                        <input name="admin-username" id="admin-username" type="text" class="form-control" placeholder="Username" required>
                    </div>
                    <div class="mb-3">
                        <input name="admin-fullname" id="admin-fullname" type="text" class="form-control" placeholder="Full Name" required>
                    </div>
                    <div class="mb-3">
                        <input name="admin-email" type="email" id="admin-email" class="form-control" placeholder="Email" required>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" id="create-admin-btn" class="btn btn-primary px-4">
                        <i class="bi bi-check-circle me-1"></i>Create
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
<div class="mx-4 mt-3 flex-grow-1">
    <div class="d-flex">
        <h2 class="flex-grow-1">Admins</h2>
        <button data-bs-toggle="modal" data-bs-target="#createAdminModal" class="my-2 btn btn-success">Create Admin</button>
    </div>
    <table id="example" class="table table-striped small">
        <thead>
        <tr>
            <th>Full Name</th>
            <th>Username</th>
            <th>Email</th>
            <th>Action</th>
        </tr>
        </thead>
        <tbody id="admin-table-body">
        </tbody>
    </table>
</div>
<script>
    $('#create-admin-form').on('submit',function (e){
        e.preventDefault()

        let data={
            username:$("#admin-username").val(),
            fullname: $("#admin-fullname").val(),
            email: $("#admin-email").val(),
        }

        $.ajax({
            url:"http://localhost:8080/register",
            method:'POST',
            contentType: "application/json",
            data: JSON.stringify(data),
            success: function (res){
                $('#createAdminModal').modal('hide');
                window.location.href = "/verify-otp-page?email=" + data.email;
            },
            error: function (error){
                console.log("error");
            }
        })

    })


    function fetchAdmins(){
        $.ajax({
            url:"http://localhost:8080/dashboard/admins",
            method:'GET',
            success: function (admins){
                let tableContent="";

                admins.forEach(admin=>{

                    tableContent+= "<tr> " +
                        "<td>"+admin.fullname+"</td> "+
                        "<td>"+admin.username+"</a></td> " +
                        "<td>"+admin.email+"</td>" + "<td><button onclick='removeAdmin("+admin.id+")' class='btn btn-danger px-1 py-0 small'>REMOVE</button></td>"
                    "</tr>"
                })

                $("#admin-table-body").html(tableContent);


                if ($.fn.DataTable.isDataTable("#example")){
                    $("#example").DataTable().destroy();
                }

                $("#example").DataTable({
                    "order":[[2,'desc']],
                    "pageLength":10,
                    "language":{
                        "emptyTable":"No document submissions found"
                    }
                })
            },
            error: function (error){
                console.log(error);
            }
        })
    }

    function removeAdmin(adminid){
        console.log(adminid)
        $.ajax({
            url:"http://localhost:8080/remove-admin",
            method:"POST",
            contentType: "text/plain",
            data: adminid.toString(),
            success: function (res){
                fetchAdmins();
            },
            error: function (error){
                console.log(error)
            }
        })
    }

    $(document).ready(function () {
        fetchAdmins();
    })
</script>
</body>
</html>