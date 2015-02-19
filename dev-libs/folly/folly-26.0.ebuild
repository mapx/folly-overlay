# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils git-2

DESCRIPTION="An open-source C++ library developed and used at Facebook"
HOMEPAGE="https://github.com/facebook/folly"
EGIT_PROJECT="${PN}"
EGIT_REPO_URI="https://github.com/facebook/folly.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="mirror"

PDEPEND="sys-devel/libtool
    dev-cpp/gtest
    dev-libs/jemalloc
    app-arch/unzip
    dev-vcs/git
	>=sys-devel/gcc-4.7.3
	sys-devel/automake
	sys-devel/autoconf
	sys-devel/autoconf-archive
	dev-cpp/glog
	dev-cpp/gflags
	dev-libs/boost
	>=dev-libs/double-conversion-2.0.1[static-libs]
	"
DEPEND="${PDEPEND}"


VERSION="7d2497f0e5"

src_unpack() {
	git clone ${EGIT_REPO_URI} ${S}
}

src_prepare() {
	cd "${S}/folly"
	git checkout ${VERSION}
	#epatch "${FILESDIR}/${PV}-Makefile.am.diff"
	sed -e 's,gtest-1.6.0/include,/usr/include/gtest,' \
		-e '/^lib_LTLIBRARIES/d' \
	   	-e '/^libgtes/d' \
		-e 's/libgtestmain\.la/-lgtest_main/g' \
	   	-e 's/libgtest\.la/-lgtest/g' -i test/Makefile.am && \
	autoheader ; autoreconf ; automake --add-missing ; \
		ln -s /usr/share/libtool/config/ltmain.sh build-aux/ ; \
		autoheader ; autoreconf ; automake --add-missing || die "autoreconf failed"
}

src_compile() {
	cd "${S}/folly"
	CPPFLAGS=-I/usr/include/double-conversion/ \
		econf || die "econf failed"
	CPPFLAGS=-I/usr/include/double-conversion/ \
		emake || die "emake failed"
	CPPFLAGS=-I/usr/include/double-conversion/ \
		emake || die "emake failed"
}

src_install() {
	cd "${S}/folly"
	einstall || die "einstall failed"
}
