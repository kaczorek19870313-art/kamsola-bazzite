# Podmień na wariant, którego faktycznie używasz, jeśli inny niż nvidia:
# bazzite, bazzite-nvidia, bazzite-deck, bazzite-deck-nvidia, bazzite-gnome, ...
FROM ghcr.io/ublue-os/bazzite-nvidia:stable

# --- Pliki brandingu Kamsola (plymouth, sddm, tapeta, ikona, dzwiek) ---
COPY files/system/ /

# --- Pakiety potrzebne do dzialania motywu plymouth i dzwieku ---
RUN dnf5 install -y plymouth-plugin-script alsa-utils && \
    dnf5 clean all

# --- Ustaw Kamsola jako domyslny motyw Plymouth ---
RUN plymouth-set-default-theme kamsola

# --- Dolacz logo Kamsola do "O systemie" (KDE czyta klucz LOGO z os-release) ---
RUN if ! grep -q '^LOGO=' /usr/lib/os-release; then \
        echo 'LOGO=kamsola-logo' >> /usr/lib/os-release; \
    else \
        sed -i 's/^LOGO=.*/LOGO=kamsola-logo/' /usr/lib/os-release; \
    fi && \
    gtk-update-icon-cache -f /usr/share/icons/hicolor || true

# --- Wlacz dzwiek startowy ---
RUN systemctl enable kamsola-boot-chime.service

# --- Tapeta domyslna dla nowych profili (best-effort: KDE trzyma to per-user,
#     wiec wymuszamy to jako domyslny szablon dla nowo tworzonych kont) ---
RUN mkdir -p /etc/skel/.config && \
    printf '[Wallpaper][org.kde.image][General]\nImage=/usr/share/wallpapers/Kamsola/contents/images/1920x1080.png\n' \
        > /etc/skel/.config/kamsola-wallpaper-hint.conf

# --- Wymus przebudowe initramfs przy kazdym buildzie tego obrazu ---
RUN dracut -f --regenerate-all
