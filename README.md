# Online-Judge

Tools used
-----------
* Programming languages: Java, JavaScript, C and Linux Shell Script (bash)
* Frameworks / Libraries: Bootstrap, Jquery, Ace Editor, Ckeditor, Java Mailer(spring), Google GSON, Java Encoder OWASP, Apache Validator, Apache Commons File Upload and MySQL JDBC Connector
* Server: Tomcat 9
* Database: MySQL 5.7
* Host OS: Ubuntu 18.04 LTS
* Sandboxing: Chroot based on Ubuntu 18.04 LTS
* Compilers: GCC 7.3.0, G++ 7.3.0, JDK 11(Oracle) and Python 3
* Additional libraries: libseccomp-dev and software-properties-common

Edits required
---------------
* Edit <b>website/src/auth/Mailer.java</b> using your email and password after subscribing for google mail service.
* Edit <b>website/src/link/Link.java</b> using your database credentials.
* Replace <b>path-to-workspace</b> in <b>web.xml</b> with a suitable path such as <b>home/username/Desktop</b>.

Login id
---------
* Email: root@codepadoj.com
* Password: 123456

Demo video
-----------
* Link: https://www.linkedin.com/posts/vaibhaw-samrat-76511813a_my-btech-final-year-project-an-online-judge-activity-6568790862925529088-ccIw

Deployment
-----------
* Install JDK, Tomcat Server, MYSQL.
* Setup chroot based on Ubuntu 18.04 LTS with all the compilers and addtitional libraries installed inside it.
* Path of chroot should be "/cryptic_security/jail".
* Place the "liboj" folder at "/" without the source folders and readme files.
* Adjust the permissions of all the files in the "liboj" folder.
* Binary files in "liboj/bin" folder are setuid wrappers, so, set the permissions accordingly.
* Place the "java_policy" file(available in source folder of judge) inside the "/etc" folder of chroot os.
* Import the database using the "database.sql" file in database folder.
* Deploy the website on Tomcat Server.

Bugs
-----
Some of the known bugs are:
* JQuery AJAX and prepend functions fail on Google Chrome but works on Firefox, Edge and other popular browsers.
* Judge fails for first few program run initially when server is started but starts working smoothly after 2 failed attempts.
