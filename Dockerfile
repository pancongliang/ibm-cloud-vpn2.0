FROM quay.io/fedora/fedora:39-x86_64

ENV RUNIT='MotionPro_Linux_RedHat_x64_build-8.sh'

COPY entrypoint.sh /
COPY $RUNIT /

RUN dnf install iproute systemd procps-ng openssh-clients bind-utils iputils -y && \
    chmod +x $RUNIT && \
    ./$RUNIT && \
    rm $RUNIT

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "--help" ]
