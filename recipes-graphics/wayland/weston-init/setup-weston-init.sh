#!/bin/sh

get_mode () {
  IFNAME=${1##*/}
  RESOL=$(cat $1/modes | head -n 1)
  WIDTH=${RESOL//x*}
  HEIGHT=${RESOL//*x}
}

for card in /sys/class/drm/card?-*
do
  get_mode $card

  # Only excute auto-rotation when display output is MIPI-DSI
  if [ -f /etc/xdg/weston/weston.ini -a -n $RESOL ] && [[ "$IFNAME" =~ ^card.*-DSI-.* ]]; then
    # check existing core section for cardX
    if grep -q "^drm-device=" /etc/xdg/weston/weston.ini; then
      sed -e 's,drm-device.*,drm-device='${IFNAME%%-*}',g' -i /etc/xdg/weston/weston.ini
    fi

    if ! grep -q "^name=${IFNAME#*-}" /etc/xdg/weston/weston.ini || ! grep -q "^mode=${RESOL}" /etc/xdg/weston/weston.ini ; then
        # If the interface name and resolution in weston.ini doesn't match the settings detected by DRM,
        # then, clear the old settings in westion.ini and create a new one.

        # clear [output] display section
        sed -i '/^\[output\]/,/^$/d' /etc/xdg/weston/weston.ini
        # remove blank lines from the end of a file
        sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' /etc/xdg/weston/weston.ini
        # enable cardX output section
        echo >> /etc/xdg/weston/weston.ini
        echo -e "[output]" >> /etc/xdg/weston/weston.ini
        echo "name=${IFNAME#*-}" >> /etc/xdg/weston/weston.ini
        echo "mode=${RESOL}@60" >> /etc/xdg/weston/weston.ini
        if [ $HEIGHT -gt $WIDTH ]; then
          echo "transform=rotate-270" >> /etc/xdg/weston/weston.ini
        fi
        
        echo -e "[shell]" >> /etc/xdg/weston/weston.ini
        echo "background-color=0xffdddddd" >> /etc/xdg/weston/weston.ini        
        echo "background-image=/etc/xdg/weston/wallpaper.png" >> /etc/xdg/weston/weston.ini        
        echo "background-type=centered" >> /etc/xdg/weston/weston.ini                        
        echo "syncpanel-position=none" >> /etc/xdg/weston/weston.ini             
    fi

  fi
done
