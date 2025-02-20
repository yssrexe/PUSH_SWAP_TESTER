#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
RESET='\033[0m'

# Configuration
MAX_MOVES=700
PUSH_SWAP="./push_swap"
CHECKER="./checker_linux"
WORST_CASE=0
TOTAL_MOVES=0
TEST_COUNT=0
FAILED_COUNT=0
LOG_FILE="push_swap_failed_cases.log"

# Clear previous log file
> "$LOG_FILE"

# ASCII Art Banner
print_banner() {
    echo -e "${CYAN}"
    echo "██████╗ ██╗   ██╗███████╗██╗  ██╗    ███████╗██╗    ██╗ █████╗ ██████╗"
    echo "██╔══██╗██║   ██║██╔════╝██║  ██║    ██╔════╝██║    ██║██╔══██╗██╔══██╗"
    echo "██████╔╝██║   ██║███████╗███████║    ███████╗██║ █╗ ██║███████║██████╔╝"
    echo "██╔═══╝ ██║   ██║╚════██║██╔══██║    ╚════██║██║███╗██║██╔══██║██╔═══╝"
    echo "██║     ╚██████╔╝███████║██║  ██║    ███████║╚███╔███╔╝██║  ██║██║"
    echo "╚═╝      ╚═════╝ ╚══════╝╚═╝  ╚═╝    ╚══════╝ ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝"
    echo "                     MEGA EVIL PATTERN TESTER"
    echo "                        by isel-kha @ 42"
    echo -e "${RESET}"
}

# Check if required programs exist
check_requirements() {
    if [ ! -f "$PUSH_SWAP" ]; then
        echo -e "${RED}Error: push_swap executable not found${RESET}"
        exit 1
    fi
    if [ ! -f "$CHECKER" ]; then
        echo -e "${YELLOW}Warning: checker_linux not found, will skip correctness verification${RESET}"
    fi
    chmod +x "$PUSH_SWAP" 2>/dev/null
    chmod +x "$CHECKER" 2>/dev/null
}

# Log failed test case
log_failed_case() {
    local sequence="$1"
    local test_name="$2"
    local moves="$3"
    local reason="$4"
    
    echo "====================" >> "$LOG_FILE"
    echo "Failed Test: $test_name" >> "$LOG_FILE"
    echo "Moves: $moves" >> "$LOG_FILE"
    echo "Reason: $reason" >> "$LOG_FILE"
    echo "Sequence: $sequence" >> "$LOG_FILE"
    echo "Time: $(date)" >> "$LOG_FILE"
    echo "====================" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"
}

# Test a single sequence
test_sequence() {
    local sequence="$1"
    local test_name="$2"
    local moves=0
    local result="OK"
    
    # Run push_swap and count moves
    moves=$(./push_swap $sequence 2>/dev/null | wc -l)
    
    # Update statistics
    ((TEST_COUNT++))
    ((TOTAL_MOVES += moves))
    if [ $moves -gt $WORST_CASE ]; then
        WORST_CASE=$moves
    fi
    
    # Verify sorting if checker exists
    if [ -f "$CHECKER" ]; then
        result=$(./push_swap $sequence 2>/dev/null | ./checker_linux $sequence 2>/dev/null)
    fi

    # Print results with progress indicator
    printf "Test %3d: %-20s" "$TEST_COUNT" "$test_name"
    if [ "$result" != "OK" ]; then
        echo -e "${RED}❌ Failed (incorrect sorting)${RESET}"
        log_failed_case "$sequence" "$test_name" "$moves" "Incorrect sorting"
        ((FAILED_COUNT++))
    elif [ $moves -gt $MAX_MOVES ]; then
        echo -e "${RED}❌ Failed ($moves moves > $MAX_MOVES)${RESET}"
        log_failed_case "$sequence" "$test_name" "$moves" "Too many moves ($moves > $MAX_MOVES)"
        ((FAILED_COUNT++))
    else
        echo -e "${GREEN}✓ Passed ($moves moves)${RESET}"
    fi
}

# Process test patterns from the files
process_patterns() {
    local section=""
    local pattern=""
    local section_count=0
    
    while IFS= read -r line; do
        # Skip empty lines
        [[ -z "$line" ]] && continue
        
        # Handle section headers
        if [[ "$line" =~ ^#.*Section ]]; then
            section=$(echo "$line" | sed 's/^#[[:space:]]*Section[[:space:]]*\([0-9]*\).*/\1/')
            echo -e "\n${CYAN}Testing Section $section Patterns${RESET}"
            continue
        fi
        
        # Skip other comments
        [[ "$line" =~ ^#.* ]] && continue
        
        # Process pattern if it looks valid (contains numbers)
        if [[ "$line" =~ [0-9] ]]; then
            test_sequence "$line" "Section ${section:-Unknown} Pattern"
        fi
    done
}

# Main execution
print_banner
check_requirements

# Process all pattern files
echo -e "${CYAN}Starting comprehensive evil pattern testing...${RESET}\n"

# Check if pattern files exist
if ! ls evil-patterns*.md 1> /dev/null 2>&1; then
    echo -e "${RED}Error: No pattern files found (evil-patterns*.md)${RESET}"
    exit 1
fi

# Process all MD files
cat evil-patterns*.md | process_patterns

exit $((FAILED_COUNT > 0))
