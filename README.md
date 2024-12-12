# Servidor Web Seguro

## Descrição
Implementação de um servidor web seguro com foco em hardening e boas práticas de segurança. 
Projeto desenvolvido para a disciplina de Segurança da Informação - IF Goiano Campus Ceres.

## Estrutura do Projeto
```
.
├── Vagrantfile           # Configuração da máquina virtual
├── script.sh            # Script de hardening
├── src/                 # Arquivos da aplicação web
│   ├── index.html
│   ├── style.css
│   └── script.js
└── README.md           # Documentação
```

## Requisitos
- VirtualBox
- Vagrant

## Implementação

### 1. Hardware (Via Vagrant)
- 1GB de RAM
- 2 CPUs
- Ubuntu 18.04 LTS (bionic64)

### 2. Configurações de Segurança Implementadas

#### Hardening do Sistema
- Atualizações automáticas habilitadas
- Fail2ban para proteção contra força bruta
- AppArmor ativado e configurado
- Firewall UFW configurado
- Serviços não essenciais desabilitados
- Políticas de senha fortes
- Limites do sistema configurados
- Auditoria do sistema ativa

#### Segurança do SSH
- Acesso root via SSH desabilitado
- Autenticação por senha desabilitada
- Máximo de 3 tentativas de autenticação
- Apenas chaves SSH permitidas

#### Segurança do Apache
- Informações da versão ocultas
- Assinatura do servidor desabilitada
- Método TRACE desabilitado
- Configurações padrão restritas

## Instalação e Uso

1. Clone o repositório:
```bash
git clone [URL_DO_REPOSITORIO]
```

2. Inicie a máquina virtual:
```bash
vagrant up
```

3. Para acessar o servidor:
```bash
vagrant ssh
```

4. O servidor web estará disponível em:
```
http://localhost:80
```

## Verificação de Segurança

Para verificar se as medidas de segurança estão funcionando:

1. Status do Fail2ban:
```bash
sudo fail2ban-client status
```

2. Status do Firewall:
```bash
sudo ufw status
```

3. Status do AppArmor:
```bash
sudo apparmor_status
```

4. Verificar serviços ativos:
```bash
systemctl list-units --type=service --state=active
```

## Autores
Nikolas de Hor, João Victor Secundo

## Professor Orientador
Roitier Campos Gonçalves