FROM ubuntu
RUN apt-get update && apt-get install -y apache2
COPY . /var/www/html/
EXPOSE 80
CMD ["apache2ctl", "-D", "FOREGROUND"]