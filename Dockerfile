# Base image versions
ARG NOTEBOOK_VERSION=notebook-6.2.0
ARG PYTHON_VERSION=3.10
ARG ALPINE_VERSION=3.15

# Jupyter notebook image is used as the builder
FROM jupyter/base-notebook:${NOTEBOOK_VERSION} AS builder

# Copy the required project files
WORKDIR /home/jovyan/work/petition-stats
COPY --chown=jovyan:users python/*.*py* ./python/

# Convert Jupyter notebooks to regular Python scripts
RUN jupyter nbconvert --to python python/*.ipynb && \
    rm python/*.ipynb

# Ensure project file permissions are correct
RUN chmod 755 python/*.py

# Create final image from Python 3 (Alpine Linux)
FROM python:${PYTHON_VERSION}-alpine${ALPINE_VERSION}

# Note: Jovian is a fictional native inhabitant of the planet Jupiter
ARG PY_USER=jovyan
ARG PY_GROUP=jovyan
ARG PY_UID=1000
ARG PY_GID=1000

# Create the Python user and work directory
RUN addgroup -g ${PY_GID} ${PY_GROUP} && \
    adduser -u ${PY_UID} --disabled-password ${PY_USER} -G ${PY_GROUP} && \
    mkdir -p /home/${PY_USER}/work && \
    chown -R ${PY_USER} /home/${PY_USER}

# Install Tini
RUN apk add --no-cache tini=~0.19

# Copy project files from the builder
USER ${PY_USER}
WORKDIR /home/${PY_USER}/work/petition-stats
COPY --from=builder --chown=jovyan:jovyan /home/jovyan/work/petition-stats/ ./
RUN mkdir data docs

# Wait for CMD to exit, reap zombies and perform signal forwarding
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["python"]
