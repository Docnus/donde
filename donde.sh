#!/bin/bash
#donde - Script para obtener informacion del dominio - Whois - Registros de zona DNS escenciales - Reverso
#Autor: Docnus
#Version: 1.0
#
#Uso: donde -x dominio.tld - Donde -x corresponde a alguna opción
#Puedes ocupar algunos de estos switch:
# -g ocupará los DNS de Google
# -o ocupará los DNS de OpenDNS
# -c ocupará los DNS de Cloudflare
# -hn ocupará los DNS de HN
# -l ocupará tu DNS local
# -h Esta ayuda

#####Definimos variables a utilizar#####
#Valor necesario para las opciones/switches
option=$1
#Dominio necesario para realizar la consulta el cual pasa por parametro
dominio=$2
#Colores, por que hay que hacerlo "lindo"
GREEN="92"
RED="31"
BOLDGREEN="\e[1;${GREEN}m"
BOLDRED="\e[1;${RED}m"
ENDCOLOR="\e[0m"
#####Fin definicion de variables#####

#####Comenzamos#####
#Titulo del script para no tener que escribirlo tantas veces...

print_titulo(){
echo -e "$lineaverde"
echo -e "${BOLDGREEN}#Whois - Registros Zona DNS - Reverso ${ENDCOLOR}"
echo -e "$linearoja"
echo -e "${BOLDRED}#Revisa la version mas nueva en: https://github.com/Docnus/donde${ENDCOLOR}"
}
lineaverde="${BOLDGREEN}#--------------------------------------------------------------------------${ENDCOLOR}"
linearoja="${BOLDRED}#--------------------------------------------------------------------------${ENDCOLOR}"

