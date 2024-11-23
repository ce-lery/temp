#! /bin/bash

# set log
# mkdir -p results/log/$(basename "$0" .sh)
# log=results/log/$(basename "$0" .sh)/$(date +%Y%m%d_%H%M%S).log
# exec &> >(tee -a $log)
# set -x

# pretrain
# refer: https://note.com/npaka/n/n26a587be962d
# refer: https://discuss.huggingface.co/t/customized-tokenization-files-in-run-clm-script/21460/3
python ./source/inference/inference.py \
    --model_path "./results/pretrain/pretrain_mistral/trial2/" \
    --device "cuda" \
    --prompt "日本の首都は" \

# set +x