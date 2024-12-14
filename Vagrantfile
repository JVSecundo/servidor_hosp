Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  
  #usando forwarded_port para acessar o Apache no contêiner
  config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
    vb.cpus = 2
  end

  config.vm.provision "shell", inline: <<-SHELL
    #atualização do sistema
    sudo apt-get update -y
    sudo apt-get upgrade -y

    #instalação do Docker
    sudo apt-get install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker

    #instalação do Docker Compose
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

    #Subir os contêineres com o docker-compose.yml
    cd /vagrant
    sudo docker-compose up -d
  SHELL

  #executar script de hardening por último
  config.vm.provision "shell", path: "script.sh"
end
