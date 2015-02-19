# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
SCONS_MIN_VERSION="1.2.0"

inherit eutils flag-o-matic multilib scons-utils versionator

MY_P=legacy-${PV}

DESCRIPTION="C++ Driver for MongoDB"
HOMEPAGE="https://github.com/mongodb/mongo-cxx-driver"
SRC_URI="https://github.com/mongodb/mongo-cxx-driver/archive/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="kerberos +sharedclient ssl"

RDEPEND="
	app-arch/snappy
	>=dev-libs/boost-1.50[threads(+)]
	>=dev-libs/libpcre-8.30[cxx]
	dev-util/google-perftools[-minimal]
	ssl? ( >=dev-libs/openssl-1.0.1g )"
DEPEND="${RDEPEND}
	kerberos? ( dev-libs/cyrus-sasl[kerberos] )"

S=${WORKDIR}/${PN}-${MY_P}

pkg_setup() {
	scons_opts="--variant-dir=build --cc=$(tc-getCC) --cxx=$(tc-getCXX)"
	scons_opts+=" --disable-warnings-as-errors"
	scons_opts+=" --c++11=auto"
	# Enable compile-time optimization
	scons_opts+=" --opt=on"

	if use kerberos; then
		scons_opts+=" --use-sasl-client"
	fi

	if use sharedclient; then
		scons_opts+=" --sharedclient"
	fi

	if use ssl; then
		scons_opts+=" --ssl"
	fi
}

src_prepare() {
	# fix yaml-cpp detection
	sed -i -e "s/\[\"yaml\"\]/\[\"yaml-cpp\"\]/" SConstruct || die

	# bug #462606
	sed -i -e "s@\$INSTALL_DIR/lib@\$INSTALL_DIR/$(get_libdir)@g" src/SConscript.client || die
}

src_compile() {
	escons ${scons_opts}
}

src_install() {
	escons ${scons_opts} install --prefix="${ED}"/usr

	use sharedclient && find "${ED}"/usr/ -type f -name "*.a" -delete

	dodoc README.md CONTRIBUTING.md
}

pkg_preinst() {
	# wrt bug #461466
	if [[ "$(get_libdir)" == "lib64" ]]; then
		rmdir "${ED}"/usr/lib/ &>/dev/null
	fi
}
