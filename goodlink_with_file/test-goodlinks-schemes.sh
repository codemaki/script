#!/bin/bash

# Test different GoodLinks URL schemes

TEST_URL="https://www.apple.com"
ENCODED_URL=$(python3 -c "import urllib.parse; print(urllib.parse.quote('''$TEST_URL''', safe=''))")
ENCODED_URL_SAFE=$(python3 -c "import urllib.parse; print(urllib.parse.quote('''$TEST_URL''', safe=':/'))")

echo "Testing GoodLinks URL Schemes"
echo "================================"
echo ""
echo "Test URL: $TEST_URL"
echo "Fully encoded: $ENCODED_URL"
echo "Safe encoded: $ENCODED_URL_SAFE"
echo ""
echo "Which scheme would you like to test?"
echo ""
echo "1. goodlinks://x-callback-url/add?url=$ENCODED_URL"
echo "2. goodlinks://add?url=$ENCODED_URL"
echo "3. goodlinks://x-callback-url/add?url=$ENCODED_URL_SAFE"
echo "4. goodlinks://add?url=$ENCODED_URL_SAFE"
echo "5. Test all (with 3 second delay between each)"
echo ""
read -p "Enter choice (1-5): " choice

case $choice in
    1)
        echo "Opening: goodlinks://x-callback-url/add?url=$ENCODED_URL"
        open "goodlinks://x-callback-url/add?url=$ENCODED_URL"
        ;;
    2)
        echo "Opening: goodlinks://add?url=$ENCODED_URL"
        open "goodlinks://add?url=$ENCODED_URL"
        ;;
    3)
        echo "Opening: goodlinks://x-callback-url/add?url=$ENCODED_URL_SAFE"
        open "goodlinks://x-callback-url/add?url=$ENCODED_URL_SAFE"
        ;;
    4)
        echo "Opening: goodlinks://add?url=$ENCODED_URL_SAFE"
        open "goodlinks://add?url=$ENCODED_URL_SAFE"
        ;;
    5)
        echo ""
        echo "Testing scheme 1..."
        open "goodlinks://x-callback-url/add?url=$ENCODED_URL"
        sleep 3

        echo "Testing scheme 2..."
        open "goodlinks://add?url=$ENCODED_URL"
        sleep 3

        echo "Testing scheme 3..."
        open "goodlinks://x-callback-url/add?url=$ENCODED_URL_SAFE"
        sleep 3

        echo "Testing scheme 4..."
        open "goodlinks://add?url=$ENCODED_URL_SAFE"

        echo ""
        echo "All tests complete! Check GoodLinks to see which one worked."
        ;;
    *)
        echo "Invalid choice"
        ;;
esac

echo ""
echo "Did any of these work? Check your GoodLinks app!"
