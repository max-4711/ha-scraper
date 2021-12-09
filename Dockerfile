FROM homeassistant/home-assistant:latest

WORKDIR /config/custom_components
COPY ./multiscrape .

WORKDIR /config/.storage
COPY ./auth /config/.storage/auth

WORKDIR /config
COPY ./example-config.yaml ./configuration.yaml

#REMOVE BEFORE FLIGHT:
RUN ls -la /config/custom_components/multiscrape
RUN cat /config/.storage/auth