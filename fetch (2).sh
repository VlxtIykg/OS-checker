if test -f "/etc/os-release"; then
    cat /etc/os-release | grep "NAME=" -w > /tmp/a
    sed -i 's/NAME=//g' /tmp/a
    sed -i 's/"//g' /tmp/a
    name=$(cat /tmp/a)
else
    name=$(lsb_release -a | grep "Description" -w)
fi

case "$name" in
    *Arch*) os="Arch Linux"  ;;
    *Red*) os="Red Hat"  ;; 
    *Ubuntu*) os="Ubuntu"   ;;
    *Mint*) os="Mint"     ;;
    *Fedora*) os="Fedora"    ;;
    *Debian*) os="Debian"    ;;
    *Gentoo*) os="Gentoo"    ;;
esac

case "$os" in
    Arch*) PACKAGES=$(pacman -Qq | wc -l)                           ;;           
    Red*) PACKAGES=$(rpm -qa | wc -l)                               ;;               
    Ubuntu) PACKAGES=$(dpkg --list | wc -l)                ;;
    Mint) PACKAGES=$(dpkg --list | wc -l)                  ;;
    Fedora) PACKAGES=$(dnf list installed | wc -l)                  ;;
    Debian) PACKAGES=$(dpkg --list | wc -l)                ;; 
    Gentoo) PACKAGES= $(ls -d /var/db/pkg/*/*| cut -f5- -d/| wc -l) ;;
esac

HOST=$(cat /etc/hostname)

#MEM=$( lsmem | grep "Total online" | awk '{ print $4 }')
KERNEL=$( uname -r )
CPU=$( lscpu | \
	grep "Model name" | \
	awk -vFS=":" \
	' { print  $2 "" $3 "" $4 "" $5 "" $6 ""$7 "" $8 "" $9 "" $10 "" } '
)
CPU1=$(echo $CPU| sed -e 's/^[[:space:]]*//')

colors()
{
	bold="$(      tput bold     )"
	black="$(     tput setaf 0  )"
	red="$(       tput setaf 1  )"
	green="$(     tput setaf 2  )"
	yellow="$(    tput setaf 3  )"
	blue="$(       tput setaf 4  )"
	magenta="$(   tput setaf 5  )"
	cyan="$(      tput setaf 6  )"
	white="$(     tput setaf 7  )"
	reset="$(     tput sgr0     )"
}

colors 
case "$TERM" in
	*rxvt-unicode*) terminal="urxvt"    ;;
	st*)            terminal="st"       ;;
	xterm-2*)       terminal="xterm"    ;;
	*termite)       terminal="termite"  ;;
	*alacritty*)    terminal="alacritty";;
	*kitty*)        terminal="kitty"    ;;
	putty*)         terminal="PuTTY"    ;;
	linux)          terminal="$(tty)"     ;;
	*xfce*)         terminal="xfce4-terminal" ;;
	lx*)            terminal="lxterminal"  ;;
    *)              terminal="not found";;
	xterm*)         terminal="xterm" ;;
	xterm)          terminal="xterm" ;;
    *gnome*)        terminal="gnome-terminal" ;;
	
esac

cat <<EOF

${blue}${reset}OS: $bold$blue$os$reset
${blue}${reset}Hostname: $bold$cyan$HOST $reset 
${blue}${reset}Terminal: $bold$red$terminal $reset
${blue}${reset}CPU: $bold$green$CPU1$reset
${blue}${reset}Packages: $bold$blue$PACKAGES $reset
${blue}${reset}Kernel: $bold$yellow$KERNEL $reset
${blue}${reset}User: $bold $magenta $USER $reset

EOF
