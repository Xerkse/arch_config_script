#!/bin/bash 

sudo sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 15/" /etc/pacman.conf

sudo sed -i "s/^  set timeout=5$/  set timeout=2/" /boot/grub/grub.cfg
sudo grub-mkconfig -o /boot/grub/grub.cfg

sudo pacman -Sy --noconfirm \
    pulsemixer \
    nsxiv mpv  \
    pacman-contrib \
    lf ueberzug \
    zathura zathura-pdf-mupdf ffmpeg \
    imagemagick gimp darktable\
    perl-image-exiftool perl-archive-zip \
    fzf xclip \
    zip unzip unrar p7zip \
    xdotool brightnessctl  \
    rsync samba nfs-utils \
    xcompmgr dunst \
    vim neovim \
    npm \
    git github-cli\
    man-db \
    feh \
    timeshift cronie \
    libx11 libxft libxinerama xorg-xinit xorg-xinput xorg-server webkit2gtk xorg-drivers\
    pass gnupg pass-otp \
    bash-completion \
    libreoffice-fresh jre-openjdk \
    newsboat \
    noto-fonts-emoji \
    exfatprogs \
    xorg-xsetroot acpi \
    maim \
    wget \
    zbar \
    base-devel \
    bc \
    zsh dash \
    torbrowser-launcher firefox \
    mpd ncmpcpp \
    ttf-liberation-mono-nerd \
    || exit

    #mpd ncmpcpp 
    #ttf-joypixels 

#change default shell
chsh -s "$(which zsh)"

git clone --separate-git-dir="$HOME/.git" "https://github.com/Xerkse/configs" "tmpconfigs"

rsync --links --recursive --verbose --exclude '.git' "tmpconfigs/" "$HOME/" \
    && rm -r tmpconfigs

git clone --depth=1 https://github.com/Xerkse/my_dmenu.git ~/.local/src/dmenu \
    && sudo make -C ~/.local/src/dmenu install

git clone --depth=1 https://github.com/Xerkse/my_st.git ~/.local/src/st \
    && sudo make -C ~/.local/src/st install

git clone --depth=1 https://github.com/Xerkse/my_dwm.git ~/.local/src/dwm \
    && sudo make -C ~/.local/src/dwm install

git clone --depth=1 https://github.com/Xerkse/my_sent.git ~/.local/src/sent \
    && sudo make -C ~/.local/src/sent install

git clone --depth=1 https://github.com/Xerkse/my_slock.git ~/.local/src/slock \
    && sudo make -C ~/.local/src/slock install

#suckless for sent
git clone --depth=1 https://git.suckless.org/farbfeld ~/.local/src/farbfeld \
    && sudo make -C ~/.local/src/farbfeld install

#install yay
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
cd ~ && rm -r yay

#not working, dont know why
#yay -S ttf-ms-win10-auto
yay -S espeak \
    simple-mtpfs \


#timeshift
sudo systemctl enable cronie.service
sudo systemctl start cronie.service

#use dash instead of bash for /bin/sh
sudo ln -sf /bin/dash /bin/sh

#arkenfox userjs
wget https://raw.github.com/arkenfox/user.js/master/user.js
wget https://raw.github.com/arkenfox/user.js/master/updater.sh
wget https://raw.github.com/arkenfox/user.js/master/prefsCleaner.sh
sudo chmod +x updater.sh
sudo chmod +x prefsCleaner.sh
mv user.js "$HOME/.config/areknfox/"
mv updater.sh "$HOME/.config/areknfox/"
mv prefsCleaner.sh  "$HOME/.config/areknfox/"

#run firefox to get the profiles file loaded so it can be edited
echo -n "firefox will be killed. Hit Enter." && read
pkill firefox
firefox -CreateProfile "arkenfox $HOME/.config/arkenfox"

#change arkenfox to default
echo -n "Firefox will be started. Make arkenfox the default profile. Hit Enter." && read
pkill firefox
firefox --new-window about:profiles || exit

echo -n "install ublock origin then close. Hit Enter." && read
pkill firefox
firefox "https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/?utm_source=addons.mozilla.org"

