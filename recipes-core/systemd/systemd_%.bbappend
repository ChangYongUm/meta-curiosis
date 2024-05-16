PACKAGECONFIG:append = " networkd resolved"
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://80-wired.network \
"

FILES_${PN} += " \
    ${sysconfdir}/systemd/network/80-wirednetwork \
"

do_install_:ppend() {
    install -d ${D}lib/systemd/network
    install -m 0644 ${WORKDIR}/80-wired.network ${D}lib/systemd/network/
}
