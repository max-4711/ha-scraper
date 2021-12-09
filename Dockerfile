FROM homeassistant/home-assistant:latest

WORKDIR /config/custom_components
COPY multiscrape /config/custom_components

WORKDIR /config/.storage
COPY auth /config/.storage/auth