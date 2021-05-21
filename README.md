Donde - script bash para obtener registros DNS e información de whois de un dominio.

Script para obtener datos de un dominio

Version: 1.0

Este script existe por que me canse de estar haciendo whois y dig a cada rato para obtener datos de un dominio para mi trabajo. 

Requisitos:
dig
whois

Dependiento de tu OS, los puedes obtener en diferentes paquetes:

Red Hat Linux /CentOS
dnf install bind-utils whois

CentOS7 e inferiores
yum install bind-utils whois

Basados en Debian:
apt install dnsutils whois

Basados en Arch:
pacman -Sy dnsutils whois

Idealmente, dejalo en tu /usr/local/sbin/ y renombralo a "donde" solamente. 

Antes de ejecutarlo, aplica chmod +x donde para poder ejecutarlo.

Uso: "donde -x dominio.tld" | Donde -x corresponde a alguna opción
--------------------------------------------------------------------------
RECUERDA:No puedes ocupar dos opciones a la vez!
--------------------------------------------------------------------------
Puedes ocupar algunos de estas opciones:
-g Ocupará los DNS de Google
-o Ocupará los DNS de OpenDNS
-c Ocupará los DNS de Cloudflare
-hn Ocupará los DNS de HN - Util para revisar dominios que esten el datacenter
-l Ocupará tu DNS local
-a Muestra esta ayuda

Actualmente funciona para dominios .com .net. org. cl. pe. info .us y quizá algunos otros.

Si el dominio no existe, entregará un mensaje: "el dominio no existe"
Es probable que entregue algunos errores, no esta totalmente validado.
