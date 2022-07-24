# decrypt mystery.gpg    (SEND CONTENTS TO XCLIP)
# decrypt mystery.gpg -d (SEND CONTENTS TO STDOUT)

TOKEN="$1"
gpg-connect-agent reloadagent /bye
if [ "$2" == "-d" ] || [ "$2" == "--display" ]; then
	gpg -d $TOKEN
else
	gpg -d $TOKEN | xclip -sel clip
fi
