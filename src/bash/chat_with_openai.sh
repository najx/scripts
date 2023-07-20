#!/bin/bash

# Configuration
OPENAI_API_KEY="your_openai_api_key"
OPENAI_API_URL="https://api.openai.com/v1/chat/completions"

# Mandatory parameter
path=$1

# Check if the path exists
if [ ! -d "$path" ]; then
    echo "The specified path does not exist"
    exit 1
fi

# Initialize the prompt with a description of the task
prompt="Hello, I am an AI assistant and I need to analyze the entire content of a project. The project is organized as follows:"

# Generate a description of the project structure
for file in $(find $path); do
    if [ -d "$file" ]; then
        prompt+="\n- Directory: ${file#$path}"
    else
        prompt+="\n  - File: ${file#$path}"
    fi
done

prompt+="\nPlease provide an overview and insights on this project."

# Create a JSON payload for the API request
jsonPayload=$(
    jq -n \
    --arg model "gpt-3.5-turbo" \
    --arg content "$prompt" \
    '{
        "model": $model,
        "messages": [{"role": "system", "content": "I am a helpful assistant."}, {"role": "user", "content": $content}],
        "temperature": 0.7
    }'
)

# Print the JSON payload
echo "Sending the following payload to the OpenAI API:"
echo "$jsonPayload"

# Call OpenAI API with curl
response=$(curl -s -X POST $OPENAI_API_URL \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -d "$jsonPayload"
)

# Extract the 'choices' field from the JSON response
#result=$(echo $response | jq -r '.choices[0].message.content')

# Print the response
echo "AI Response:"
echo "$response"
