git clone https://aur.archlinux.org/package-query.git
cd package-query
makepkg -si
cd ..
rm -rf package-query

git clone https://aur.archlinux.org/yaourt.git
cd yaourt
makepkg -si
cd ..
rm -rf yaourt

yaourt -S --noconfirm package-query
