<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>forget password</title>

    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
            rel="stylesheet"
            integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB"
            crossorigin="anonymous"
    />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

</head>
<body class="background-color: rgba(0, 0, 0, 0.1);">

<div class="toast-container position-fixed top-0 end-0 p-3">
    <div id="myToast" class="toast align-items-center text-white bg-primary border-0" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body" id="toast-body">
                Hello, world! This is a toast message.
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    </div>

</div>
<div >
    <div class="mx-auto bg-light px-3 py-1 mt-5 rounded shadow bg-white" style="width: 350px;">
        <div class="d-flex flex-column justify-content-center align-items-center mb-2">
            <img style="height: 200px;width: 250px" src="https://res.cloudinary.com/dy5qenphg/image/upload/v1775759662/378122291_41bdfb4f-320e-4d85-89ea-64c04adc920f-removebg-preview_h5bc9z.png">
            <h4 class="text-center">Reset Password</h4>
        </div>
        <div>
            <form id="reset-password-form">
<%--            <div>--%>
<%--                <input class="form-control mb-3" id="new-pwd" type="password" placeholder="Enter new password"/>--%>
<%--            </div>--%>
                <div class="input-group mb-3">
                    <input
                            type="password"
                            id="new-pwd"
                            class="form-control"
                            placeholder="Enter new password"
                            required
                    />
                    <button class="btn btn-outline-secondary" type="button" id="togglePasswordNew">
                        <i class="fa fa-eye-slash" id="eyeIconPasswordNew"></i>
                    </button>
                </div>
<%--            <div>--%>
<%--                <input class="form-control mb-3" id="retype-new-pwd" type="password" placeholder="Re-type new password"/>--%>
<%--            </div>--%>
    <div class="input-group mb-3">
        <input
                type="password"
                id="retype-new-pwd"
                class="form-control"
                placeholder="Re-type new password"
                required
        />
        <button class="btn btn-outline-secondary" type="button" id="togglePasswordRetypePass">
            <i class="fa fa-eye-slash" id="eyeIconRetypePass"></i>
        </button>
    </div>
            <div>
                <button type="submit" class="form-control btn btn-primary mb-3">Submit</button>
            </div>
            </form>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        $("#togglePasswordNew").click(function() {
            const passwordField = $("#new-pwd");
            const eyeIcon = $("#eyeIconPasswordNew");

            const type = passwordField.attr("type") === "password" ? "text" : "password";
            passwordField.attr("type", type);

            eyeIcon.toggleClass("fa-eye fa-eye-slash");
        });
    });

    $(document).ready(function() {
        $("#togglePasswordRetypePass").click(function() {
            const passwordField = $("#retype-new-pwd");
            const eyeIcon = $("#eyeIconRetypePass");

            const type = passwordField.attr("type") === "password" ? "text" : "password";
            passwordField.attr("type", type);

            eyeIcon.toggleClass("fa-eye fa-eye-slash");
        });
    });


    function toasthandler(msg,type){

        const toastElement=document.getElementById("myToast");
        const toastbody=document.getElementById("toast-body");

        toastbody.textContent=msg;

        toastElement.classList.remove('bg-primary', 'bg-success', 'bg-danger');

        if(type=="success"){
            toastElement.classList.add("bg-success");
        }
        else if(type=="error"){
            toastElement.classList.add("bg-danger");
        }
        else{
            toastElement.classList.add("bg-primary");
        }
        const toastInstance=new bootstrap.Toast(toastElement,{
            autohide:true,
            delay:3000
        });
        toastInstance.show();
    }
  $("#reset-password-form").submit(function (e){
      e.preventDefault()
      const newPassword=$("#new-pwd").val()

      if(newPassword!==$("#retype-new-pwd").val()){
          toasthandler("Passwords do not match. Please re-type your password.","error")
          return
      }

      data={
          newPassword:newPassword
      }

      $.ajax({
          url:"http://localhost:8080/reset-pwd",
          method:"POST",
          contentType:"application/json",
          data:JSON.stringify(data),
          success: function (res){
              toasthandler(res+" Please login with your new credentials.","success")
              setTimeout(function (){
                  window.location.href="/"
              },1500)

          },
          error: function (err){
                toasthandler(err.responseText,"error")
          }
      })
  })
</script>

</body>
</html>