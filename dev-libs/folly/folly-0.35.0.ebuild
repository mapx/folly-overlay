# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="An open-source C++ library developed and used at Facebook"
HOMEPAGE="https://github.com/facebook/folly"
SRC_URI="https://github.com/facebook/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="-experimental-fibers"

PDEPEND="
	app-arch/lz4
	app-arch/snappy
    app-arch/unzip
	app-arch/xz-utils
	dev-cpp/glog
	dev-cpp/gflags
    dev-cpp/gtest
	experimental-fibers? ( >=dev-libs/boost-1.57.0 )
	!experimental-fibers? ( >=dev-libs/boost-1.55.0 )
    dev-libs/jemalloc
	dev-libs/libevent
	dev-libs/openssl
	>=dev-libs/double-conversion-2.0.1[static-libs]
	sys-devel/libtool
	sys-devel/automake
	sys-devel/autoconf
	sys-devel/autoconf-archive
	>=sys-devel/gcc-4.8.0
	sys-libs/zlib
	"
DEPEND="${PDEPEND}"

S="${WORKDIR}/${P}/folly"

src_prepare() {
	use experimental-fibers || epatch "${FILESDIR}/${P}-remove-experimental-fibers.patch"
	autoreconf -ivf
}
