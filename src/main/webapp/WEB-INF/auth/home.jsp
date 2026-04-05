<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Document</title>
  </head>
  <body>
    <% Object user = session.getAttribute("user"); if(user == null){
    response.sendRedirect("../auth/auth.jsp"); } out.println(user); %>
    <h1>Helloooo <span id="username"></span></h1>
    <script>
      let username = localStorage.getItem("username");

      if (username) {
        document.getElementById("username").innerText = username;
      }
    </script>
  </body>
</html>
