let username = localStorage.getItem("username");
if (username) {
    const userElement = document.getElementById("username");
    if(userElement) userElement.innerText = username;
}
document.addEventListener("DOMContentLoaded", function() {
    const currentPath = window.location.pathname;
    const navLinks = document.querySelectorAll('.nav-link');

    navLinks.forEach(link => {
        // We use .includes or exact match depending on your URL structure
        if (link.getAttribute('href') === currentPath) {
            link.classList.add('active');
            link.classList.remove('link-dark');
        } else {
            link.classList.remove('active');
            link.classList.add('link-dark');
        }
    });
});

let currentDocId=null;
let currentStatus=null;

function updateStatus(docId,newStatus){
    console.log("hello")
    currentDocId=docId;
    currentStatus=newStatus;

    const colorClass= newStatus === 'APPROVED' ? 'text-success' : newStatus === 'PENDING' ? 'text-warning' : 'text-danger';
    $("#modalTitle").html("Confirm " + newStatus);
    $("#modalBody").html("Are you sure you want to mark this document as <strong class='"+colorClass +"'>"+  newStatus +"</strong>?");

    $("#confirmBtn").removeClass('btn-primary btn-success btn-danger').addClass(newStatus==="APPROVED" ? 'btn-success':newStatus === 'PENDING'? 'btn-warning' : 'btn-danger');


    const myModal=new bootstrap.Modal(document.getElementById('confirmModal'));
    myModal.show();
}


function logout(){
    $.ajax({
        url:"http://localhost:8080/logout",
        method:"GET",
        success: function (){
            window.location.href="/"
        },
        error: function (){
            console.log("faild to logout")
        }

    })
}
