# # Use Ubuntu 22.04 as the base image
# FROM ubuntu:22.04

# # Set environment variables
# ENV DEBIAN_FRONTEND=noninteractive

# # Install necessary packages
# RUN apt-get update && \
#     apt-get install -y \
#     curl \
#     build-essential \
#     m4 \
#     opam \
#     pkg-config \
#     libgmp-dev \
#     libgsl-dev \
#     liblapacke-dev \
#     libopenblas-dev \
#     git \
#     sudo && \
#     rm -rf /var/lib/apt/lists/*

# # Initialize OPAM and install OCaml
# RUN opam init --disable-sandboxing -y && \
#     opam switch create 4.14.0 && \
#     eval $(opam env) && \
#     opam install dune owl owl-base opium -y

# # Set OPAM environment for all users
# RUN echo "eval $(opam env)" >> /etc/profile

# # Create a directory for your project
# WORKDIR /app

# # Install dependencies
# RUN opam install -y dune opium owl owl-base

# # Copy your project files into the container
# COPY . .

# # Navigate to the calculator directory and build the project
# WORKDIR /app/calculator

# # Clean and then build to ensure fresh creation of _build folder
# # RUN eval $(opam env) && dune clean && dune build
# RUN eval $(opam env) && dune clean && dune build @install

# # # Copy the built executable to a known location in /app
# # RUN cp _build/default/calculator/bin/server.exe /app/server.exe

# # # Set WORKDIR back to /app for the final executable location
# # WORKDIR /app

# # Build the project
# RUN dune build

# # Expose port 3000
# EXPOSE 3000
# # Run the server
# CMD ["dune", "exec", "calculator"]

# # # Default command to run the copied server executable
# # CMD ["/bin/sh", "-c", "eval $(opam env) && ./server.exe"]




# # Use Ubuntu 22.04 as the base image
# FROM ubuntu:22.04

# # Set environment variables
# ENV DEBIAN_FRONTEND=noninteractive

# # Install necessary packages
# RUN apt-get update && \
#     apt-get install -y \
#     curl \
#     build-essential \
#     m4 \
#     opam \
#     pkg-config \
#     libgmp-dev \
#     libgsl-dev \
#     liblapacke-dev \
#     libopenblas-dev \
#     git \
#     sudo && \
#     rm -rf /var/lib/apt/lists/*

# # Initialize OPAM, create a switch, and install dependencies
# RUN opam init --disable-sandboxing -y && \
#     opam switch create 4.14.0 && \
#     eval $(opam env) && \
#     opam install -y dune owl owl-base opium && \
#     echo "eval $(opam env)" >> /etc/profile && \
#     echo "eval $(opam env)" >> ~/.bashrc

# # Set the PATH to include opam binaries
# ENV PATH="/root/.opam/4.14.0/bin:${PATH}"

# # Create a directory for your project
# WORKDIR /app

# # Copy your project files into the container
# COPY . .

# # Navigate to the calculator directory and build the project
# WORKDIR /app/calculator

# # Clean and build the project with the proper environment
# RUN eval $(opam env) && dune clean && dune build @install

# # Expose port 3000 for the Opium server
# EXPOSE 3000

# # Run the server
# CMD ["sh", "-c", "eval $(opam env) && dune exec calculator"]




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

# Initialize OPAM, create a switch, and install dependencies
RUN opam init --disable-sandboxing -y && \
    opam switch create 4.14.0 && \
    eval $(opam env) && \
    opam install -y dune owl owl-base opium tyxml && \
    echo "eval $(opam env)" >> /etc/profile && \
    echo "eval $(opam env)" >> ~/.bashrc

# Set the PATH to include opam binaries
ENV PATH="/root/.opam/4.14.0/bin:${PATH}"

# Create a directory for your project
WORKDIR /app

# Copy your project files into the container
COPY . .

# Navigate to the calculator directory and build the project
WORKDIR /app/calculator

# Clean and build the project with the proper environment
RUN eval $(opam env) && dune clean && dune build @install

# Expose port 3000 for the Opium server
EXPOSE 3000

# Run the server
CMD ["sh", "-c", "eval $(opam env) && dune exec calculator"]
