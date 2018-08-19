#! //bin/bash

source ./setup.sh

cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} push action eosmsg sendmsg  '["player1","player2","mensagem to player2"]' -p player1
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} push action eosmsg sendmsg  '["player2","player1","mensagem to player1"]' -p player2
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} push action eosmsg sendmsg  '["player3","player1","mensagem to player1 from 3"]' -p player3

cleos -u http://${NODE_EOS}:8800 get table eosmsg eosmsg notification -l 100

cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} push action eosmsg receivemsg '["player1",1]' -p player1

cleos -u http://${NODE_EOS}:8800 get table eosmsg eosmsg notification -l 100

cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} push action eosmsg erasemsg '["player1",0]' -p player1

cleos -u http://${NODE_EOS}:8800 get table eosmsg eosmsg notification -l 100
