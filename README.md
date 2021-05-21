# Donde - script bash para obtener registros DNS e información de whois de un dominio.

## Script para obtener datos de un dominio

## Autor: @Docnus

## Version: 1.0

Este script existe por que me canse de estar haciendo whois y dig a cada rato para obtener datos de un dominio para mi trabajo. 


**Requisitos:**
* dig
* whois

**Dependiento de tu OS, los puedes obtener en diferentes paquetes:**

_Red Hat Linux /CentOS_
> dnf install bind-utils whois

_CentOS7 e inferiores_
> yum install bind-utils whois

_Basados en Debian:_
> apt install dnsutils whois

_Basados en Arch:_
> pacman -Sy dnsutils whois

## Instrucciones

Idealmente, dejalo en tu `/usr/local/sbin/` y renombralo a "donde" solamente. 

Recuerda aplicar `chmod +x donde` antes, para poder ejecutarlo.

**Uso: "donde -x dominio.tld" | Donde -x corresponde a alguna opción**

**RECUERDA: No puedes ocupar dos opciones a la vez!**

_Puedes ocupar algunos de estas opciones:_


Opción | Que hace
------------ | -------------
-g | Ocupará los DNS de Google
-o | Ocupará los DNS de OpenDNS
-c | Ocupará los DNS de Cloudflare
-h | Ocupará los DNS de HN - Util para revisar dominios que esten el datacenter
-l | Ocupará tu DNS local
-a | Muestra la ayuda

## Información adicional

Actualmente funciona para dominios .com .net. org. cl. pe. info y quizá algunos otros.

Si el dominio no existe, entregará un mensaje: "el dominio no existe"

Es probable que entregue algunos errores, está casi validado en su totalidad.
