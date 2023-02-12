source /opt/rh/gcc-toolset-11/enable
sudo update-crypto-policies --set LEGACY

# We want to pick up the OpenSSL-QUIC version of curl in /opt/bin.
# The HTTP/3 AuTests depend upon this, so update the PATH accordingly.
export PATH=/opt/bin:${PATH}

autoreconf -fiv
./configure --enable-experimental-plugins --enable-example-plugins --prefix=${ATS_PREFIX:-/tmp/ats} --enable-werror --enable-debug --enable-wccp --enable-luajit
make -j V=1
