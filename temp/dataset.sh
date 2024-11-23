#! /bin/bash

# set log
mkdir -p results/log/$(basename "$0" .sh)
log=results/log/$(basename "$0" .sh)/$(date +%Y%m%d_%H%M%S).log
exec &> >(tee -a $log)
set -x

GIT_LFS_SKIP_SMUDGE=1 git clone https://huggingface.co/datasets/ce-lery/wiki.git
cd wiki
git lfs pull 
mv ./wiki.jsonl ../
cd -

echo "# split wiki.txt"
LINES=`wc -l wiki.jsonl | awk '{print $1}'`
echo $LINES

TRAIN_DATA_LINES=$(($LINES*66/100))
REMAIN_DATA_LINES=$(($LINES-$TRAIN_DATA_LINES))
echo $TRAIN_DATA_LINES
echo $REMAIN_DATA_LINES

head -n $TRAIN_DATA_LINES wiki.jsonl > wiki_66.jsonl
tail -n $REMAIN_DATA_LINES wiki.jsonl > wiki_34.jsonl


set +x