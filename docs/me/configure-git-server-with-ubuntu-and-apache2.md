# Configure Git Server With Ubuntn and Apache 2

I always wanted to establish a local git server that I can push my code or other material on it. But there is no enough time for me to take it into practice. And This weekend, I make it working. So, I want to record this process for review.


I have a respberry pi 3 Model B Card Computer, and Ubuntu System is hosted on it. So, I can manipulate it through the ssh protocol by my Mac Book Pro terminal.

So, Let's start working!


First, we should install the `git` and `Apache Http Server`, using command as follow:

```
sudo apt-get install git apache2
```

With `git` installed, we can create our repositories on local disk.

With `Apache2 Http Server` installed, we can make the local disk repositories be access by other people connecting the same local network. 

So, we should go under the directory: `/var/www/html/	` to create our bare git repository and configure it with command: 

```
pi@raspberrypi:~/Documents $ sudo git init --bare /var/www/html/sample.git
Initialized empty Git repository in /var/www/html/sample.git/
pi@raspberrypi:~ $ cd /var/www/html/sample.git/hooks/
pi@raspberrypi:/var/www/html/sample.git/hooks $ sudo mv post-update.sample post-update
pi@raspberrypi:/var/www/html/sample.git/hooks $ sudo chmod a+x post-update 
pi@raspberrypi:/var/www/html/sample.git/hooks $ cd ..
pi@raspberrypi:/var/www/html/sample.git $ sudo git update-server-info
```

because the directory:`/var/www/html/` is the default apache2 http server's root directory.


After we create the bare git repository under the server root directory, we should start the apache2 http server to make this repository been access by other in the same network.

Before we start apache, we should configure it. We add the line:

```
ServerName localhost:80
```
into the top of the configuration file named: `apache2.conf`, which is under directory: `/etc/apache2/`. We can use the `vim` editor the change it as follow:


```
sudo vi /etc/apache2/apache2.conf
```

The `apache2.conf` be changed as follow:

```
ServerName localhost:80
# This is the main Apache server configuration file.  It contains the
# configuration directives that give the server its instructions.
# See http://httpd.apache.org/docs/2.4/ for detailed information about
# the directives and /usr/share/doc/apache2/README.Debian about Debian specific
# hints.
#
#
# Summary of how the Apache 2 configuration works in Debian:
# The Apache 2 web server configuration in Debian is quite different to
# upstream's suggested way to configure the web server. This is because Debian's
# default Apache2 installation attempts to make adding and removing modules,
# virtual hosts, and extra configuration directives as flexible as possible, in
# order to make automating the changes and administering the server as easy as
# possible.

# It is split into several files forming the configuration hierarchy outlined
# below, all located in the /etc/apache2/ directory:
#
#       /etc/apache2/
#       |-- apache2.conf
#       |       `--  ports.conf
#       |-- mods-enabled
#       |       |-- *.load

```                                                                                                                                                                             
We save the changed file and exit with `:wq` vim command.

Now, we shoud start the http serve using the command: 

```
pi@raspberrypi:~ $ sudo /etc/init.d/apache2 restart 
[ ok ] Restarting apache2 (via systemctl): apache2.service.
```

if you use your browser with url: `http://192.168.0.121` and see some web page with title `Apache2 Debian Default Page`, congratulation! you web server is working.

**Note:**  The `ip: 192.168.0.121` may be not the same as you, or you can use the `127.0.0.1` if you work in the same one computer)

Then you can clone you repository from the apache http server with the command on another computer in the same network:

```
localhost:~ wangzhizhou$ git clone http://192.168.0.121/sample.git
Cloning into 'sample'...
warning: You appear to have cloned an empty repository.
Checking connectivity... done.
```


Of course, you can clone the repository under the same computer with the command: 

```
pi@raspberrypi:~ $ git clone http://localhost/sample.git
Cloning into 'sample'...
warning: You appear to have cloned an empty repository.
Checking connectivity... done.
```

**or**

```
pi@raspberrypi:~ $ git clone http://127.0.0.1/sample.git
Cloning into 'sample'...
warning: You appear to have cloned an empty repository.
Checking connectivity... done.
```

Because, the `localhost` is equal the ip: `127.0.0.1`

Now, you can pull repository from server, but you can not push your code to it, because the server directory access permission should be configured properly! This should be studied deeperly!


