
# Copyright (c) Contributors to the Open 3D Engine Project.
# For complete copyright and license terms please see the LICENSE at the root of this distribution.
#
# SPDX-License-Identifier: Apache-2.0 OR MIT
#

# This docker file uses ubuntu 20.04 as the base image so that the AWS Native C++ libraries will use OpenSSL 3 as the base
# for its dependencies
#

ARG BASE_DOCKER_IMAGE=public.ecr.aws/ubuntu/ubuntu

ARG BASE_DOCKER_TAG=20.04_stable

FROM ${BASE_DOCKER_IMAGE}:${BASE_DOCKER_TAG}

ARG BASE_DOCKER_IMAGE

ARG BASE_DOCKER_TAG
 
WORKDIR /data/workspace

ARG ZLIB_FOLDER_PATH

# Initilize apt cache
RUN apt-get clean && apt-get update

# Setup time zone and locale data (necessary for SSL and HTTPS packages)
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata locales keyboard-configuration

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8

# Install the development packages needed to build Qt from source
RUN apt-get install -y build-essential \
                       pkg-config \
                       libminizip-dev \
                       git \
                       cmake \
                       ninja-build \
                       wget \
                       libssl-dev \
                       g++ \
                       checkinstall

# Build cmake 3.20 from source
RUN cd /data/workspace && \
    mkdir -p cmake_src && \
    cd cmake_src && \
    wget https://github.com/Kitware/CMake/releases/download/v3.20.0/cmake-3.20.0.tar.gz && \
    tar -zvxf cmake-3.20.0.tar.gz && \
    cd cmake-3.20.0 && \
    ./bootstrap && \
    make -j8 && \
    checkinstall --pkgname=cmake --pkgversion="3.20-custom" --default && \
    hash -r

# Prepare a target folder within the container to install the build artifacts tp
RUN mkdir -p /data/workspace/build

ENV ZLIB_LIB_PATH=${ZLIB_FOLDER_PATH}

ARG CACHEBUST=1

# Copy the build script specific to this Docker script in order to execute the build
COPY docker_build_assimp_linux.sh /data/workspace/
