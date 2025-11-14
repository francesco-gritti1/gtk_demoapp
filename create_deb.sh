#!/bin/bash


APP_NAME="gtk_demoapp"
PKG_NAME="gtk-demoapp"


mkdir -p install
mkdir -p install/$PKG_NAME
mkdir -p install/$PKG_NAME/DEBIAN
mkdir -p install/$PKG_NAME/usr
mkdir -p install/$PKG_NAME/usr/local
mkdir -p install/$PKG_NAME/usr/local/bin

mkdir -p install/$PKG_NAME/etc
mkdir -p install/$PKG_NAME/etc/systemd
mkdir -p install/$PKG_NAME/etc/systemd/system/



make config=release -j4
if [ $? -ne 0 ]; then
  echo "Error: compilation error."
  exit 1
fi

cp ./bin/Release/$APP_NAME ./install/$PKG_NAME/usr/local/bin
if [ $? -ne 0 ]; then
  echo "Error: unable to copy executables."
  exit 1
fi



VERSION_HEADER="./src/VERSION.h"
CONTROL_FILE="install/$PKG_NAME/DEBIAN/control"

# Estrai valori MAJ e MIN dal file VERSION.h
MAJ=$(grep '#define ver_MAJ' "$VERSION_HEADER" | awk '{print $3}')
MIN=$(grep '#define ver_MIN' "$VERSION_HEADER" | awk '{print $3}')

if [[ -z "$MAJ" ]] || [[ -z "$MIN" ]]; then
    echo "Errore: non sono riuscito a trovare MAJ o MIN in $VERSION_HEADER"
    exit 1
fi

VERSION="${MAJ}.${MIN}"
sed -i "s/^Version: .*/Version: $VERSION/" "$CONTROL_FILE"
echo "Versione aggiornata a $VERSION nel file $CONTROL_FILE"



# build .deb package
dpkg --build install/$PKG_NAME
if [ $? -ne 0 ]; then
  echo "Error: unable to create .deb archieve."
  exit 1
fi



