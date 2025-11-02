#!/bin/bash

# Debug version - shows what's happening

LOG_FILE="/tmp/goodlinks-debug.log"
echo "=== GoodLinks Import Debug Log $(date) ===" > "$LOG_FILE"

SUCCESS_COUNT=0
FAIL_COUNT=0
FAILED_FILES=""
DEBUG_INFO=""

# Process each file passed as argument
for FILE in "$@"; do
    echo "Processing: $FILE" >> "$LOG_FILE"

    # Check if file exists and has .webloc extension
    if [[ ! -f "$FILE" ]]; then
        FAIL_COUNT=$((FAIL_COUNT + 1))
        FAILED_FILES="${FAILED_FILES}\n- $(basename "$FILE"): File not found"
        echo "ERROR: File not found" >> "$LOG_FILE"
        continue
    fi

    if [[ ! "$FILE" =~ \.webloc$ ]]; then
        FAIL_COUNT=$((FAIL_COUNT + 1))
        FAILED_FILES="${FAILED_FILES}\n- $(basename "$FILE"): Not a .webloc file"
        echo "ERROR: Not a .webloc file" >> "$LOG_FILE"
        continue
    fi

    # Extract URL from .webloc file using PlistBuddy
    URL=$(/usr/libexec/PlistBuddy -c "Print :URL" "$FILE" 2>/dev/null)
    echo "Extracted URL: $URL" >> "$LOG_FILE"

    if [[ -z "$URL" ]]; then
        FAIL_COUNT=$((FAIL_COUNT + 1))
        FAILED_FILES="${FAILED_FILES}\n- $(basename "$FILE"): Could not extract URL"
        echo "ERROR: Could not extract URL" >> "$LOG_FILE"
        continue
    fi

    # URL encode the URL for the scheme
    ENCODED_URL=$(python3 -c "import urllib.parse; print(urllib.parse.quote('''$URL''', safe=''))")
    echo "Encoded URL: $ENCODED_URL" >> "$LOG_FILE"

    # Try different GoodLinks URL schemes
    SCHEME_URL="goodlinks://x-callback-url/add?url=${ENCODED_URL}"
    echo "Opening: $SCHEME_URL" >> "$LOG_FILE"

    DEBUG_INFO="${DEBUG_INFO}\n\nFile: $(basename "$FILE")\nOriginal URL: $URL\nEncoded: $ENCODED_URL"

    # Add to GoodLinks using URL scheme
    open "$SCHEME_URL"

    # Small delay to prevent overwhelming the app
    sleep 0.5

    SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
done

echo "Success: $SUCCESS_COUNT, Failed: $FAIL_COUNT" >> "$LOG_FILE"

# Prepare result message
TOTAL=$((SUCCESS_COUNT + FAIL_COUNT))
MESSAGE="GoodLinks Import Debug\n\n"
MESSAGE="${MESSAGE}Total files: ${TOTAL}\n"
MESSAGE="${MESSAGE}✅ Processed: ${SUCCESS_COUNT}\n"
MESSAGE="${MESSAGE}❌ Failed: ${FAIL_COUNT}"

if [[ $FAIL_COUNT -gt 0 ]]; then
    MESSAGE="${MESSAGE}\n\nFailed files:${FAILED_FILES}"
fi

MESSAGE="${MESSAGE}\n\n📋 Debug info saved to:\n/tmp/goodlinks-debug.log${DEBUG_INFO}"

# Show result dialog
osascript -e "display dialog \"${MESSAGE}\" buttons {\"OK\"} default button \"OK\" with title \"GoodLinks Debug\""

# Also open the log file
open -a TextEdit "$LOG_FILE"
