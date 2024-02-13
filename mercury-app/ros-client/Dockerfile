ARG CROSS

FROM ros:noetic-ros-base

SHELL ["/bin/bash", "-c"]

# Install Cross Compilers and Curl
RUN apt-get update && apt-get install -y \
    curl \
    gcc-arm-linux-gnueabihf \
    g++-arm-linux-gnueabihf

# Install and setup rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup target add armv7-unknown-linux-gnueabihf

# Copy files to image
COPY . .

SHELL ["/bin/bash", "-c"]

# Conditionally cross compile / compile for host
RUN if [[ -z "$CROSS" ]] ; \
        then source /opt/ros/noetic/setup.bash && cargo build ; \
        else source /opt/ros/noetic/setup.bash && cargo build \
            --target armv7-unknown-linux-gnueabihf ; \
    fi;