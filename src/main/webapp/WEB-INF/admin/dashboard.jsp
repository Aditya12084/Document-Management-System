
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="Mark Otto, Jacob Thornton, and Bootstrap contributors">
    <meta name="generator" content="Hugo 0.84.0">
    <title>Sidebars · Bootstrap v5.0</title>

    <link rel="canonical" href="https://getbootstrap.com/docs/5.0/examples/sidebars/">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
      rel="stylesheet"
      integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB"
      crossorigin="anonymous"
    />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- Bootstrap core CSS -->
<link href="/docs/5.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

    <!-- Favicons -->
<link rel="apple-touch-icon" href="/docs/5.0/assets/img/favicons/apple-touch-icon.png" sizes="180x180">
<link rel="icon" href="/docs/5.0/assets/img/favicons/favicon-32x32.png" sizes="32x32" type="image/png">
<link rel="icon" href="/docs/5.0/assets/img/favicons/favicon-16x16.png" sizes="16x16" type="image/png">
<link rel="manifest" href="/docs/5.0/assets/img/favicons/manifest.json">
<link rel="mask-icon" href="/docs/5.0/assets/img/favicons/safari-pinned-tab.svg" color="#7952b3">
<link rel="icon" href="/docs/5.0/assets/img/favicons/favicon.ico">
<meta name="theme-color" content="#7952b3">

    <style>
      body {
        min-height: 100vh;
        min-height: -webkit-fill-available;
      }

      html {
        height: -webkit-fill-available;
      }

      main {
        display: flex;
        flex-wrap: nowrap;
        height: 100vh;
        height: -webkit-fill-available;
        max-height: 100vh;
        overflow-x: auto;
        overflow-y: hidden;
      }

      .b-example-divider {
        flex-shrink: 0;
        width: 1rem;
        height: 100vh;
        /*background-color: rgba(0, 0, 0, .1);*/
        /*border: solid rgba(0, 0, 0, .15);*/
        /*box-shadow: inset 0 .5em 1.5em rgba(0, 0, 0, .1), inset 0 .125em .5em rgba(0, 0, 0, .15);*/
      }

      .nav-flush .nav-link {
        border-radius: 0;
      }
    </style>

    
    <!-- Custom styles for this template -->
    <link href="sidebars.css" rel="stylesheet">
  </head>
  <body style="background-color: rgba(0, 0, 0, .1);">

  <%@ include file="../common/sidebar.jsp" %>
  <div class="b-example-divider mt-3 flex-grow-1 border border-danger">

      <h2 class="ms-2">Dashboard</h2>


    <div class="container-fluid mt-3">
      <div class="row g-3">

        <div class="col-md-4">
          <div class="card shadow-sm border-0 rounded-3 h-100">
            <div class="card-body d-flex align-items-center justify-content-between">
              <i class="bi bi-person fs-1 text-primary"></i>
              <div class="text-end">
                <h6 class="text-muted mb-1 text-nowrap" style="font-size: 10px;">TOTAL USERS</h6>
                <h3 class="fw-bold mb-0">120</h3>
              </div>
            </div>
          </div>
        </div>

        <div class="col-md-4">
          <div class="card shadow-sm border-0 rounded-3 h-100">
            <div class="card-body d-flex align-items-center justify-content-between">
              <i class="bi bi-shield-lock fs-1 text-dark"></i>
              <div class="text-end">
                <h6 class="text-muted mb-1 text-nowrap" style="font-size: 10px;">TOTAL ADMINS</h6>
                <h3 class="fw-bold mb-0">10</h3>
              </div>
            </div>
          </div>
        </div>

        <div class="col-md-4">
          <div class="card shadow-sm border-0 rounded-3 h-100">
            <div class="card-body d-flex align-items-center justify-content-between">
              <i class="bi bi-file-earmark fs-1 text-info"></i>
              <div class="text-end">
                <h6 class="text-muted mb-1 text-nowrap" style="font-size: 10px;">TOTAL DOCUMENTS</h6>
                <h3 class="fw-bold mb-0">190</h3>
              </div>
            </div>
          </div>
        </div>

        <div class="col-md-4">
          <div class="card shadow-sm border-0 rounded-3 h-100">
            <div class="card-body d-flex align-items-center justify-content-between">
              <i class="bi bi-patch-exclamation fs-1 text-warning"></i>
              <div class="text-end">
                <h6 class="text-muted mb-1 text-nowrap" style="font-size: 10px;">PENDING</h6>
                <h3 class="fw-bold mb-0">190</h3>
              </div>
            </div>
          </div>
        </div>

        <div class="col-md-4">
          <div class="card shadow-sm border-0 rounded-3 h-100">
            <div class="card-body d-flex align-items-center justify-content-between">
              <i class="bi bi-patch-check-fill fs-1 text-success"></i>
              <div class="text-end">
                <h6 class="text-muted mb-1 text-nowrap" style="font-size: 10px;">APPROVED</h6>
                <h3 class="fw-bold mb-0">190</h3>
              </div>
            </div>
          </div>
        </div>

        <div class="col-md-4">
          <div class="card shadow-sm border-0 rounded-3 h-100">
            <div class="card-body d-flex align-items-center justify-content-between">
              <i class="bi bi-patch-minus-fill fs-1 text-danger"></i>
              <div class="text-end">
                <h6 class="text-muted mb-1 text-nowrap" style="font-size: 10px;">REJECTED</h6>
                <h3 class="fw-bold mb-0">190</h3>
              </div>
            </div>
          </div>
        </div>

      </div> </div>
  <div>
    pending docs list
  </div>
</div>

    <script src="/docs/5.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>

      <script src="sidebars.js"></script>

  <script>
    let username=localStorage.getItem("username");

    if (username){
      document.getElementById("username").innerText=username;
    }

    // $(document).ready(function() {
    //   $('.nav-link').click(function(e) {
    //     e.preventDefault();
    //
    //     // 1. Get the target ID from the clicked link
    //     var targetId = $(this).data('target');
    //
    //     // 2. Only run if a target is actually defined
    //     if (targetId) {
    //       // 3. Hide all content sections
    //       $('.content-view').hide();
    //
    //       // 4. Show the one we want
    //       $('#' + targetId).show();
    //
    //       // 5. Update Sidebar UI (The blue 'active' background)
    //       $('.nav-link').removeClass('active').addClass('link-dark');
    //       $(this).addClass('active').removeClass('link-dark');
    //     }
    //   });
    // });
  </script>

  </body>
</html>








