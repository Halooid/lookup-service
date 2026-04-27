# Production stage
FROM golang:alpine AS builder

RUN apk add --no-cache git

WORKDIR /src

COPY backend/go-shared /src/backend/go-shared
COPY backend/lookup-service /src/backend/lookup-service

WORKDIR /src/backend/lookup-service

RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux go build -o /app/lookup-service cmd/server/main.go

# Run stage
FROM alpine:3.18

RUN apk add --no-cache ca-certificates

WORKDIR /app

COPY --from=builder /app/lookup-service .
COPY --from=builder /src/backend/lookup-service/internal/db/migration ./internal/db/migration

ENV GRPC_PORT=50051

EXPOSE 50051

CMD ["./lookup-service"]
