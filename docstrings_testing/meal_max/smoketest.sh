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


create_meal() {
    meal=$1
    cuisine=$2
    price=$3
    difficulty=$4

    echo "Adding meal ($meal, $cuisine, $price, $difficulty) to the playlist..."
    curl -v -X POST "$BASE_URL/create-meal" -H "Content-Type: application/json" \
        -d "{\"meal\":\"$meal\", \"cuisine\":$cuisine, \"price\":\"$price\", \"difficulty\":$difficulty}" | grep -q '"status": "success"'

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
    response=$(curl -s -X DELETE "$BASE_URL/delete-meal/$meal_name")
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
    response=$(curl -s -X GET "$BASE_URL/get-leaderboard/$meal_id")
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

update_meal_stats() {
    meal_id=$1
    result=$2

    echo "Updating meal ($meal_id) with ($result)..."
    curl -s -X POST "$BASE_URL/update-meal-stats" -H "Content-Type: application/json" \
    -d "{\"meal_id\":\"$meal_id\", \"rsult\":\"$result\"}" | grep -q '"status": "success"'

    if [ $? -eq 0 ]; then
        echo "Meal updated successfully."
    else
        echo "Failed to update meal."
        exit 1
    fi
}

check_health
check_db

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

update_meal_stats 2 "win"

get_leaderboard