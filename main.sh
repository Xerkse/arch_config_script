sudo sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 15/" /etc/pacman.conf

sudo sed -i "s/^  set timeout=5$/  set timeout=2/" /boot/grub/grub.cfg
sudo grub-mkconfig -o /boot/grub/grub.cfg

sudo pacman -Sy --noconfirm sxiv mpv  \
    pacman-contrib \
    pulsemixer \
    torbrowser-launcher \
    lf ueberzug \
    zathura zathura-pdf-mupdf ffmpeg \
    imagemagick gimp \
    fzf xclip \
    zip unzip unrar p7zip \
    xdotool brightnessctl  \
    rsync samba nfs-utils \
    firefox \
    xcompmgr dunst \
    vim neovim \
    npm \
    git github-cli\
    man \
    feh \
    timeshift \
    libx11 libxft libxinerama xorg-xinit xorg-xinput xorg-server webkit2gtk \
    pass gnupg pass-otp \
    bash-completion \
    libreoffiec jre-openjdk \
    newsboat \
    ttf-joypixels \
    noto-fonts-emoji \
    exfat-utils \
    xorg-xsetroot acpi \
    maim \
    wget \
    zbar \
    #mpd ncmpcpp 

git clone --separate-git-dir="$HOME/.git" "https://github.com/Xerkse/configs" "tmpconfigs"

rsync --recursive --verbose --exclude '.git' "tmpconfigs/" "$HOME/" \
    && rm -r tmpconfigs

git clone --depth=1 https://github.com/Xerkse/my_dmenu.git ~/.local/src/dmenu \
    && sudo make -C ~/.local/src/dmenu install

git clone --depth=1 https://github.com/Xerkse/my_st.git ~/.local/src/st \
    && sudo make -C ~/.local/src/st install

git clone --depth=1 https://github.com/Xerkse/my_dwm.git ~/.local/src/dwm \
    && sudo make -C ~/.local/src/dwm install

git clone --depth=1 https://github.com/Xerkse/my_sent.git ~/.local/src/sent \
    && sudo make -C ~/.local/src/sent install

#install yay
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
cd ~ && rm -r yay

#not working, dont know why
#yay -S ttf-ms-win10-auto
yay -S espeak \
    simple-mtpfs 
