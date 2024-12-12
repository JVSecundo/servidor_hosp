#!/bin/bash

# Script de Hardening para Servidor Web
echo "Iniciando processo de hardening do servidor..."

# 1. Atualizações do sistema
echo "Atualizando o sistema..."
apt-get update && apt-get upgrade -y

# 2. Instalação de ferramentas de segurança
echo "Instalando ferramentas de segurança..."
apt-get install -y ufw fail2ban unattended-upgrades apparmor apparmor-utils

# 3. Configurar atualizações automáticas
echo "Configurando atualizações automáticas..."
dpkg-reconfigure -plow unattended-upgrades

# 4. Configurar fail2ban para proteção contra força bruta
echo "Configurando fail2ban..."
cat > /etc/fail2ban/jail.local <<EOF
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 3

[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
EOF

systemctl enable fail2ban
systemctl start fail2ban

# 5. Configurar SSH
echo "Configurando SSH..."
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/#MaxAuthTries 6/MaxAuthTries 3/' /etc/ssh/sshd_config
# Mantendo autenticação por senha para permitir vagrant ssh
# sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# 6. Configurar firewall (UFW)
echo "Configurando firewall..."
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 80/tcp
ufw allow 443/tcp
echo "y" | ufw enable

# 7. Desabilitar serviços não necessários
echo "Desabilitando serviços desnecessários..."
systemctl disable cups
systemctl disable bluetooth
systemctl disable avahi-daemon

# 8. Configurar AppArmor
echo "Configurando AppArmor..."
aa-enforce /etc/apparmor.d/*

# 9. Configurar políticas de senha
echo "Configurando políticas de senha..."
sed -i 's/PASS_MAX_DAYS\t99999/PASS_MAX_DAYS\t90/' /etc/login.defs
sed -i 's/PASS_MIN_DAYS\t0/PASS_MIN_DAYS\t10/' /etc/login.defs
sed -i 's/PASS_WARN_AGE\t7/PASS_WARN_AGE\t7/' /etc/login.defs

# 10. Configurar limites do sistema
echo "Configurando limites do sistema..."
cat >> /etc/security/limits.conf <<EOF
* soft core 0
* hard core 0
* soft nproc 1000
* hard nproc 2000
EOF

# 11. Hardening do Apache
echo "Configurando segurança do Apache..."
cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.bak
cat >> /etc/apache2/apache2.conf <<EOF
ServerTokens Prod
ServerSignature Off
TraceEnable Off
EOF

# 12. Auditoria do sistema
echo "Configurando auditoria do sistema..."
apt-get install -y auditd
systemctl enable auditd
systemctl start auditd

echo "Processo de hardening concluído!"
echo "Por favor, verifique os logs para garantir que tudo foi aplicado corretamente."