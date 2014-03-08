# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
SCONS_MIN_VERSION="2.1.0"

inherit eutils multilib scons-utils

DESCRIPTION="Binary-decimal and decimal-binary routines for IEEE doubles"
HOMEPAGE="http://code.google.com/p/double-conversion/"
SRC_URI="http://double-conversion.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+static-libs -debug"
S=${WORKDIR}

DEPEND="
    dev-util/scons
	"

src_compile() {
	if use debug; then
		scons_opts=" debug=1"
	else
		scons_opts=" optimize=1"
	fi
	escons prefix=/usr ${scons_opts}
}

src_test() {
	escons ${scons_opts} run_test && make test || die
}


src_install() {
	#escons prefix=/tmp -j1 install
	insinto /usr/include/double-conversion
	doins ${S}/src/*.h
	insinto /usr/lib
	doins ${S}/libdouble-conversion*.so*
	if use static-libs; then
		doins ${S}/libdouble-conversion*.a
	fi
}
