{stdenv, fetchgit, gettext, python, elfutils}:

stdenv.mkDerivation {
  name = "libsystemtap";
  src = fetchgit {
    url = git://sourceware.org/git/systemtap.git;
    rev = "4051c70c9318c837981384cbb23f3e9eb1bd0892";
    sha256 = "0sd8n3j3rishks3gyqj2jyqhps7hmlfjyz8i0w8v98cczhhh04rq";
    fetchSubmodules = false;
  };

  dontBuild = true;

  nativeBuildInputs = [ gettext python elfutils ];

  installPhase = ''
    mkdir -p $out/include
    cp -r includes/* $out/include/
  '';

  meta = with stdenv.lib; {
    description = "systemtap-sdt-dev - statically defined probes development files";
    homepage = http://sourceware.org/systemtap/;
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
