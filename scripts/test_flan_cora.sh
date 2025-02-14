#This file is for testing the instructGLM on the prompt (I think) which runs pretrain.py. More comments in pretrain.py.
#!/bin/bash

export CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7

name=cora-base

output=snap/$name

PYTHONPATH=$PYTHONPATH:./flan_cora_src \
python -m torch.distributed.launch \
    --nproc_per_node=$1 \
    --master_port 12322 \
    flan_cora_src/pretrain.py \
        --distributed --multiGPU \
        --seed 42 \
	--gradient_accumulation_steps 1 \
        --train Cora \
        --valid Cora \
        --batch_size 50 \
        --optim adamw \
        --warmup_ratio 0.05 \
        --num_workers 8 \
        --clip_grad_norm 1.0 \
        --losses 'classification' \
        --backbone 'google/flan-t5-base' \
        --output $output ${@:2} \
        --epoch 6 \
	--inference \
	--weight_decay 0 \
        --max_text_length 512 \
        --gen_max_length 64 \
	--lr 0.00001
