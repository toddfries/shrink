# $OpenBSD: Makefile,v 1.3 2011/06/20 15:31:26 dhill Exp $

COMMENT=	compression wrapper library

DISTNAME=	shrink-0.2.3
PKGNAME=	lib${DISTNAME}
CATEGORIES=    	archivers devel
SHARED_LIBS=	shrink	0.1

HOMEPAGE=	http://opensource.conformal.com/wiki/Shrink	
MASTER_SITES=	http://opensource.conformal.com/snapshots/shrink/

MAINTAINER=	Conformal Systems LLC <info@conformal.com>

WANTLIB=	c crypto lzma lzo2 ssl util z
LIB_DEPENDS=	archivers/lzo2 \
		archivers/xz

NO_REGRESS=	Yes

# ISC
PERMIT_PACKAGE_CDROM=	Yes
PERMIT_PACKAGE_FTP=	Yes
PERMIT_DISTFILES_CDROM=	Yes
PERMIT_DISTFILES_FTP=	Yes

# See bsd.lib.mk:162
.if ${MACHINE_ARCH:Mmips64*}
PKG_ARGS+=	-Dno_mips64=0
.else
PKG_ARGS+=	-Dno_mips64=1
.endif 

FAKE_FLAGS=	MANDIR=${PREFIX}/man/man

do-configure:
	printf "major=${LIBshrink_VERSION:R}\nminor=${LIBshrink_VERSION:E}\n" \
            > ${WRKSRC}/libshrink/shlib_version

.include <bsd.port.mk>