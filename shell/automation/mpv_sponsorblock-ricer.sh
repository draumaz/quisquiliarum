export PATCH_URL="https://raw.githubusercontent.com/draumaz/patches/main/mpv_sponsorblock"
export PO5_SB_URL="https://github.com/po5/mpv_sponsorblock"

SCR_PATH="$HOME/.config/mpv/scripts"

mkdir -pv $SCR_PATH
echo "Moving into $SCR_PATH" && cd $SCR_PATH;
git clone $PO5_SB_URL
mv -v mpv_sponsorblock/sponsorblock.lua ./sponsorblock.lua
mv -v mpv_sponsorblock/sponsorblock_shared .
rm -rf mpv_sponsorblock
patch sponsorblock.lua <(curl $PATCH_URL/sponsorblock.lua.patch)
patch sponsorblock_shared/sponsorblock.py <(curl $PATCH_URL/sponsorblock_shared/sponsorblock.py.patch)
rm -rfv LICENSE README.md
