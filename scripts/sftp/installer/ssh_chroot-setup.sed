s/Port 22/# Line commented automatically by the sftp installer\n#&/
s/# HostKeys for protocol version 2/&\n# Next lines commented automatically by the sftp installer/
/^HostKey/s/^/#/
s/^PermitRootLogin/# Next line commented automatically by the sftp installer\n#&/
s/^Subsystem/# Next line commented automatically by the sftp installer\n#&/
s/^PasswordAuthentication/# Next line commented automatically by the sftp installer\n#&/
$ a\\n#------- Next lines added automatically by the sftp installer -------\n
$ a\\n# What ports, IPs and protocols we listen for
$ a\Port 2222
$ a\\n# HostKeys for protocol version 2
$ a\HostKey /etc/ssh_chroot/ssh_host_rsa_key
$ a\HostKey /etc/ssh_chroot/ssh_host_dsa_key
$ a\HostKey /etc/ssh_chroot/ssh_host_ecdsa_key
$ a\HostKey /etc/ssh_chroot/ssh_host_ed25519_key
$ a\\n# Enable PasswordAuthetication
$ a\PasswordAuthentication yes
$ a\\n# Authentication:
$ a\PermitRootLogin  no
$ a\\n# SFTP config
$ a\PidFile /run/sshd_chroot.pid
$ a\AllowGroups submitters
$ a\Subsystem sftp internal-sftp
$ a\Match Group submitters LocalPort 2222
$ a\       ChrootDirectory /data/submitters/%u
$ a\       X11Forwarding no
$ a\       AllowTcpForwarding no
$ a\       ForceCommand internal-sftp
$ a\
