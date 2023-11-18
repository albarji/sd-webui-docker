FROM nvidia/cuda:12.2.2-runtime-ubuntu22.04 as build
LABEL author="Álvaro Barbero Jiménez, https://github.com/albarji"

# Install system dependencies
RUN set -ex && \
	apt-get update && apt-get install --no-install-recommends --no-install-suggests -y \
	wget git python3 python3-venv libgl1 libglib2.0-0 \
	&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create user for the container
RUN useradd -ms /bin/bash stableuser
USER stableuser
WORKDIR /home/stableuser

# Download automatic1111 stable-diffusion-webui install script
# and run it in install mode to install its dependencies.
# Also install also xformers for more efficient GPU usage
SHELL ["/bin/bash", "-c"]
RUN wget -q https://raw.githubusercontent.com/AUTOMATIC1111/stable-diffusion-webui/master/webui.sh \
	&& bash webui.sh --skip-torch-cuda-test --exit \
	&& python3 -m venv stable-diffusion-webui/venv/ \
	&& source stable-diffusion-webui/venv/bin/activate \
	&& pip install xformers \
 	&& pip cache purge

# New stage to download models and run
FROM nvidia/cuda:12.2.2-runtime-ubuntu22.04

# Install runtime system dependencies
RUN set -ex && \
	apt-get update && apt-get install --no-install-recommends --no-install-suggests -y \
	wget git python3 python3-venv libgl1 libglib2.0-0 \
	&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Configure user again
RUN useradd -ms /bin/bash stableuser
USER stableuser
WORKDIR /home/stableuser

# Copy stable-diffusion-webui files from previous layer
COPY --from=build --chown=stableuser /home/stableuser/stable-diffusion-webui /home/stableuser/stable-diffusion-webui

# Install models of interest
RUN wget -q -O /home/stableuser/stable-diffusion-webui/models/Stable-diffusion/juggernautXL_version6Rundiffusion.safetensors http://civitai.com/api/download/models/198530

EXPOSE 7860
ENTRYPOINT [ "bash", "/home/stableuser/webui.sh", "--listen", "--port", "7860", "--no-download-sd-model", "--xformers"]
