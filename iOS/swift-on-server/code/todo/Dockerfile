FROM ibmcom/swift-ubuntu:3.1.1
MAINTAINER joker
LABEL Description="todolist app with CouchDB"

# Expose default port for Kitura
EXPOSE 8080

RUN mkdir /root/todo

ADD Sources /root/todo/Sources
ADD Package.swift /root/todo

RUN cd /root/todo && swift build

USER root
CMD [ "sh", "-c", "cd /root/todo && .build/debug/todo" ]
