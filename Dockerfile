FROM alpine:latest

MAINTAINER Peter Szalatnay <theotherland@gmail.com>

RUN \
    apk --update add \
    	python \
    	py-mysqldb \
    	py-twisted \
    && rm -fr /var/cache/apk/*

COPY ./clustercheck /

RUN chmod +x /clustercheck

ENTRYPOINT ["/clustercheck"]

EXPOSE 8000

CMD [">", "/dev/stdout", "&"]