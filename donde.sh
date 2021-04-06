#!/bin/bash
#Script para obtener informacion del dominio
#Autor: Docnus
#Version: 0.1
#
#Definimos la variable para el dominio
dominio=$1
GREEN="92"
BOLDGREEN="\e[1;${GREEN}m"
ENDCOLOR="\e[0m"

#Antes de cualquier cosa, realizamos un whois al dominio al cual le 
#realizaremos un filtro para sacar lo que necesitamos solamente y asi evitar la basura. 
#El mismo filtro contiene palabras para identificar si el dominio existe o no.

echo -e "${BOLDGREEN}#Whois - Zona DNS - Reverso | Docnus${ENDCOLOR}"
echo -e "${BOLDGREEN}#Procesando...${ENDCOLOR}"
echo -e "${BOLDGREEN}#Whois${ENDCOLOR}"
#variable "quien" para guardar el output del whois
quien=$(whois $dominio | egrep -i -e 'name server' -e 'no match' -e 'no entries found' -e 'registrant name' -e 'registrant organisation' -e 'registrar name' -e 'registrar URL' -e 'creation date' -e 'expiration date' -e 'No Object Found' -e 'NOT FOUND')

#comparamos el output con las siguientes condiciones:
if [[ "$quien" == *"No match"* ]]; then
	echo -e "el dominio ${BOLDGREEN}#"$dominio"${ENDCOLOR} no existe"
	exit
elif [[ "$quien" == *"no entries found"* ]]; then
	echo -e "el dominio ${BOLDGREEN}#"$dominio"${ENDCOLOR} no existe"
	exit
elif [[ "$quien" == *"No Object Found"* ]]; then
	echo -e "el dominio ${BOLDGREEN}#"$dominio"${ENDCOLOR} no existe"
	exit
elif [[ "$quien" == *"NOT FOUND"* ]]; then
	echo -e "el dominio ${BOLDGREEN}#"$dominio"${ENDCOLOR} no existe"
	exit
#si el dominio está registrado, o no coincide con alguno de los registros anteriores, mostrará el whois completo.
else 
	#mostrar whois
	echo "$quien"
	#dig al dominio
	echo -e "${BOLDGREEN}#Dig NS del dominio "$dominio"${ENDCOLOR}"
	dig +short $dominio ns 

	echo -e "${BOLDGREEN}#IP del registro A${ENDCOLOR}"
	dig +short $dominio a

	echo -e "${BOLDGREEN}#IP del registro mail."$dominio"${ENDCOLOR}"
	dig +short mail.$dominio

	echo -e "${BOLDGREEN}#Registros MX${ENDCOLOR}"
	dig +short mx $dominio
	
	echo -e "${BOLDGREEN}#Registros TXT${ENDCOLOR}"
	dig +short txt $dominio
		
	echo -e "${BOLDGREEN}#Reverso, si es que lo tiene${ENDCOLOR}"
	ip=$(dig +short $dominio a)
	echo "IP del registro A para reverso: ""$ip"
	reverso=$(dig +short -x $ip)
	echo "Reverso: ""$reverso"
fi
