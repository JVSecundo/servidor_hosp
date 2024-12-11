FROM php:7.4-apache

# Copiar os arquivos do diretório src para o diretório de documentos do Apache
COPY ./src/ /var/www/html/

# Ativar módulos do Apache necessários
RUN docker-php-ext-install mysqli

# Exponhe a porta 80
EXPOSE 80
