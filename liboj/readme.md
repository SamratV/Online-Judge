Additional stuffs:


SETUP
------
/liboj/scripts/setup.sh username  /path-to-workspace/Codepad/runtime/ 2 /cryptic_security/jail/


COMPILE
--------
/liboj/scripts/compile.sh /code/username/ java /cryptic_security/jail /path-to-workspace/Codepad/runtime/username/Solution.java


RUN
----
/liboj/scripts/run.sh /code/username/ java 1 /cryptic_security/jail /path-to-workspace/Codepad/runtime/username/


SETUID WRAPPER
---------------
sudo chown root:root rsw
sudo chmod 4755 rsw


NOTE
-----
* Don't forget to setup chroot(based on Ubuntu 18.04) in the folder "/cryptic_security/jail".
* GCC, G++, JAVA(oracle jdk 8 or above, oracle jdk 11 was used actually) and PYTHON 3 compilers must be installed inside the chroot.
* "libseccomp-dev" and "software-properties-common" libraries should also be installed inside the chroot.
* Also place the "java_policy" file(available in source folder of judge) inside the "/etc" folder of chroot os.


REFERENCES
-----------
The judge was designed using the codes and tips available at the following links:
* https://github.com/DOMjudge/domjudge
* https://github.com/QingdaoU/Judger
* https://www.hackerearth.com/practice/notes/vivekprakash/technical-diving-into-memory-used-by-a-program-in-online-judges/
