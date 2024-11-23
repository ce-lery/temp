#! /bin/bash

# set log
mkdir -p results/log/$(basename "$0" .sh)
log=results/log/$(basename "$0" .sh)/$(date +%Y%m%d_%H%M%S).log
exec &> >(tee -a $log)
set -x

# set parameters
export TOKENIZERS_PARALLELISM=false
#refer: https://zenn.dev/bilzard/scraps/5b00b74984831f
export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True

BATCH_SIZE=4
GRADIENT_ACCUMULATION_STEPS=32
EPOCH=1
DIR_NAME=pretrain_mistral
mkdir -p ./results/patch_train/

#! /bin/bash

# set log
mkdir -p results/log/$(basename "$0" .sh)
log=results/log/$(basename "$0" .sh)/$(date +%Y%m%d_%H%M%S).log
exec &> >(tee -a $log)
set -x

# set parameters
export TOKENIZERS_PARALLELISM=false
#refer: https://zenn.dev/bilzard/scraps/5b00b74984831f
export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True

BATCH_SIZE=4
GRADIENT_ACCUMULATION_STEPS=32
EPOCH=1
DIR_NAME=pretrain_mistral
mkdir -p ./results/usual_train/

# intialize process counter
SECONDS=0


# ------------------------------------------
#   train
# ------------------------------------------
#rm -r ./results/pretrain/$DIR_NAME/mistral2b_trial2
python run_clm.py \
    --model_type "mistral" \
    --config_name config_mistral_300m.json \
    --tokenizer_name ce-lery/japanese-mistral-300m-base \
    --train_file wiki.jsonl \
    --patch_size 1 \
    --output_dir ./results/pretrain/$DIR_NAME/trial1 \
    --cache_dir ./results/pretrain/cache/usual_train \
    --do_train \
    --prediction_loss_only \
    --remove_unused_columns False \
    --learning_rate 3.0e-4 \
    --weight_decay 0.1 \
    --adam_beta2 0.95 \
    --num_train_epochs $EPOCH \
    --logging_dir ./results/pretrain/logs/$DIR_NAME/trial1 \
    --logging_strategy "steps" \
    --logging_steps 10 \
    --save_strategy "steps" \
    --save_steps 100 \
    --save_total_limit 3 \
    --warmup_steps 1000 \
    --min_lr_rate 0.1 \
    --lr_scheduler_type cosine_with_min_lr \
    --per_device_train_batch_size $BATCH_SIZE \
    --per_device_eval_batch_size $BATCH_SIZE \
    --block_size 1024 \
    --adam_epsilon 1.0e-8 \
    --torch_dtype "bfloat16" \
    --gradient_accumulation_steps $GRADIENT_ACCUMULATION_STEPS \
    --push_to_hub False\
    --preprocessing_num_workers 8 \
    --dataloader_num_workers 8 \
    --optim "adamw_bnb_8bit" \
    --torch_compile True \
    --torch_compile_backend "eager" \
    # --resume_from_checkpoint ./results/pretrain/pretrain_mistral/trial1/checkpoint-5000/
    # --gradient_checkpointing True 
    # --min_lr 8.0e-6 \
    #--load_best_model_at_end \


time=$SECONDS
echo "process_time: $time sec"

set +x