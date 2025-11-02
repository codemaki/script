#!/bin/bash

# Add .webloc files to GoodLinks
# This script processes multiple .webloc files and adds them to GoodLinks app

SUCCESS_COUNT=0
FAIL_COUNT=0
FAILED_FILES=""

# Process each file passed as argument
for FILE in "$@"; do
    # Check if file exists and has .webloc extension
    if [[ ! -f "$FILE" ]]; then
        FAIL_COUNT=$((FAIL_COUNT + 1))
        FAILED_FILES="${FAILED_FILES}\n- $(basename "$FILE"): File not found"
        continue
    fi

    if [[ ! "$FILE" =~ \.webloc$ ]]; then
        FAIL_COUNT=$((FAIL_COUNT + 1))
        FAILED_FILES="${FAILED_FILES}\n- $(basename "$FILE"): Not a .webloc file"
        continue
    fi

    # Extract URL from .webloc file using PlistBuddy
    URL=$(/usr/libexec/PlistBuddy -c "Print :URL" "$FILE" 2>/dev/null)

    if [[ -z "$URL" ]]; then
        FAIL_COUNT=$((FAIL_COUNT + 1))
        FAILED_FILES="${FAILED_FILES}\n- $(basename "$FILE"): Could not extract URL"
        continue
    fi

    # URL encode the URL for the scheme
    ENCODED_URL=$(python3 -c "import urllib.parse; print(urllib.parse.quote('''$URL''', safe=''))")

    # Add to GoodLinks using URL scheme
    # GoodLinks supports: goodlinks://x-callback-url/save?url=ENCODED_URL&quick=1
    open "goodlinks://x-callback-url/save?url=${ENCODED_URL}&quick=1"

    # Small delay to prevent overwhelming the app
    sleep 0.3

    SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
done

# Prepare result message
TOTAL=$((SUCCESS_COUNT + FAIL_COUNT))
MESSAGE="GoodLinks Import Complete\n\n"
MESSAGE="${MESSAGE}Total files: ${TOTAL}\n"
MESSAGE="${MESSAGE}✅ Successfully added: ${SUCCESS_COUNT}\n"
MESSAGE="${MESSAGE}❌ Failed: ${FAIL_COUNT}"

if [[ $FAIL_COUNT -gt 0 ]]; then
    MESSAGE="${MESSAGE}\n\nFailed files:${FAILED_FILES}"
fi

# Show result dialog
osascript -e "display dialog \"${MESSAGE}\" buttons {\"OK\"} default button \"OK\" with title \"Add to GoodLinks\""
