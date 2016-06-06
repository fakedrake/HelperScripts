import os
import subprocess

def mailpasswd(acct):
    acct = os.path.basename(acct)
    # pass insert Email/{gmail,csail}
    # to create my passwords.
    args = ["pass", "Email/%s" % acct]
    try:
        return subprocess.check_output(args).strip()
    except subprocess.CalledProcessError:
        return ""

if __name__ == '__main__':
    print mailpasswd("gmail")
