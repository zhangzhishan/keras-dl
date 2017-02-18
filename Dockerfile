FROM ubuntu:16.04
MAINTAINER Zhishan Zhang <zhangzhishanlo@gmail.com>

RUN apt-get update

# Supress warnings about missing front-end. As recommended at:
# http://stackoverflow.com/questions/22466255/is-it-possibe-to-answer-dialog-questions-when-installing-under-docker
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y --no-install-recommends apt-utils

# Developer Essentials
RUN apt-get install -y --no-install-recommends git curl vim unzip openssh-client wget

# Build tools
RUN apt-get install -y --no-install-recommends build-essential cmake

# OpenBLAS
RUN apt-get install -y --no-install-recommends libopenblas-dev

#
# Python 3.5
#
RUN apt-get install -y --no-install-recommends python3.5 python3.5-dev python3-pip
RUN pip3 install --no-cache-dir --upgrade pip setuptools
# Pillow and it's dependencies
RUN apt-get install -y --no-install-recommends libjpeg-dev zlib1g-dev
RUN pip3 --no-cache-dir install Pillow
# Common libraries
RUN pip3 --no-cache-dir install \
    numpy scipy sklearn scikit-image pandas matplotlib

#
# Jupyter Notebook
#
RUN pip3 --no-cache-dir install jupyter
# Allow access from outside the container, and skip trying to open a browser.
# NOTE: disable authentication token for convenience. DON'T DO THIS ON A PUBLIC SERVER.
RUN mkdir /root/.jupyter
RUN echo "c.NotebookApp.ip = '*'" \
         "\nc.NotebookApp.open_browser = False" \
         "\nc.NotebookApp.token = ''" \
         > /root/.jupyter/jupyter_notebook_config.py
EXPOSE 8888

#
# Tensorflow 0.12.1 - CPU
#
RUN pip3 install --no-cache-dir --upgrade \
    https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.12.1-cp35-cp35m-linux_x86_64.whl

# Expose port for TensorBoard
EXPOSE 6006


#
# Keras
#
RUN pip install keras

#
# Cleanup
#
RUN apt-get clean && \
    apt-get autoremove

WORKDIR "/root"
CMD ["/bin/bash"]
