#!/bin/bash 

sudo sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 15/" /etc/pacman.conf

sudo sed -i "s/^  set timeout=5$/  set timeout=2/" /boot/grub/grub.cfg && sudo grub-mkconfig -o /boot/grub/grub.cfg

mkdir -p "$HOME/Pictures/Screenshots/"
mkdir -p "$HOME/Pictures/QR/"

sudo pacman -Sy --noconfirm \
    pulsemixer \
    nsxiv mpv  \
    lf ueberzug \
    zathura zathura-pdf-mupdf \
    ffmpeg \
    imagemagick gimp darktable\
    perl-image-exiftool perl-archive-zip \
    fzf \
    xclip \
    zip unzip unrar p7zip \
    xdotool brightnessctl  \
    rsync samba nfs-utils \
    picom dunst \
    neovim \
    tree-sitter-cli \
    npm \
    git github-cli\
    man-db \
    timeshift cronie \
    xss-lock \
    libx11 libxft libxinerama xorg-xinit xorg-xinput xorg-server webkit2gtk xorg-drivers\
    xorg-xev \
    pass gnupg pass-otp \
    bash-completion \
    libreoffice-fresh jre-openjdk \
    newsboat \
    noto-fonts-emoji \
    exfatprogs \
    xorg-xsetroot \
    acpi \
    zbar \
    bc \
    wget \
    zsh dash \
    firefox \
    mpd ncmpcpp \
    ttf-liberation-mono-nerd \
    maim feh \
    base-devel \
    reflector \
    || exit

    #mpd ncmpcpp 
    #ttf-joypixels 

#get better mirrors
printf "Updating mirrors, this may take some time"
sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup \
    && sudo reflector --latest 200 -age 12 --country "United States",Canada --sort rate --save /etc/pacman.d/mirrorlist --protocol https --download-timeout 15
#change default shell
chsh -s "$(which zsh)"

update_git() {
    dir_path="$1"

    if [ -d "$dir_path/.git" ]; then
        git --git-dir="$dir_path/.git" --work-tree="$dir_path" pull && return 0
        printf "unable to easily update %s would you like to force it?[y/N]" "$dir_path"
        read -r force_input
        case "$force_input" in
            [Yy]* ) {
                git --git-dir="$dir_path/.git" --work-tree="$dir_path" reset --hard
                git --git-dir="$dir_path/.git" --work-tree="$dir_path" pull && echo "$dir_path successfully updated"
                return 0
            } ;;
            [Nn]* ) return 0 ;;
            *) echo "this is bad -> $force_input?" & exit 1 ;;
        esac
    else
        return 1
    fi
}

# git clone --separate-git-dir="$HOME/.git" "https://github.com/Xerkse/configs" "tmpconfigs"
#
# rsync --links --recursive --verbose --exclude '.git' "tmpconfigs/" "$HOME/" \
#     && rm -r tmpconfigs

configs_path="$HOME/.git"
if update_git "$configs_path"; then
    pass
else
    git clone --separate-git-dir="$HOME/.git" "https://github.com/Xerkse/configs" "tmpconfigs"
    rsync --links --recursive --verbose --exclude '.git' "tmpconfigs/" "$HOME/" \
        && rm -r tmpconfigs
fi

mkdir "$HOME/.trash"


dmenu_path="$HOME/.local/src/dmenu/"
if update_git "$dmenu_path"; then
    sudo make -C "$dmenu_path" install
else
    git clone --depth=1 "https://github.com/Xerkse/my_dmenu.git" "$HOME/.local/src/dmenu" \
    && sudo make -C "$HOME/.local/src/dmenu" install
fi

st_path="$HOME/.local/src/st/"
if update_git "$st_path"; then
    sudo make -C "$st_path" install
else
    git clone --depth=1 "https://github.com/Xerkse/my_st.git" "$HOME/.local/src/st" \
    && sudo make -C "$HOME/.local/src/st" install
fi

dwm_path="$HOME/.local/src/dwm/"
if update_git "$dwm_path"; then
    sudo make -C "$dwm_path" install
else
    git clone --depth=1 "https://github.com/Xerkse/my_dwm.git" "$HOME/.local/src/dwm" \
    && sudo make -C "$HOME/.local/src/dwm" install
