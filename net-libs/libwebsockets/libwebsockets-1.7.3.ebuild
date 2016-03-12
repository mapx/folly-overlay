# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="canonical libwebsockets.org websocket library"
HOMEPAGE="https://libwebsockets.org/"
SRC_URI="https://github.com/warmcat/libwebsockets/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="libwebsockets"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-util/cmake
	dev-libs/openssl
	"
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-no_ecdh_h_file.patch # 457
}
