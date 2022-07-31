# cpp-builder

This repository contains a CentOS7 based Docker image, that includes GCC 11.2.1, python 3.7.8, conan, meson, cmake 3.23.3 and ninja 1.11.

Building portable C++ applications is not trivial. Linking against glibc statically is discouraged and glibc is not forwards-compatible, so when building you need to link against the oldest version you wish to support.

A few of the older distros still being used (like RHEL7 and CentOS7) use glibc 2.17, so I wanted to target that glibc version.

The compiler included in the package repositories for such old distros is usually similarly ancient, so you need to get a newer compiler yourself. Thankfully there are "devtoolsets" for RHEL and CentOS, which provide these newer compilers.

If you use this image to build your executable and link everything else statically (including libstdc++ with `-static-libstdc++`, but not libgcc - see [here](https://github.com/phusion/holy-build-box/blob/master/ESSENTIAL-SYSTEM-LIBRARIES.md)), you *should* have fairly portable executables that should run on almost any (glibc-based) Linux system that people actually use.

## Important Note on CXX11 ABI
This image compiles your code with the old (non-cxx11) ABI. libstdc++ had an ABI break from version 4 to 5, because C++ demanded certain complexity requirements on the `std::string` and `std::list` that forced the implementation to not use copy-on-write (COW) anymore. Instead the new implementation provides small string optimization (SSO). RHEL 6 and 7 fully disable the usage of `_GLIBCXX_USE_CXX11_ABI` ([Red Hat Bugzilla](https://bugzilla.redhat.com/show_bug.cgi?id=1546704)), which can be used to control the usage of the new cxx11 ABI (note that the compiler and libstdc++ in the image are more than recent enough), so maybe this is what's going on in CentOS 7 as well, because using the macro has no effect on the symbols that end up in the object files.

Depending on what you do this might be relevant for you, or even a deal-breaker. It might even have performance implications.
