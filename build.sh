#!/bin/bash

[ ! "${EUID}" = "0" ] && {
  echo "Execute esse script como root:"
  echo
  echo "  sudo ${0}"
  echo
  exit 1
}

HERE="$(dirname "$(readlink -f "${0}")")"

working_dir=$(mktemp -d)

mkdir -p "${working_dir}/usr/bin"            \
         "${working_dir}/usr/share/applications/"     \
         "${working_dir}/DEBIAN"

cp "${HERE}/src/font-installer.sh"    "${working_dir}/usr/bin/font-installer-gui"
cp "${HERE}/src/launcher.desktop"     "${working_dir}/usr/share/applications/font-installer.desktop"

chmod a+x "${working_dir}/usr/bin/font-installer-gui"

(echo "Package: instalador-de-fontes"
 echo "Priority: optional"
 echo "Version: 1.0"
 echo "Architecture: all"
 echo "Maintainer: Natanael Barbosa Santos"
 echo "Depends: yad, imagemagick"
 echo "Description: $(cat ${HERE}/README.md  | sed -n '1p')"
 echo
) > "${working_dir}/DEBIAN/control"

dpkg -b ${working_dir}
rm -rfv ${working_dir}

mv "${working_dir}.deb" "${HERE}/instalador-de-fontes.deb"

chmod 777 "${HERE}/instalador-de-fontes.deb"
chmod -x  "${HERE}/instalador-de-fontes.deb"


