#!/bin/bash

contract=i.near-analytics.testnet

near create-account $contract --masterAccount near-analytics.testnet --initialBalance 10
near deploy $contract res/near_analytics.wasm --initFunction new --initArgs '{}'

for i in $(seq 1 2)
do
near call $contract add_post --accountId near-analytics.testnet --deposit 0.01 --args '{"parent_id":null,"body":{"post_type": "Idea","idea_version":"V1","name":"a'$i'","description":"aaa"},"labels":[]}'
near call $contract add_post --accountId near-analytics.testnet --deposit 0.01 --args '{"parent_id":null,"body":{"post_type": "Idea","idea_version":"V1","name":"b'$i'","description":"bbb"},"labels":[]}'
near call $contract add_post --accountId a.near-analytics.testnet --deposit 0.01 --args '{"parent_id":null,"body":{"post_type": "Idea","idea_version":"V1","name":"c'$i'","description":"ccc"},"labels":[]}'
near call $contract add_post --accountId near-analytics.testnet --deposit 0.01 --args '{"parent_id":null,"body":{"post_type": "Idea","idea_version":"V1","name":"d'$i'","description":"ddd"},"labels":[]}'
done

near deploy $contract res/near_analytics.wasm

near call $contract unsafe_self_upgrade --accountId $contract --args $(base64 < res/near_analytics.wasm ) --base64 --gas 300000000000000

near call $contract unsafe_migrate --accountId $contract --gas 300000000000000