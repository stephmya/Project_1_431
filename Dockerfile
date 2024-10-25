# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update the system and install dependencies
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

# Set OPAM environment for all users
RUN echo "eval $(opam env)" >> /etc/profile

# Create a directory for your project
WORKDIR /app

# Copy your project files into the container
COPY . .

# Navigate to the calculator directory before running Dune commands
WORKDIR /app/calculator

# Build the project (removed @install step)
RUN eval $(opam env) && dune build

# Default command to run the calculator executable
CMD ["/bin/sh", "-c", "eval $(opam env) && dune exec calculator"]
