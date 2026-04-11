{ pkgs }:

let
  pname = "pencil-desktop";
  version = "1.1.46";

  src = pkgs.fetchurl {
    url = "https://pencil.dev/download/Pencil-linux-x86_64.AppImage";
    sha256 = "1jwx7hls80xpd3w8bi021pnmf7n3bi4j6imhkrysijpxv1syw25f";
  };

  appimageContents = pkgs.appimageTools.extractType2 {
    inherit pname version src;
  };
in
pkgs.appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    # Install desktop file
    install -Dm444 ${appimageContents}/pencil.desktop $out/share/applications/pencil.desktop

    # Fix desktop file paths
    substituteInPlace $out/share/applications/pencil.desktop \
      --replace-warn 'Exec=AppRun --no-sandbox %U' "Exec=$out/bin/${pname} --no-sandbox %U" \
      --replace-warn 'Exec=AppRun' "Exec=$out/bin/${pname}"

    # Install icons
    cp -r ${appimageContents}/usr/share/icons $out/share/icons 2>/dev/null || true
  '';

  meta = with pkgs.lib; {
    description = "Pencil – Design on canvas. Land in code.";
    homepage = "https://pencil.dev";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
