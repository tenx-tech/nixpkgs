{ stdenv, fetchgit, pythonPackages, python3, pkgconfig, gcc, boost, git, systemd, gnutls, cmake }:
stdenv.mkDerivation rec {
  name = "scylladb-${version}";
  version = "3.0.5";

  src = fetchgit {
    url = "https://github.com/scylladb/scylla.git";
    rev = "403f66ecad6bc773712c69c4a80ebd172eb48b13";
    sha256 = "14mg0kzpkrxvwqyiy19ndy4rsc7s5gnv2gwd3xdwm1lx1ln8ywsi";
    fetchSubmodules = true;
  };


  nativeBuildInputs = [ pythonPackages.pyparsing python3 pkgconfig gcc boost git systemd gnutls cmake ];
  installPhase = ''
    ./configure.py --mode=release
    #mkdir -p $out
    #cp -R * $out
  '';
  meta = with stdenv.lib; {
    description = "NoSQL data store using the seastar framework, compatible with Apache Cassandra";
    homepage = http://scylladb.com;
    license = licenses.agpl3;
    platforms = stdenv.lib.platforms.linux;
  };
}
