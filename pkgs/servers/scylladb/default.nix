{ stdenv,
  fetchgit,
  python3Packages,
  python3,
  pkgconfig,
  gcc8,
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
let
  thriftNixpkgs = fetchgit {
    name = "thrift-0.10";
    url = https://github.com/nixos/nixpkgs/;
    rev = "fbaa12bad90e3c8726a5427fdd981dc60c7f08ff";
  };
  thriftPkgs = import thriftNixpkgs {};
in
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
   gcc8
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
   thriftPkgs.thrift
  ];

  configurePhase = ''
     patchShebangs ./configure.py
    ./configure.py --mode=release
  '';
  buildPhase = ''
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
