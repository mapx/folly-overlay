# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

DESCRIPTION="An open-source C++ library developed and used at Facebook"
HOMEPAGE="https://github.com/facebook/folly"
SRC_URI="https://github.com/facebook/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+static-libs +shared-libs"

PDEPEND="
	app-arch/lz4
	app-arch/snappy
    app-arch/unzip
	app-arch/xz-utils
	dev-cpp/glog
	dev-cpp/gflags
    dev-cpp/gtest
	dev-libs/boost
    dev-libs/jemalloc
	dev-libs/libevent
	dev-libs/openssl
	dev-libs/double-conversion
	sys-devel/libtool
	sys-libs/zlib
	"
DEPEND="${PDEPEND}"

S="${WORKDIR}/${P}/folly"

src_prepare() {
	autoreconf -ivf
}


src_configure() {
	    econf \
			$(use_enable static-libs ) \
			$(use_enable shared-libs ) \
			--with-gnu-ld
}
