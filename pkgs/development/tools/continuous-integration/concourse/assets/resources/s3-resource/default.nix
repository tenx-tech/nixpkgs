{
  buildEnv,
  buildGoPackage,
  callPackage,
  dockerTools,
  fetchFromGitHub,
  pkgs,
  runCommand,
}:
let
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "concourse";
    repo = "s3-resource";
    rev = "v${version}";
    sha256 = "10wh4yszkqrgnq0apfgvg6cccnifxiphfgf1g9klzf7qdkcx75mp";
  };
  s3-resource = buildGoPackage {
    name = "docker-image-resource";
    inherit src;
    goPackagePath = "github.com/concourse/s3-resource";
    goDeps = ./deps.nix;
  };
  env = buildEnv {
    name = "system-path";
    ignoreCollisions = true;
    paths = with pkgs; [
      cacert
      gnutar
      gzip
      tzdata
      unzip
      zip
    ];
    postBuild = ''
      mkdir -p $out/opt/resource
      cp -a ${s3-resource}/bin/. $out/opt/resource/
    '';
  };

  image =
    dockerTools.buildImageWithNixDb {
      name = "s3-resource";
      tag = "latest";
      contents = env;
      config.Env = [
        "PATH=/bin"
        "GIT_SSL_CAINFO=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
        "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      ];
      extraCommands = ''
        chmod +w etc

        cat >etc/passwd <<EOF
        root:x:0:0::/root:/bin/sh
        EOF
        cat >etc/group <<EOF
        root:x:0:
        EOF
        cat >etc/nsswitch.conf <<EOF
        hosts: files dns
        EOF
      '';
    };

  dir =
    runCommand
    "s3-resource-dir"
    {
      metadata = builtins.toJSON {
        type = "s3";
        inherit version;
        privileged = false;
      };
      src = image;
      passAsFile = [ "metadata" ];
    }
    ''
      mkdir -p $out
      tar -xzf $src
      for layer in `find . -name 'layer.tar'`; do
          gzip -c $layer > $out/rootfs.tgz
      done
      cp $metadataPath $out/resource_metadata.json
    '';
in
{
  inherit dir version src;
}