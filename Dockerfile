# Original credits:
# - https://github.com/jpetazzo/dockvpn
# - https://github.com/kylemanna/docker-openvpn

# Smallest base image
FROM alpine:3.17

LABEL org.opencontainers.image.authors="alikasundara <https://github.com/alikasundara>"

RUN apk add --update --no-cache openssl=3.0.8-r4 openvpn=2.5.8-r0 iptables=1.8.8-r2 easy-rsa=3.1.1-r0 openvpn-auth-pam=2.5.8-r0 google-authenticator=1.09-r2 libqrencode=4.1.1-r1 bash=5.2.15-r0 && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

# Needed by scripts
ENV OPENVPN=/etc/openvpn
ENV EASYRSA=/usr/share/easy-rsa \
    EASYRSA_CRL_DAYS=3650 \
    EASYRSA_PKI=$OPENVPN/pki

VOLUME ["/etc/openvpn"]

# Internally uses port 1194/udp, remap using `docker run -p 443:1194/tcp`
EXPOSE 1194/udp

CMD ["ovpn_run"]

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*

# Add support for OTP authentication using a PAM module
ADD ./otp/openvpn /etc/pam.d/
