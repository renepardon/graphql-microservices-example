# Multistage build
FROM node:carbon-alpine as builder

WORKDIR /app

COPY . /app
RUN npm install

# Final image
FROM node:carbon-alpine

WORKDIR /app

COPY --from=builder /app /app

# Do not run application as root user
RUN chown -R 1001:1001 /app
USER 1001

EXPOSE 8080
CMD ["npm", "run", "start"]
