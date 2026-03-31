{
  stdenv,
  fetchFromGitHub,
  gnumake,
  pkg-config,
  wayland,
  wayland-scanner,
  wayland-protocols,
  cairo,
  pango,
  json_c,
  libxkbcommon,
  glib,
  librsvg,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wswitch";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "DreamMaoMao";
    repo = "wswitch";
    rev = finalAttrs.version;
    hash = "sha256-10YVuQngFV1oucfTrny0TgEUPLbCSyjentzgNkDnXWY="; # your hash here
  };

  nativeBuildInputs = [gnumake pkg-config wayland-scanner wayland-protocols];

  buildInputs = [wayland cairo pango json_c libxkbcommon glib librsvg];

  installPhase = ''
    mkdir -p $out/bin
    install -m 755 wswitch $out/bin/wswitch

    mkdir -p $out/share/wswitch/themes
    install -m 644 themes/*.ini $out/share/wswitch/themes/

    mkdir -p $out/share/doc/wswitch
    install -m 644 config.ini.example $out/share/doc/wswitch/
    install -m 644 README.md $out/share/doc/wswitch/ 2>/dev/null || true
  '';

  meta = {
    description = "Window switcher for Wayland";
    homepage = "https://github.com/DreamMaoMao/wswitch";
    platforms = lib.platforms.linux;
  };
})
