sudo apt update && sudo apt upgrade -y
sudo apt install openjdk-17-jdk -y

cd /opt
sudo wget https://archive.apache.org/dist/kafka/3.6.2/kafka_2.13-3.6.2.tgz
sudo tar -xvzf kafka_2.13-3.6.2.tgz
sudo mv kafka_2.13-3.6.2 kafka
sudo chown -R ubuntu:ubuntu /opt/kafka
