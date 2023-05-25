#!/usr/bin/env bash

DOMAIN_ID=d-f5kpjyge0dzi
REGION=us-east-2

export AWS_REGION="<YOUR-AWS-REGION>"
export KENDRA_INDEX_ID="<YOUR-KENDRA-INDEX-ID>"
export FLAN_XL_ENDPOINT="<YOUR-SAGEMAKER-ENDPOINT-FOR-FLAN-T-XL>"
export FLAN_XXL_ENDPOINT="<YOUR-SAGEMAKER-ENDPOINT-FOR-FLAN-T-XXL>"
export OPENAI_API_KEY="<YOUR-OPEN-AI-API-KEY>"
export ANTHROPIC_API_KEY="<YOUR-ANTHROPIC-API-KEY>"

echo https://${DOMAIN_ID}.studio.${REGION}.sagemaker.aws/jupyter/default/proxy/8501/

streamlit run samples/app.py openai --server.port 8501