#Funcion principal para obtener registros.
get_records () {
		
#Antes de cualquier cosa, realizamos un whois al dominio, al cual le haremos un filtro para sacar lo que necesitamos solamente y asi evitar la basura.
#El mismo filtro contiene palabras para identificar si el dominio existe o no.
#La variable "quien" la tenemos para guardar la salida del whois
#Revisamos si tenemos un dominio para ingresar, si no tenemos nada, nos dará un mensajito.
if [[ -z $dominio ]]; then
	local quien="No olvides ingresar un dominio. Aplica donde -h para la ayuda"
	echo "$quien"
	exit
else
	local quien=$(whois $dominio | egrep -i -e 'name server' -e 'no match' -e 'no entries found' -e 'registrant name' -e 'registrant organisation' -e 'registrar name' -e 'registrar URL' -e 'creation date' -e 'expiration date' -e 'No Object Found' -e 'NOT FOUND' -e 'No whois server is known')
fi

#Comparamos la variable "quien" con las siguientes condiciones:

if [[ "$quien" == *"No match"* ]]; then
	echo -e "el dominio ${BOLDRED}"$dominio"${ENDCOLOR} no existe"
exit
elif [[ "$quien" == *"no entries found"* ]]; then
	echo -e "el dominio ${BOLDRED}"$dominio"${ENDCOLOR} no existe"
exit
elif [[ "$quien" == *"No Object Found"* ]]; then
	echo -e "el dominio ${BOLDRED}"$dominio"${ENDCOLOR} no existe"
exit
elif [[ "$quien" == *"NOT FOUND"* ]]; then
	echo -e "el dominio ${BOLDRED}"$dominio"${ENDCOLOR} no existe"
exit
elif [[ "$quien" == *"No whois server is known"* ]]; then
	echo -e "el dominio ${BOLDRED}"$dominio"${ENDCOLOR} no existe"
exit



#Si el dominio está registrado, o no coincide con alguno de los registros anteriores, mostrará el whois completo... recortado, pero con lo necesario.
#Aqui ya tenemos el dominio, asi que, procedemos a realizar los DiG correspondientes.

else
	
#Consultamos Registros NS
local ns=$(dig $DNS +nocmd +noall +answer +ttlid $dominio ns)

#Consultamos Registros A
local a=$(dig $DNS +nocmd +noall +answer +ttlid $dominio a)

#Consultamos Registro mail.dominio.tld
local mail=$(dig $DNS +nocmd +noall +answer +ttlid +additional mail.$dominio)

#Consultamos Registros MX
local mx=$(dig $DNS +nocmd +noall +answer +ttlid +additional mx $dominio)

#Consultamos Registros TXT
local txt=$(dig $DNS +nocmd +noall +answer +ttlid txt $dominio)

#Consultamos Registro DMARC
local dmarc=$(dig $DNS +nocmd +noall +answer +ttlid txt _dmarc.$dominio)

#Consultamos Registros DKIM
local dkim=$(dig $DNS +nocmd +noall +answer +ttlid txt default._domainkey.$dominio)

#Consultamos Registros para reverso
local ip=$(dig $DNS +short $dominio a)
local reverso=$(dig +short -x $ip)

#####Este segmento será la salida de la funcion
echo -e "${BOLDGREEN}#Whois${ENDCOLOR}"
echo "$quien"

#NS
echo -e "${BOLDGREEN}#Registros NS del dominio "$dominio"${ENDCOLOR}"
if [[ -z $ns ]]; then
	ns="No tiene registros NS."
	echo -e "${BOLDRED}$ns${ENDCOLOR}"
else
	echo "$ns"
fi

#A
echo -e "${BOLDGREEN}#Registros A del dominio "$dominio"${ENDCOLOR}"
if [[ -z $a ]]; then
	a="No tiene registros NS."
	echo -e "${BOLDRED}$a${ENDCOLOR}"
else
	echo "$a"
fi

#A mail
echo -e "${BOLDGREEN}#Registro mail."$dominio"${ENDCOLOR}"
if [[ -z $mail ]]; then
	mail="No tiene registros NS."
	echo -e "${BOLDRED}$mail${ENDCOLOR}"
else
	echo "$mail"
fi

#MX
echo -e "${BOLDGREEN}#Registros MX${ENDCOLOR}"
if [[ -z $mx ]]; then
	mx="No tiene registros NS."
	echo -e "${BOLDRED}$mx${ENDCOLOR}"
else
	echo "$mx"
fi

#TXT
echo -e "${BOLDGREEN}#Registros TXT${ENDCOLOR}"
if [[ -z $txt ]]; then
	txt="No tiene registros NS."
	echo -e "${BOLDRED}$txt${ENDCOLOR}"
else
	echo "$txt"
fi

#DMARC
echo -e "${BOLDGREEN}#DMARC, si es que lo tiene${ENDCOLOR}"
if [[ -z $dmarc ]]; then
	dmarc="No tiene registros NS."
	echo -e "${BOLDRED}$dmarc${ENDCOLOR}"
else
	echo "$dmarc"
fi

#DKIM
echo -e "${BOLDGREEN}#DKIM, si es que lo tiene${ENDCOLOR}"
if [[ -z $dkim ]]; then
	dkim="No tiene registro DKIM."
	echo -e "${BOLDRED}$dkim${ENDCOLOR}"
else
	echo "$dkim"
fi


#A para REVERSO
echo -e "${BOLDGREEN}#IP del registro A para reverso: ${ENDCOLOR}"
if [[ -z $ip ]]; then
	ip="No tiene registro A para extraer reverso"
	echo -e "${BOLDRED}$ip${ENDCOLOR}"
else
	echo -e "$ip"
fi

#Reverso
echo -e "${BOLDGREEN}#Reverso, del registro A si es que lo tiene${ENDCOLOR}"
if [[ -z $reverso ]]; then
	reverso="No tiene reverso."
	echo -e "${BOLDRED}$reverso${ENDCOLOR}"
fi
echo -e "Reverso: ""${BOLDGREEN}$reverso${ENDCOLOR}"

fi	

}



#Funciones para imprimir salida final por DNS

print_dnsgoogle(){
DNS="@8.8.8.8"
DNSNAME="Google"
echo -e "$(print_titulo)"
echo -e "$lineaverde"
echo -e "${BOLDGREEN}#Procesando...${ENDCOLOR}"
echo -e "${BOLDGREEN}#Consulta a ${BOLDRED}"$DNSNAME" - "$DNS"${ENDCOLOR} por dominio "$dominio"${ENDCOLOR}"
echo "$(get_records)"
exit
}

print_dnsopendns(){
DNS="@208.67.222.222"
DNSNAME="OpenDNS"
echo -e "$(print_titulo)"
echo -e "$lineaverde"
echo -e "${BOLDGREEN}#Procesando...${ENDCOLOR}"
echo -e "${BOLDGREEN}#Consulta a ${BOLDRED}"$DNSNAME" - "$DNS"${ENDCOLOR} por dominio "$dominio"${ENDCOLOR}"
echo "$(get_records)"
exit
}

