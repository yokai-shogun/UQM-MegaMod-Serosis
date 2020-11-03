#!/bin/sh
#
# Generates a .nsh file for the NSIS Windows installer with MD5 checksums
# and file sizes of the UQM packages.
#
# Run this from an MSYS2 bash shell.
#
# The packages must be in the current directory.
#
# The awk, md5sum, and wc utilities must be installed, but MSYS2
# should generally already have those in your path.

NSH_FILE="packages.nsh"
PKG_VERSION="0.8.0.85"

CONTENT_PKG="mm-$PKG_VERSION-content.uqm"
HD_CONTENT_PKG="mm-$PKG_VERSION-hd.uqm"
MUSIC_PKG="uqm-0.7.0-3DOMusicRemastered.uqm"
VOICE_PKG="mm-$PKG_VERSION-voice.uqm"
VIDEO_PKG="uqm-0.7.0-3dovideo.uqm"
VOLS_REMIX="volasaurus-remix-pack.uqm"
VOL_SPACE="volasaurus-space-music.uqm"
RMX_UTWIG="rmx-utwig.uqm"
MEL_FIX="MelnormeVoiceFixMMAddon.uqm"
SYR_FIX="SyreenVoiceFixMMAddon.uqm"
REMIX5_PKG="mm-remix-timing.uqm"

check_pkg() {
    if [ ! -f "$1" ]; then
        echo "$1 not found."
        exit 1
    fi
}

process_pkg() {
    echo "Processing $1..."
    SUM=$(md5sum "$1" | awk '{print $1}')
    SZ=$(wc -c "$1" | awk '{print $1}')
    SZ=$(( SZ / 1024 ))
    {
        echo "!define $2_FILE \"$1\""
        echo "!define $2_MD5SUM \"$SUM\""
        echo "!define $2_SIZE $SZ"
    } >> $NSH_FILE
}

check_pkg $CONTENT_PKG
check_pkg $HD_CONTENT_PKG
check_pkg $MUSIC_PKG
check_pkg $VOICE_PKG
check_pkg $VIDEO_PKG
check_pkg $VOLS_REMIX
check_pkg $VOL_SPACE
check_pkg $RMX_UTWIG
check_pkg $MEL_FIX
check_pkg $SYR_FIX
check_pkg $REMIX5_PKG

echo "# Autogenerated by procpkgs.sh" > $NSH_FILE
echo "#" >> $NSH_FILE
process_pkg $CONTENT_PKG PKG_CONTENT
process_pkg $HD_CONTENT_PKG PKG_HD_CONTENT
process_pkg $MUSIC_PKG PKG_3DOMUSIC
process_pkg $VOICE_PKG PKG_VOICE
process_pkg $VIDEO_PKG PKG_VIDEO
process_pkg $VOLS_REMIX VOLS_REMIX
process_pkg $VOL_SPACE VOL_SPACE
process_pkg $RMX_UTWIG RMX_UTWIG
process_pkg $MEL_FIX MEL_FIX
process_pkg $SYR_FIX SYR_FIX
process_pkg $REMIX5_PKG PKG_REMIX5

echo "All packages processed. ${NSH_FILE} generated."
