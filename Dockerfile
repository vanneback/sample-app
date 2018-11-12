#FROM golang:alpine as builder
#
#RUN mkdir /build
#
#ADD . /build/
#WORKDIR /build
#RUN go build -o main .
#EXPOSE 8080
#CMD ["/build/main"]

FROM golang:alpine
RUN mkdir /app
ADD . /app/
WORKDIR /app
RUN go build -o main .
#COPY --from=builder /build /app/
EXPOSE 8080
CMD ["/app/main"]
