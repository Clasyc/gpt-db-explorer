FROM golang:alpine as builder

WORKDIR /app

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o api .

FROM busybox

WORKDIR /app

COPY --from=builder /app/api /usr/bin/
COPY --from=builder /app/openAPI.yml ./

EXPOSE 8080

ENTRYPOINT ["api"]