# MegaCMD Docker for Alpine Linux

This repository provides a Dockerfile to build [MegaCMD](https://mega.io/cmd) for Alpine Linux. MegaCMD is a command-line interface (CLI) for the MEGA.nz cloud storage service, allowing users to interact with their MEGA.nz account from the terminal.

**The reason:** The Mega team currently doesn't provide a MegaCMD build for Alpine Linux. There is a MegaCMD community package, but it doesn't support WebDAV. This repository was created to build MegaCMD with WebDAV support for Alpine Linux on both x86 and aarch64 platforms.

[![Docker Pulls](https://img.shields.io/docker/pulls/roinj/megacmd-alpine.svg)](https://hub.docker.com/r/roinj/megacmd-alpine/)

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [License](#license)

## Installation

Before you begin, ensure you have the Docker installed on your machine: [Install Docker](https://docs.docker.com/get-docker/).

### Pull the image from Docker Hub 

To pull the pre-built image from Docker Hub, run the following command:

```sh
docker pull roinj/megacmd-alpine
```

### Building the Docker Image

Alternatively, you can build the Docker image for from the source:

```sh
git clone https://github.com/roinj/megacmd-alpine-docker.git
cd MegaCMD-Alpine-Docker
docker build -t megacmd-alpine .
```

## Usage

### Running the Docker Container

After building the Docker image or pulling it from Docker Hub, you can run the container using the following command:

```sh
docker run -it --rm megacmd-alpine
```

This command will start a container with MegaCMD installed, allowing you to use MegaCMD commands.

### Example Commands

```sh
# Login to your MEGA.nz account
mega-login your-email@example.com your-password

# Upload a file to your MEGA.nz account
mega-put /path/to/local/file /remote/path

# Download a file from your MEGA.nz account
mega-get /remote/path /path/to/local/destination

# List files in your MEGA.nz account
mega-ls /remote/path

# Start WebDAV service
mega-webdav
```

You can find more commands in this [User Guide](https://github.com/meganz/MEGAcmd/blob/master/UserGuide.md).

## License

This project is licensed under the GPL-3.0 License. See the [LICENSE](LICENSE) file for details.