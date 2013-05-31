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
IUSE="+libs"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	if use libs ; then
		cp "${FILESDIR}/SConstruct.double-conversion" "${S}/" || die
	fi
}

src_compile() {
	#scons_opts=" --cxx=$(tc-getCXX) --use-system-all --sharedclient"
	scons_opts=""
	if use libs; then
		scons_opts+=" -f SConstruct.double-conversion"
	fi
	escons ${scons_opts}
}

src_install() {
	#escons ${scons_opts} install
	use libs || rm "${D}/usr/$(get_libdir)/libdouble_conversion*.a"
	insinto /usr/include/double-conversion
	doins ${S}/src/*.h
	#insinto /usr/lib/double-conversion
	insinto /usr/lib
	doins ${S}/libdouble_conversion*.a
}
