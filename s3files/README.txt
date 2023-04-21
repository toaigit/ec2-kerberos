NOTE: - these files are required to setup Kerberos authentication and duo 2FA
Please update your specific values in authinfo, pam_duo.conf files, and krb5.conf.
Upload these files to your S3 bucket. The userdata scripts will copy these files
and place in the right locations to make it worked.
pam_krb5-4.11-1.el8.x86_64.rpm came from 
   https://mirrors.opensource.is/epel/8/Everything/x86_64/Packages/p/
   https://rpmfind.net/linux/rpm2html/search.php?query=pam_krb5
