{ pkgs }:

let
  pname = "paper-desktop";
  version = "0.1.10";
  buildId = "26031739o5exfj4";

  src = pkgs.fetchurl {
    url = "https://download.todesktop.com/2601167vjw8xe/${pname}-${version}-build-${buildId}-x86_64.AppImage";
    sha256 = "6574b48b79885ecfeb6d7692b68edff95006f77bd7fef3a02ba80fbed4d59d77";
  };

  appimageContents = pkgs.appimageTools.extractType2 {
    inherit pname version src;
  };
in
pkgs.appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    # Install desktop file
    install -Dm444 ${appimageContents}/paper-desktop.desktop $out/share/applications/paper-desktop.desktop

    # Fix desktop file paths
    substituteInPlace $out/share/applications/paper-desktop.desktop \
      --replace-warn 'Exec=AppRun' "Exec=$out/bin/${pname}" \
      --replace-warn 'Exec=paper-desktop' "Exec=$out/bin/${pname}"

    # Install icons
    cp -r ${appimageContents}/usr/share/icons $out/share/icons 2>/dev/null || true
  '';

  meta = with pkgs.lib; {
    description = "Paper - Design tool";
    homepage = "https://paper.design";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
