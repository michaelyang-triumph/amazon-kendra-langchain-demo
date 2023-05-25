# AWS Langchain
This repo provides a set of utility classes to work with [Langchain](https://github.com/hwchase17/langchain/tree/master). It currently has a retriever class `KendraIndexRetriever` for working with a Kendra index and sample scripts to execute the QA chain for SageMaker, Open AI and Anthropic providers.

## Installing

Clone the repository
```bash
git clone https://github.com/aws-samples/amazon-kendra-langchain-extensions.git
```

Move to the repo dir
```bash
cd amazon-kendra-langchain-extensions
```


Install the classes
```bash
run install_dep.sh
```

## Usage

Usage with SageMaker Endpoint for Flan-T-XXL
```python
from aws_langchain.kendra_index_retriever import KendraIndexRetriever
from langchain.chains import RetrievalQA
from langchain import OpenAI
from langchain.prompts import PromptTemplate
from langchain import SagemakerEndpoint
from langchain.llms.sagemaker_endpoint import ContentHandlerBase
import json

class ContentHandler(ContentHandlerBase):
    content_type = "application/json"
    accepts = "application/json"

    def transform_input(self, prompt: str, model_kwargs: dict) -> bytes:
        input_str = json.dumps({"inputs": prompt, "parameters": model_kwargs})
        return input_str.encode('utf-8')

    def transform_output(self, output: bytes) -> str:
        response_json = json.loads(output.read().decode("utf-8"))
        return response_json[0]["generated_text"]

content_handler = ContentHandler()
llm=SagemakerEndpoint(
        endpoint_name=endpoint_name,
        region_name="us-east-1", 
        model_kwargs={"temperature":1e-10, "max_length": 500},
        content_handler=content_handler
    )

retriever = KendraIndexRetriever(kendraindex=kendra_index_id,
        awsregion=region,
        return_source_documents=True
    )

prompt_template = """
The following is a friendly conversation between a human and an AI.
The AI is talkative and provides lots of specific details from its context.
If the AI does not know the answer to a question, it truthfully says it
does not know.
{context}
Instruction: Based on the above documents, provide a detailed answer for, {question} Answer "don't know" if not present in the document. Solution:
"""
PROMPT = PromptTemplate(
    template=prompt_template, input_variables=["context", "question"]
)
chain_type_kwargs = {"prompt": PROMPT}
qa = RetrievalQA.from_chain_type(
    llm,
    chain_type="stuff",
    retriever=retriever,
    chain_type_kwargs=chain_type_kwargs,
    return_source_documents=True
)
result = qa("What's SageMaker?")
print(result['answer'])

```

## Creating an Amazon Kendra index with test data
If you wish to create a sample Kendra index and index sample data and experiment with the index using the sample applications you can deploy the CloudFormation template samples/kendra-docs-index.yaml


## Running samples
1. Edit duplicate run_app_template.sh as run_app.sh
2. Replace env variables 
3. 
```bash
sh run_app.sh
```

