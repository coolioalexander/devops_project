FROM golang:1.14

WORKDIR /go/src/app
COPY ./*.go ./

RUN go get -d -v ./...
RUN go install -v ./...

EXPOSE 5000

CMD ["app"]

# docker run -it -p 5000:5000 alexandercoolio/devops_app