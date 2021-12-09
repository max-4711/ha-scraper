# HA+Multiscrape: A very primitive but easy-to-use scraper

## What is this about?

This repository contains a dockerfile, which is being used to build a docker image containing [HomeAssistant](https://github.com/home-assistant/core) (taken from the [official homeassistant docker image](https://hub.docker.com/r/homeassistant/home-assistant/)) and the [multiscrape custom component](https://github.com/danieldotnl/ha-multiscrape) baked into it right away. 

Also a (rather minimalistic) example configuration is being provided.

## But what's the purpose?

I personally already run a home assistant instance on a Raspi at home, which is being scraped by a [Prometheus](https://github.com/prometheus/prometheus) instance running in the cloud (whose data is being used to display a [Grafana](https://github.com/grafana/grafana) dashboard).\
This dashboard should now be enriched with some data scraped from the web. As the HomeAssistant instance on my Raspi won't do anything with this data, it isn't supposed to do the scraping (to take load off both the Raspi and my internet connection).\
Therefore this docker image is going to be useful, as it will run a HomeAssistant instance on the aforementioned server in the cloud, which is going to do the scraping.

TL;DR: You get a container with a primitive but ready-to-use crawler: Write a config file (see `example-config.yaml`) with URLs and CSS selectors and you can monitor these values with Prometheus.

## A bit obscure this solution, isn't it?

Well, it's not a solution 'by the book' for getting data scraped from the web into Grafana, that's for sure. But on the other hand, it's a convenient solution for me: Everything is already set up to display data from a HomeAssistant instance...a new HomeAssistant instance can be created with docker basically in no time. A 'real' scraping/crawling solution would be just an overkill in my case, while still causing effort for needing to configuring (or even coding) the crawler, setting up a database, getting the data into it, configuring Grafana to get the data from there, ...

## You had me at 'obscure'! How do i use it?

Well...depends of course a bit on your environment/setup. But in general, it's more or less this (in this case assuming your HomeAssistant config file is `/home/ubuntu/hascraper/configuration.yaml` and the bridge network where Prometheus is also connected is called `promgraf`):

```shell
sudo docker run -d --restart unless-stopped --name hascraper -v /home/ubuntu/hascraper/configuration.yaml:/config/configuration.yaml --net=promgraf max4711/hascraper:latest
```

You should then be able to configure Prometheus like this (see the [HomeAssistant documentation](https://www.home-assistant.io/integrations/prometheus/#full-example) for more details and configuration options):
```yaml
  - job_name: "hascraper"
    scrape_interval: 60s
    metrics_path: /api/prometheus
    authorization:
      credentials: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiIxMjMxODg5ZjA2MGE0MGY0OWQ1OTVkYzcxOWRkZDJhOSIsImlhdCI6MTYzODgxODc3NywiZXhwIjoxOTU0MTc4Nzc3fQ.MHoU5daF5sMA8WmEh8bdJ4sFmLIGJJM1qtvHqk8uOkI

    scheme: http
    static_configs:
      - targets: ['hascraper:8123']
```

Please note, that authorization token is also baked into the image - for convenience reasons, the image contains the user `dummyuser`, in which context the API is accessible with this token. You shouldn't make the container publicly accessible with this user/token in place. You can override it, by providing a custom version of the `auth` file to the container (-> append to the `docker run` command:  `-v /path/to/your/modified/auth/file:/config/.storage/auth`)

You may wish to verify you new scraper container is working. A convenient (and this repo is all about convenience 😀) way for this would be this command:
```shell
sudo docker run --rm --net=promgraf busybox wget --header="Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiIxMjMxODg5ZjA2MGE0MGY0OWQ1OTVkYzcxOWRkZDJhOSIsImlhdCI6MTYzODgxODc3NywiZXhwIjoxOTU0MTc4Nzc3fQ.MHoU5daF5sMA8WmEh8bdJ4sFmLIGJJM1qtvHqk8uOkI" -S -O - http://hascraper:8123/api/prometheus
```
If you see lots of text afterwards, basically it should be all good.