#!/bin/bash
# Helper script to submit Advent of Code answers
# Usage: ./submit.sh YEAR DAY PART ANSWER

if [ "$#" -ne 4 ]; then
    echo "Usage: $0 YEAR DAY PART ANSWER"
    echo "Example: $0 2020 1 1 514579"
    exit 1
fi

YEAR=$1
DAY=$2
PART=$3
ANSWER=$4

if [ -z "$AOC_SESSION" ]; then
    echo "Error: AOC_SESSION environment variable not set"
    exit 1
fi

URL="https://adventofcode.com/${YEAR}/day/${DAY}/answer"

echo "Submitting to: $URL"
echo "Part: $PART"
echo "Answer: $ANSWER"
echo ""

RESPONSE=$(curl -s -X POST "$URL" \
    -H "Cookie: session=$AOC_SESSION" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "level=${PART}&answer=${ANSWER}")

# Extract the main message from the response
echo "$RESPONSE" | grep -oP '(?<=<article>).*?(?=</article>)' | sed 's/<[^>]*>//g' | head -1

# Check for specific responses
if echo "$RESPONSE" | grep -q "That's the right answer"; then
    echo "✅ CORRECT!"
    exit 0
elif echo "$RESPONSE" | grep -q "That's not the right answer"; then
    echo "❌ WRONG ANSWER"
    exit 1
elif echo "$RESPONSE" | grep -q "You gave an answer too recently"; then
    echo "⏱️  RATE LIMITED - wait before trying again"
    exit 2
elif echo "$RESPONSE" | grep -q "Did you already complete it"; then
    echo "✓ Already completed"
    exit 0
else
    echo "⚠️  Unknown response"
    exit 3
fi
