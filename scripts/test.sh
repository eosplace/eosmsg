#! //bin/bash

source ./setup.sh

cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} push action eosdirectmsg sendmsg '["player1","player2","mensagem to player2"]' -p player1
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} push action eosdirectmsg sendmsg '["player2","player1","mensagem to player1"]' -p player2
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} push action eosdirectmsg sendmsg '["player3","player1","mensagem to player1 from 3"]' -p player3

cleos -u http://${NODE_EOS}:8800 get table eosdirectmsg eosdirectmsg notification -l 100
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} push action eosdirectmsg receivemsg '["player1",1]' -p player1
cleos -u http://${NODE_EOS}:8800 get table eosdirectmsg eosdirectmsg notification -l 100
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} push action eosdirectmsg erasemsg '["player1",0]' -p player1
cleos -u http://${NODE_EOS}:8800 get table eosdirectmsg eosdirectmsg notification -l 100

echo "bets ctgbarbeting"
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} push action ctgbarbeting newgame '["Jogo1","Brazil","Germany",3,"1.0000 EOS", "10.0000 EOS",2019,07,30,0,0,"","Russia"]' -p ctgbarbeting
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} push action ctgbarbeting newgame '["Jogo2","Brazil","France",5,"1.0000 EOS", "10.0000 EOS",2019,07,30,0,0,"","Russia"]' -p ctgbarbeting
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} push action ctgbarbeting newgame '["Jogo3","Brazil","Mexico",10,"1.0000 EOS", "10.0000 EOS",2019,07,30,0,0,"","Russia"]' -p ctgbarbeting

echo "----- bets"
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} transfer player1 ctgbarbeting "2.0000 EOS"  "0,2,1" -p player1
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} transfer player2 ctgbarbeting "5.0000 EOS"  "0,1,1" -p player2
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} transfer player3 ctgbarbeting "10.0000 EOS" "0,3,1" -p player3

echo "----- Finalizing game with only one winner"
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} push action ctgbarbeting finalize '[0, 2, 1 ]' -p ctgbarbeting

echo "----- Show table player"
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} get table ctgbarbeting ctgbarbeting player
