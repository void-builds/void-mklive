#!/bin/bash
clear
HTMLDIR="/var/www/voidbuilds.xyz/public"
FILENAME="status.html"
ISODIR="download"


mvImages(){
# move image files to final destination

    PKGLISTDIR="package_lists"

    if [ ! -f sha256sums.txt ];then
        echo "checksum file not found, aborting!"
        exit 1
    fi

    if [ -d "${HTMLDIR}" ];then
        rm ${HTMLDIR}/${ISODIR}/*.iso
        rm ${HTMLDIR}/${ISODIR}/*.txt
        rm ${HTMLDIR}/${ISODIR}/*.sig
        mv sha256sums.txt build
        mv sha256sums.txt.sig build
        mv build/* ${HTMLDIR}/${ISODIR}
    else
        echo "${HTMLDIR}/ does not exist"
    fi

    if [ ! -d "${PKGLISTDIR}" ];then
        mkdir "${PKGLISTDIR}"
    fi

    rm -r ${PKGLISTDIR}/*
    cp gnome-x64.packages ${PKGLISTDIR}/gnome-x64.packages.txt
    cp base-x64.packages ${PKGLISTDIR}/base-x64.packages.txt
    cp cinnamon-x64.packages ${PKGLISTDIR}/cinnamon-x64.packages.txt
    cp e17-x64.packages ${PKGLISTDIR}/e17-x64.packages.txt
    cp mate-x64.packages ${PKGLISTDIR}/mate-x64.packages.txt
#    cp lxde-x64.packages ${PKGLISTDIR}/lxde-x64.packages.txt
    cp lxqt-x64.packages ${PKGLISTDIR}/lxqt-x64.packages.txt
    cp i3-x64.packages ${PKGLISTDIR}/i3-x64.packages.txt
    cp kde-x64.packages ${PKGLISTDIR}/kde-x64.packages.txt
    #cp gnome-x64.packages ${PKGLISTDIR}/gnome-x64.packages.txt
    cp xfce-x64.packages ${PKGLISTDIR}/xfce-x64.packages.txt

    cp -r ${PKGLISTDIR} ${HTMLDIR}

    return
}

runBuilds(){
    TOTAL="9"
    ERR_FILE="error-status.txt"

    if [ -f "${ERR_FILE}" ];then
        echo "removing error file"
        rm ${ERR_FILE}
    fi

    if [ ! -z "$(ls -A build)" ];then
        rm build/*
    fi

    #echo "0/${TOTAL} completed at $(date +%T)</br></br>" >> ${HTMLDIR}/${FILENAME}

    echo "Building Image: Base</br>" >> ${HTMLDIR}/${FILENAME}
    echo "Building: Base Image..."

    sleep 1
    ./base-x64.sh

    if [ $(cat ${ERR_FILE}) = "ERR=1" ];then
        echo "<b style="color:red">Build failed for image: 'base', trying again at 00:00 MST</b></br>" >> ${HTMLDIR}/${FILENAME}
        rm ${ERR_FILE}
        ${0} -bl
    else
        echo "1/${TOTAL} completed at $(date +%T)</br></br>" >> ${HTMLDIR}/${FILENAME}
    fi

    echo "Building Image: Cinnamon</br>" >> ${HTMLDIR}/${FILENAME}
    echo " Building: Cinnamon Image..."

    sleep 1
    ./cinnamon-x64.sh

    if [ $(cat ${ERR_FILE}) = "ERR=1" ];then
        echo "<b style="color:red">Build failed for image: 'Cinnamon', trying again at 00:00 MST</b></br>" >> ${HTMLDIR}/${FILENAME}
        rm ${ERR_FILE}
        ${0} -bl
    else
        echo "2/${TOTAL} completed at $(date +%T)</br></br>" >> ${HTMLDIR}/${FILENAME} 
    fi

    

    echo "Building Image: i3</br>" >> ${HTMLDIR}/${FILENAME}
    echo "Building: i3 image..."

    sleep 1
    ./i3-x64.sh

    if [ $(cat ${ERR_FILE}) = "ERR=1" ];then
        echo "<b style="color:red">Build failed for image: 'i3', trying again at 00:00 MST</b></br>" >> ${HTMLDIR}/${FILENAME}
        rm ${ERR_FILE}
        ${0} -bl
    else
        echo "3/${TOTAL} completed at $(date +%T)</br></br>" >> ${HTMLDIR}/${FILENAME}
    fi

    echo "Building Image: Enlightenment</br>" >> ${HTMLDIR}/${FILENAME}
    echo "Building: enlightenment image..."

    sleep 1
    ./e17-x64.sh

    if [ $(cat ${ERR_FILE}) = "ERR=1" ];then
        echo "<b style="color:red">Build failed for image: 'e17', trying again at 00:00 MST</b></br>" >> ${HTMLDIR}/${FILENAME}
        rm ${ERR_FILE}
        ${0} -bl
    else
        echo "4/${TOTAL} completed at $(date +%T)</br></br>" >> ${HTMLDIR}/${FILENAME}
    fi

    echo "Building Image: KDE</br>" >> ${HTMLDIR}/${FILENAME}
    echo "Building: Kde image..."
    sleep 1
    ./kde-x64.sh

    if [ $(cat ${ERR_FILE}) = "ERR=1" ];then
        echo "<b style="color:red">Build failed for image: 'KDE', trying again at 00:00 MST</b></br>" >> ${HTMLDIR}/${FILENAME}
        rm ${ERR_FILE}
        ${0} -bl
    else
	    echo "5/${TOTAL} completed at $(date +%T)</br></br>" >> ${HTMLDIR}/${FILENAME}    
    fi

    echo "Building Image: GNOME</br>" >> ${HTMLDIR}/${FILENAME}
    echo "Building: GNOME image..."
    sleep 1
    ./gnome-x64.sh

    if [ $(cat ${ERR_FILE}) = "ERR=1" ];then
        echo "<b style="color:red">Build failed for image: 'GNOME', trying again at 00:00 MST</b></br>" >> ${HTMLDIR}/${FILENAME}
        rm ${ERR_FILE}
        ${0} -bl
    else
	    echo "6/${TOTAL} completed at $(date +%T)</br></br>" >> ${HTMLDIR}/${FILENAME}    
    fi


    #echo "Building Image: LXDE</br>" >> ${HTMLDIR}/${FILENAME}
    #echo "Building: Lxde Image..."
    #sleep 1
    #./lxde-x64.sh

    #if [ $(cat ${ERR_FILE}) = "ERR=1" ];then
     #   echo "<b style="color:red">Build failed for image: 'LXDE', trying again at 00:00 MST</b></br>" >> ${HTMLDIR}/${FILENAME}
      #  rm ${ERR_FILE}
       # ${0} -bl
    #else
     #   echo "6/${TOTAL} completed at $(date +%T)</br></br>" >> ${HTMLDIR}/${FILENAME}
    #fi

    echo "Building Image: LXQT</br>" >> ${HTMLDIR}/${FILENAME}
    echo "Building: Lxqt Image..."
    sleep 1
    ./lxqt-x64.sh

    if [ $(cat ${ERR_FILE}) = "ERR=1" ];then
        echo "<b style="color:red">Build failed for image: 'LXQT', trying again at 00:00 MST</b></br>" >> ${HTMLDIR}/${FILENAME}
        rm ${ERR_FILE}
        ${0} -bl
    else
        echo "7/${TOTAL} completed at $(date +%T)</br></br>" >> ${HTMLDIR}/${FILENAME}
    fi

    echo "Building Image: MATE</br>" >> ${HTMLDIR}/${FILENAME}
    echo "Building: Mate Image..."
    sleep 1
    ./mate-x64.sh

    if [ "$(cat ${ERR_FILE})" = "ERR=1" ];then
        echo "<b style="color:red">Build failed for image: 'MATE', trying again at 00:00 MST</b></br>" >> ${HTMLDIR}/${FILENAME}
        rm ${ERR_FILE}
        ${0} -bl
    else
        echo "8/${TOTAL} completed at $(date +%T)</br></br>" >> ${HTMLDIR}/${FILENAME}
    fi

    echo "Building Image: XFCE</br>" >> ${HTMLDIR}/${FILENAME}
    echo "Building: Xfce Image..."
    sleep 1
    ./xfce-x64.sh

    if [ "$(cat ${ERR_FILE})" = "ERR=1" ];then
        echo "<b style="color:red">Build failed for image: 'XFCE', trying again at 00:00 MST</b></br>" >> ${HTMLDIR}/${FILENAME}
        rm ${ERR_FILE}
        ${0} -bl
    else
        echo "9/${TOTAL} completed at $(date +%T) </br></br>" >> ${HTMLDIR}/${FILENAME}
    fi


    #echo "Building Image: DWM</br>" >> ${HTMLDIR}/${FILENAME}
    #echo "Building: DWM Image..."
    #sleep 1
    #./dwm-x64.sh

    #if [ "$(cat ${ERR_FILE})" = "ERR=1" ];then
     #   echo "<b style="color:red">Build failed for image: 'MATE', trying again at 00:00 MST</b></br>" >> ${HTMLDIR}/${FILENAME}
      #  rm ${ERR_FILE}
       # ${0} -bl
    #else
     #   echo "9/${TOTAL} completed at $(date +%T)</br></br>" >> ${HTMLDIR}/${FILENAME}
    #fi

    if [ ! -f sha256sums.txt ];then
        echo "sha manifest does not exist!"
    else
        echo "Signing checksum file</br>" >> ${HTMLDIR}/${FILENAME}
        ./sign-file.sh -f sha256sums.txt
        mvImages
    fi

    

    echo "Done!"
    return
}


genSpecs(){
    HTMLDIR="/var/www/voidbuilds.xyz/public"
    FILENAME="specs.html"

    echo "<DOCTYPE! html>" > ${HTMLDIR}/${FILENAME}
    echo "<html>" >> ${HTMLDIR}/${FILENAME}
    echo "<head>" >> ${HTMLDIR}/${FILENAME}

    echo "<style>" >> ${HTMLDIR}/${FILENAME}
    echo "body {" >> ${HTMLDIR}/${FILENAME}
    echo "color: black;" ${HTMLDIR}/${FILENAME}
    echo "}" >> ${HTMLDIR}/${FILENAME}
    echo "h1 {" ${HTMLDIR}/${FILENAME}
    echo "color: #000000;" >> ${HTMLDIR}/${FILENAME}
    echo "</style>" >> ${HTMLDIR}/${FILENAME}
    echo "</head>" >> ${HTMLDIR}/${FILENAME}
    echo '<body text=white style="background-color: black">' >> ${HTMLDIR}/${FILENAME}	
    echo '<H4 style="color:lightgreen">System Specs</H4>' >> ${HTMLDIR}/${FILENAME}
    echo "CPU Cores: 1</br>" >> ${HTMLDIR}/${FILENAME}
    echo "Disk Size: $(df -h| tr -s ' ' $'\t' | grep vda1 | cut -f2)</br>" >> ${HTMLDIR}/${FILENAME}
    echo "Disk Space Used: $(df | tr -s ' ' $'\t' | grep vda1 | cut -f5)</br>" >> ${HTMLDIR}/${FILENAME}
    echo "Memory Size: $(free -m| tr -s ' ' $'\t' | grep Mem: | cut -f2) Mb</br>" >> ${HTMLDIR}/${FILENAME}
    echo "Memory Free: $(free -m| tr -s ' ' $'\t' | grep Mem: | cut -f4) Mb</br>" >> ${HTMLDIR}/${FILENAME}
    echo "Swap Size: $(free -m| tr -s ' ' $'\t' | grep Swap: | cut -f2) Mb</br>" >> ${HTMLDIR}/${FILENAME}
    echo "Swap Used: $(free -m| tr -s ' ' $'\t' | grep Swap: | cut -f3) Mb</br></br>" >> ${HTMLDIR}/${FILENAME}

    echo "<H4 style="color:lightgreen">Live Image Specs</H4>" >> ${HTMLDIR}/${FILENAME}
    echo "<h5>System</h5>"
    echo "Kernel Version: $(xbps-query -R linux| grep pkgver | sed 's/pkgver://') series</br>" >> ${HTMLDIR}/${FILENAME}
    echo "GlibC Version: $(xbps-query -R glibc| grep pkgver | sed 's/pkgver://')</br></br>" >> ${HTMLDIR}/${FILENAME}
    echo "AMDGPU Version: $(xbps-query -R xf86-video-amdgpu| grep pkgver | sed 's/pkgver://')</br></br>" >> ${HTMLDIR}/${FILENAME}
    echo "</html>" >> ${HTMLDIR}/${FILENAME}
}

genHtml(){
    FILENAME="status.html"



	echo "<DOCTYPE! html>" > ${HTMLDIR}/${FILENAME}
	echo "<html>" >> ${HTMLDIR}/${FILENAME}
	echo "<head>" >> ${HTMLDIR}/${FILENAME}
	echo '<script type="text/javascript">' >> ${HTMLDIR}/${FILENAME}
  	echo 'function timedRefresh(timeoutPeriod) {' >> ${HTMLDIR}/${FILENAME}
	echo 'setTimeout("location.reload(true);",timeoutPeriod);' >> ${HTMLDIR}/${FILENAME}
    echo '}' >> ${HTMLDIR}/${FILENAME}

    echo 'window.onload = timedRefresh(60000);' >> ${HTMLDIR}/${FILENAME}
	echo "</script>" >> ${HTMLDIR}/${FILENAME}
	
	echo "<style>" >> ${HTMLDIR}/${FILENAME}
	echo "body {" >> ${HTMLDIR}/${FILENAME}
    echo "color: black;" ${HTMLDIR}/${FILENAME}
	echo "}" >> ${HTMLDIR}/${FILENAME}
	echo "h1 {" ${HTMLDIR}/${FILENAME}
    echo "color: #FFFFFF;" >> ${HTMLDIR}/${FILENAME}
	echo "}" >> ${HTMLDIR}/${FILENAME}

	echo "</style>" >> ${HTMLDIR}/${FILENAME}

	echo "</head>" >> ${HTMLDIR}/${FILENAME}
	echo '<body text=white style="background-color: black">' >> ${HTMLDIR}/${FILENAME}
	echo "<H5>This page will refresh every 60 seconds</H5></br>" >> ${HTMLDIR}/${FILENAME} 

	
	echo "<H4 style="color:cyan">Build process initiated at:</H4> $(date +%R) MST  ($(date -u +%R)  UTC) on $(date +%D)" >> ${HTMLDIR}/${FILENAME}
	echo "<H4 style="color:cyan">ETA: 2 hours from initiation time</H4></br>" >> ${HTMLDIR}/${FILENAME}
	echo "<H4 style="color:yellow">Note: ISO files will not appear in downloads until all have been successfully built</H4></br>" >> ${HTMLDIR}/${FILENAME}

    echo "<hr>" >> ${HTMLDIR}/${FILENAME}

	#cat ${HTMLDIR}/${FILENAME}

    echo "<H3 style="color:orange">Status</H3>" >> ${HTMLDIR}/${FILENAME}

	runBuilds
	
	echo "Disk Space Used: $(df | tr -s ' ' $'\t' | grep vda1 | cut -f5)</br>" >> ${HTMLDIR}/${FILENAME}
	echo "All images were completed at $(date +%R) MST  ($(date -u +%R) UTC)</br>" >> ${HTMLDIR}/${FILENAME}
	echo "Next build round in 24 hours</b>" >> ${HTMLDIR}/${FILENAME}
	echo '<a href="https://voidbuilds.xyz/landing.html">Return to landing page</a>' >> ${HTMLDIR}/${FILENAME}
	echo "</body>" >> ${HTMLDIR}/${FILENAME}
	echo "</html>" >> ${HTMLDIR}/${FILENAME}

    return
}

cleanUp(){
# Clean: mklive xbps cache, build dir| Remove: old kernels, orphan packages

    BUILDDIR="build"
    if [ "$(ls -A $BUILDDIR)" ];then
        current=`date +%s`
        last_modified=`stat -c "%Y" ${BUILDDIR}/`

        if [ $(($current-$last_modified)) -gt 180 ]; then 
            echo "Removing unused image files.."
            rm -v build/*; 
        else 
            mvImages; 
        fi
        
    fi
    
    echo "[Cleaning up...]"
    echo "Checking for local XBPS cache dir..."

    if [ -d xbps-cachedir-x86_64 ];then
        echo "Removing local XBPS cache dir"
        rm -r xbps-cachedir-x86_64/
    fi
    
    echo "Removing mklive tmp directories..."
    rm -r tmp*
    
    echo "Removing orphans..."

    xbps-remove -yo

    echo "Clearing system XBPS cache files..."

    tux c

    echo "Checking for unused image files..." 

    

    echo "Checking for and removing unused kernels..."

    vkpurge rm all

}

case ${1} in


-bl|--build-later)
	while true;do
		snooze -v && cleanUp && genSpecs && genHtml && cleanUp && genSpecs
	done
;;

-bn|--build-now)
    while true;do
        cleanUp && genSpecs && genHtml && cleanUp && genSpecs && snooze -v 
    done
;;

-c|-clean)
    cleanUp
;;

*)
	echo -e """\nusage: ${0} [-bn, -bl]\n
    echo -e \n-bn      run builds now, snooze after\n
    echo -e -bl        snooze now, run builds after\n"""
    echo 
;;
esac
