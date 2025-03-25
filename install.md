# INSTALL
pkg update -y
pkg upgrade -y
pkg install curl -y
pkg install jq -y
pkg install nano -y
pkg install git
git clone https://github.com/vpm666/RX2HAT.git
cd RX2HAT
bash rx2hat.sh
