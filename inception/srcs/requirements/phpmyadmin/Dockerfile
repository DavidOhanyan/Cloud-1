# Используем официальный образ phpMyAdmin
FROM phpmyadmin/phpmyadmin:latest

# Создаем файл конфигурации Apache с ServerName _
RUN echo "ServerName _" > /etc/apache2/conf-available/servername.conf

# Включаем эту конфигурацию
RUN a2enconf servername

# Перезапускаем Apache, чтобы применить изменения
RUN service apache2 restart

# Оставляем стандартную команду для phpMyAdmin
CMD ["apache2-foreground"]

