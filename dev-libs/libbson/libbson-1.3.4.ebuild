# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools eutils

DESCRIPTION="A BSON utility library"
HOMEPAGE="https://github.com/mongodb/libbson"
SRC_URI="https://github.com/mongodb/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~hppa ~x86"
IUSE="static-libs -debug +man-pages"

DEPEND=""
RDEPEND="${DEPEND}
	man-pages? ( app-text/yelp-tools )
"

src_prepare() {
	# https://github.com/mongodb/mongo-c-driver/issues/54
	sed -i -e "s/PTHREAD_LIBS/PTHREAD_CFLAGS/g" src/bson/Makefile.am \
		tests/Makefile.am || die
	eautoreconf
}

src_configure() {
	econf $(use_enable debug) \
		$(use_enable static-libs static) \
		 $(use_enable man-pages) \
		 --enable-silent-rules
}

src_install() {
	emake DESTDIR="${D}" install
	if use man-pages; then
		find "${D}"/usr/share/man/man3 -type f -not -name 'bson_*.3*' -exec rm {} \;
	else
		rm -rf "${D}"/usr/share
	fi
	use static-libs || find "${D}" -name '*.la' -delete
}
