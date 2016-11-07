# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

VERSION_STR=${PV#0.}

DESCRIPTION="An open-source C++ library developed and used at Facebook"
HOMEPAGE="https://github.com/facebook/folly"
SRC_URI="https://github.com/facebook/${PN}/archive/v${VERSION_STR}.tar.gz -> ${PN}-${VERSION_STR}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+static-libs shared-libs"

RDEPEND="
	app-arch/lz4:=
	app-arch/snappy:=
	app-arch/xz-utils:=
	dev-cpp/glog:=
	dev-cpp/gflags:=
	dev-libs/boost:0/1.62.0
	dev-libs/double-conversion:=
	dev-libs/jemalloc:=
	dev-libs/libevent:=
	dev-libs/openssl:0=
	>=sys-devel/gcc-4.8.5:*
	sys-libs/zlib:=
	"
DEPEND="${RDEPEND}
	dev-cpp/gtest
	"

S="${WORKDIR}/folly-${VERSION_STR}/folly"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable shared-libs shared)
	econf $(use_enable static-libs static)
}
