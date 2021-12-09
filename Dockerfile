FROM homeassistant/home-assistant:latest

WORKDIR /config/custom_components/multiscrape
COPY ./multiscrape .

WORKDIR /config/.storage
COPY ./auth /config/.storage/auth

WORKDIR /config
COPY ./example-config.yml ./configuration.yaml

#DEBUG: This folder should now contain the actual custom integration
RUN ls -la /config/custom_components/multiscrape