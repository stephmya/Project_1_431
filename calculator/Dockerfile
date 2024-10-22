# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive \
    OPAMYES="1" \
    OPAMJOBS="2" \
    OPAMDEPEXTS_NO="true"

# Install system dependencies and required system packages
RUN apt-get update && apt-get install -y \
    build-essential \
    m4 \
    pkg-config \
    curl \
    git \
    ca-certificates \
    sudo \
    unzip \
    ocaml \
    opam \
    liblapacke-dev \
    libopenblas-dev \
    zlib1g-dev

# Initialize opam without sandboxing
RUN opam init -a --disable-sandboxing --dot-profile=/dev/null

# Install dune via opam
RUN opam install dune

# Set the working directory
WORKDIR /calculator

# Copy your project files into the container
COPY . /calculator

# Generate the opam file
RUN opam exec -- dune build @install

# Pin the local package
RUN opam exec -- opam pin add calculator . -n

# Install project dependencies specified in your opam file
RUN opam exec -- opam install . --deps-only

# Build your project using Dune
RUN opam exec -- dune build

# Set the default command to build and run your application
CMD ["opam", "exec", "--", "bash", "-c", "dune build && dune exec calculator"]
