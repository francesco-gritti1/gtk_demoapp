#!/bin/bash

./create_deb.sh
if [ $? -ne 0 ]; then
  echo "Error: unable to create .deb archieve."
  exit 1
fi

sudo apt install ./install/gtk-demoapp/gtk-demoapp.deb -y
if [ $? -ne 0 ]; then
  echo "Error: unable to install."
  exit 1
fi