# Base image versions
ARG NOTEBOOK_VERSION=c39518a3252f
ARG PYTHON_VERSION=3.8
ARG ALPINE_VERSION=3.10

# Jupter notebook image is used as the builder
FROM jupyter/base-notebook:${NOTEBOOK_VERSION} AS builder

# Environment variables
ENV NB_USER=jovyan
ENV PROJDIR=/home/${NB_USER}/work/petition-stats

# Convert Jupter notebooks to regular Python scripts
COPY --chown=jovyan:users python/*.ipynb ${PROJDIR}/python/
RUN jupyter nbconvert --to python ${PROJDIR}/python/*.ipynb && \
    chmod 755 ${PROJDIR}/python/*.py && \
    rm ${PROJDIR}/python/*.ipynb

# Create final image from Python 3 + Beautiful Soup 4 on Alpine Linux
FROM python:${PYTHON_VERSION}-alpine${ALPINE_VERSION}

# Environment variables
ENV NB_USER=jovyan
ENV PROJDIR=/home/${NB_USER}/work/petition-stats

# Create the notebook user and project structure
RUN addgroup -g 1000 -S ${NB_USER} && \
    adduser -u 1000 -S ${NB_USER} -G ${NB_USER}
USER ${NB_USER}

# Copy project files
COPY --from=builder --chown=jovyan:jovyan ${PROJDIR}/ ${PROJDIR}/

# Create data and docs volumes
RUN cd ${PROJDIR} && \
    mkdir data reports

# Define the command / entrypoint
CMD ["python3"]