fi

sent_path="$HOME/.local/src/sent/"
if update_git "$sent_path"; then
    sudo make -C "$sent_path" install
else
    git clone --depth=1 "https://github.com/Xerkse/my_sent.git" "$HOME/.local/src/sent" \
    && sudo make -C "$HOME/.local/src/sent" install
fi

slock_path="$HOME/.local/src/slock/"
if update_git "$slock_path"; then
    sudo make -C "$slock_path" install
else
    git clone --depth=1 "https://github.com/Xerkse/my_slock.git" "$HOME/.local/src/slock" \
    && sudo make -C "$HOME/.local/src/slock" install
fi

farbfeld_path="$HOME/.local/src/farbfeld/"
if update_git "$farbfeld_path"; then
    sudo make -C "$farbfeld_path" install
else
    git clone --depth=1 "https://git.suckless.org/farbfeld" "$HOME/.local/src/farbfeld" \
        && sudo make -C "$HOME/.local/src/farbfeld" install
fi



# git clone --depth=1 "https://github.com/Xerkse/my_st.git" "$HOME/.local/src/st" \
#     && sudo make -C "$HOME/.local/src/st" install
#
# git clone --depth=1 "https://github.com/Xerkse/my_dwm.git" "$HOME/.local/src/dwm" \
#     && sudo make -C "$HOME/.local/src/dwm" install
#
# git clone --depth=1 "https://github.com/Xerkse/my_sent.git" "$HOME/.local/src/sent" \
#     && sudo make -C "$HOME/.local/src/sent" install
#
# git clone --depth=1 "https://github.com/Xerkse/my_slock.git" "$HOME/.local/src/slock" \
#     && sudo make -C "$HOME/.local/src/slock" install

#suckless for sent
# git clone --depth=1 "https://git.suckless.org/farbfeld" "$HOME/.local/src/farbfeld" \
#     && sudo make -C "$HOME/.local/src/farbfeld" install

#install yay
if ! command -v yay; then
    git clone https://aur.archlinux.org/yay.git
    cd yay && makepkg -si
    cd "$HOME" && sudo rm -r yay
fi

#not working, dont know why
#yay -S ttf-ms-win10-auto
yay -S simple-mtpfs \

# slock service
if [ ! -e /etc/systemd/system/slock@.service ]; then
    ln -s "$HOME/.config/x11/services/slock@.service" "/etc/systemd/system/"
fi

if [ "$(systemctl is-active slock@xerkse)" != "active" ]; then
    systemctl enable slock@xerkse
fi

#timeshift
if [ "$(systemctl is-active cronie.service)" != "active" ]; then
    sudo systemctl enable cronie.service
    sudo systemctl start cronie.service
fi

#use dash instead of bash for /bin/sh
if [ "$(readlink /bin/sh)" != "/bin/dash" ]; then
    sudo ln -sf /bin/dash /bin/sh
fi

if [ -d "$HOME/.config/arkenfox" ]; then
    "$HOME/.config/arkenfox/updater.sh"
else
    #arkenfox userjs
    wget https://raw.github.com/arkenfox/user.js/master/user.js
    wget https://raw.github.com/arkenfox/user.js/master/updater.sh
    wget https://raw.github.com/arkenfox/user.js/master/prefsCleaner.sh
    sudo chmod +x updater.sh
    sudo chmod +x prefsCleaner.sh
    mkdir "$HOME/.config/arkenfox"
    mv user.js "$HOME/.config/arkenfox/"
    mv updater.sh "$HOME/.config/arkenfox/"
    mv prefsCleaner.sh  "$HOME/.config/arkenfox/"

    #run firefox to get the profiles file loaded so it can be edited
    echo -n "firefox will be killed. Hit Enter." && read -r
    pkill firefox
    firefox -CreateProfile "arkenfox $HOME/.config/arkenfox"

    #change arkenfox to default
    echo -n "Firefox will be started. Make arkenfox the default profile. Hit Enter." && read -r
    pkill firefox
    firefox --new-window about:profiles || exit

    echo -n "install ublock origin then close. Hit Enter." && read -r
    pkill firefox
    firefox "https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/?utm_source=addons.mozilla.org"
fi


