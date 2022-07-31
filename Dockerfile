FROM centos:7 as builder

RUN yum install -y centos-release-scl
RUN yum install -y devtoolset-11
RUN yum install -y python3 unzip wget

RUN pip3 install conan meson

RUN wget https://github.com/Kitware/CMake/releases/download/v3.23.3/cmake-3.23.3-linux-x86_64.tar.gz
RUN tar xf cmake-3.23.3-linux-x86_64.tar.gz
RUN ln -s /cmake-3.23.3-linux-x86_64/bin/cmake /usr/bin/cmake

RUN wget https://github.com/ninja-build/ninja/releases/download/v1.11.0/ninja-linux.zip
RUN unzip ninja-linux.zip
RUN ln -s /ninja /usr/bin/ninja

# The following replicates what `source /opt/rh/devtoolset-11/enable` does.
ENV DEVTOOLSET_ROOT="/opt/rh/devtoolset-11/root"
ENV PATH="${DEVTOOLSET_ROOT}/usr/bin/:${PATH}"
ENV LD_LIBRARY_PATH="${DEVTOOLSET_ROOT}/usr/lib64:${LD_LIBRARY_PATH}"
ENV LD_LIBRARY_PATH="${DEVTOOLSET_ROOT}/usr/lib:${LD_LIBRARY_PATH}"
ENV LD_LIBRARY_PATH="${DEVTOOLSET_ROOT}/usr/lib64/dyninst:${LD_LIBRARY_PATH}"
ENV LD_LIBRARY_PATH="${DEVTOOLSET_ROOT}/usr/lib/dyninst:${LD_LIBRARY_PATH}"
#env PKG_CONFIG_PATH="/opt/rh/devtoolset-11/root/usr/lib64/pkgconfig:${PKG_CONFIG_PATH}"

RUN conan profile new default --detect
# cxx11 ABI just does not seem to work at all.
RUN conan profile update settings.compiler.libcxx=libstdc++ default
