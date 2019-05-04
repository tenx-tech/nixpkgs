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
  haskell,
  haskellPackages,
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

  # TODO: Learn to use https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/haskell.section.md#how-to-override-package-versions-in-a-compiler-specific-package-set to override hackage network version to http://hackage.haskell.org/package/network-2.5.0.0
  fixedCassandraThrift = haskell.lib.dontCheck (haskellPackages.cassandra-thrift);

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
   fixedCassandraThrift
  ];

  configurePhase = ''
    ./configure.py --mode=release
  '';
  buildPhase = ''
    #ninja -j "$NIX_BUILD_CORES" -v
    ninja -j 2
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
