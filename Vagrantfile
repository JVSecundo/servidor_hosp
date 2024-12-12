Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  
  # Usando forwarded_port ao invés de bridge para maior compatibilidade
  config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
    vb.cpus = 2
  end

  config.vm.provision "shell", inline: <<-SHELL
    # Atualização do sistema
    sudo apt-get update -y
    sudo apt-get upgrade -y

    # Instalação do Apache e PHP primeiro
    sudo apt-get install -y apache2 php libapache2-mod-php
    sudo systemctl enable apache2
    sudo systemctl start apache2

    # Instalação do Docker e Docker Compose
    sudo apt-get install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker

    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

    # Copiar os arquivos da aplicação web
    sudo cp -r /vagrant/src/* /var/www/html/
  SHELL

  # Executar script de hardening por último
  config.vm.provision "shell", path: "script.sh"
end