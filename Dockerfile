FROM nvidia/cuda:11.1-runtime-ubuntu18.04

RUN HOST="192.168.1.106" && \
    apt-get update && \
    apt-get install -y --no-install-recommends curl && \
\
    curl http://$HOST:8080/cinema4d_23.008-RB323902_amd64.deb -o cinema4d.deb && \
    curl http://$HOST:8080/redshift_v3.0.31_linux_demo.run -o redshift.run && \
    chmod +x redshift.run && \
\
    apt-get install -y /cinema4d.deb && \
    rm cinema4d.deb && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/* && \
    echo accept | /redshift.run && \
    rm redshift.run && \
    mkdir $(ls -d /opt/maxon/*/bin)/plugins && \
    cp -r /usr/redshift/redshift4c4d/R21/Redshift $(ls -d /opt/maxon/*/bin/plugins) && \
    ln -s /usr/redshift/bin/redshiftCmdLine /usr/local/bin/

COPY c4d /
ENTRYPOINT ["/c4d"]