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
            alert(res);
        }
    })
})