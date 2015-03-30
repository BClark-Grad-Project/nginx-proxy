upstream $UNIT_NAME {
  server $UNIT-ADDRESS
}


server {
  server_name $UNIT_NAME;
  listen 80;
  return 301 https://$server_name$request_uri;
}

server {
  server_name $UNIT_NAME;
  listen 443 ssl;

  ssl on;
  ssl_certificate         /etc/nginx/ssl/${UNIT_NAME}/server.crt;
  ssl_certificate_key     /etc/nginx/ssl/${UNIT_NAME}/server.key;

  # static file 404's aren't logged and expires header is set to maximum age
  location ~* \.(jpg|jpeg|gif|css|png|js|ico|html)$ {
        
        proxy_pass http://${UNIT_NAME};
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
  }
}
