#!/bin/bash

################################################################
# UI JS plugins

#
# Custom header
#

set_header_text() {
DOMAIN_NAME=$(whiptail --inputbox "Insert custom title" 8 78 Name --title "Set text title" 3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "User selected Ok and entered " $DOMAIN_NAME
    sed -i "/var customHeaderText/c\var customHeaderText = '$DOMAIN_NAME';" /root/omv-theme/javascript/header-text.js
else
    echo "User selected Cancel."
fi

echo "(Exit status was $exitstatus)"
}


set_header_logo_url() {
LOGO_URL=$(whiptail --inputbox "Insert logo url [hotlink to image should end in (jpg, png)]" 8 78 http:// --title "Set logo url" 3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "User selected Ok and entered " $LOGO_URL
    wget $LOGO_URL -O /root/omv-theme/images/custom-logo.png
    cp /root/omv-theme/images/custom-logo.png /var/www/openmediavault/images/custom-logo.png
else
    echo "User selected Cancel."
fi

echo "(Exit status was $exitstatus)"
}

do_header_backup() {
if [ ! -f /root/omv-theme/backup/Workspace.js ]; then
    cp /var/www/openmediavault/js/omv/workspace/Workspace.js /root/omv-theme/backup/Workspace.js
fi
}

do_header_text() {
if [ -f /root/omv-theme/backup/Workspace.js ]; then
    cp /root/omv-theme/backup/Workspace.js /var/www/openmediavault/js/omv/workspace/Workspace.js
fi
sed -i -e '/buildHeader: function() {/,/},/c\buildHeader: function() {\n\/\/custom header\n},' /var/www/openmediavault/js/omv/workspace/Workspace.js
sed -i -e "/\/\/custom header/r /root/omv-theme/javascript/header-text.js" /var/www/openmediavault/js/omv/workspace/Workspace.js
}

do_header_logo() {
if [ -f /root/omv-theme/backup/Workspace.js ]; then
    cp /root/omv-theme/backup/Workspace.js /var/www/openmediavault/js/omv/workspace/Workspace.js
fi
sed -i -e '/buildHeader: function() {/,/},/c\buildHeader: function() {\n\/\/custom header\n},' /var/www/openmediavault/js/omv/workspace/Workspace.js
sed -i -e "/\/\/custom header/r /root/omv-theme/javascript/header-logo.js" /var/www/openmediavault/js/omv/workspace/Workspace.js
}

do_revert_header() {
if [ -f /root/omv-theme/backup/Workspace.js ]; then
    cp /root/omv-theme/backup/Workspace.js /var/www/openmediavault/js/omv/workspace/Workspace.js
fi

rm /var/www/openmediavault/images/custom-logo.png
}
