<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Bootstrap 5 OTP Input</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    /* Removes arrows from number inputs */
    input::-webkit-outer-spin-button,
    input::-webkit-inner-spin-button {
      -webkit-appearance: none;
      margin: 0;
    }
    /* Simple styling for the OTP boxes */
    .otp-input {
      width: 50px;
      height: 60px;
      font-size: 24px;
      font-weight: bold;
    }
  </style>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body class="bg-light">

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

<div class="container p-5 mt-5">
  <div class="row justify-content-center">
    <div class="col-md-5">
      <div class="card border-0 shadow-sm p-4 text-center">
        <h3 class="mb-2">Verify Account</h3>
        <p class="text-muted mb-4">Your code was sent to you via email</p>

        <div id="otp-inputs" class="d-flex justify-content-between mb-4">
          <input type="number" class="form-control otp-input text-center mx-1" maxlength="1">
          <input type="number" class="form-control otp-input text-center mx-1" maxlength="1" disabled>
          <input type="number" class="form-control otp-input text-center mx-1" maxlength="1" disabled>
          <input type="number" class="form-control otp-input text-center mx-1" maxlength="1" disabled>
          <input type="number" class="form-control otp-input text-center mx-1" maxlength="1" disabled>
          <input type="number" class="form-control otp-input text-center mx-1" maxlength="1" disabled>
        </div>

        <button class="btn btn-primary w-100 py-2 mb-3" id="verify-btn">
          Verify Code
        </button>
      </div>
    </div>
  </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<script>

  $(document).ready(function() {
    const $inputs = $('#otp-inputs input');

    // 1. Handle Typing and Auto-focus
    $inputs.on('input', function() {
      const $this = $(this);
      let val = $this.val();

      // Ensure only 1 digit
      if (val.length > 1) {
        $this.val(val.slice(0, 1));
        val = $this.val();
      }

      // Move to next box
      if (val !== "" && $this.next().length) {
        $this.next().prop('disabled', false).focus();
      }
    });

    // 2. Handle Backspace (Keydown is better for capturing Backspace)
    $inputs.on('keydown', function(e) {
      const $this = $(this);
      if (e.key === 'Backspace') {
        if ($this.val() === "" && $this.prev().length) {
          $this.prop('disabled', true);
          $this.prev().focus();
        }
      }
    });

    // 3. Handle Paste (Crucial for UX)
    $inputs.first().on('paste', function(e) {
      const pasteData = e.originalEvent.clipboardData.getData('text').trim();
      if (pasteData.length === $inputs.length && /^\d+$/.test(pasteData)) {
        $inputs.each(function(i) {
          $(this).prop('disabled', false).val(pasteData[i]);
        });
        $inputs.last().focus();
      }
      e.preventDefault();
    });

    // 4. Verification Logic
    $('#verify-btn').on('click', function() {
      const otpValue = $inputs.map(function() {
        return $(this).val();
      }).get().join('');

      const urlParams=new URLSearchParams(window.location.search);
      const emailvalue=urlParams.get('email');

      if (otpValue.length < 6) {
        toasthandler("Please enter all 6 digits.")
        return;
      }
        $.ajax({
          url: "http://localhost:8080/verify-otp",
          type: "POST",
          contentType: "application/json",
          data: JSON.stringify({
            email:emailvalue,
            otp:otpValue
          }),
          success: function (res) {
            toasthandler(`OTP Verified Successfully!`,"success");
            setTimeout(function(){
              window.location.href = "/";
            },3000)
          },
          error: function (res) {
            console.log(res);
            toasthandler(res.responseText,"error");
          },
        });

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
</script>

</body>
</html>