#! //bin/bash

source ./setup.sh

echo "----- Jogo que tera ganhador unico" 
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} push action ctgbarbeting newgame '["Jogo1","Brazil","Germany",3,"1.0000 EOS", "10.0000 EOS",2019,07,30,0,0,"","Russia"]' -p ctgbarbeting 

# echo "----- Jogo que tera 2 ganhadores"
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} push action ctgbarbeting newgame '["Jogo2","Brazil","France",5,"1.0000 EOS", "10.0000 EOS",2019,07,30,0,0,"","Russia"]' -p ctgbarbeting 

# echo "----- Jogo que nao tera ganhadores"
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} push action ctgbarbeting newgame '["Jogo3","Brazil","Mexico",10,"1.0000 EOS", "10.0000 EOS",2019,07,30,0,0,"","Russia"]' -p ctgbarbeting

echo "----- listing games" 
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} get table ctgbarbeting ctgbarbeting game

echo "----- show saldos"
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} get table eosio.token player1 accounts
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} get table eosio.token player2 accounts
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} get table eosio.token player3 accounts

echo "----- bets"
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} transfer player1 ctgbarbeting "2.0000 EOS"  "0,2,1" -p player1
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} transfer player2 ctgbarbeting "5.0000 EOS"  "0,1,1" -p player2
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} transfer player3 ctgbarbeting "10.0000 EOS" "0,3,1" -p player3
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} transfer player1 ctgbarbeting "10.0000 EOS"  "1,1,2" -p player1
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} transfer player2 ctgbarbeting "7.0000 EOS"  "1,1,2" -p player2
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} transfer player3 ctgbarbeting "5.0000 EOS" "1,2,1" -p player3
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} transfer player1 ctgbarbeting "5.0000 EOS"  "2,1,2" -p player1
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} transfer player2 ctgbarbeting "1.0000 EOS"  "2,1,2" -p player2
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} transfer player3 ctgbarbeting "4.0000 EOS" "2,1,1" -p player3

echo "----- show saldos"
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} get table eosio.token player1 accounts
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} get table eosio.token player2 accounts
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} get table eosio.token player3 accounts
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} get table eosio.token ctgbarbeting accounts
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} get table eosio.token feebarbeting accounts

echo "----- listing bets" 
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} get table ctgbarbeting ctgbarbeting bet


echo "----- Finalizing game with only one winner"
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} push action ctgbarbeting finalize '[0, 2, 1 ]' -p ctgbarbeting


echo "----- show saldos"
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} get table eosio.token ctgbarbeting accounts
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} get table eosio.token feebarbeting accounts

echo "----- Finalizing game with 2 winners"
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} push action ctgbarbeting finalize '[1, 1, 2 ]' -p ctgbarbeting

echo "----- show saldos"
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} get table eosio.token ctgbarbeting accounts
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} get table eosio.token feebarbeting accounts


echo "----- Finalizing game without winners"
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} push action ctgbarbeting finalize '[2, 5, 5 ]' -p ctgbarbeting

echo "----- show saldos"
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} get table eosio.token ctgbarbeting accounts
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} get table eosio.token feebarbeting accounts

echo "----- listing games" 
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} get table ctgbarbeting ctgbarbeting game

echo "----- Show table player"
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} get table ctgbarbeting ctgbarbeting player

echo "----- show saldos"
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} get table eosio.token player1 accounts
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} get table eosio.token player2 accounts
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} get table eosio.token player3 accounts

echo "----- Claim tokens"
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} push action ctgbarbeting claim '["player1"]' -p player1
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} push action ctgbarbeting claim '["player2"]' -p player2
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} push action ctgbarbeting claim '["player3"]' -p player3

echo "----- Show table player"
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} get table ctgbarbeting ctgbarbeting player

echo "----- show saldos"
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} get table eosio.token player1 accounts
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} get table eosio.token player2 accounts
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} get table eosio.token player3 accounts
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} get table eosio.token ctgbarbeting accounts
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} get table eosio.token feebarbeting accounts


echo "----- listing games" 
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} get table ctgbarbeting ctgbarbeting game

echo "----- listing bets" 
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} get table ctgbarbeting ctgbarbeting bet

echo "----- Releasing game ram"
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} push action ctgbarbeting relgameram '[0]' -p ctgbarbeting
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} push action ctgbarbeting relgameram '[2]' -p ctgbarbeting

echo "----- listing games" 
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} get table ctgbarbeting ctgbarbeting game

echo "----- listing bets" 
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} get table ctgbarbeting ctgbarbeting bet
