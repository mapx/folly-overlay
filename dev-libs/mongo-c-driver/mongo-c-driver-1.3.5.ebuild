# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools eutils

DESCRIPTION="A high-performance MongoDB driver for C"
HOMEPAGE="https://github.com/mongodb/mongo-c-driver"
SRC_URI="https://github.com/mongodb/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~hppa ~x86"
IUSE="debug man-pages sasl ssl static-libs test"

RDEPEND="=dev-libs/libbson-${PV}[debug=,static-libs=]
	man-pages?  ( app-text/yelp-tools )
	sasl? ( dev-libs/cyrus-sasl )
	ssl?  ( dev-libs/openssl:= )"
DEPEND="${RDEPEND}
	test? ( dev-db/mongodb )"

src_prepare() {
	rm -r src/libbson || die
	sed -i -e '/SUBDIRS/s:src/libbson::g' Makefile.am || die

	# https://github.com/mongodb/mongo-c-driver/issues/54
	sed -i -e "s/PTHREAD_LIBS/PTHREAD_CFLAGS/g" src/Makefile.am \
		tests/Makefile.am || die
	eautoreconf
}

src_configure() {
	extra_options=" --enable-silent-rules"
	if use debug; then
		extra_options+=" --enable-debug-symbols=full"
	fi

	econf --with-libbson=system \
		--disable-example \
		$(use_enable man-pages) \
		$(use_enable sasl) \
		$(use_enable ssl) \
		$(use_enable debug) \
		$(use_enable static-libs static) \
		${extra_options}
}

src_install() {
	emake DESTDIR="${D}" install

	if use man-pages; then
		find "${D}"/usr/share/man/man3 -type f -not -name 'mongoc_*.3*' -exec rm {} \;
	else
		rm -rf "${D}"/usr/share
	fi

	use static-libs || find "${D}" -name '*.la' -delete
}

src_test() {
	# Avoid allocating too much disk space by using server.smallFiles = 1
	echo -e "storage:\n    smallFiles: true" > "${T}/mongod.conf"
	local PORT=27099
	mongod --port ${PORT} --bind_ip 127.0.0.1 --nounixsocket --fork \
		-f "${T}/mongod.conf" --dbpath="${T}" \
		--logpath="${T}/mongod.log" || die
	MONGOC_TEST_HOST="127.0.0.1:${PORT}" emake test
	kill `cat "${T}/mongod.lock"`
}
