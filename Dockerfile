FROM archlinux:latest

# Update and install necessary packages
RUN pacman -Syu --noconfirm && \
    pacman -S vsftpd openssh rclone openssl --noconfirm

# Generate a self-signed certificate for FTPS
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/vsftpd.pem \
    -out /etc/ssl/certs/vsftpd.pem \
    -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com"

# Copy vsftpd and SSHD configurations
COPY vsftpd.conf /etc/vsftpd.conf
COPY sshd_config /etc/ssh/sshd_config

# Copy rclone configuration (assuming you've set it up on your host machine)
COPY rclone.conf /root/.config/rclone/rclone.conf

# Copy script to move files to SharePoint
COPY move_to_sharepoint.sh /move_to_sharepoint.sh

# Expose FTP, FTPS, and SFTP ports
EXPOSE 21 22

# Start vsftpd and SSHD
CMD service ssh start && vsftpd /etc/vsftpd.conf
