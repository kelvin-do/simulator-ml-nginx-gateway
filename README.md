# NGINX API Gateway

This repository allows to deplos an API gateway for the simulator on Qovery.

[Read this tutorial](https://hub.qovery.com/guides/tutorial/use-an-api-gateway-in-front-of-multiple-services/) to understand the steps created to deployed this API gateway in the simulator

## Usage

Only the routes.conf.template needs to be update to remove or add a path in the gateway. 
You need to set the variable `SIMULATOR_API_VX` following the tutorial above.

The project is deployed [here](https://console.qovery.com/organization/806fb32e-5ca0-4cb4-8856-97e6550ad63b/project/b040a9d5-6a7f-4dc6-9dcd-74e89cfa4556/environment/e8a571d0-cc9e-4a2a-8812-29012899cde2/application/ff6d751e-9c04-4db0-85cd-40432752b537/general) in dev and prod. 

To deploy a new version you need to do it manually using the wanted commit from the "main" branch inside Qovery 

## NGINX Documentation

[NGINX](https://www.nginx.com/) is an open-source web server that can also be used as a reverse proxy, load balancer, mail proxy and HTTP cache.
Check out the [NGINX documentation](https://nginx.org/en/docs/beginners_guide.html) for more advanced configuration.

