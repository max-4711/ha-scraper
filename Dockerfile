FROM homeassistant/home-assistant:latest

WORKDIR /config/custom_components/multiscrape
COPY ./multiscrape .

WORKDIR /config/.storage
COPY ./auth /config/.storage/auth