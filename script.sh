
### 3. **script.sh**
Esse script aplica as configurações de hardening no servidor. Ele pode incluir atualizações e configurações de firewall.

```bash
#!/bin/bash
# Atualizar pacotes
apt-get update && apt-get upgrade -y

# Desabilitar serviços não necessários
systemctl disable cups
systemctl disable avahi-daemon

# Configurar firewall
ufw enable
ufw allow ssh
ufw allow 'Apache Full'
