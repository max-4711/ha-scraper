FROM homeassistant/home-assistant:latest

WORKDIR /config/custom_components/multiscrape
RUN curl https://codeload.github.com/danieldotnl/ha-multiscrape/tar.gz/master | \ tar -xz --strip=2 ha-multiscrape-master/custom_components/multiscrape
