<% Object user = session.getAttribute("user"); if(user != null){
response.sendRedirect("/"); out.println(user);} %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta
      name="viewport"
      content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0"
    />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
      rel="stylesheet"
      integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB"
      crossorigin="anonymous"
    />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <title>Welcome - DMS</title>
  </head>
  <body class="bg-light">



  <div class="modal fade" id="forgotPasswordModal" tabindex="-1" aria-labelledby="forgotPasswordModal" aria-hidden="true" ">
    <div class="modal-dialog modal-dialog-centered " style="max-width: 400px;">
      <div class="modal-content border-0 shadow-lg">
        <div class="modal-header bg-primary text-white">
          <h5 class="modal-title" id="forgotPasswordModal">
            Forgot Password
          </h5>
          <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <form id="create-admin-form" method="POST">
          <div class="modal-body">
            <div class="mb-3">
              <input name="email" id="forgot-email" type="email" class="form-control" placeholder="Enter registered email" required>
            </div>
          </div>
          <div class="modal-footer bg-light">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            <button type="button" onclick="forgotPassword()" id="create-admin-btn" class="btn btn-primary px-4">
              <i class="bi bi-check-circle me-1"></i>Continue
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>

    <nav class="navbar navbar-expand-lg navbar-light " style="background-color: #0090ff;">
  <div class="container-fluid mx-5">

    <div class="d-flex ms-2 justify-content-center align-items-center"><img src="https://res.cloudinary.com/dy5qenphg/image/upload/v1775403053/ecc87d3a-0768-4637-9a79-71e716922416_xtx8qd.png" alt="Logo" width="32" height="32" class="me-2">
      <a class="navbar-brand fw-bold" href="#">DMS</a></div>

    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>

  </div>
</nav>

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
    <div class="container mt-5">
      <div class="card p-4 col-md-4 mx-auto shadow">
        <ul class="nav nav-tabs">
          <li class="nav-item" id="authTab">
            <button
              class="nav-link active"
              data-bs-toggle="tab"
              data-bs-target="#login"
            >
              Login
            </button>
          </li>
          <li>
            <button
              class="nav-link"
              data-bs-toggle="tab"
              data-bs-target="#register"
            >
              Register
            </button>
          </li>
        </ul>

        <div class="tab-content mt-3">
          <div class="tab-pane fade show active" id="login">
            <h4 class="text-center">Login</h4>
            <div id="loginMsg" class="text-danger text-center"></div>

            <form id="loginForm">
              <input
                type="text"
                id="loginUsername"
                class="form-control mb-3"
                placeholder="Username"
                required
              />
              <input
                type="password"
                id="loginPassword"
                class="form-control mb-3"
                placeholder="Password"
                required
              />
              <button class="btn  w-100" style="background-color: #0090ff;">Login</button>
              <div class="d-flex mt-2 justify-content-end">
                <a href="javascript:void(0)"
                   class="small italic text-decoration-none"
                   data-bs-toggle="modal"
                   data-bs-target="#forgotPasswordModal">
                  Forgot Password?
                </a>
              </div>
            </form>
          </div>

          <div class="tab-pane fade" id="register">
            <h4 class="text-center">Register</h4>
            <div class="registerMsg text-danger text-center"></div>

            <form id="registerForm">

              <input
                type="text"
                name=""
                id="registerUsername"
                class="form-control mb-3"
                placeholder="Username"
                required
              />
              <input
                      type="text"
                      name=""
                      id="registerFullname"
                      class="form-control mb-3"
                      placeholder="Full name"
                      required
              />
              <input 
              type="email"
              id="registerEmail"
              class="form-control mb-3"
              placeholder="Email"
              required
              >
              <input
                type="password"
                id="registerPassword"
                class="form-control mb-3"
                placeholder="Password"
                required
              />
              <button class="btn btn-success w-100">Register</button>
            </form>
          </div>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script
      src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"
      integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI"
      crossorigin="anonymous"
    ></script>

    <script>
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


      $("#loginForm").submit(function (e) {
        e.preventDefault();

        let data = {
          username: $("#loginUsername").val(),
          password: $("#loginPassword").val(),
        };

        $.ajax({
          url: "http://localhost:8080/login",
          type: "POST",
          contentType: "application/json",
          data: JSON.stringify(data),

          success: function (res) {
            localStorage.setItem("username", res.username);
            localStorage.setItem("role", res.role);

            toasthandler("Login successful! Redirecting...","success");

            setTimeout(function(){
              window.location.href = "dashboard";
            },2000)
            
          },

          error: function (res) {
            toasthandler("Invalid credentials","errror");
          },
        });
      });

      $("#registerForm").submit(function (e) {
        e.preventDefault();

        let data = {
          username: $("#registerUsername").val(),
          fullname:$("#registerFullname").val(),
          email:$("#registerEmail").val(),
          password: $("#registerPassword").val(),
        };

        $.ajax({
          url: "http://localhost:8080/register",
          type: "POST",
          contentType: "application/json",
          data: JSON.stringify(data),
          success: function (res) {
            toasthandler(`Redirecting for otp verification.`,"success");
            setTimeout(function(){
              window.location.href = "/verify-otp-page?email=" + data.email;
            },3000)
          },
          error: function (res) {
            console.log(res);
            toasthandler(res.responseText,"error");
          },
        });
      });


      function forgotPassword(){
        let forgotEmail=$("#forgot-email").val()

        $.ajax({
          url:"http://localhost:8080/forget-pwd",
          method:"POST",
          contentType:"application/json",
          data:JSON.stringify({
             email:forgotEmail
          }),
          success: function (res){
            window.location.href="http://localhost:8080/verify-otp-frg-pwd?email="+forgotEmail+"&mode=forgetPwd"
          },
          error:function (err){
            console.log("error")
          }

        })

      }

     
    </script>
  </body>
</html>
