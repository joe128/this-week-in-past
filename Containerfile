# # # # # # # # # # # # # # # # # # # #
# Builder
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
FROM docker.io/alpine:3 as builder

# Create a cache directory that will be copied into the final image
RUN mkdir "/cache"

# Install alpine-sdk that provides build dependencies
# Install ssl certificates that will also be copied into the final image
# Install pavao (smb client) required dependencies
# Install Rust cargo
RUN apk update && apk add --no-cache alpine-sdk ca-certificates samba-dev cargo

# Prepare build dir
RUN mkdir /app
WORKDIR /app

# Copy app sources
COPY Cargo.toml Cargo.lock /app/
COPY src/ /app/src

# Build the application
RUN CARGO_NET_GIT_FETCH_WITH_CLI=true cargo build --release

# # # # # # # # # # # # # # # # # # # #
# Run image
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
FROM scratch

ENV CACHE_DIR "/cache"
ENV RESOURCE_PATHS "/resources"

# For performance reasons write cache to docker volume instead of containers write fs layer
VOLUME /cache

# Copy required libs for the application, generated by: 'ldd /app/target/release/this-week-in-past'
COPY --from=builder /usr/lib/libsmbclient.so.0 /usr/lib/libsmbclient.so.0
COPY --from=builder /usr/lib/libgcc_s.so.1 /usr/lib/libgcc_s.so.1
COPY --from=builder /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1
COPY --from=builder /usr/lib/libndr.so.2 /usr/lib/libndr.so.2
COPY --from=builder /usr/lib/samba/liblibsmb-samba4.so /usr/lib/samba/liblibsmb-samba4.so
COPY --from=builder /usr/lib/samba/liblibcli-lsa3-samba4.so /usr/lib/samba/liblibcli-lsa3-samba4.so
COPY --from=builder /usr/lib/samba/libsamba-security-samba4.so /usr/lib/samba/libsamba-security-samba4.so
COPY --from=builder /usr/lib/samba/libmsrpc3-samba4.so /usr/lib/samba/libmsrpc3-samba4.so
COPY --from=builder /usr/lib/libsmbconf.so.0 /usr/lib/libsmbconf.so.0
COPY --from=builder /usr/lib/libsamba-util.so.0 /usr/lib/libsamba-util.so.0
COPY --from=builder /usr/lib/samba/libreplace-samba4.so /usr/lib/samba/libreplace-samba4.so
COPY --from=builder /usr/lib/libsamba-errors.so.1 /usr/lib/libsamba-errors.so.1
COPY --from=builder /usr/lib/samba/libgse-samba4.so /usr/lib/samba/libgse-samba4.so
COPY --from=builder /usr/lib/samba/libcli-smb-common-samba4.so /usr/lib/samba/libcli-smb-common-samba4.so
COPY --from=builder /usr/lib/samba/libdcerpc-samba-samba4.so /usr/lib/samba/libdcerpc-samba-samba4.so
COPY --from=builder /usr/lib/libsamba-credentials.so.1 /usr/lib/libsamba-credentials.so.1
COPY --from=builder /usr/lib/libsamba-hostconfig.so.0 /usr/lib/libsamba-hostconfig.so.0
COPY --from=builder /usr/lib/libndr-standard.so.0 /usr/lib/libndr-standard.so.0
COPY --from=builder /usr/lib/libtevent-util.so.0 /usr/lib/libtevent-util.so.0
COPY --from=builder /usr/lib/samba/libsamba3-util-samba4.so /usr/lib/samba/libsamba3-util-samba4.so
COPY --from=builder /usr/lib/samba/libsamba-debug-samba4.so /usr/lib/samba/libsamba-debug-samba4.so
COPY --from=builder /usr/lib/samba/libsecrets3-samba4.so /usr/lib/samba/libsecrets3-samba4.so
COPY --from=builder /usr/lib/libtalloc.so.2 /usr/lib/libtalloc.so.2
COPY --from=builder /usr/lib/libtevent.so.0 /usr/lib/libtevent.so.0
COPY --from=builder /usr/lib/samba/libgenrand-samba4.so /usr/lib/samba/libgenrand-samba4.so
COPY --from=builder /usr/lib/samba/libasn1util-samba4.so /usr/lib/samba/libasn1util-samba4.so
COPY --from=builder /usr/lib/samba/libkrb5samba-samba4.so /usr/lib/samba/libkrb5samba-samba4.so
COPY --from=builder /usr/lib/samba/libCHARSET3-samba4.so /usr/lib/samba/libCHARSET3-samba4.so
COPY --from=builder /usr/lib/samba/libgensec-samba4.so /usr/lib/samba/libgensec-samba4.so
COPY --from=builder /usr/lib/samba/libcliauth-samba4.so /usr/lib/samba/libcliauth-samba4.so
COPY --from=builder /usr/lib/samba/libcom_err-samba4.so.0 /usr/lib/samba/libcom_err-samba4.so.0
COPY --from=builder /usr/lib/samba/libsmb-transport-samba4.so /usr/lib/samba/libsmb-transport-samba4.so
COPY --from=builder /usr/lib/libgnutls.so.30 /usr/lib/libgnutls.so.30
COPY --from=builder /usr/lib/libdcerpc-binding.so.0 /usr/lib/libdcerpc-binding.so.0
COPY --from=builder /usr/lib/samba/libdbwrap-samba4.so /usr/lib/samba/libdbwrap-samba4.so
COPY --from=builder /usr/lib/samba/libndr-samba-samba4.so /usr/lib/samba/libndr-samba-samba4.so
COPY --from=builder /usr/lib/samba/libsamba-sockets-samba4.so /usr/lib/samba/libsamba-sockets-samba4.so
COPY --from=builder /usr/lib/samba/libutil-tdb-samba4.so /usr/lib/samba/libutil-tdb-samba4.so
COPY --from=builder /usr/lib/samba/libsocket-blocking-samba4.so /usr/lib/samba/libsocket-blocking-samba4.so
COPY --from=builder /usr/lib/samba/libutil-reg-samba4.so /usr/lib/samba/libutil-reg-samba4.so
COPY --from=builder /usr/lib/samba/libmessages-util-samba4.so /usr/lib/samba/libmessages-util-samba4.so
COPY --from=builder /usr/lib/samba/libsys-rw-samba4.so /usr/lib/samba/libsys-rw-samba4.so
COPY --from=builder /usr/lib/samba/libserver-id-db-samba4.so /usr/lib/samba/libserver-id-db-samba4.so
COPY --from=builder /usr/lib/samba/libtalloc-report-printf-samba4.so /usr/lib/samba/libtalloc-report-printf-samba4.so
COPY --from=builder /usr/lib/samba/libiov-buf-samba4.so /usr/lib/samba/libiov-buf-samba4.so
COPY --from=builder /usr/lib/samba/libmessages-dgm-samba4.so /usr/lib/samba/libmessages-dgm-samba4.so
COPY --from=builder /usr/lib/samba/libinterfaces-samba4.so /usr/lib/samba/libinterfaces-samba4.so
COPY --from=builder /usr/lib/samba/libsmbd-shim-samba4.so /usr/lib/samba/libsmbd-shim-samba4.so
COPY --from=builder /usr/lib/samba/libsamba-cluster-support-samba4.so /usr/lib/samba/libsamba-cluster-support-samba4.so
COPY --from=builder /usr/lib/samba/libtime-basic-samba4.so /usr/lib/samba/libtime-basic-samba4.so
COPY --from=builder /usr/lib/samba/libtdb-wrap-samba4.so /usr/lib/samba/libtdb-wrap-samba4.so
COPY --from=builder /usr/lib/samba/libutil-setid-samba4.so /usr/lib/samba/libutil-setid-samba4.so
COPY --from=builder /usr/lib/samba/libserver-role-samba4.so /usr/lib/samba/libserver-role-samba4.so
COPY --from=builder /usr/lib/libldap.so.2 /usr/lib/libldap.so.2
COPY --from=builder /usr/lib/libtdb.so.1 /usr/lib/libtdb.so.1
COPY --from=builder /usr/lib/liblber.so.2 /usr/lib/liblber.so.2
COPY --from=builder /usr/lib/libcap.so.2 /usr/lib/libcap.so.2
COPY --from=builder /lib/libz.so.1 /lib/libz.so.1
COPY --from=builder /usr/lib/samba/libkrb5-samba4.so.26 /usr/lib/samba/libkrb5-samba4.so.26
COPY --from=builder /usr/lib/libndr-nbt.so.0 /usr/lib/libndr-nbt.so.0
COPY --from=builder /usr/lib/samba/libaddns-samba4.so /usr/lib/samba/libaddns-samba4.so
COPY --from=builder /usr/lib/samba/libgssapi-samba4.so.2 /usr/lib/samba/libgssapi-samba4.so.2
COPY --from=builder /usr/lib/samba/libcli-cldap-samba4.so /usr/lib/samba/libcli-cldap-samba4.so
COPY --from=builder /usr/lib/samba/libauthkrb5-samba4.so /usr/lib/samba/libauthkrb5-samba4.so
COPY --from=builder /usr/lib/samba/libcli-nbt-samba4.so /usr/lib/samba/libcli-nbt-samba4.so
COPY --from=builder /usr/lib/samba/libldbsamba-samba4.so /usr/lib/samba/libldbsamba-samba4.so
COPY --from=builder /usr/lib/samba/libsamdb-common-samba4.so /usr/lib/samba/libsamdb-common-samba4.so
COPY --from=builder /usr/lib/libldb.so.2 /usr/lib/libldb.so.2
COPY --from=builder /usr/lib/samba/libasn1-samba4.so.8 /usr/lib/samba/libasn1-samba4.so.8
COPY --from=builder /usr/lib/samba/libsamba-modules-samba4.so /usr/lib/samba/libsamba-modules-samba4.so
COPY --from=builder /usr/lib/libwbclient.so.0 /usr/lib/libwbclient.so.0
COPY --from=builder /usr/lib/libsamdb.so.0 /usr/lib/libsamdb.so.0
COPY --from=builder /usr/lib/samba/libcommon-auth-samba4.so /usr/lib/samba/libcommon-auth-samba4.so
COPY --from=builder /usr/lib/libp11-kit.so.0 /usr/lib/libp11-kit.so.0
COPY --from=builder /usr/lib/libunistring.so.2 /usr/lib/libunistring.so.2
COPY --from=builder /usr/lib/libtasn1.so.6 /usr/lib/libtasn1.so.6
COPY --from=builder /usr/lib/libnettle.so.8 /usr/lib/libnettle.so.8
COPY --from=builder /usr/lib/libhogweed.so.6 /usr/lib/libhogweed.so.6
COPY --from=builder /usr/lib/libgmp.so.10 /usr/lib/libgmp.so.10
COPY --from=builder /usr/lib/samba/libmsghdr-samba4.so /usr/lib/samba/libmsghdr-samba4.so
COPY --from=builder /usr/lib/libsasl2.so.3 /usr/lib/libsasl2.so.3
COPY --from=builder /lib/libssl.so.1.1 /lib/libssl.so.1.1
COPY --from=builder /lib/libcrypto.so.1.1 /lib/libcrypto.so.1.1
COPY --from=builder /usr/lib/samba/libroken-samba4.so.19 /usr/lib/samba/libroken-samba4.so.19
COPY --from=builder /usr/lib/samba/libhx509-samba4.so.5 /usr/lib/samba/libhx509-samba4.so.5
COPY --from=builder /usr/lib/samba/libheimbase-samba4.so.1 /usr/lib/samba/libheimbase-samba4.so.1
COPY --from=builder /usr/lib/samba/libwind-samba4.so.0 /usr/lib/samba/libwind-samba4.so.0
COPY --from=builder /usr/lib/samba/libhcrypto-samba4.so.5 /usr/lib/samba/libhcrypto-samba4.so.5
COPY --from=builder /usr/lib/samba/libclidns-samba4.so /usr/lib/samba/libclidns-samba4.so
COPY --from=builder /usr/lib/samba/libcli-ldap-common-samba4.so /usr/lib/samba/libcli-ldap-common-samba4.so
COPY --from=builder /usr/lib/libndr-krb5pac.so.0 /usr/lib/libndr-krb5pac.so.0
COPY --from=builder /usr/lib/samba/libflag-mapping-samba4.so /usr/lib/samba/libflag-mapping-samba4.so
COPY --from=builder /usr/lib/samba/libwinbind-client-samba4.so /usr/lib/samba/libwinbind-client-samba4.so
COPY --from=builder /usr/lib/samba/libMESSAGING-SEND-samba4.so /usr/lib/samba/libMESSAGING-SEND-samba4.so
COPY --from=builder /usr/lib/libjansson.so.4 /usr/lib/libjansson.so.4
COPY --from=builder /usr/lib/libffi.so.8 /usr/lib/libffi.so.8

# Create an empty cache directory
COPY --chown=1337:1337 --from=builder /cache /cache

# Copy ssl certificates to the scratch image to enable HTTPS
COPY --chown=1337:1337 --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Copy the built application from the host to the container
COPY --chown=1337:1337 --from=builder /app/target/release/this-week-in-past /this-week-in-past

# Copy the static html website data from the host to the container
COPY --chown=1337:1337 web-app /web-app

EXPOSE 8080
USER 1337

CMD ["/this-week-in-past"]
