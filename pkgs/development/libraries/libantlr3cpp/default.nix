{stdenv, fetchgit}:

stdenv.mkDerivation {
  name = "libantlr3cpp-3.5";
  src = fetchgit {
    url = "https://github.com/antlr/antlr3.git";
    rev = "5c2a916a10139cdb5c7c8851ee592ed9c3b3d4ff";
    sha256 = "1i0w2v9prrmczlwkfijfp4zfqfgrss90a7yk2hg3y0gkg2s4abbk";
    fetchSubmodules = false;
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/include
    cp runtime/Cpp/include/* $out/include/
  '';

  meta = with stdenv.lib; {
    description = "C++ runtime libraries of ANTLR v3";
    homepage = http://www.antlr3.org/;
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
