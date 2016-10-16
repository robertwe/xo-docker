### Xen Orchestra docker image
To run it you need to first:    
  
  1. Build docker container: `docker build -t xo-server:latest .`    
  2. Run XO container and link it to Redis container `docker run -d --name xo-server --link redis:redis -p 8080:8080 xo-server:latest`
