FROM homeassistant/home-assistant:latest

#DEBUG!
RUN ls -la

WORKDIR /config/custom_components
COPY . .

WORKDIR /config/.storage
COPY ./auth /config/.storage/auth