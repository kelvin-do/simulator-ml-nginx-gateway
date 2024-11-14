#!/bin/sh

set -e

if [ -z "$KUBERNETES_DNS_SERVICE_IP" ]; then
  nameserver=$(grep nameserver /etc/resolv.conf | awk '{print $2}' | head -1)
  export KUBERNETES_DNS_SERVICE_IP=$nameserver
fi

envsubst '$KUBERNETES_DNS_SERVICE_IP' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

cp /etc/nginx/routes.conf.template /etc/nginx/routes.conf

fqdn=$(grep search /etc/resolv.conf | awk '{print $2}' | head -1)

if [ -z "$fqdn" ]; then
  fqdn='local'
fi

for var in $(env)
do
  ENV_VAR_KEY="\$$(echo "$var" | tr "=" " " | awk '{print $1}')"
  ENV_VAR_VALUE=$(echo "$var" | tr "$ENV_VAR_KEY=" " " | awk '{print $1}')

  case "$ENV_VAR_VALUE" in
  *.*)
    # il y a un domaine, donc ne pas concaténer avec fqdn, ajoutez :8000 au besoin
    CMD="sed -i 's/$ENV_VAR_KEY/$(echo "$ENV_VAR_VALUE" | tr "/" "\/"):8000/g' /etc/nginx/routes.conf"
    ;;
  *)
    # Utiliser 'dig' pour trouver le port local, sinon 8000 par défaut
    local_port="$(dig +noall +answer +time=3 +tries=1 srv \*._tcp."$ENV_VAR_VALUE"."$fqdn" | awk '{print $7}')"
    local_port="${local_port:-8000}"  # Définit le port à 8000 si aucune valeur n'est trouvée

    # Insertion dans le fichier de configuration
    CMD="sed -i 's/$ENV_VAR_KEY/$(echo "$ENV_VAR_VALUE" | tr "/" "\/").$fqdn:$local_port/g' /etc/nginx/routes.conf"
    ;;
  esac

  eval "$CMD"
done

printf "nameserver: %s\n" "$KUBERNETES_DNS_SERVICE_IP"
printf "search FQDN: %s\n\n" "$fqdn"

printf "--------- GENERATED ROUTES.CONF ------------\n"
cat /etc/nginx/routes.conf
printf "--------- EOF GENERTED ROUTES.CONF ---------\n"

printf "> nginx.conf and routes.conf configuration files loaded!\n\n"

# Start NGINX
nginx -g 'daemon off;'
