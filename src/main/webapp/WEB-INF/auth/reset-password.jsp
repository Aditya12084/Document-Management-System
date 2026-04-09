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

</head>
<body class="background-color: rgba(0, 0, 0, 0.1);">
<div >
    <div class="mx-auto bg-light px-3 py-1 mt-5 rounded shadow bg-white" style="width: 350px;">
        <div class="d-flex flex-column justify-content-center align-items-center mb-2">
            <img style="height: 200px;width: 250px" src="https://res.cloudinary.com/dy5qenphg/image/upload/v1775759662/378122291_41bdfb4f-320e-4d85-89ea-64c04adc920f-removebg-preview_h5bc9z.png">
            <h4 class="text-center">Reset Password</h4>
        </div>
        <div>
            <form id="reset-password-form">
            <div>
                <input class="form-control mb-3" id="new-pwd" type="password" placeholder="Enter new password"/>
            </div>
            <div>
                <input class="form-control mb-3" id="retype-new-pwd" type="password" placeholder="Re-type new password"/>
            </div>
            <div>
                <button type="submit" class="form-control btn btn-primary mb-3">Submit</button>
            </div>
            </form>
        </div>
    </div>
</div>

<script>
  $("#reset-password-form").submit(function (e){
      e.preventDefault()
      data={
          newPassword:$("#new-pwd").val()
      }

      $.ajax({
          url:"http://localhost:8080/reset-pwd",
          method:"POST",
          contentType:"application/json",
          data:JSON.stringify(data),
          success: function (res){
              window.location.href="/"
          },
          error: function (err){
                console.log(err)
          }
      })
  })
</script>

</body>
</html>