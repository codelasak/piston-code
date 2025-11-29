FROM ghcr.io/engineer-man/piston:latest

# Install Node.js (needed for CLI)
RUN apt-get update && apt-get install -y nodejs npm && rm -rf /var/lib/apt/lists/*

# Clone Piston repository for CLI access
WORKDIR /piston-build
RUN git clone https://github.com/engineer-man/piston.git . && \
    cd cli && npm install && cd ..

# Install runtimes using the CLI in a single RUN command
# This approach starts piston, waits, installs runtimes, then stops it
RUN piston start & \
    sleep 15 && \
    node /piston-build/cli/index.js ppman install python && \
    node /piston-build/cli/index.js ppman install gcc && \
    node /piston-build/cli/index.js ppman install node && \
    pkill -f piston || true

# Clean up build artifacts
RUN rm -rf /piston-build

EXPOSE 2000

# Start Piston API
CMD ["piston", "start"]
