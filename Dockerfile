FROM golang:alpine as builder

RUN mkdir /build

ADD . /build/
WORKDIR /build
RUN go build -o main .
#EXPOSE 8080
#CMD ["/build/main"]

FROM alpine
RUN mkdir /app
COPY --from=builder /build /app/
WORKDIR /app
EXPOSE 8080
CMD ["/app/main"]
