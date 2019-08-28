{
  buildGoPackage,
  callPackage,
  fetchFromGitHub,
  go-packr,
  stdenv,
}:

let

  version = "5.4.1";

  src = fetchFromGitHub {
    repo = "concourse";
    owner = "concourse";
    rev = "v${version}";
    sha256 = "0000000000000000000000000000000000000000000000000000";
  };

  main-asset = callPackage ./assets/main {
    inherit src;
  };

  resources = import ./assets/resources { inherit callPackage fly; };

  mkResourcesDir = callPackage ./assets/resources/make-resource-dir.nix {};

  resourceDir = mkResourcesDir resources;

  buildConcourse = { name, packages, platforms, passthru ? {}, preBuild ? "" }:
    let
      preBuild_ = preBuild;
    in
    buildGoPackage rec {
      inherit name version;
      goPackagePath = "github.com/concourse/concourse";
      subPackages = packages;
      goDeps = ./deps.nix;
      nativeBuildInputs = [ go-packr ];
      inherit src passthru;
      preBuild = ''
        rm -rf $NIX_BUILD_TOP/go/src/github.com/concourse/dex/vendor/github.com/lib/pq
        ${preBuild_}
      '';

      buildFlagsArray = ''
        -ldflags=
        -X github.com/concourse/concourse.Version=${version}
      '';

      meta = {
        inherit platforms;
        license = stdenv.lib.licenses.asl20;
        maintainers = with stdenv.lib.maintainers; [ edude03 dxf ];
      };
    };

  fly = buildConcourse {
    name = "fly-${version}";
    packages = [ "fly" ];
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
in
{
  concourse = buildConcourse {
    name = "concourse-${version}";
    passthru = {
      inherit resources main-asset mkResourcesDir resourceDir;
    };
    packages = [ "cmd/concourse" ];
    platforms = stdenv.lib.platforms.linux;
    preBuild =''
      cp -R ${main-asset}/. go/src/github.com/concourse/concourse/web/
      packr -i go/src/github.com/concourse
    '';
  };

  inherit fly;
}
