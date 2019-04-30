# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "SoftPosit"
version = v"0.4.1"

# Collection of sources required to build SoftPosit
sources = [
    "https://gitlab.com/cerlane/SoftPosit/-/archive/$version/SoftPosit-$version.tar.gz" =>
    "13f7360c5b91ad3704f66537a754ba3748a764e1291eaa33940866ca37c7dbf5",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/SoftPosit-*/build/Linux-x86_64-GCC/
if [[ "${target}" == *darwin* ]]; then
    make COMPILER="$CC" SLIB=".dylib" julia
elif [[ "${target}" == *mingw* ]]; then
    make COMPILER="$CC" SLIB=".dll" julia
else
    make julia
fi
cp softposit.* $prefix/
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:x86_64, libc=:glibc),
    FreeBSD(:x86_64),
    MacOS(:x86_64),
    Windows(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "softposit", :libsoftposit)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

