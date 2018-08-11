#!/bin/bash 

NODE_EOS=192.168.0.105

echo "NOTIFICATIONS"
cleos -u http://${NODE_EOS}:8800 get table eosmsg eosmsg notification -l 100 

echo "MESSAGES eosmsg"
cleos -u http://${NODE_EOS}:8800 get table eosmsg eosmsg message -l 100

echo "MESSAGES player1"
cleos -u http://${NODE_EOS}:8800 get table eosmsg player1 message -l 100

echo "MESSAGES player2"
cleos -u http://${NODE_EOS}:8800 get table eosmsg player2 message -l 100

