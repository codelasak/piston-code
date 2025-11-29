# Piston Code Execution Engine

A containerized deployment of [Piston](https://github.com/engineer-man/piston), a high-performance general-purpose code execution engine.

## Quick Start

1. **Start the container:**
   ```bash
   docker-compose up -d
   ```

2. **Install language runtimes** (after container is running):
   ```bash
   # Make the script executable and run it
   chmod +x install-runtimes.sh
   docker exec -it piston_api /install-runtimes.sh
   ```

3. **Verify installation:**
   ```bash
   curl http://localhost:2000/api/v2/runtimes
   ```

## Usage

### API Endpoints

- **Get available runtimes:** `GET http://localhost:2000/api/v2/runtimes`
- **Execute code:** `POST http://localhost:2000/api/v2/execute`

### Example API Usage

```bash
# Execute Python code
curl -X POST http://localhost:2000/api/v2/execute \
  -H "Content-Type: application/json" \
  -d '{
    "language": "python",
    "version": "*",
    "files": [{
      "content": "print(\"Hello, World!\")"
    }]
  }'
```

### Manual Runtime Installation

You can install specific runtimes manually:

```bash
# Access the container
docker exec -it piston_api bash

# Clone Piston CLI (if not already done)
cd /tmp && git clone https://github.com/engineer-man/piston.git
cd piston/cli && npm install

# Install specific runtimes
node index.js ppman list              # List available packages
node index.js ppman install python    # Install latest Python
node index.js ppman install python=3.9.4  # Install specific version
```

## Configuration

The container is configured with:
- **Port:** 2000 (mapped to host)
- **Privileges:** Required for sandboxing
- **Resource Limits:** Configured in docker-compose.yaml
- **Persistent Storage:** Packages and jobs are stored in Docker volumes

## Security

Piston provides secure code execution through:
- Isolate sandboxing with Linux namespaces
- Process and file limits
- Network isolation
- Resource capping
- Automatic cleanup

For production use, consider additional security measures like network policies and monitoring.