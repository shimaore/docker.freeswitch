FROM shimaore/freeswitch:4.0.1
COPY conf/ /opt/freeswitch/conf
CMD ["/opt/freeswitch/bin/freeswitch","-c","-nosql","-nonat","-nonatmap","-nocal","-nort"]
EXPOSE 8021/tcp 5060/udp
