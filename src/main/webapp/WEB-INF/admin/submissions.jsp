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
  <%@ include file="../common/sidebar.jsp"%>
  <%@ include file="../common/confirm-status-modal.jsp"%>

  <div class="m-3 d-flex flex-column flex-grow-1">
   <h2 class="mb-3">User Submissions</h2>
  <table id="example" class="table table-striped small">
      <thead>
      <tr>
          <th>Owner</th>
          <th>Document Name</th>
          <th>Upload Date</th>
          <th>Status</th>
          <th>Actions</th>
      </tr>
      </thead>
      <tbody id="sub-table-body">

      </tbody>
<%--      <tfoot>--%>
<%--      <tr>--%>
<%--          <th>Name</th>--%>
<%--          <th>Position</th>--%>
<%--          <th>Office</th>--%>
<%--          <th>Age</th>--%>
<%--          <th>Start date</th>--%>
<%--          <th>Salary</th>--%>
<%--      </tr>--%>
<%--      </tfoot>--%>
  </table>
  </div>

  <script>
      $(document).ready(function() {
          fetchSubmissions();
      });


      function fetchSubmissions(){

          $.ajax({
              url:"http://localhost:8080/dashboard/submissions",
              method:'GET',
              success: function (submissions){
                  let tableContent="";

                  submissions.forEach(subs=>{
                      let cleanDate=subs.uploadDate.split('T')[0];
                      let statusTag="";
                      let actionTag="";
                      if(subs.status=="APPROVED"){
                          statusTag="<td class='text-success fw-bold'>"+subs.status+"</td>";
                          actionTag="<td><button onclick='updateStatus(" + subs.id + ", \"PENDING\")' class='btn btn-sm btn-outline-warning' title='Pending'>" +
                              "<i class='bi bi-hourglass-split '></i> " +
                              "</button> "  +
                              "<button onclick='updateStatus(" + subs.id + ", \"REJECTED\")' class='btn btn-sm btn-outline-danger' title='Reject'>" +
                              "<i class='bi bi-x-lg'></i>" +
                              "</button></td>"

                      }
                      if(subs.status=="REJECTED"){
                          statusTag="<td class='text-danger fw-bold'>"+subs.status+"</td>";
                          actionTag="<td><button onclick='updateStatus(" + subs.id + ", \"PENDING\")' class='btn btn-sm btn-outline-warning' title='Pending'>" +
                              "<i class='bi bi-hourglass-split '></i> " +
                              "</button>   <button onclick='updateStatus(" + subs.id + ", \"APPROVED\")' class='btn btn-sm btn-outline-success' title='Approve'>" +
                              "<i class='bi bi-check-lg'></i>" +
                              "</button></td>";
                      }
                      if(subs.status=="PENDING"){
                          statusTag="<td class='text-warning fw-bold'>"+subs.status+"</td>";
                          actionTag="<td><button onclick='updateStatus(" + subs.id + ", \"APPROVED\")' class='btn btn-sm btn-outline-success me-1' title='Approve'>" +
                              "<i class='bi bi-check-lg'></i>" +
                              "</button>" +
                              "<button onclick='updateStatus(" + subs.id + ", \"REJECTED\")' class='btn btn-sm btn-outline-danger' title='Reject'>" +
                              "<i class='bi bi-x-lg'></i>" +
                              "</button></td>"
                      }

                      // actionTag="<td><button onclick='updateStatus(" + subs.id + ", \"PENDING\")' class='btn btn-sm btn-outline-warning' title='Pending'>" +
                      //     "<i class='bi bi-hourglass-split '></i> " +
                      //     "</button>   <button onclick='updateStatus(" + subs.id + ", \"APPROVED\")' class='btn btn-sm btn-outline-success' title='Approve'>" +
                      //     "<i class='bi bi-check-lg'></i>" +
                      //     "</button>" +
                      //     "<button onclick='updateStatus(" + subs.id + ", \"REJECTED\")' class='btn btn-sm btn-outline-danger' title='Reject'>" +
                      //     "<i class='bi bi-x-lg'></i>" +
                      //     "</button></td>";

                          tableContent+= "<tr> " +
                          "<td>"+subs.owner+"</td> " +
                          "<td><a href='/document/"+subs.id+"' target='_blank' class='text-decoration-none fw-semibold text-primary'><i class='bi bi-file-earmark-text me-1 '></i>"+subs.docName+"</a></td> " +
                          "<td>"+cleanDate+"</td>" + statusTag + actionTag +
                          "</tr>"
                  })

                  $("#sub-table-body").html(tableContent);



                  if ($.fn.DataTable.isDataTable("#example")){
                        $("#example").DataTable.destroy();
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
                  console.log("error");
              }
          })
      }

      $("#confirmBtn").on("click",function (){
          const btn=$(this)
          btn.prop('disabled',true).html('<span class="spinner-border spinner-border-sm"></span> Processing...');

          $.ajax({
              url:"http://localhost:8080/document/"+currentDocId+"/status?status="+currentStatus,
              method:'POST',
              success: function (res){
                  bootstrap.Modal.getInstance(document.getElementById('confirmModal')).hide();
                  btn.prop('disabled',false).text('Confirm');

                  fetchSubmissions();

              },
              error: function (error){
                  alert("Error updating status.");
                  btn.prop('disabled',false).text('Confirm');
              }

          })
      })

  </script>
</body>
</html>
