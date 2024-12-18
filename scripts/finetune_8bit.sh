#!/bin/bash

MODEL_NAME="mistral-community/pixtral-12b"

# Pixtral does not support flash-attnetion2 yet.

export PYTHONPATH=src:$PYTHONPATH

accelerate launch --fp8_backend=msamp --fp8_opt_level=O2 src/training/train.py \
    --deepspeed scripts/zero3.json \
    --optim adamw_bnb_8bit \
    --model_id $MODEL_NAME \
    --data_path /home/workspace/Dataset/vlm/description/traffic_sample.json \
    --image_folder /home/workspace/Dataset/vlm/images \
    --disable_flash_attn2 True \
    --lora_enable False \
    --tune_img_projector True \
    --freeze_vision_tower False \
    --freeze_llm False \
    --bf16 False \
    --fp16 True \
    --output_dir output/test \
    --num_train_epochs 1 \
    --per_device_train_batch_size 1 \
    --gradient_accumulation_steps 1 \
    --learning_rate 1e-5 \
    --projector_lr 1e-5 \
    --vision_lr 2e-6 \
    --weight_decay 0. \
    --warmup_ratio 0.03 \
    --lr_scheduler_type "cosine" \
    --logging_steps 1 \
    --tf32 False \
    --gradient_checkpointing True \
    --report_to tensorboard \
    --lazy_preprocess True \
    --dataloader_num_workers 4