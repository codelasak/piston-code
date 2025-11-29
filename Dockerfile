FROM ghcr.io/engineer-man/piston:latest

# The base image already includes everything needed to run Piston
# Runtimes can be installed after startup via the API or CLI

EXPOSE 2000

# Start Piston API
CMD ["piston", "start"]
