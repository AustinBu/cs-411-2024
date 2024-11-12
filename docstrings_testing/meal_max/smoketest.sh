#!/bin/bash

# Define the base URL for the Flask API
BASE_URL="http://localhost:5001/api"

# Flag to control whether to echo JSON output
ECHO_JSON=false

# Parse command-line arguments
while [ "$#" -gt 0 ]; do
  case $1 in
    --echo-json) ECHO_JSON=true ;;
    *) echo "Unknown parameter passed: $1"; exit 1 ;;
  esac
  shift
done


###############################################
#
# Health checks
#
###############################################

# Function to check the health of the service
check_health() {
  echo "Checking health status..."
  curl -s -X GET "$BASE_URL/health" | grep -q '"status": "healthy"'
  if [ $? -eq 0 ]; then
    echo "Service is healthy."
  else
    echo "Health check failed."
    exit 1
  fi
}

# Function to check the database connection
check_db() {
  echo "Checking database connection..."
  curl -s -X GET "$BASE_URL/db-check" | grep -q '"database_status": "healthy"'
  if [ $? -eq 0 ]; then
    echo "Database connection is healthy."
  else
    echo "Database check failed."
    exit 1
  fi
}


##########################################################
#
# Meal Management
#
##########################################################

clear_catalog() {
  echo "Clearing the playlist..."
  curl -s -X DELETE "$BASE_URL/clear-catalog" | grep -q '"status": "success"'
}

create_meal() {
    meal=$1
    cuisine=$2
    price=$3
    difficulty=$4

    echo "Adding meal ($meal, $cuisine, $price, $difficulty) to the playlist..."
    curl -s -X POST "$BASE_URL/create-meal" -H "Content-Type: application/json" \
        -d "{\"meal\":\"$meal\", \"cuisine\":\"$cuisine\", \"price\":$price, \"difficulty\":\"$difficulty\"}" | grep -q '"status": "success"'

    if [ $? -eq 0 ]; then
        echo "Meal added successfully."
    else
        echo "Failed to add meal."
        exit 1
    fi
}

delete_meal_by_id() {
    meal_id=$1

    echo "Deleting meal by ID ($meal_id)..."
    response=$(curl -s -X DELETE "$BASE_URL/delete-meal/$meal_id")
    if echo "$response" | grep -q '"status": "success"'; then
        echo "Meal deleted successfully by ID ($meal_id)."
    else
        echo "Failed to delete meal by ID ($meal_id)."
        exit 1
    fi
}

get_leaderboard() {
    sort_by=$1

    echo "Getting leaderboard by ($sort_by)..."
    response=$(curl -s -X GET "$BASE_URL/leaderboard?sort=$sort_by")
    if echo "$response" | grep -q '"status": "success"'; then
        echo "Leaderboard retrieved successfully."
        if [ "$ECHO_JSON" = true ]; then
        echo "Meals JSON:"
        echo "$response" | jq .
        fi
    else
        echo "Failed to get leaderboard."
        exit 1
    fi
}

get_meal_by_id() {
  meal_id=$1

  echo "Getting meal by name ($meal_id)..."
  response=$(curl -s -X GET "$BASE_URL/get-meal-by-id/$meal_id")
  if echo "$response" | grep -q '"status": "success"'; then
    echo "Meal retrieved successfully by ID ($meal_id)."
    if [ "$ECHO_JSON" = true ]; then
      echo "Meal JSON (Name $meal_id):"
      echo "$response" | jq .
    fi
  else
    echo "Failed to get meal by ID ($meal_id)."
    exit 1
  fi
}

get_meal_by_name() {
  meal_name=$1

  echo "Getting meal by name ($meal_name)..."
  response=$(curl -s -X GET "$BASE_URL/get-meal-by-name/$meal_name")
  if echo "$response" | grep -q '"status": "success"'; then
    echo "Meal retrieved successfully by name ($meal_name)."
    if [ "$ECHO_JSON" = true ]; then
      echo "Meal JSON (Name $meal_name):"
      echo "$response" | jq .
    fi
  else
    echo "Failed to get meal by name ($meal_name)."
    exit 1
  fi
}

check_health
check_db

clear_catalog

create_meal "Meal1" "Cuisine1" 1.00 "LOW"
create_meal "Meal2" "Cuisine2" 1.00 "LOW"
create_meal "Meal3" "Cuisine3" 1.00 "LOW"
create_meal "Meal4" "Cuisine4" 1.00 "LOW"
create_meal "Meal5" "Cuisine5" 1.00 "LOW"
create_meal "Meal6" "Cuisine6" 1.00 "LOW"
create_meal "Meal7" "Cuisine7" 1.00 "LOW"
create_meal "Meal8" "Cuisine8" 1.00 "LOW"
create_meal "Meal9" "Cuisine9" 1.00 "LOW"

delete_meal_by_id 1

get_leaderboard "wins"
get_meal_by_id 2
get_meal_by_name "Meal3"

############################################################
#
# Combatant Management
#
############################################################

add_combatant() {
  meal=$1

  echo "Adding combatant: $meal"
  response=$(curl -s -X POST "$BASE_URL/prep-combatant" -H "Content-Type: application/json" \
    -d "{\"meal\":\"$meal\"}")
  if echo "$response" | grep -q '"status": "success"'; then
    echo "Combatant added successfully."
  else
    echo "Failed to add combatant."
    exit 1
  fi
}

get_combatants() {
  echo "Retrieving current combatants..."
  response=$(curl -s -X GET "$BASE_URL/get-combatants")
  if echo "$response" | grep -q '"status": "success"'; then
    echo "Combatants retrieved successfully."
    if [ "$ECHO_JSON" = true ]; then
      echo "Combatants JSON:"
      echo "$response" | jq .
    fi
  else
    echo "Failed to retrieve combatants."
    exit 1
  fi
}

clear_combatants() {
  echo "Clearing all combatants..."
  response=$(curl -s -X POST "$BASE_URL/clear-combatants")
  if echo "$response" | grep -q '"status": "success"'; then
    echo "Combatants cleared successfully."
  else
    echo "Failed to clear combatants."
    exit 1
  fi
}

############################################################
#
# Battle Execution
#
############################################################

start_battle() {
  echo "Starting a battle..."
  response=$(curl -s -X GET "$BASE_URL/battle")
  if echo "$response" | grep -q '"status": "success"'; then
    echo "Battle completed successfully."
    if [ "$ECHO_JSON" = true ]; then
      echo "Battle result JSON:"
      echo "$response" | jq .
    fi
  else
    echo "Failed to start battle."
    exit 1
  fi
}

############################################################
#
# Smoke Test Execution
#
############################################################

# Health check
check_health
clear_combatants
# Add combatants
add_combatant "Meal4"
add_combatant "Meal5"
# Retrieve combatants
get_combatants
# Clear combatants and re-add for battle test
clear_combatants
add_combatant "Meal6"
add_combatant "Meal7"
# Start a battle
start_battle
# Clear combatants after testing
clear_combatants

echo "All smoke tests passed successfully!"