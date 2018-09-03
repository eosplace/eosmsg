#!/bin/bash 

EOS_CONTRACTS=/home/trumae/eos/eosio/build/contracts
NODE_EOS=192.168.0.105
PORT=8899

echo "Stopping process/server" 
killall -9 nodeos
killall -9 keosd

echo "Cleaning database" 
rm -rf ~/.local/share/eosio
rm -rf ~/eosio-wallet

echo "Starting nodeos and keosd" 
keosd --http-server-address ${NODE_EOS}:${PORT} > /dev/null 2> /dev/null &
nodeos --contracts-console --config-dir . 2> nodeos.log &

echo "Waiting servers ... " 
sleep 3 

echo "Initializing wallet" 
cleos --wallet-url http://${NODE_EOS}:${PORT}  wallet create | tail -n 1 | cut -d'"' -f 2 > key.wallet 
cat key.wallet | cleos --wallet-url http://${NODE_EOS}:${PORT}  wallet unlock

echo "Importing keys" 
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} wallet import --private-key 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} wallet import --private-key 5KEFmzRkaWXZh2XF3SkPenzsGMrfdJvDGapmjBbKwZrGfU2ZWxa

echo "Sending bios contract" 
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} set contract eosio ${EOS_CONTRACTS}/eosio.bios -p eosio 

echo "Creating system users"
for user in eosio.bpay eosio.msig eosio.names eosio.ram eosio.ramfee eosio.saving eosio.stake eosio.token eosio.vpay; do	    
   cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} create account eosio ${user} EOS7rMZfsA4yucaLyuEzAiBrhKj221qABT5zuKqtsq1Q1a1iVxe8M EOS7rMZfsA4yucaLyuEzAiBrhKj221qABT5zuKqtsq1Q1a1iVxe8M
done

echo "Sending eosio.token contract"
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} set contract eosio.token ${EOS_CONTRACTS}/eosio.token -p eosio.token

echo "Sending eosio.msig contract"
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} set contract eosio.msig ${EOS_CONTRACTS}/eosio.msig -p eosio.msig

echo "Creating eosdirectmsg user and registring contract" 
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT}  create account eosio eosdirectmsg EOS7rMZfsA4yucaLyuEzAiBrhKj221qABT5zuKqtsq1Q1a1iVxe8M EOS7rMZfsA4yucaLyuEzAiBrhKj221qABT5zuKqtsq1Q1a1iVxe8M
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} set contract eosdirectmsg ../contract/ -p eosdirectmsg


echo "Creating player1"
### Private key: 5JDM42HnuB1oVNWmdkcLPozEvMztyqnkVLdJDcqfD38NVht68ck
### Public key: EOS6pXfwZ976YHeNiRgWewX3ZTmmyTD5ej8RkWoQDQXw4J63zNnov
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} create account eosio player1 EOS7oWRkoquFbJstwms4bMUM2LB1qQ9kG8mZ7FjxEMFcCAre3miGu EOS6pXfwZ976YHeNiRgWewX3ZTmmyTD5ej8RkWoQDQXw4J63zNnov
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} wallet import --private-key 5JDM42HnuB1oVNWmdkcLPozEvMztyqnkVLdJDcqfD38NVht68ck

echo "Creating player2"
### Private key: 5J4sU5tBujAq6xdkQLuYohKPBFuTj4Er9fCtpBYmibrchNCe4L7
### Public key: EOS6AcefxUgbQQeK7hXRTyAn2gxgZmsRyKZLVFeUnWrY1p4oMo2Ee
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} create account eosio player2 EOS7oWRkoquFbJstwms4bMUM2LB1qQ9kG8mZ7FjxEMFcCAre3miGu EOS6AcefxUgbQQeK7hXRTyAn2gxgZmsRyKZLVFeUnWrY1p4oMo2Ee
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} wallet import --private-key 5J4sU5tBujAq6xdkQLuYohKPBFuTj4Er9fCtpBYmibrchNCe4L7

echo "Creating player3"
### Private key: 5KDSPKGxwnrhDWyczJW7MYs6HM2YaYorri1kN8gY4yx4FGDRSXf
### Public key: EOS6ZXD8W9ttK3PzypRpGmE7Y2pQq151k9jjEQc4LQq1rivk2Fpu1
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} create account eosio player3 EOS7oWRkoquFbJstwms4bMUM2LB1qQ9kG8mZ7FjxEMFcCAre3miGu EOS6ZXD8W9ttK3PzypRpGmE7Y2pQq151k9jjEQc4LQq1rivk2Fpu1
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} wallet import --private-key 5KDSPKGxwnrhDWyczJW7MYs6HM2YaYorri1kN8gY4yx4FGDRSXf

echo "Creating and issue EOS token" 
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} push action eosio.token create '["eosio", "1000000000.0000 EOS" ]' -p eosio.token
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} push action eosio.token issue '[ "player1", "1000.0000 EOS", "issue" ]' -p eosio
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} push action eosio.token issue '[ "player2", "1000.0000 EOS", "issue" ]' -p eosio
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} push action eosio.token issue '[ "player3", "1000.0000 EOS", "issue" ]' -p eosio


echo "Creating ctgbarbeting user and registring contract ctgbarbeting " 
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT}  create account eosio ctgbarbeting EOS7rMZfsA4yucaLyuEzAiBrhKj221qABT5zuKqtsq1Q1a1iVxe8M EOS7rMZfsA4yucaLyuEzAiBrhKj221qABT5zuKqtsq1Q1a1iVxe8M
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT}  create account eosio feebarbeting EOS7rMZfsA4yucaLyuEzAiBrhKj221qABT5zuKqtsq1Q1a1iVxe8M EOS7rMZfsA4yucaLyuEzAiBrhKj221qABT5zuKqtsq1Q1a1iVxe8M
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} set contract ctgbarbeting /home/trumae/eos/goalbarclub/contracts/ctgbarbeting/contract/ -p ctgbarbeting

echo "Allow contract send money"
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} set account permission ctgbarbeting active '{"threshold":1, "keys":[{"key":"EOS7rMZfsA4yucaLyuEzAiBrhKj221qABT5zuKqtsq1Q1a1iVxe8M", "weight":1}], "accounts": [{"permission":{"actor":"ctgbarbeting","permission":"eosio.code"},"weight":1}]}' owner -p ctgbarbeting


cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} push action ctgbarbeting newgame '["Jogo1","Brazil","Germany",3,"1.0000 EOS", "10.0000 EOS",2019,07,30,0,0,"","Russia"]' -p ctgbarbeting
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} push action ctgbarbeting newgame '["Jogo2","Brazil","France",5,"1.0000 EOS", "10.0000 EOS",2019,07,30,0,0,"","Russia"]' -p ctgbarbeting
cleos -u http://${NODE_EOS}:8800 --wallet-url http://${NODE_EOS}:${PORT} push action ctgbarbeting newgame '["Jogo3","Brazil","Mexico",10,"1.0000 EOS", "10.0000 EOS",2019,07,30,0,0,"","Russia"]' -p ctgbarbeting

