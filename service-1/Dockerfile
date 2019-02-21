# Multistage build
FROM node:carbon-alpine as builder

WORKDIR /app

COPY . /app
RUN npm install

# Final image
FROM node:carbon-alpine

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="gme-service1" \
      org.label-schema.description="GraphQL Microservice Example" \
      org.label-schema.url="https://github.com/renepardon/graphql-microservices-example" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/renepardon/graphql-microservices-example" \
      org.label-schema.vendor="renepardon" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

ENV PORT="8080"

WORKDIR /app

COPY --from=builder /app /app

# Do not run application as root user
RUN addgroup -g 1001 appuser && \
    adduser -D -u 1001 -G appuser appuser
RUN chown -R appuser:appuser /app
USER appuser

EXPOSE $PORT
CMD ["npm", "run", "start"]
