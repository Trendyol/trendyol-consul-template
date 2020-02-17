<h1> Welcome to Trendyol Consul-Template Project 👋 </h1> 

# Prerequisites
You should install to cli tool to achieve this demo :
 
 - https://learn.hashicorp.com/consul/getting-started/install
 - https://stedolan.github.io/jq/download/

# Goal
This projects is a containerized application of consul-template tool with some modifications. <br/>
 - Checkout consul-template tool at : ```https://github.com/hashicorp/consul-template ```<br/>
 - Checkout our project at : ```https://github.com/Trendyol/trendyol-consul-template ```

 When you got your image on your local cache after pull command , you can inspect our images via inspect command and you should see some useful labels that added our image:
 ```docker
 $ docker image inspect trendyoltech/trendyol-consul-template:latest --format '{{json .Config.Labels}}'| jq
 {
   "org.opencontainers.image.authors": "trendyoltech",
   "org.opencontainers.image.created": "02-11-2020T11:00:43Z",
   "org.opencontainers.image.description": "This image is wrapper of consul-template",
   "org.opencontainers.image.revision": "bb43a36",
   "org.opencontainers.image.source": "https://github.com/Trendyol/trendyol-consul-template",
   "org.opencontainers.image.title": "Trendyol Consul Template Image",
   "org.opencontainers.image.vendor": "Trendyol",
   "org.opencontainers.image.version": "0.0.1"               
 } 
 ```
 # Environment Variables (ENV <env_name> » "explanation" [default_value])
 - ```ENV LOGGING_LEVEL``` » Logging level for consul-template tool. [debug]
 - ```ENV CONSUL_TEMPLATE_PROCESS_FLAGS``` » The flags for consul-template tool , https://github.com/hashicorp/consul-template#command-line-flags. [""]
 - ```ENV CONSUL_TEMPLATE_TEMPLATE_PATH``` » The path for input template to generate configuration file for the project. [""]
 - ```ENV CONSUL_TEMPLATE_OUTPUT_PATH``` » The output path for the generated configuration file from input template. [""]
 - ```ENV CONSUL_ADDR```  » The connection string to connect a Consul. [""]
 
 # Usage (in macOS)
 - Start a new Consul agent in dev mode on your host : ```$ consul agent -dev```
 - Create a working director , for example : ```$ mkdir base```
 - Go to working directory and create a new template file : ```$ echo 'hello to : {{ key "hello/target"  }}' >> init.tpl```
 - Prepare your key's value on Consul K/V Store:  ```$ consul kv put hello/target trendyol```
 - Start your docker container with using volumes to mount init.tpl to container :  <br/>
 ```
 $ docker container run --rm --name trendyol-consul-template \
         -e CONSUL_ADDR=host.docker.internal:8500 \
         -e CONSUL_TEMPLATE_TEMPLATE_PATH=/conf/init.tpl \
         -e CONSUL_TEMPLATE_OUTPUT_PATH=/conf/output.txt \
        -v $(pwd):/conf trendyoltech/trendyol-consul-template:latest```
Then check your output file inside your working directory, you should see "hello to: trendyol" : ```$ cat output.txt```
