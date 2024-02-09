#!/bin/bash

DATA=$(date +%d/%m/%Y)
HORA=$(date +%H:%M:%S)
SERVICO="httpd.service"
ESTADO=$(systemctl is-active $SERVICO)

if [ $ESTADO == 'active' ]; then
        echo "[ $DATA-$HORA ] - O serviço $SERVICO está ONLINE" >> /home/ec2-us$
else
    	echo "[ $DATA-$HORA ] - O serviço $SERVICO está OFFLINE" >> /home/ec2-u$
fi
