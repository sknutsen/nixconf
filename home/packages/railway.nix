{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeBinaryWrapper,
  openssl,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "railway";
  version = "5.57.8";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = "cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-R8wM1BOfIeOPZh0VDe/y/Xrud9+VDcTV2AVN5TKncb0=";
  };

  cargoHash = "sha256-gODbXkyG7/KH67rRPO/wFHyxkFrjPz9I3D2F1bVTMq8=";

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
  ];

  buildInputs = [openssl];

  env.OPENSSL_NO_VENDOR = 1;

  # Upstream tests expect a writable home, SSH, and agent harnesses that
  # the Nix sandbox does not provide.
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/railway \
      --set RAILWAY_NO_AUTO_UPDATE true
  '';

  meta = {
    mainProgram = "railway";
    description = "Railway.app CLI";
    homepage = "https://github.com/railwayapp/cli";
    changelog = "https://github.com/railwayapp/cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Crafter
      techknowlogick
    ];
  };
})
