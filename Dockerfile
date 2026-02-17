# --- Stage 1: The Compilation Stage ---
    FROM swift:6.2-noble AS builder

    # Install make along with git
    RUN apt-get update && apt-get install -y git make
    
    WORKDIR /source
    RUN git clone https://github.com/twostraws/Ignite.git .
    
    # Use the official build and install process
    # This usually places the binary in /usr/local/bin/ignite
    RUN make && make install
    
    # --- Stage 2: The Distribution Stage ---
    FROM swift:6.2-noble
    
    # Copy the binary that 'make install' placed in the previous stage
    COPY --from=builder /usr/local/bin/ignite /usr/local/bin/ignite
    
    # Ignite requires git to manage Swift Package dependencies during 'ignite build'
    RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

    WORKDIR /app
    ENTRYPOINT ["ignite"]