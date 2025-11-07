#!/bin/bash


git clone git@github.com:francesco-gritti1/demo_update.git


# Estrai versione dal file .deb (major.minor)
deb_version=$(dpkg --info demo_update/install/demoupdate.deb | grep Version | awk '{print $2}' | cut -d'.' -f1,2)

# Estrai versione del pacchetto installato (major.minor)
installed_version=$(dpkg -s demo-update | grep Version | awk '{print $2}' | cut -d'.' -f1,2)

echo "Deb version: $deb_version"
echo "Installed version: $installed_version"

# Funzione per confrontare versioni major.minor
version_greater() {
  IFS='.' read -r maj1 min1 <<< "$1"
  IFS='.' read -r maj2 min2 <<< "$2"

  if (( maj1 > maj2 )); then
    return 0
  elif (( maj1 < maj2 )); then
    return 1
  else
    # Se major uguale, confronta minor
    if (( min1 > min2 )); then
      return 0
    else
      return 1
    fi
  fi
}

if version_greater "$deb_version" "$installed_version"; then
  echo "New software version $deb_version found. Update"
  sudo dpkg -i demo_update/install/demoupdate.deb
else
  echo "Software is already up to date at the version $installed_version"
fi

sudo rm -r demo_update



