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
        <h2 class="flex-grow-1">Home</h2>
        <button class="btn btn-primary d-flex align-items-center" data-bs-toggle="modal" data-bs-target="#uploadModal">  <i class="bi bi-cloud-arrow-up me-2 fs-4"></i>Upload document</button>
    </div>

    <div>
    <div class="bg-white d-flex mt-2 rounded p-4 mb-3">

        <div class="col-md-6 ">
            <div class="d-flex">
                <h4 class="fs-6 fw-bold flex-grow-1">PENDING DOCUMENTS </h4>
                <a href="/my-documents" class="nav-link active" ><i  class="bi bi-chevron-right me-2"></i></a>
            </div>
            <div id="pending-docs-body">
                <div colspan="4" class="text-center">Loading documents...</div>
            </div>
        </div>
        <div class="col-md-6 px-4 border-start">
            <h4 class="fs-6 fw-bold">RECENT SHARES</h4>
            <div id="recent-shares-body">
                <td colspan="4" class="text-center">Loading documents...</td>
            </div>
        </div>

    </div>

        <div class="d-flex flex-column flex-grow-1 border-end p-4 bg-white rounded">
            <h4 class="fs-6 fw-bold">REJECETD DOCUMENTS</h4>
            <table class="table">
                <thead>
                <tr>
                    <th scope="col" class="small">Filename</th>
                    <th scope="col" class="small">Type</th>
                    <th scope="col" class="small">Date</th>
                    <th scope="col" class="small">Reason</th>
                    <th scope="col" class="small">Action</th>
                </tr>
                </thead>
                <tbody id="rejected-docs-body">
                <tr>
                    <td colspan="4" class="text-center">Loading documents...</td>
                </tr>
                </tbody>
            </table>
        </div>

    </div>

</div>
<script>

    $(document).ready(function (){
        fetchPendingDocuments();
        fetchRecentShares();
        fetchRejectedDocuments();
    })

    function fetchPendingDocuments() {
        $.ajax({
            url:"http://localhost:8080/user/pending-docs",
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
                            "<div class='d-flex flex-row border-bottom py-1  small mx-2'>"+
                            "<div class='d-flex flex-column flex-grow-1'>" +
                            "<a href='/document/" + doc.id + "' target='_blank' class='text-decoration-none text-primary fw-semibold'>" +
                            "<i class='bi bi-file-earmark-text me-1'></i>" + doc.docName +
                            "</a>" +
                            "<div class='d-flex text text-warning'>" +
                            "<span class='small'>"+ sizeLabel  + " | </span>" +
                            "<span class='small ms-1'>Type - "+ doc.docCategory  +"</span>" +
                            "</div>" +"</div>" +
                            "<span class='small'>"+ timelabel  +"</span>"+
                            "</div>";
                    })
                }

                $("#pending-docs-body").html(tableContent);

            },
            error: function (err){
                console.log("error")
            }
        })
    }

    function fetchRecentShares() {
        $.ajax({
            url:"http://localhost:8080/user/recent-shares",
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
                            "<div class='d-flex flex-row items-align-center justify-content-center border-bottom py-1  small mx-2'>"+
                            "<div class='d-flex flex-column flex-grow-1'>" +
                            "<a href='/document/" + doc.id + "' target='_blank' class='text-decoration-none text-primary fw-semibold'>" +
                            "<i class='bi bi-file-earmark-text me-1'></i>" + doc.docName +
                            "</a>" +
                            "<div class='d-flex'>" +
                            "<span class='small'>"+ sizeLabel  + " | </span>" +
                            "<span class='small ms-1'>Type - "+ doc.docCategory  +" |</span>" +
                            "<span class='small ms-1'>"+ timelabel  +"</span>"+
                            "</div>" +"</div>" +
                            "<a href='/document/" + doc.id + "' download='" + doc.docName + "' class='text-dark'>" +
                            "<i class='pt-1 fw-bold bi bi-download fs-6'></i>" +
                            "</a>"
                            "</div>";
                    })
                }

                $("#recent-shares-body").html(tableContent);

            },
            error: function (err){
                console.log("error")
            }
        })
    }



    function fetchRejectedDocuments() {
        $.ajax({
            url:"http://localhost:8080/user/rejected-docs",
            method:'GET',
            success: function (docs){
                console.log(docs)
                let tableContent = "";

                if (docs.length == 0) {
                    tableContent = '<tr><td colspan="4" class="text-center">No pending documents found.</td></tr>';
                }
                else{
                    docs.forEach(doc=> {
                        let cleanDate=doc.statusModificationTime.split('T')[0];

                        tableContent +=
                            "<tr class='align-middle'>" +
                            "<td class='text-black small fw-semibold'>" +
                            "<a href='/document/" + doc.id + "' target='_blank' class='text-decoration-none text-danger'>" +
                            "<i class='bi bi-file-earmark-text me-1'></i>" + doc.docName +
                            "</a>" +
                            "</td>" +
                            "<td class='text-black small'><span class='badge bg-light text-dark border'>" + doc.docCategory + "</span></td>" +
                            "<td class='text-black small '>" + cleanDate + "</td>" +
                            "<td class='w-40' style='width: 30% !important'>" +
                             doc.rejectionRemark +
                            "</td>" +
                            "<td>" +
                            "<div>" +
                            "<button class='btn btn-sm btn-outline-primary me-1' title='view'>" +
                            "<a href='/document/" + doc.id + "' target='_blank' class='text-decoration-none text-primary'>" +
                            "<i class='bi bi-eye'></i>"+
                            "</a>"+
                             "</button>" +
                            "<button type='button' onclick='handleUploadBtn(`"+doc.docCategory+"`)'  data-bs-toggle='modal'  data-bs-target='#uploadModal' class='btn btn-sm btn-outline-success' title='re-upload'>" +
                            "<i class='bi bi-upload'></i>" +
                            "</button>" +
                            "</div>" +
                            "</td>" +
                            "</tr>";
                    })
                }

                $("#rejected-docs-body").html(tableContent);

            },
            error: function (err){
                console.log("error")
            }
        })
    }

    function handleUploadBtn(cat){
        $("#docCategory").val(cat).prop("disabled",true);

    }


</script>
<script src="<c:url value='/js/common.js' />"></script>
<script src="<c:url value='/js/api.js' />"></script>
</body>
</html>

