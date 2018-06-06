# vcap.me

There is a known set of DNS servers who are resolving everything to localhost, for example `*.vcap.me` which is wery usefull for local development when you gonna need to check cors stuff, or test facebook oauth, etc

The problem with vcap.me it going to work only by http and for some cases we do really need https (for example you wish to check if secure cookie working as expected or integrate with facebook)

# How

We gonna create self signed certificate and add it as trusted in our system.

Then we will use [nginx-proxy](https://hub.docker.com/r/jwilder/nginx-proxy/) docker image to proxy all requests to containers.

Profit

# Self signed certificate

There is bazillion of ways to create certificates, but we gonna use [one](https://github.com/jwilder/nginx-proxy/raw/master/test/certs/create_server_certificate.sh) from nginx-proxy, which will hide all complexity from us and just do the workd.

```bash
mkdir certs
cd certs
wget https://github.com/jwilder/nginx-proxy/raw/master/test/certs/create_server_certificate.sh
```

because of [openssl](https://github.com/jwilder/nginx-proxy/pull/914) we gonna need to make small fix and add `apt-get update && apt-get install openssl -y` at line 30

```bash
chmod +x create_server_certificate.sh
./create_server_certificate.sh vcap.me "*.vcap.me"
rm create_server_certificate.sh
```

if everythin ok, you will see:

```bash
ca-root.crt
ca-root.key
vcap.me.crt
vcap.me.key
```

To always trust this certificates you can use command:

```bash
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain certs/vcap.me.crt
```

which was found [here](https://imagineer.in/blog/https-on-localhost-with-nginx/)

or by hands:

![trust certificate](https://camo.githubusercontent.com/d38be82afbf00850747542314c6104aefb2eeedb/68747470733a2f2f63646e2e7261776769742e636f6d2f6a65642f363134373837322f7261772f326663366563663263636438656364383833303132346565396232666433613763666633383964622f74727573745f63657274696669636174652e676966)

found [here](https://gist.github.com/jed/6147872#avoid-https-warnings-by-telling-os-x-to-trust-the-certificate)


# Demo

```bash
cd demo
docker-compose up
curl https://whoami.vcap.me
open https://frontend.vcap.me
```

# Docker image

To reuse this we can build our own image:

```
FROM jwilder/nginx-proxy:alpine

COPY ./certs/vcap.me.crt /etc/nginx/certs/vcap.me.crt
COPY ./certs/vcap.me.key /etc/nginx/certs/vcap.me.key
```

```bash
docker build -t mac2000/nginx-proxy:alpine .
docker push mac2000/nginx-proxy:alpine
```