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
  unwrapped = pkgs.appimageTools.wrapType2 {
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

    # Upstream t3code-nix sets this false, which leaves orphaned backends
    # (PPID 1) after quit. Those hold 3773+ and ~/.t3/userdata/state.sqlite,
    # so the next launch scans to a new port and freezes on the shared DB.
    dieWithParent = true;

    extraPkgs = pkgs:
      with pkgs; [
        autoPatchelfHook
      ];
  };
in
  pkgs.symlinkJoin {
    inherit pname version;
    name = "${pname}-${version}";
    paths = [unwrapped];
    nativeBuildInputs = [pkgs.makeWrapper];
    # X11 avoids the Wayland ready-to-show hang. --no-sandbox matches the
    # upstream desktop file; Nix store chrome-sandbox is not setuid.
    # GPU disable flags do not fix the post-splash black window.
    postBuild = ''
      wrapProgram $out/bin/${pname} \
        --unset ELECTRON_RUN_AS_NODE \
        --unset ELECTRON_NO_ASAR \
        --add-flags "--no-sandbox"
    '';
    passthru = {inherit unwrapped;};
  }
