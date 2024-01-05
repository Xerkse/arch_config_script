sudo sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 15/" /etc/pacman.conf

sudo sed -i "s/^  set timeout=5$/  set timeout=2/" /boot/grub/grub.cfg
sudo grub-mkconfig -o /boot/grub/grub.cfg

sudo pacman -Sy --noconfirm sxiv mpv  \
    lf ueberzug \
    zathura zathura-pdf-mupdf ffmpeg \
    imagemagick gimp \
    fzf xclip \
    zip unzip unrar xdotool brightnessctl  \
    rsync \
    firefox \
    xcompmgr dunst \
    vim neovim \
    git \
    libx11 libxft libxinerama xorg-xinit xorg-server webkit2gtk \
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


