let username = localStorage.getItem("username");
if (username) {
    const userElement = document.getElementById("username");
    if(userElement) userElement.innerText = username;
}


document.addEventListener("DOMContentLoaded", function() {
    // 1. Get the current path (e.g., /dashboard)
    const currentPath = window.location.pathname;
    const navLinks = document.querySelectorAll('.nav-link');

    navLinks.forEach(link => {
        // 2. Get the href attribute
        const linkHref = link.getAttribute('href');

        // 3. Reset all links to default state first
        link.classList.remove('active');
        link.classList.add('link-dark');

        // 4. Check for match
        // We check if currentPath starts with linkHref to handle sub-pages,
        // OR if they are exactly the same.
        if (currentPath === linkHref || (linkHref !== '/' && currentPath.startsWith(linkHref))) {
            link.classList.add('active');
            link.classList.remove('link-dark');
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

    $("#modalBody").html("Are you sure you " +
        " to mark this document as <strong class='"+colorClass +"'>"+  newStatus +"</strong> ?");

    if(newStatus==="REJECTED"){
        $("#modalBody").append(`
    <div class="mt-3 mb-2">
      <input type="text" class="form-control" id="admin-remark-input" placeholder="Rejection remark" required>
    </div>
`);
    }

    $("#confirmBtn").removeClass('btn-primary btn-success btn-danger').addClass(newStatus==="APPROVED" ? 'btn-success':newStatus === 'PENDING'? 'btn-warning' : 'btn-danger');


    const myModal=new bootstrap.Modal(document.getElementById('confirmModal'));
    myModal.show();
}


function logout(){
    $.ajax({
        url:"http://localhost:8080/logout",
        method:"GET",
        success: function (){
            localStorage.clear()
            window.location.href="/"

        },
        error: function (){
            console.log("faild to logout")
        }

    })
}

function formatBytes(bytes, decimals = 2) {
    if (bytes === 0) return '0 Bytes';

    const k = 1024;
    const dm = decimals < 0 ? 0 : decimals;
    const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];

    const i = Math.floor(Math.log(bytes) / Math.log(k));

    return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i];
}

function getRelativeTime(dateString) {
    const date = new Date(dateString);
    const now = new Date();
    const diffInSeconds = Math.floor((now - date) / 1000);
    const diffInDays = Math.floor(diffInSeconds / 86400);

    if (diffInDays === 0) return "Today";
    if (diffInDays === 1) return "Yesterday";
    if (diffInDays < 7) return diffInDays + " days ago";

    return date.toLocaleDateString('en-GB', { day: '2-digit', month: 'short' });
}

function truncateFileName(name, startChars = 15, endChars = 5) {
    if (!name || name.length <= (startChars + endChars + 3)) {
        return name; // Return original if it's already short
    }

    const start = name.substring(0, startChars);
    const end = name.substring(name.length - endChars);

    return start + "..." + end;
}

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