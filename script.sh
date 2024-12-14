#atualizar pacotes
echo "Atualizando pacotes..."
apt-get update -y

# Instalar dependências necessárias para o Docker
echo "Instalando dependências para o Docker..."
apt-get install -y apt-transport-https ca-certificates curl software-properties-common

#adicionar chave GPG e repositório do Docker
echo "Adicionando chave GPG e repositório do Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

#instalar Docker e Docker Compose
echo "Instalando Docker e Docker Compose..."
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io

# Baixar e instalar o Docker Compose
echo "Baixando e instalando o Docker Compose..."
curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

#Verificar se o Docker e o Docker Compose estão instalados corretamente
echo "Verificando Docker e Docker Compose..."
docker --version
docker-compose --version

#instalar o Fail2Ban
echo "Instalando o Fail2Ban..."
apt-get install -y fail2ban

# Copiar o arquivo de configuração padrão do Fail2Ban
echo "Configurando o Fail2Ban..."
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Configurar Fail2Ban para monitorar o SSH
echo "[sshd]" >> /etc/fail2ban/jail.local
echo "enabled = true" >> /etc/fail2ban/jail.local
echo "port    = ssh" >> /etc/fail2ban/jail.local
echo "logpath = /var/log/auth.log" >> /etc/fail2ban/jail.local
echo "maxretry = 3" >> /etc/fail2ban/jail.local
echo "bantime  = 600" >> /etc/fail2ban/jail.local
echo "findtime = 600" >> /etc/fail2ban/jail.local

# Reiniciar o Fail2Ban
echo "Reiniciando o Fail2Ban..."
systemctl restart fail2ban

#verificar o status do Fail2Ban
echo "Status do Fail2Ban:"
systemctl status fail2ban

#constroi e iniciar os serviços do Docker Compose
echo "Construindo e iniciando os serviços do Docker Compose..."
docker-compose up -d

#Verificar se os serviços Docker Compose estão em execução
echo "Verificando status dos containers Docker..."
docker ps

echo "Configuração concluída com sucesso!"
