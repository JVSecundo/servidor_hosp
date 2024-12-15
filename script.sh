#!/bin/bash

# Atualização do sistema
apt-get update -y && apt-get upgrade -y
apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Fail2Ban
apt-get install -y fail2ban
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

sudo bash -c 'cat > /etc/fail2ban/jail.local << EOL
[DEFAULT]
bantime = 10m
findtime = 10m
maxretry = 3

[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 10m
EOL'

systemctl enable fail2ban
systemctl restart fail2ban

# UFW
apt-get install -y ufw
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 80/tcp
ufw allow 443/tcp
echo "y" | ufw enable
ufw status


# AppArmor
apt-get install -y apparmor apparmor-utils
systemctl enable apparmor
systemctl start apparmor

# Auditd
apt-get install -y auditd audispd-plugins

cat > /etc/audit/rules.d/audit.rules << EOL
-w /etc/passwd -p wa -k identity
-w /etc/group -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/sudoers -p wa -k identity
-w /var/log/auth.log -p wa -k sudo_log
-w /var/log/sudo.log -p wa -k sudo_log
-w /etc/systemd/ -p wa -k systemd
-w /etc/init.d/ -p wa -k init
-w /etc/security/ -p wa -k security
EOL

systemctl enable auditd
systemctl restart auditd

# Script de coleta de evidências
cat > /usr/local/bin/collect-evidence << 'EOL'
#!/bin/bash

EVIDENCE_DIR="/var/log/security_evidence"
mkdir -p $EVIDENCE_DIR
cd $EVIDENCE_DIR

echo "=== Fail2Ban Status ===" > fail2ban.log
fail2ban-client status >> fail2ban.log

echo "=== UFW Status ===" > ufw.log
ufw status verbose >> ufw.log

echo "=== AppArmor Status ===" > apparmor.log
aa-status >> apparmor.log

echo "=== Audit Status ===" > audit.log
auditctl -l >> audit.log
aureport --summary >> audit.log

tar -czf evidence.tar.gz *.log
echo "Evidências coletadas em $EVIDENCE_DIR/evidence.tar.gz"
EOL

chmod +x /usr/local/bin/collect-evidence

# Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

# Docker Compose
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Ativar serviços
systemctl enable docker
systemctl start docker

# Verificar instalações
docker --version
docker-compose --version
fail2ban-client status
ufw status
aa-status
systemctl status auditd

echo "Script de hardening concluído com sucesso!"