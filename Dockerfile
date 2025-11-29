FROM ghcr.io/engineer-man/piston:latest

# Install Node.js (needed for CLI)
RUN apt-get update && apt-get install -y nodejs npm && rm -rf /var/lib/apt/lists/*

# Clone Piston repository for CLI access
WORKDIR /piston-build
RUN git clone https://github.com/engineer-man/piston.git . && \
    cd cli && npm install && cd ..

# Start the Piston API in the background
RUN piston start &
SLEEP 10

# Install runtimes using the CLI
# Python
RUN node /piston-build/cli/index.js ppman install python

# GCC (C/C++)
RUN node /piston-build/cli/index.js ppman install gcc

# Node.js (JavaScript)
RUN node /piston-build/cli/index.js ppman install node

# Clean up build artifacts
RUN rm -rf /piston-build

EXPOSE 2000

# Start Piston API
CMD ["piston", "start"]
