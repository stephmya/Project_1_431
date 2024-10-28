# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && \
    apt-get install -y \
    curl \
    build-essential \
    m4 \
    opam \
    pkg-config \
    libgmp-dev \
    libgsl-dev \
    liblapacke-dev \
    libopenblas-dev \
    git \
    sudo && \
    rm -rf /var/lib/apt/lists/*

# Initialize OPAM and install OCaml
RUN opam init --disable-sandboxing -y && \
    opam switch create 4.14.0 && \
    eval $(opam env) && \
    opam install dune owl owl-base -y

# Remove unsupported GCC options for ARM architecture
RUN eval $(opam env) && \
    if [ -f ~/.opam/4.14.0/.opam-switch/build/owl.0.7.2/src/owl/dune ]; then \
        sed -i 's/-mfpmath=sse//g' ~/.opam/4.14.0/.opam-switch/build/owl.0.7.2/src/owl/dune && \
        sed -i 's/-msse2//g' ~/.opam/4.14.0/.opam-switch/build/owl.0.7.2/src/owl/dune; \
    fi

# Set environment variables for OpenBLAS
ENV OPENBLAS_NUM_THREADS=1
ENV LD_LIBRARY_PATH=/usr/lib:/usr/local/lib

# Create a directory for your project
WORKDIR /app

# Copy your project files into the container
COPY . .

# Navigate to the calculator directory before running Dune commands
WORKDIR /app/calculator

# Build the project
RUN eval $(opam env) && dune build

# Default command to run the calculator executable
CMD ["/bin/sh", "-c", "eval $(opam env) && dune exec calculator"]