print_dnshn(){
DNS="@ns1.hostname.cl"
DNSNAME="HN"
echo -e "$(print_titulo)"
echo -e "$lineaverde"
echo -e "${BOLDGREEN}#Procesando...${ENDCOLOR}"
echo -e "${BOLDGREEN}#Consulta a ${BOLDRED}"$DNSNAME" - "$DNS"${ENDCOLOR} por dominio "$dominio"${ENDCOLOR}"
echo "$(get_records)"
exit
}

printdns_cloudflare(){
DNS="@1.1.1.1"
DNSNAME="Cloudflare"
echo -e "$(print_titulo)"
echo -e "$lineaverde"
echo -e "${BOLDGREEN}#Procesando...${ENDCOLOR}"
echo -e "${BOLDGREEN}#Consulta a ${BOLDRED}"$DNSNAME" - "$DNS"${ENDCOLOR} por dominio "$dominio"${ENDCOLOR}"
echo "$(get_records)"
exit
}

print_dnslocal () {
DNS=""
DNSNAME="DNS Locales"
echo -e "$(print_titulo)"
echo -e "$lineaverde"
echo -e "${BOLDGREEN}#Procesando...${ENDCOLOR}"
echo -e "${BOLDGREEN}#Consulta a ${BOLDRED}"$DNSNAME"${ENDCOLOR} por dominio "$dominio"${ENDCOLOR}"
echo "$(get_records)"
exit
}

print_ayuda (){
echo -e "$lineaverde"
echo -e "${BOLDGREEN}#AYUDA${ENDCOLOR}"
echo -e "${BOLDGREEN}#Si no ingresas nada, esto te orientará:${ENDCOLOR}"
echo -e '#Uso: "donde -x dominio.tld" | Donde -x corresponde a alguna opción'
echo -e "$lineaverde"
echo -e "${BOLDRED}#RECUERDA:No puedes ocupar dos opciones a la vez!${ENDCOLOR}"
echo -e "$lineaverde"
echo -e "${BOLDGREEN}#Puedes ocupar algunos de estas opciones:${ENDCOLOR}"
echo -e "# -g Ocupará los DNS de Google"
echo -e "# -o Ocupará los DNS de OpenDNS"
echo -e "# -c Ocupará los DNS de Cloudflare"
echo -e "# -hn Ocupará los DNS de HN - Util para revisar dominios que esten el datacenter"
echo -e "# -l Ocupará tu DNS local"
echo -e "# -a Muestra esta ayuda"
exit
}

#Menu de opciones
#Revisamos si la variable dominio viene con un guion inicial y por si viene vacia.
primerCaracter=${dominio:0:1}
#Si lo tiene, detenemos el proceso y le damos la ayuda
if [[ $primerCaracter == "-" ]]; then
	echo "$(print_titulo)"
	echo -e "$linearoja"
	echo -e '${BOLDRED}#Error${ENDCOLOR}'
	echo -e '${BOLDRED}#Un dominio no puede comenzar con un "-" o "guión" ${ENDCOLOR}'
	echo -e "$linearoja"
	echo "$(print_ayuda)"
exit
elif [[ -z $dominio ]]; then
	echo "$(print_titulo)"
	echo -e "$linearoja"
	echo -e "${BOLDRED}#Error${ENDCOLOR}"
	dumb="#Debes ingresar un dominio para consultar!!"
	echo -e "${BOLDRED}$dumb${ENDCOLOR}"
	echo -e "$linearoja"
	echo "$(print_ayuda)"
exit
else

while getopts ":g:o:h:c:l:a:" options; do
	case "${options}" in
	g)
	print_dnsgoogle
	;;
	
	o)
	print_dnsopendns
	;;
	
	h)
	print_dnshn
	;;
	
	c)
	printdns_cloudflare
	;;
	
	l)
	print_dnslocal
	;;
	
	a)
	echo "$(print_titulo)"
	echo "$(print_ayuda)"
	exit 1
	;;
	
	\? )
    echo 'Opción no disponible '"-${OPTARG}." 'Aplica: "donde -a"  para ver la ayuda'
	exit 1
	;;
	
	: )
	echo "$(print_titulo)"
	echo "$(print_ayuda)"
	exit 1
	;;
	esac
done
shift $((OPTIND -1))
exit 0

fi   

#####
