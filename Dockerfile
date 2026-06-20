FROM nginx:alpine
RUN rm /etc/nginx/conf.d/default.conf
COPY site/ /usr/share/nginx/html/
COPY start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]
