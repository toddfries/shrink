# port specific config data
name=shrink
port=libshrink
category=archivers

# local override variables
# PACKAGE_DATA_DIR - defaults to ~/package_data if not specified
# PACKAGE_DEST_DIR - no default - no action taken if not specified
[ "${PACKAGE_DATA_DIR}" = "" ] && PACKAGE_DATA_DIR=~/package_data

# local derived variables 
NAME=$(echo $name | tr '[a-z]' '[A-Z]')
PORT=$(echo $port | tr '[a-z]' '[A-Z]')

mkdir -p ${PACKAGE_DATA_DIR}
[ $? -ne 0 ] && exit 4
rev_file=${PACKAGE_DATA_DIR}/${name}.rev
VERSION=$(cd ../.. && sh version.sh)

EPOCH=$(grep EPOCH ${category}/${port}/Makefile | sed -e 's/.*=[^0-9]*//g' -e 's/[ \t]*//g')
DISTNAME=$(grep DISTNAME ${category}/${port}/Makefile | sed -e 's/.*=[^0-9]*//g' -e 's/[ \t]*//g')

if [ "${EPOCH}" = "" ]
then
	epoch=""
else
	epoch="v${EPOCH}"
fi

if [ -f ${rev_file} ]
then
    . ${rev_file} 
else
    version=-1.-1.-1
fi

if [ ${DISTNAME} != "${VERSION}" ]
then
	echo "VERSION does not match distfile ver: ${VERSION} ${DISTNAME}"
	exit 8
fi

if [ "${PORTSDIR}" = "" ]
then
	export PORTSDIR=/usr/ports
fi

rm -f ${name}-${VERSION}.tar.gz
rm -f ${name}-${VERSION}
rm -rf $(uname -m)
rm -rf bld
mkdir bld
export WRKOBJDIR=${PWD}/bld

ln -s ../.. ${name}-${VERSION}
tar czf ${name}-${VERSION}.tar.gz ${name}-${VERSION}/*

ls -l  ${name}-${VERSION}.tar.gz

export PORTSDIR_PATH=${PWD}:${PACKAGE_DATA_DIR}:${PORTSDIR}
export DISTDIR=${PWD}
export PACKAGE_REPOSITORY=${PWD}

#bump rev 
if [ "${VERSION}" = "${version}" ]
then
    if [ "${revision}" == "" ]
    then
	revision=0
    else
	revision=$(expr ${revision} + 1)
    fi
    prevision=p${revision}
    export REVISION=${revision}
else
    unset revision
    prevision=""
fi

(cd ${category}/${port} && rm distinfo && touch distinfo && make makesum)
(cd ${category}/${port} && make)
(cd ${category}/${port} && make package install)
(cd ${category}/${port} && rm -f distinfo && touch distinfo)

echo "version=${VERSION}" >${rev_file}
if [ "${revision}" != "" ]
then
    echo "revision=${revision}" >>${rev_file}
fi
rm -rf ${PACKAGE_DATA_DIR}/${category}/${port}
cp -r ${category} ${PACKAGE_DATA_DIR}

if [ "${PACKAGE_DEST_DIR}" != "" ]
then
	scp $(uname -m)/all/${port}-${VERSION}${prevision}${epoch}.tgz  \
	    ${PACKAGE_DEST_DIR}
fi

ls -l $(uname -m)/all/${port}-${VERSION}${prevision}${epoch}.tgz

rm -f ${name}-${VERSION}