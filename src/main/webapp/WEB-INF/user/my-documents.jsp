<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

<%@ include file="../common/upload-doc-modal.jsp"%>

<div class="m-3 d-flex flex-column flex-grow-1">
    <div class="mb-1 d-flex flex-row">
        <h2 class="flex-grow-1">My Documents</h2>
        <button class="btn btn-primary d-flex align-items-center" data-bs-toggle="modal" data-bs-target="#uploadModal">  <i class="bi bi-cloud-arrow-up me-2 fs-4"></i>Upload document</button>
    </div>

    <div class="mt-2">
        <table id="example" class="table table-striped small">
            <thead>
            <tr>
                <th>Document Name</th>
                <th>Type</th>
                <th>Status</th>
                <th>Upload Date</th>
                <th style="width: 25%;">Admin Remarks</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody id="sub-table-body">

            </tbody>
        </table>
    </div>

</div>
<script>

    $(document).ready(function (){
        fetchMyDocuments();
    })


    function fetchMyDocuments(){

        $.ajax({
            url:"http://localhost:8080/user/my-docs",
            method:'GET',
            success: function (submissions){
                let tableContent="";

                submissions.forEach(subs=>{
                    let filename=truncateFileName(subs.docName)

                    let cleanDate=subs.uploadDate.split('T')[0];
                    let statusTag="";
                    let actionTag="";
                    let remark="<td class='text-muted'>-</td>";


                    if(subs.status=="APPROVED"){
                        statusTag="<td class='text-success fw-bold'>"+subs.status+"</td>";
                        actionTag="<div>" +
                            "<button class='btn btn-sm btn-outline-primary me-1' title='view'>" +
                            "<a href='/document/" + subs.id + "' target='_blank' class='text-decoration-none text-primary'>" +
                            "<i class='bi bi-eye'></i>"+
                            "</a>"+
                            "</button>" +
                            "<button class='btn btn-sm btn-outline-primary me-1' title='view'>" +
                            "<a href='/document/" + subs.id + "' download='" + subs.docName + "' class=''>" +
                            "<i class='pt-1 fw-bold bi bi-download small'></i>" +
                            "</a>"+
                            "</button>"+
                            "</div>"
                    }
                    if(subs.status=="REJECTED"){
                        statusTag="<td class='text-danger fw-bold'>"+subs.status+"</td>";
                        remark="<td>"+subs.rejectionRemark +"</td>"
                        actionTag="<div>" +
                            "<button class='btn btn-sm btn-outline-primary me-1' title='view'>" +
                            "<a href='/document/" + subs.id + "' target='_blank' class='text-decoration-none text-primary'>" +
                            "<i class='bi bi-eye'></i>"+
                            "</a>"+
                            "</button>" +
                            "<button type='button' onclick='handleUploadBtn(`"+subs.docCategory+"`)'  data-bs-toggle='modal'  data-bs-target='#uploadModal' class='btn btn-sm btn-outline-success' title='re-upload'>" +
                            "<i class='bi bi-upload'></i>" +
                            "</button>" +
                            "</div>"

                    }
                    if(subs.status=="PENDING"){
                        statusTag="<td class='text-warning fw-bold'>"+subs.status+"</td>";
                        actionTag="<div>" +
                            "<button class='btn btn-sm btn-outline-primary me-1' title='view'>" +
                            "<a href='/document/" + subs.id + "' target='_blank' class='text-decoration-none text-primary'>" +
                            "<i class='bi bi-eye'></i>"+
                            "</a>"+
                            "</button>" +
                            "<button type='button' onclick='removeDocument("+subs.id+")'  class='btn btn-sm btn-outline-danger me-1' title='re-upload'>" +
                            "<i class='bi bi-x-lg text-danger'></i>" +
                            "</button>" +
                            "<button class='btn btn-sm btn-outline-primary me-1' title='view'>" +
                            "<a href='/document/" + subs.id + "' download='" + subs.docName + "' class=''>" +
                            "<i class='fw-bold bi bi-download small'></i>" +
                            "</a>"+
                            "</button>"+
                            "</div>"

                    }

                    tableContent+= "<tr> " +
                        "<td><a  title='"+subs.docName+"' href='/document/"+subs.id+"' target='_blank' class='text-decoration-none fw-semibold text-primary'><i class='bi bi-file-earmark-text me-1'></i>"+filename+"</a></td> " + "<td>"+subs.docCategory+"</td>" + statusTag +
                        "<td>"+cleanDate+"</td>" + remark +
                        "<td>"+actionTag+"</td>" +
                        "</tr>";
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

    function removeDocument(id){

        $.ajax({
            url:"http://localhost:8080/document/remove/"+id,
            method:'POST',
            success: function (result){
                fetchMyDocuments();
            },
            error: function (err){
                console.log("error")
            }
        })

    }


</script>
<script src="<c:url value='/js/common.js' />"></script>
<script src="<c:url value='/js/api.js' />"></script>
</body>
</html>

