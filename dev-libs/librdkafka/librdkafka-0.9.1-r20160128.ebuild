# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="The Apache Kafka C/C++ library"
HOMEPAGE="https://github.com/edenhill/librdkafka"
SRC_URI="https://github.com/edenhill/${PN}/archive/${PV}-wip1.tar.gz -> ${PF}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~x86 amd64-linux"
IUSE="+zlib +ssl +sasl +libcrypto +static-libs"

PDEPEND="
	sys-devel/gcc
	sys-libs/glibc
	zlib?      ( sys-libs/zlib )
	sasl?      ( dev-libs/cyrus-sasl )
	ssl?       ( dev-libs/openssl:= )
	libcrypto? ( dev-libs/openssl:= )
	"
DEPEND="${PDEPEND}"

S="${WORKDIR}/librdkafka-${PV}-wip1"

src_configure() {
	extra_options=" --disable-debug-symbols"
	if not use ssl; then
		extra_options+=" --disable-ssl"
	fi
	if not use sasl; then
		extra_options+=" --disable-sasl"
	fi

	econf \
		$(use_enable static-libs static) \
		${extra_options}
}
