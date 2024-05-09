FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
      file://terminal.png \    
      file://wallpaper.png \     
"

do_install:append() {
    install -d ${D}${datadir}/weston
    install ${WORKDIR}/terminal.png ${D}${datadir}/weston     
    
    install -d ${D}${sysconfdir}/xdg/weston   
    install -m 0644 ${WORKDIR}/wallpaper.png ${D}${sysconfdir}/xdg/weston/    
}

FILES:${PN} += "${sysconfdir}/xdg/weston/wallpaper.png"
