install:
	cp hdmi_cable_toggled.sh /usr/local/bin/hdmi_cable_toggled.sh
	cp hdmi_cable_toggled.service /etc/systemd/system/hdmi_cable_toggled.service
	cp 99-hdmi-cable.rules /etc/udev/rules.d/99-hdmi-cable.rules
	udevadm control --reload-rules
	systemctl daemon-reload

uninstall:
	rm -f /usr/local/bin/hdmi_cable_toggled.sh
	rm -f /etc/systemd/system/hdmi_cable_toggled.service
	rm -f /etc/udev/rules.d/99-hdmi-cable.rules
	udevadm control --reload-rules
	systemctl daemon-reload
