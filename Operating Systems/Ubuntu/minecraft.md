# Minecraft
## Initial Setup

Make a new user
```sh
sudo adduser minecraft
sudo usermod -aG sudo minecraft
```

Update and install java
```sh
sudo apt-get -y upgrade
sudo apt-get -y update
sudo apt-get -y install default-jdk
```
Install Git
```
sudo apt-get install git
```

**Login to minecraft user**

## New World
Get tools and create world
```sh
wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
wget https://cdn.getbukkit.org/spigot/spigot-x.y.z.jar
java -jar /home/minecraft/world/spigot-x.y.z.jar nogui
nano eula.txt
```

## Old World
Enter directory, clone repo
```
cd /home/minecraft
git clone https://github.com/JosephBateh/world.git
```

Check if it runs correctly.
```
cd world/
git checkout Neon
java -jar /home/minecraft/world/spigot-1.9.4.jar nogui
op WorldEdit
```

## Create a new system service
```sh
sudo nano /etc/systemd/system/minecraft-server.service
```
Copy and paste the following, replacing brackets with your information

```
[Unit]
Description=<Server Name>

[Service]
WorkingDirectory=/home/minecraft/world
User=minecraft
Group=minecraft
Restart=on-failure
RestartSec=20 5
ExecStart=/usr/bin/java -Xms256m -Xmx768m -jar spigot-1.9.4.jar nogui -noconsole

[Install]
WantedBy=multi-user.target
```

Reload services

```
sudo systemctl daemon-reload
sudo systemctl enable minecraft-server
```

To run the service manually
```
sudo service minecraft-server start
```
To check the status
```
sudo systemctl status minecraft-server.service
```

## Other
To accept EULA
```sh
sudo nano eula.txt
```
To use different build tools
```sh
wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
wget http://www.mediafire.com/download/6h09558h3ekzyd3/spigot-x.y.z.jar
```
