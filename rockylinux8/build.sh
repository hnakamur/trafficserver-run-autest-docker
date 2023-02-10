source /opt/rh/gcc-toolset-11/enable
sudo update-crypto-policies --set LEGACY

# We want to pick up the OpenSSL-QUIC version of curl in /opt/bin.
# The HTTP/3 AuTests depend upon this, so update the PATH accordingly.
export PATH=/opt/bin:${PATH}

# Change permissions so that all files are readable
# (default user umask may change and make these unreadable)
sudo chmod -R o+r .
autoreconf -fiv
./configure --enable-experimental-plugins --enable-example-plugins --prefix=/tmp/ats --enable-werror --enable-debug --enable-wccp --enable-luajit --enable-ccache
make -j4
make install
