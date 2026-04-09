<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>
    <link rel="canonical" href="https://getbootstrap.com/docs/5.0/examples/sidebars/">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
            rel="stylesheet"
            integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB"
            crossorigin="anonymous"
    />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.3/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/2.3.7/css/dataTables.bootstrap5.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/2.3.7/js/dataTables.js"></script>
    <script src="https://cdn.datatables.net/2.3.7/js/dataTables.bootstrap5.js"></script>


    <style>
        #example_wrapper{
            /*border: 2px solid black;*/
            /*width: auto;*/
            background-color: white;
            padding: 5px;
            border-radius: 5px;
        }

    </style>

</head>
<body style="background-color: rgba(0, 0, 0, .1);">
<%@ include file="sidebar.jsp"%>

<div class="m-3 d-flex flex-column flex-grow-1 ">
    <h2 class="mb-3">My Profile</h2>

    <div class="d-flex align-items-center">
        <div class=" mx-auto p-3 rounded" style="min-width: 370px; background-color: white">
        <form id="create-admin-form bg-white" method="POST">
            <div class="d-flex mb-3">
                <img class="mx-auto" style="height: 100px; width: 100px;" src="https://res.cloudinary.com/dy5qenphg/image/upload/v1775675218/5951752_hynfyk.png">
            </div>
            <div class="">
                <div class="mb-3 d-flex align-items-center">
                    <h6 class="text-block mb-0">Username:</h6>
                    <p class="mb-0 ms-1">Aditya26</p>
                </div><div class="mb-3 d-flex align-items-center">
                    <h6 class="text-block mb-0">Full Name:</h6>
                    <p class="mb-0 ms-1">Aditya Patayane</p>
                </div><div class="mb-3 d-flex align-items-center">
                    <h6 class="text-block mb-0">Email:</h6>
                    <p class="mb-0 ms-1">adityapatayane1@gmail.com</p>
                </div>
                <div class="d-flex justify-content-center" >
                    <button type="button"  id="update-pwd-btn" style="display: block" onclick="showUpdatePwdDiv()" class="btn btn-primary">Update Password</button>
                </div>
            </div>
            <div id="update-pwd-div" style="display: none">
                <form>
                <div class="mb-3">
                    <input name="" id="current-pwd" type="password" class="form-control" placeholder="Enter current password" required>
                </div>
                <div class="mb-3">
                    <input name="admin-email" type="password" id="new-pwd" class="form-control" placeholder="Enter new password" required>
                </div><div class="mb-3">
                <input name="admin-email" type="password" id="retype-new-pwd" class="form-control" placeholder="Re-type new password" required>
                </div>
                <div class="d-flex flex-wrap justify-content-center gap-1 ">
                    <button type="submit" class="col-5 btn btn-success" id="updatePwdbtn">Update</button>
                    <button type="button" onclick="showUpdatePwdDiv()" class="col-5 btn btn-danger w-80">Cancel</button>
                </div>
                </form>
            </div>

        </form>
        </div>
    </div>

</div>

<script>

    function showUpdatePwdDiv(){
        let updatePwdDiv=document.getElementById("update-pwd-div");
        let updatePwdBtn=document.getElementById("update-pwd-btn");


        if(updatePwdDiv.style.display=="block"){
            updatePwdDiv.style.display="none";
            updatePwdBtn.style.display="block";
        }
        else{
            updatePwdDiv.style.display="block";
            updatePwdBtn.style.display="none";
        }
    }

    $("#updatePwdbtn").on("click",function (e){

        e.preventDefault()
        let currentPwd=$("#current-pwd").val()
        let newPwd=$("#new-pwd").val()
        let retypeNewPwd=$("#retype-new-pwd").val()


        $.ajax({
            url:"http://localhost:8080/verify-current-pwd",
            method:"POST",
            contentType:"application/json",
            data:JSON.stringify({
                currentPwd:currentPwd,
                newPwd:newPwd
            }),
            success: function (res){
                window.location.href="/verify-otp-pass-up?mode=pwdUpdate"
            },
            error: function (err){
                console.log("error")
            }

        })
    })
</script>

</body>
</html>

