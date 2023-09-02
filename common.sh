ID=$(id -u)
if [ $ID -ne 0 ]; then
  echo You should run this Script as root user or with sudo Privileges.
  exit 1
  fi

StatusCheck() {
if [ $1 -eq 0 ]; then
  echo -e status = "\e[32mSUCCESS\e[0m"
else
  echo -e status = "\e[31mFAILURE\e[0m"
  exit 1
  fi
}