FROM homeassistant/home-assistant:latest

WORKDIR /config/custom_components
COPY multiscrape /config/custom_components

WORKDIR /config/.storage
ADD https://raw.githubusercontent.com/max-4711/ha-scraper/main/auth /config/.storage/auth