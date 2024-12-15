# Servidor Web Seguro

## Descrição
Este projeto tem como objetivo implementar um servidor web seguro com foco em hardening e boas práticas de segurança. O servidor é provisionado automaticamente usando o Vagrant e Docker. Além disso, todas as configurações de segurança, como **Fail2Ban**, **AppArmor**, **UFW** e **SSH** seguro, são aplicadas. A aplicação web é executada dentro de um contêiner Docker.
Projeto desenvolvido para a disciplina de Segurança da Informação - IF Goiano Campus Ceres.

## Estrutura do Projeto
```
.
├── Vagrantfile           # Configuração da máquina virtual
├── docker-compose.yml    # Configuração do Docker Compose
├── script.sh             # Script de hardening
├── src/                  # Arquivos da aplicação web
│   ├── index.html
│   ├── style.css
│   └── script.js
└── README.md             # Documentação
```

## Requisitos
- **VirtualBox**
- **Vagrant**
- **Docker**
- **Docker Compose**
  
## Implementação


### 1. Planejamento do Hardware
A máquina virtual foi configurada com as seguintes especificações:
- 1 GB de RAM
- 2 CPUs
- Ubuntu 20.04 LTS

### 2. Instalação e Configuração do Sistema Operacional
O servidor é provisionado automaticamente via **Vagrantfile** e o sistema operacional Ubuntu 20.04 LTS é configurado com as dependências necessárias.

### 3. Implementação de Hardening
O script de hardening **script.sh** realiza as seguintes ações:
- Atualizações automáticas
- Instalação e configuração de **Fail2Ban**
- Configuração do **AppArmor**
- Configuração do firewall **UFW**
- Desabilitação de serviços não essenciais
- Configuração de **SSH seguro**
- Instalação de **auditd** para auditoria de segurança

### 4. Docker e Docker Compose
A aplicação web é executada dentro de um contêiner Docker, configurado via **docker-compose.yml**. O Docker e o Docker Compose são instalados no servidor.

### 5. Como Usar

1. Clone o repositório:
```
git clone [https://github.com/JVSecundo/servidor_hosp.git]
cd [servidor_hosp]
```
2. Inicie a máquina virtual:
```
vagrant up
```

3. Acesse a máquina virtual:
```
vagrant ssh
```

4.  Inicie o Docker Compose  
```
cd /vagrant
sudo docker-compose up -d
```
**Se o comando retornar um erro, é porque o Docker Compose não está instalado corretamente.**

**Baixar a versão mais recente do Docker Compose**

Usar wget com Tolerância a Falhas, o **wget** é mais robusto para redes instáveis.

```
sudo apt-get install -y wget

sudo wget --tries=20 --continue -O /usr/local/bin/docker-compose "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)"

```

**Tornar o arquivo executável**

```
sudo chmod +x /usr/local/bin/docker-compose

```

**Verifique a versão instalada**

```
docker-compose --version

```

**Executar o Compose: Executar o projeto com**

```
sudo docker-compose up -d

```

**Visualizar os logs de um serviço gerenciado pelo Docker Compose**

```
sudo docker-compose logs

```


5. O servidor web estará disponível em:
```
http://localhost:8080
```

## Verificação de Segurança

Após a execução do script de hardening, você pode verificar o status dos serviços de segurança usando os seguintes comandos:

### 1. Verificar Status do Fail2Ban
```
# Ver status geral do Fail2Ban
sudo fail2ban-client status

# Ver status específico da jail SSH
sudo fail2ban-client status sshd
```

### 2. Verificar Status do Firewall (UFW)
```
# Ver status e regras ativas
sudo ufw status verbose

# Ver regras numeradas (útil para gerenciamento)
sudo ufw status numbered
```

### 3. Verificar Status do AppArmor
```
# Ver status do AppArmor
sudo aa-status
```

### 4. Verificar Status do Auditd
```
# Ver regras de auditoria ativas
sudo auditctl -l

# Ver resumo dos eventos de auditoria
sudo aureport --summary
```

### 5. Verificar Todos os Serviços Ativos
```
# Listar serviços ativos
systemctl list-units --type=service --state=active
```

## Coletando Evidências de Hardening

Para facilitar a coleta de evidências durante a apresentação, use o script automatizado:

```
sudo collect-evidence
```

Este comando irá:
1. Criar um diretório `/var/log/security_evidence`
2. Coletar status de todos os serviços de segurança
3. Gerar um arquivo compactado com todas as evidências

### Verificando as Evidências Coletadas

Após executar o script de coleta, você pode verificar as evidências:

```
# Ver o arquivo de evidências gerado
ls -l /var/log/security_evidence/evidence.tar.gz

# Extrair e ver o conteúdo
cd /var/log/security_evidence
tar -xzf evidence.tar.gz
cat fail2ban.log
cat ufw.log
cat apparmor.log
cat audit.log
```

## Testando as Medidas de Segurança

Para demonstrar que as medidas de segurança estão funcionando:

1. Teste do Fail2Ban:
```
# Tente fazer login SSH com senha errada várias vezes
# Depois verifique se o IP foi banido:
sudo fail2ban-client status sshd
```

2. Teste do Firewall:
```
# Tente acessar uma porta não permitida
# Verifique os logs:
sudo tail -f /var/log/ufw.log
```

3. Teste do Auditd:
```
# Faça alguma alteração em arquivo monitorado
sudo touch /etc/passwd
# Verifique os logs:
sudo ausearch -f /etc/passwd
```

### Apresentação do Projeto


1. **IMG Provisionamento Automático**

![Comando: vagrant up](assets/up.png)

2. **IMG Docker compose em execução**

![Comando: docker-compose --version ](assets/docker1.png)

![Comando: docker-compose --version ](assets/docker2.png)

![Comando: sudo docker-compose logs ](assets/logs1.png)

**Logs Docker**

3. **IMG a Aplicação Web**

![Aplicação WEB](assets/web.png)

4. **IMG Logs de Segurança**

   
## Autores
Nikolas de Hor, João Victor Secundo

## Professor Orientador
Roitier Campos Gonçalves
