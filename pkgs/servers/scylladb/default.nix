{ stdenv,
  fetchgit,
  python3Packages,
  python3,
  pkgconfig,
  gcc,
  boost,
  git,
  systemd,
  gnutls,
  cmake,
  makeWrapper,
  ninja,
  ragel,
  hwloc,
  jsoncpp,
  thrift,
  libantlr3cpp,
  antlr3,
  numactl,
  protobuf,
  cryptopp,
  libxfs,
  libyamlcpp,
  libsystemtap,
  lksctp-tools,
  lz4,
  libxml2,
  zlib,
  libpciaccess,
  snappy,
  libtool
}:
stdenv.mkDerivation rec {
  name = "scylladb-${version}";
  version = "3.0.5";

  src = fetchgit {
    url = "https://github.com/scylladb/scylla.git";
    rev = "403f66ecad6bc773712c69c4a80ebd172eb48b13";
    sha256 = "14mg0kzpkrxvwqyiy19ndy4rsc7s5gnv2gwd3xdwm1lx1ln8ywsi";
    fetchSubmodules = true;
  };

  patches = [ ./seastar-configure-script-paths.patch ];

  nativeBuildInputs = [
   python3Packages.pyparsing
   pkgconfig
   python3
   gcc
   boost
   git
   systemd
   gnutls
   cmake
   makeWrapper
   ninja
   ragel
   hwloc
   jsoncpp
   libantlr3cpp
   numactl
   antlr3
   protobuf
   cryptopp
   libxfs
   libyamlcpp
   libsystemtap
   lksctp-tools
   lz4
   libxml2
   zlib
   libpciaccess
   snappy
   libtool
   thrift
  ];

  configurePhase = ''
     patchShebangs ./configure.py
    ./configure.py --mode=release
  '';
  buildPhase = ''
    echo "BUIDLING"
    ninja -j "$NIX_BUILD_CORES" -v
  '';
  installPhase = ''
    echo "installing"
  '';
  meta = with stdenv.lib; {
    description = "NoSQL data store using the seastar framework, compatible with Apache Cassandra";
    homepage = http://scylladb.com;
    license = licenses.agpl3;
    platforms = stdenv.lib.platforms.linux;
  };
}
