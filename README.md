# compass_atividade_linux_aws

**Objetivo:** A atividade se trata em criar uma instancia na aws e configurar o protocolo NFS para o armazenamento de dados, configurar um serviço do apache e gerar scripts que valide a execução do serviço onde o resultado do script seja armazenado no NFS configurado.

---
### Requisitos da Atividade
##### 1 - AWS
- Gerar uma chave pública para acesso ao ambiente.
- Criar instância EC2 com as seguintes configurações:
	- Sistema Operacional: Amazon Linux 2.
	- Tipo de Instância: t3.small.
	- Armazenamento: 16 GB SSD.
- Gerar 1 elastic IP e anexar à instância EC2.
- Liberar as Portas de comunicação para acesso publico:
	- 22/TCP
	- 111/TCP e UDP
	- 2049/TCP e UDP
	- 80/ TCP
	- 443/TCP
##### 2 - Linux
- Configurar o NFS entregue.
- Criar um diretório dentro do filesystem do NFS com seu nome.
- Subir um apache no servidor - o apache deve estar online e rodando.
- Criar um script que valide se o serviço esta online e envie o resultado da validação para o seu diretório no NFS.
- O script deve conter - Data HORA + nome do serviço + Status + mensagem personalizada de ONLINE ou offline.
- O script deve gerar 2 arquivos de saída: 1 para o serviço online e 1 para o serviço OFFLINE.
- Preparar a execução automatizada do script a cada 5 minutos.

---
### Preparando o Ambiente

Antes de iniciar a configuração do ambiente do projeto, e necessario que se tenha configurado uma vpc, um internet gateway associado a essa 
#### Key Pairs
- No serviço EC2, clique em "Key Pairs" no menu lateral esquerdo na seção "Network & Security".
- Clique em "Create Key Pair", selecione o nome da chave, o tipo de chave e o formato do arquivo ".pem" para Linux, e clique em "Create Key Pair".
- Após isso, guarde a chave em um local seguro.
#### Security Groups
- Ainda na seção "Network & Security", clique em "Security Groups".
- Clique em "Create Security Group".
- Escolha um nome e selecione uma VPC.
- Em "Inbound Rules", configure as seguintes regras e clique em "Create Security Group":
	![[tablela-de-portas.png]]
#### Configurando a Instancia
- No serviço EC2, clique em "Launch Instances".
- Selecione a imagem Amazon Linux 2.
- Escolha o tipo t3.small.
- Selecione a chave criada anteriormente.
- Na parte de rede e firewall, selecione o security group criado.
- Em armazenamento, selecione o valor de 16 GB.
- Clique em "Launch Instance" para criar e iniciar a instância.
#### Gerar o Elastic IP
- No serviço EC2, existe uma seção "Network & Security" no menu lateral. Clique em "Elastic IP".
- Clique em "Allocate Elastic IP Address", selecione a zona em que o IP será associado e clique em "Alocar".
- Selecione o IP gerado, clique em "Actions" e em "Associate Elastic Address", selecione a instância que receberá o IP.
#### Criando o EFS na AWS
- No serviço EFS, clique em "Create File System", clique em "Customize".
- Clique em "Next".
- Em rede, selecione o security group criado com as portas liberadas e clique em "Next".
- Por fim, conclua a criação clicando em "Next".
- Voltando para a tela do "File System", selecione o EFS criado, clique em "View Details".
- Clique em "Attach" e selecione "Mount via IP".
- Copie o comando para ser usado no cliente NFS.
### Configurando o NFS no Linux
#### Configurando o NFS
- Crie um diretório que será usado para montar o NFS:```sudo mkdir /home/ec2-user/efs/```.
- Monte o NFS com o comando:```sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport 172.31.11.137:/ efs/``` , no ultimo termo do comando coloque o diretório onde NFS será montado.
- Crie um novo diretório para o usuário renan com o comando: ```sudo mkdir efs/renan```.
#### Configurando o Serviço do Apache
- Instale o Apache com o comando ```sudo yum install -y httpd```.
- Habilite o serviço com o ```sudo systemctl enable httpd```.
- Inicie o serviço do Apache com ```sudo systemctl start httpd```.
- Para verificar se o serviço está ativo, use o comando ```sudo systemctl status httpd```.
#### Criação do Script de Verificação
- Crie o arquivo com o comando ```touch status_service.sh```
- Conceda as permissões de execução com o comando ```chmod +x status_service.sh```
- Abra o arquivo com ```nano status_service.sh```
- Adicione as linhas de código abaixo ao arquivo:
```bash
#!bin/bash

DATA=$(date +%d/%m/%Y)
HORA=$(date +%H:%M:%S)
SERVICO="httpd.service"
ESTADO=$(systemctl is-active $SERVICO)

if [ $ESTADO == 'active' ]; then
        echo "[ $DATA-$HORA ] - O serviço $SERVICO está ONLINE" >> /home/ec2-user/efs/renan/status.log
else
    	echo "[ $DATA-$HORA ] - O serviço $SERVICO está OFFLINE" >> /home/ec2-user/efs/renan/status.log
fi
```

- Salve e saia do editor de texto.
- Use o comando ```sh status_service.sh``` para executar o script.
#### Automatizando o script para cada 5 minutos.
- Para automatizar, foi utilizado o crontab, que é uma forma mais simples de automatizar, com o comando ```crontab -e```.
- Ao abrir o editor de texto, adicione o seguinte código ao arquivo: ```*/5 * * * * /home/ec2-user/status_do_servico.sh```.
- Salve o script e execute o comando ```crontab -l``` para verificar se foi adicionado corretamente.
- Caso o crontab não funcione é possivel abrir o arquivos do crontab com o ```sudo nano /etc/crontab``` e adicionar ao final do arquivo o serguite codigo ```*/5 * * * * ec2-user sudo /home/ec2-user/status_do_servico.sh```



