PACKAGECONFIG:append = " networkd resolved"
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

MY_INTERFACE = "eth0"

SRC_URI += " \
    file://${MY_INTERFACE}.network \
"

FILES_${PN} += " \
    ${sysconfdir}/systemd/network/${MY_INTERFACE}.network \
"

do_install:append() {
    install -d ${D}${sysconfdir}/systemd/network
    install -m 0644 ${WORKDIR}/${MY_INTERFACE}.network ${D}${sysconfdir}/systemd/network
}

