FROM homeassistant/home-assistant:latest

WORKDIR /config/custom_components
COPY . .

WORKDIR /config/.storage
COPY ./auth /config/.storage/auth