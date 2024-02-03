#compass_atividade_linux_aws

**Objetivo:** A atividade se trata em criar uma instancia na aws e configurar o protocolo NFS (Network File Sharing) para o armazenamento de dados, configurar um servidor apache e gerar scripts que valide a execução do serviço onde o resultado do script seja armazenado no NFS configurado.

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
