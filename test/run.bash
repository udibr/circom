#!/bin/bash
# usage:
# run <file> [--protocol groth]
circom --version
snarkjs --version
old="$IFS"
IFS=''
mkdir ../build
name="../build/$*"
IFS=$old
echo ${name}
circom circuits/$1.circom -o ${name}.json
snarkjs info -c ${name}.json
snarkjs setup -c ${name}.json --pk ${name}_proving_key.json --vk ${name}_verification_key.json ${@:2}
snarkjs calculatewitness -c ${name}.json -i $1_input.json -w ${name}_witness.json
snarkjs proof -w ${name}_witness.json --pk ${name}_proving_key.json -p ${name}_proof.json --pub ${name}_public.json
snarkjs verify --vk ${name}_verification_key.json -p ${name}_proof.json --pub ${name}_public.json
snarkjs generateverifier --vk ${name}_verification_key.json -v ${name}_verifier.sol
snarkjs generatecall -p ${name}_proof.json --pub ${name}_public.json > ${name}_params