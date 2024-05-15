DESCRIPTION = "Prebuilt FreeRTOS firmware for Cortex-M core"
SECTION = "app"

do_install:append() {
    install -m 644 ${DEPLOYDIR}/imx8mm_m4_TCM_rpmsg_lite_str_echo_rtos.bin ${D}/boot/imx8mm_m4_TCM_rpmsg_lite_str_echo_rtos.bin
}

