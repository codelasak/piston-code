#!/bin/bash

set -e

echo "=== Piston Setup for Fennaver Akademi ==="
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

echo "✅ Docker and Docker Compose found"
echo ""

# Determine docker-compose command
if command -v docker-compose &> /dev/null; then
    COMPOSE_CMD="docker-compose"
else
    COMPOSE_CMD="docker compose"
fi

# Create necessary directories
mkdir -p data/piston/packages data/piston/jobs

echo "✅ Created data directories"
echo ""

# Build the custom Piston image with runtimes
echo "🔨 Building Piston image with Python, GCC, and Node.js..."
echo "   ⏱️  This may take 20-40 minutes on first build..."
echo "   🔧 Installing dependencies inside container..."
echo ""

$COMPOSE_CMD build --no-cache

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Build completed successfully!"
    echo ""
    echo "🚀 Starting Piston container..."
    $COMPOSE_CMD up -d
    
    echo ""
    echo "⏳ Waiting for Piston to be ready (120 seconds)..."
    sleep 120
    
    echo ""
    echo "✅ Checking installed runtimes..."
    curl -s http://localhost:2000/api/v2/runtimes | jq '.[] | {language, version}' 2>/dev/null || curl -s http://localhost:2000/api/v2/runtimes
    
    echo ""
    echo "✅ Piston is ready!"
    echo ""
    echo "📝 Next steps:"
    echo ""
    echo "   1️⃣  Test locally:"
    echo "      curl -X POST http://localhost:2000/api/v2/execute \\"
    echo "        -H 'Content-Type: application/json' \\"
    echo "        -d '{\"language\":\"python\",\"version\":\"*\",\"files\":[{\"content\":\"print(1+1)\"}]}'"
    echo ""
    echo "   2️⃣  In your Next.js app, use endpoint:"
    echo "      https://code.dev.fennaver.tech/api/v2/execute"
    echo ""
    echo "   3️⃣  View container logs:"
    echo "      $COMPOSE_CMD logs -f piston"
    echo ""
    echo "   4️⃣  Stop/restart:"
    echo "      $COMPOSE_CMD down"
    echo "      $COMPOSE_CMD up -d"
    echo ""
else
    echo ""
    echo "❌ Build failed. Check Docker logs for details:"
    echo "   $COMPOSE_CMD logs piston"
    exit 1
fi
