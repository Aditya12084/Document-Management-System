<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="">
  <meta name="author" content="Mark Otto, Jacob Thornton, and Bootstrap contributors">
  <meta name="generator" content="Hugo 0.84.0">
  <title>Dashboard · DMS</title>
  <link rel="canonical" href="https://getbootstrap.com/docs/5.0/examples/sidebars/">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
          rel="stylesheet"
          integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB"
          crossorigin="anonymous"
  />
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <link href="/docs/5.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
  <link rel="apple-touch-icon" href="/docs/5.0/assets/img/favicons/apple-touch-icon.png" sizes="180x180">
  <link rel="icon" href="/docs/5.0/assets/img/favicons/favicon-32x32.png" sizes="32x32" type="image/png">
  <link rel="icon" href="/docs/5.0/assets/img/favicons/favicon-16x16.png" sizes="16x16" type="image/png">
  <link rel="manifest" href="/docs/5.0/assets/img/favicons/manifest.json">
  <link rel="mask-icon" href="/docs/5.0/assets/img/favicons/safari-pinned-tab.svg" color="#7952b3">
  <link rel="icon" href="/docs/5.0/assets/img/favicons/favicon.ico">
  <meta name="theme-color" content="#7952b3">
  <style>
    body {
      min-height: -webkit-fill-available;
      overflow-x: hidden;
      overflow-y: auto;
    }
    html {
      height: -webkit-fill-available;
    }
    main {
      display: flex;
      flex-wrap: nowrap;
      height: -webkit-fill-available;
      overflow-x: hidden;
      overflow-y: hidden;
    }
    .b-example-divider {
      flex-shrink: 0;
    }
    .nav-flush .nav-link {
      border-radius: 0;
    }
    .donut-multi-segment {
      width: 200px;
      height: 200px;
      border-radius: 50%;
      background: conic-gradient(
              #0d6efd 0% var(--stop1, 40%),
              #198754 var(--stop1, 40%) var(--stop2, 70%),
              #ffc107 var(--stop2, 70%) 100%
      );
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .donut-hole {
      width: 150px;
      height: 150px;
      background-color: white;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: bold;
    }
    .sidebar{
      width: 280px;
      height: 100vh;
      position: fixed;
      top: 0;
      left: 0;
      z-index: 100;
      border-right: 1px solid #dee2e6;
    }
  </style>
  <link href="sidebars.css" rel="stylesheet">
</head>
<body style="background-color: rgba(0, 0, 0, .1);">
<%@ include file="../common/sidebar.jsp" %>

<%@ include file="../common/confirm-status-modal.jsp"%>

<div class="modal fade" id="uploadModal" tabindex="-1" aria-labelledby="uploadModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow-lg">
      <div class="modal-header bg-primary text-white">
        <h5 class="modal-title" id="uploadModalLabel">
          <i class="bi bi-cloud-arrow-up me-2"></i>Submit Document
        </h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form id="uploadForm" action="#" method="POST" enctype="multipart/form-data">
        <div class="modal-body">

          <c:if test="${sessionScope.user.role=='ADMIN'}">
            <div class="mb-3 p-3 rounded" style="background-color: #f0f7ff; border: 1px dashed #0d6efd;">
              <label class="form-label fw-bold text-primary">Target Customer ID</label>
              <input type="text" name="targetUserId" class="form-control" placeholder="Enter Account/User ID" required>
              <div class="form-text">As Admin, specify which user owns this file.</div>
            </div>
          </c:if>

          <div class="mb-3">
            <label class="form-label fw-bold">Document Category</label>
            <select class="form-select" name="docCategory" required>
              <option value="" selected disabled>Choose category...</option>
              <option value="IDENTITY">KYC / Identity</option>
              <option value="LOAN_DOC">Loan Agreement</option>
              <option value="STATEMENTS">Bank Statements</option>
              <option value="SANCTION">Sanction Letter</option>
            </select>
          </div>

          <div class="mb-3">
            <label class="form-label fw-bold">Select File</label>
            <input type="file" name="file" class="form-control" accept=".pdf,.jpg,.png" required>
            <div class="form-text">Accepted: PDF, JPG, PNG (Max 5MB)</div>
          </div>
        </div>
        <div class="modal-footer bg-light">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" id="upload-doc-btn" class="btn btn-primary px-4">
            <i class="bi bi-check-circle me-1"></i>Upload Now
          </button>
        </div>
      </form>
    </div>
  </div>
</div>

<div class="b-example-divider mt-3" style="margin-left:250px; width: calc(100% - 260px);">
  <div class="d-flex">
    <h2 class="flex-grow-1">Dashboard</h2>

    <button class="btn btn-primary d-flex align-items-center" data-bs-toggle="modal" data-bs-target="#uploadModal">  <i class="bi bi-cloud-arrow-up me-2 fs-4"></i>Upload document</button>
  </div>

  <div class="mt-3">
    <div class="row g-3">
      <div class="col-md-3">
        <div class="card shadow-sm border-0 rounded-3 h-100">
          <div class="card-body d-flex align-items-center justify-content-between">
            <i class="bi bi-person fs-1 text-primary"></i>
            <div class="text-end">
              <h6 class="text-muted mb-1 text-nowrap" style="font-size: 10px;">TOTAL USERS</h6>
              <h3 class="fw-bold mb-0" id="total-users">120</h3>
            </div>
          </div>
        </div>
      </div>
      <div class="col-md-3">
        <div class="card shadow-sm border-0 rounded-3 h-100">
          <div class="card-body d-flex align-items-center justify-content-between">
<%--            <i class="bi bi-shield-lock "></i>--%>
            <i class="bi bi-person-fill-gear fs-1 text-dark"></i>
            <div class="text-end">
              <h6 class="text-muted mb-1 text-nowrap" style="font-size: 10px;">TOTAL ADMINS</h6>
              <h3 class="fw-bold mb-0" id="total-admins">10</h3>
            </div>
          </div>
        </div>
      </div>
      <div class="col-md-3">
        <div class="card shadow-sm border-0 rounded-3 h-100">
          <div class="card-body d-flex align-items-center justify-content-between">
            <i class="bi bi-file-earmark fs-1 text-info"></i>
            <div class="text-end">
              <h6 class="text-muted mb-1 text-nowrap" style="font-size: 10px;">TOTAL DOCUMENTS</h6>
              <h3 class="fw-bold mb-0" id="total-docs">190</h3>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="mt-3 d-flex bg-white px-3 py-4 rounded shadow">
      <div class="d-flex flex-column flex-grow-1 border-end px-2">
        <h4 class="fs-6 fw-bold">PENDING DOCUMENTS</h4>
        <table class="table">
          <thead>
          <tr>
            <th scope="col" class="small">Filename</th>
            <th scope="col" class="small">Owner</th>
            <th scope="col" class="small">Date</th>
            <th scope="col" class="small">Action</th>
          </tr>
          </thead>
          <tbody id="pending-docs-body">
          <tr>
            <td colspan="4" class="text-center">Loading documents...</td>
          </tr>
          </tbody>
        </table>
      </div>
      <div class="bg-light bg-white" style="width: 250px;">
        <h4 class="text-center mb-4 fs-6 fw-bold">DOCUMENT SUMMARY</h4>
        <div class="card-body text-center">
          <div id="myDonut" class="donut-multi-segment mx-auto">
            <div class="donut-hole">
              <ul class="list-unstyled mt-3 text-start small">
                <li class="small"><span class="badge bg-primary me-2">&nbsp;</span> Pending <span id="perc-pending">0</span>%</li>
                <li class="small"><span class="badge bg-success me-2">&nbsp;</span> Rejected <span id="perc-rejected">0</span>%</li>
                <li class="small"><span class="badge bg-warning me-2">&nbsp;</span> Approved <span id="perc-approved">0</span>%</li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="bg-white d-flex mt-3 rounded p-4">

      <div class="col-md-6 p-2">
        <h4 class="fs-6 fw-bold">RECENT DOCUMENTS</h4>
        <div id="recent-doc-body">
          <div colspan="4" class="text-center">Loading documents...</div>
        </div>
      </div>
      <div class="col-md-6 px-4 border-start p-2">
        <h4 class="fs-6 fw-bold">RECENT ACTIVITIES</h4>
        <div id="recent-act-body">
          <td colspan="4" class="text-center">Loading documents...</td>
        </div>
      </div>

    </div>

  </div>

</div> <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>

<script>


  $(document).ready(function() {
    fetchStats();
    loadPendingDocuments();
    loadRecentDocuments();
    getRecentActivity();
  });

  function fetchStats() {
    $.ajax({
      url: 'http://localhost:8080/dashboard/stats',
      method: 'GET',
      success: function(data) {
        $('#total-users').text(data.users);
        $('#total-admins').text(data.admins);
        $('#total-docs').text(data.docs);
        updateChart(data.pending, data.rejected, data.approved);
      },
      error: function(error) {
        console.error("Error fetching stats: ", error);
      }
    });
  }

  function updateChart(val1, val2, val3) {
    const chart = document.getElementById('myDonut');
    if (!chart) return;

    const v1 = Number(val1);
    const v2 = Number(val2);
    const v3 = Number(val3);

    const s1 = v1;
    const s2 = v1 + v2;

    chart.style.setProperty('--stop1', s1 + '%');
    chart.style.setProperty('--stop2', s2 + '%');

    document.getElementById('perc-pending').innerText = v1;
    document.getElementById('perc-rejected').innerText = v2;
    document.getElementById('perc-approved').innerText = v3;
  }

  function loadPendingDocuments() {
    $.ajax({
      url: "http://localhost:8080/dashboard/pending-docs",
      method: 'GET',
      success: function(docs) {
        let tableContent = "";
        if (docs.length == 0) {
          tableContent = '<tr><td colspan="4" class="text-center">No pending documents found.</td></tr>';
        } else {
          docs.slice(0, 5).forEach(doc => {
            let formattedDate = new Date(doc.uploadDate).toLocaleDateString('en-GB', {
              day: '2-digit',
              month: 'short',
              year: 'numeric'
            });
            // Nuclear option as requested
            tableContent +=
                    "<tr class='align-middle'>" +
                    "<td class='text-black small fw-semibold'>" +
                    "<a href='/document/" + doc.id + "' target='_blank' class='text-decoration-none text-primary'>" +
                    "<i class='bi bi-file-earmark-text me-1'></i>" + doc.filename +
                    "</a>" +
                    "</td>" +
                    "<td class='text-black small'><span class='badge bg-light text-dark border'>" + doc.filetype + "</span></td>" +
                    "<td class='text-black small'>" + formattedDate + "</td>" +
                    "<td>" +
                    "<div class='btn-group' role='group'>" +
                    "<button onclick='updateStatus(" + doc.id + ", \"APPROVED\")' class='btn btn-sm btn-outline-success' title='Approve'>" +
                    "<i class='bi bi-check-lg'></i>" +
                    "</button>" +
                    "<button onclick='updateStatus(" + doc.id + ", \"REJECTED\")' class='btn btn-sm btn-outline-danger' title='Reject'>" +
                    "<i class='bi bi-x-lg'></i>" +
                    "</button>" +
                    "</div>" +
                    "</td>" +
                    "</tr>";
          });
        }
        $("#pending-docs-body").html(tableContent);
      },
      error: function(error) {
        console.log(error);

      }
    });
  }

  function loadRecentDocuments() {
    $.ajax({
      url:"http://localhost:8080/dashboard/recent-docs",
      method:'GET',
      success: function (docs){
        console.log(docs)
        let tableContent = "";

        if (docs.length == 0) {
          tableContent = '<tr><td colspan="4" class="text-center">No pending documents found.</td></tr>';
        }
        else{
          docs.forEach(doc=> {
            let sizeLabel = formatBytes(doc.fileSize);
            let timelabel= getRelativeTime(doc.uploadDate)

            tableContent +=
                    "<div class='d-flex flex-row border-bottom py-1'>"+
                      "<div class='d-flex flex-column flex-grow-1'>" +
                        "<p class='flex-grow-1 mb-0 fw-semibold small'>"+ doc.filename +"</p>" +
                        "<span class='small'>"+ sizeLabel  +"</span>" +
                      "</div>" +
                      "<span class='small'>"+ timelabel  +"</span>"+
                    "</div>";
          })
        }

        $("#recent-doc-body").html(tableContent);

      },
      error: function (err){
        console.log("error")
      }
    })
  }

  // function formatBytes(bytes, decimals = 2) {
  //   if (bytes === 0) return '0 Bytes';
  //
  //   const k = 1024;
  //   const dm = decimals < 0 ? 0 : decimals;
  //   const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
  //
  //   const i = Math.floor(Math.log(bytes) / Math.log(k));
  //
  //   return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i];
  // }

  // function getRelativeTime(dateString) {
  //   const date = new Date(dateString);
  //   const now = new Date();
  //   const diffInSeconds = Math.floor((now - date) / 1000);
  //   const diffInDays = Math.floor(diffInSeconds / 86400);
  //
  //   if (diffInDays === 0) return "Today";
  //   if (diffInDays === 1) return "Yesterday";
  //   if (diffInDays < 7) return diffInDays + " days ago";
  //
  //   return date.toLocaleDateString('en-GB', { day: '2-digit', month: 'short' });
  // }


  $("#confirmBtn").on("click",function (){
    const btn=$(this)
    btn.prop('disabled',true).html('<span class="spinner-border spinner-border-sm"></span> Processing...');

    if (currentStatus=="REJECTED"){
      data={
        rejectionRemark:$("#admin-remark-input").val()
      }
    }

    $.ajax({
      url:"http://localhost:8080/document/"+currentDocId+"/status?status="+currentStatus,
      method:'POST',
      contentType:"application/json",
      data:JSON.stringify(data),
      success: function (res){
        bootstrap.Modal.getInstance(document.getElementById('confirmModal')).hide();
        btn.prop('disabled',false).text('Confirm');

        loadPendingDocuments();
        loadRecentDocuments();
        getRecentActivity();
        fetchStats();

      },
      error: function (error){
        alert("Error updating status.");
        btn.prop('disabled',false).text('Confirm');
      }

    })
  })

  function getRecentActivity() {
    $.ajax({

      url:"http://localhost:8080/dashboard/recent-activity",
      method: "GET",
      success: function (docs) {
        console.log("Data received:", docs);
        var tableContent = "";

        if (docs.length === 0) {
          tableContent = '<div class="text-center p-3">No recent activities found.</div>';
        } else {

          docs.forEach(function(doc) {

            var timeLabel = getRelativeTime(doc.time);

            var icon = "";
            var statusClass = "";

            if (doc.status === "APPROVED") {
              icon = "<i class='bi bi-check-circle fs-4 text-success'></i>";
              statusClass = "text-success";
            } else if(doc.status=="REJECTED") {
              icon = "<i class='bi bi-x-circle fs-4 text-danger'></i>";
              statusClass = "text-danger";
            }
            else{
              icon = "<div class='d-inline-flex align-items-center justify-content-center border border-warning border-2 rounded-circle' style='width: 26px; height: 26px;'> " +
                      "<i class='bi bi-hourglass-split text-warning'></i>"+
            "</div>";
              statusClass = "text-warning";
            }


            tableContent += "<div class='d-flex small align-items-center border-bottom mb-1 pb-2'>" +
                    icon +
                    "<div class='ms-2'>" +
                    "<p class='mb-0 fw-bold'>" + doc.filename + "</p>" +
                    "<p class='mb-0 " + statusClass + "' style='font-size: 0.75rem;'>" +
                    "<span>" + doc.status + "</span> | " +
                    "<span>" + timeLabel + "</span> - " +
                    "<span>" + doc.adminName + "</span>" +
                    "</p>" +
                    "</div>" +
                    "</div>";
          });
        }
        $("#recent-act-body").html(tableContent);
      },
      error: function (error) {
        console.log("Error details:", error);
      }
    });
  }

 $("#upload-doc-btn").on('click',function (e) {
   e.preventDefault();
   var form = $("#uploadForm")[0];
   var formData = new FormData(form);
   $.ajax({
     url: "http://localhost:8080/document/upload",
     method: 'POST',
     data: formData,
     processData: false, // Required for FormData
     contentType: false,
     success: function (res) {
       alert("File uploaded successfully!");
       $('#uploadModal').modal('hide'); // Close modal on success
       location.reload(); // Refresh to show new data in your table
     },
     error: function (res) {
       alert("Error: " + xhr.responseText);
     }
   })
 })




</script>
</body>
</html>