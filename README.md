# Kamsola Bazzite — instrukcja finalna

Wszystko poniżej robisz na komputerze z Bazzite. Nic nie trzeba przełączać.

## 0. Sprzątanie po wcześniejszych próbach (opcjonalne, ale polecane)

Wcześniej ręcznie kopiowaliśmy pliki przez `usroverlay` — to i tak zniknęło
przy pierwszym normalnym reboocie, więc nie ma czego sprzątać w /usr.
Jedna rzecz, która ZOSTAŁA na stałe i jest ok, nic z nią nie rób:
`plymouth-plugin-script` (widziałeś go w `rpm-ostree status` jako
LayeredPackages) — jest też w tym obrazie, więc się nie zdubluje, po prostu
będzie tam dwa razy zdefiniowany bez żadnego efektu ubocznego.

## 1. Sprawdź czy masz git

```
git --version
```

Jeśli pokaże wersję — jedziesz dalej. Jeśli błąd, napisz mi, dogramy.

## 2. Rozpakuj paczkę

Pobierz `kamsola-bazzite-image.zip` (załączony w tej wiadomości), rozpakuj
np. do `~/Pobrane/kamsola-bazzite/`.

## 3. Załóż repo na GitHubie (w przeglądarce)

Wejdź na github.com (zaloguj się / załóż konto jeśli nie masz), kliknij
**New repository**. Nazwa: `kamsola-bazzite`. Zaznacz **Public**. Nie dodawaj
README/gitignore (już je masz). Kliknij **Create repository**.

## 4. Wypchnij pliki (w terminalu, w folderze z rozpakowaną paczką)

Jedna komenda na raz, czekaj na powrót `$` po każdej:

```
cd ~/Pobrane/kamsola-bazzite
```
```
git init
```
```
git add .
```
```
git commit -m "Kamsola branding"
```
```
git branch -M main
```

Teraz podmień `TWOJ-LOGIN` na swój login z GitHuba:
```
git remote add origin https://github.com/TWOJ-LOGIN/kamsola-bazzite.git
```
```
git push -u origin main
```

Poprosi o login i hasło — GitHub od pewnego czasu nie akceptuje zwykłego
hasła do pushowania, tylko **Personal Access Token**. Jeśli komenda się
wywali z błędem autoryzacji, napisz, pokażę jak zrobić token (2 minuty).

## 5. Poczekaj na build

github.com/TWOJ-LOGIN/kamsola-bazzite → zakładka **Actions** → powinien
lecieć żółty (w trakcie) workflow `build-kamsola-bazzite`. Poczekaj aż
zrobi się zielony (15–25 min). Jak jest czerwony — wklej mi log, zanim
pójdziemy dalej.

## 6. Ustaw pakiet jako publiczny

Twój profil GitHub → zakładka **Packages** → `kamsola-bazzite` →
**Package settings** (na dole) → **Change visibility** → **Public**.

## 7. Rebase — dopiero teraz, jak 5 i 6 są zrobione

```
sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/TWOJ-LOGIN/kamsola-bazzite:latest
```

Poczekaj aż się ściągnie i skończy (kilka minut), potem:

```
sudo systemctl reboot
```

## 8. Po restarcie — zanim się wylogujesz, przetestuj SDDM

Z poziomu pulpitu, w terminalu:

```
sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/kamsola
```

Jeśli komenda nie istnieje, spróbuj:
```
sddm-greeter --test-mode --theme /usr/share/sddm/themes/kamsola
```

Zobaczysz podgląd ekranu logowania w okienku. Napisz mi co widzisz.

## 9. Ikona menu Start (ręcznie, raz)

Prawy klik na przycisk Start (lewy dół) → Edytuj aplet → kliknij ikonę →
Otwórz z pliku → wskaż `/usr/share/pixmaps/kamsola-square.png` (ten plik
jest już w systemie od razu po rebase, nie trzeba nic pobierać).

## Gdyby coś poszło nie tak

- **Czarny ekran / brak logowania:** `Ctrl+Alt+F3`, zaloguj się, wpisz
  `sudo rm /etc/sddm.conf.d/kamsola.conf`, potem `sudo systemctl reboot`.
- **Cokolwiek innego wygląda źle:** `sudo rpm-ostree rollback` →
  `sudo systemctl reboot` wraca do poprzedniego, działającego stanu.

## Aktualizacje na przyszłość

```
rpm-ostree upgrade
```

To wystarczy — ściąga nowego Bazzite razem z Twoim brandingiem, bo obraz
sam w sobie jest zbudowany na najnowszym Bazzite (odświeża się co tydzień
automatycznie na GitHubie, możesz też ręcznie odpalić build z zakładki
Actions → workflow → Run workflow, jeśli chcesz aktualizację od razu).
