#!/bin/sh
uss=$USER
dialog --title "Welcome!" --msgbox "Welcome to My Setup Script" 10 60
dialog --title "AUR" --yes-label "YES" --no-label "NO" --yesno "Do You Want To Install An Aur Helper" 7 60
auuur=$?
dialog --title "Manager" --yes-label "YES" --no-label "NO" --yesno "Do You Wanna Use A Display Manager (lightdm) ??" 7 60 
manager=$?
dialog --title "Packages" --yes-label "YES" --no-label "NO" --yesno "Do You Install Required Packages??" 7 60 
pack=$?
dialog --title "My Keyboard layout" --yes-label "Yes" --no-label "NO" --yesno "Do you Wanna Use dvorak For System wide keyboad " 7 60
keyboard=$?
if [ $auuur -eq 0 ];then
  sudo pacman -Sy --noconfirm base-devel 
  git clone https://aur.archlinux.org/yay-bin.git
  cd yay-bin
  makepkg -si --noconfirm
  cd ..
  rm -rf yay-bin
fi
if [ $manager -eq 1 ];then
  echo "if [[ -z \$DISPLAY ]] && [[ \$(tty) = /dev/tty1 ]]; then exec sudo -u $uss startx /usr/local/bin/dwm; fi" | sudo tee -a /etc/bash.bashrc
elif [ $manager -eq 0 ];then
  sudo mkdir -p /usr/share/xsessions/ 
  sudo touch /usr/share/xsessions/dwm.desktop 
  sudo echo "[Desktop Entry]" | sudo tee -a /usr/share/xsessions/dwm.desktop
  sudo echo "Encoding=UTF-8"  | sudo tee -a /usr/share/xsessions/dwm.desktop
  sudo echo "Name=dwm" | sudo tee -a /usr/share/xsessions/dwm.desktop
  sudo echo "Comment=Dynamic window manager"  | sudo tee -a /usr/share/xsessions/dwm.desktop
  sudo echo "Exec=/usr/local/bin/dwm"  | sudo tee -a /usr/share/xsessions/dwm.desktop
  sudo echo "Icon=dwm" | sudo tee -a /usr/share/xsessions/dwm.desktop 
  sudo echo "Type=XSession" | sudo tee -a /usr/share/xsessions/dwm.desktop
else 
  exit 1
fi
if [ $pack -eq 0 ];then
  sudo pacman -Sy --noconfirm xorg-server xorg-xinit xorg-xsetroot xclip alacritty noto-fonts rofi neovim lxsession 
  if [ $auuur -eq 0 ];then
    yay -Sy --noconfirm brave-bin
  fi
  if [ $manager -eq 0 ];then
    sudo pacman -Sy --noconfirm lightdm lightdm-gtk-greeter
    sudo systemctl enable lightdm
  fi
fi
if [ $keyboard -eq 0 ];then
  sudo localectl set-x11-keymap us pc105 dvorak 
  sudo echo "KEYMAP=dvorak" | sudo tee /etc/vconsole.conf
sudo cp dwm /usr/local/bin/dwm
sudo chmod 755 /usr/local/bin/dwm

