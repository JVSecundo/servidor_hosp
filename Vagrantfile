Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.network "public_network", bridge: "Wi-Fi"  # Use "Wi-Fi" como o nome da interface

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
    vb.cpus = 2
  end

  config.vm.provision "shell", inline: <<-SHELL
    # Atualização do sistema
    sudo apt-get update -y
    sudo apt-get upgrade -y

    # Instalação do Docker
    sudo apt-get install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker

    # Instalação do Docker Compose
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

    # Instalação do Apache e PHP (XAMPP)
    sudo apt-get install -y apache2 php libapache2-mod-php
    sudo systemctl enable apache2
    sudo systemctl start apache2

    # Firewall básico
    sudo ufw allow OpenSSH
    sudo ufw enable
  SHELL
end
