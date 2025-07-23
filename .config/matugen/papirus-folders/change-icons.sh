#!/usr/bin/env bash

# Catppuccin Mocha renk paleti (renk ismi → hex kodu)
declare -A colors=(
  [adwaita]="#93c0ea"
  [black]="#4f4f4f"
  [blue]="#5294e2"
  [bluegrey]="#607d8b"
  [breeze]="#57b8ec"
  [brown]="#ae8e6c"
  [carmine]="#a30002"
  [cyan]="#00bcd4"
  [darkcyan]="#45abb7"
  [deeporange]="#eb6637"
  [green]="#87b158"
  [grey]="#8e8e8e"
  [indigo]="#5c6bc0"
  [magenta]="#ca71df"
  [nordic]="#81a1c1"
  [orange]="#ee923a"
  [palebrown]="#d1bfae"
  [paleorange]="#eeca8f"
  [pink]="#f06292"
  [red]="#e25252"
  [teal]="#16a085"
  [violet]="#7e57c2"
  [white]="#e4e4e4"
  [yaru]="#676767"
  [yellow]="#f9bd30"
  [cat-mocha-blue]="#89B4FA"
  [cat-mocha-flamingo]="#F2CDCD"
  [cat-mocha-green]="#A6E3A1"
  [cat-mocha-lavender]="#B4BEFE"
  [cat-mocha-maroon]="#EBA0AC"
  [cat-mocha-mauve]="#CBA6F7"
  [cat-mocha-peach]="#FAB387"
  [cat-mocha-pink]="#F5C2E7"
  [cat-mocha-red]="#F38BA8"
  [cat-mocha-rosewater]="#F5E0DC"
  [cat-mocha-sapphire]="#74C7EC"
  [cat-mocha-sky]="#89DCEB"
  [cat-mocha-teal]="#94E2D5"
  [cat-mocha-yellow]="#F9E2AF"
)

# Hex kodunu plaintext dosyadan oku
hex=$(<~/.config/matugen/papirus-folders/colors-papirus.txt)

# '#' sembolünü kaldır (varsa)
hex=${hex#\#}

# Hex kodunu büyük harfe çevir
hex=$(echo "$hex" | tr '[:lower:]' '[:upper:]')

# RR, GG, BB bileşenlerini ayır
RR=${hex:0:2}
GG=${hex:2:2}
BB=${hex:4:2}

# Hex'ten decimal'e çevir
R1=$((16#${RR}))
G1=$((16#${GG}))
B1=$((16#${BB}))

# Minimum mesafeyi ve en yakın rengi takip etmek için değişkenler
min_dist=999999
closest_color=""

# Paletdeki her renk için döngü
for color_name in "${!colors[@]}"; do
    palette_hex=${colors[$color_name]}
    palette_hex=${palette_hex#\#}
    palette_hex=$(echo "$palette_hex" | tr '[:lower:]' '[:upper:]')
    palette_RR=${palette_hex:0:2}
    palette_GG=${palette_hex:2:2}
    palette_BB=${palette_hex:4:2}
    R2=$((16#${palette_RR}))
    G2=$((16#${palette_GG}))
    B2=$((16#${palette_BB}))

    # RGB uzayındaki Öklid mesafesini hesapla (karekök almadan, kareler toplamı yeterli)
    ((diff_R = R1 - R2))
    ((diff_G = G1 - G2))
    ((diff_B = B1 - B2))
    ((dist = diff_R * diff_R + diff_G * diff_G + diff_B * diff_B))

    # Eğer bu mesafe mevcut minimumdan küçükse, güncelle
    if (( dist < min_dist )); then
        min_dist=$dist
        closest_color=$color_name
    fi
done

# En yakın rengin ismini ekrana yazdır
echo $closest_color is the closest color
~/.local/share/icons/papirus-folders.sh -C $closest_color -t ~/.local/share/icons/Papirus-Dark