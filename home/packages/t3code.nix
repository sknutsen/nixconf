# Local copy of github:rodeyseijkens/t3code-nix package.nix without
# `pkgs = pkgs`, which makes the derivation unevaluable (entire nixpkgs
# gets coerced and hits AAAAAASomeThingsFailToEvaluate).
{
  lib,
  pkgs,
}: let
  pname = "t3code";
  version = "0.0.38";
  src = pkgs.fetchurl {
    url = "https://github.com/pingdotgg/t3code/releases/download/v${version}/T3-Code-${version}-x86_64.AppImage";
    hash = "sha256-HxzNkisu+v/VBEewKO4NbiUlUCkFCHz4rj/kHv6+NG8=";
  };
  appimageContents = pkgs.appimageTools.extract {
    inherit pname version src;
  };
in
  pkgs.appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/t3code.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/t3code.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';

    extraBwrapArgs = [
      "--bind-try /etc/nixos/ /etc/nixos/"
    ];

    dieWithParent = false;

    extraPkgs = pkgs:
      with pkgs; [
        autoPatchelfHook
      ];
  }
