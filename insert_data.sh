#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

CSV_FILE="games.csv"
TEAMS_TABLE="teams"
GAMES_TABLE="games"

read -r headers < "$CSV_FILE"

IFS=, read -ra column_names <<< "$headers"

while IFS=, read -r "${column_names[@]}"; do

    WINNER_ID="$($PSQL "SELECT team_id FROM $TEAMS_TABLE WHERE name = '$winner'")"
    OPPONENT_ID="$($PSQL "SELECT team_id FROM $TEAMS_TABLE WHERE name = '$opponent'")"

    if [[ -z $WINNER_ID ]]; then
      eval "$PSQL \"INSERT INTO $TEAMS_TABLE (name) VALUES ('$winner');\""
    fi

    if [[ -z $OPPONENT_ID ]]; then
      eval "$PSQL \"INSERT INTO $TEAMS_TABLE (name) VALUES ('$opponent');\""
    fi

done < <(tail -n +2 "$CSV_FILE")

while IFS=, read -r "${column_names[@]}"; do

    WINNER_ID="$($PSQL "SELECT team_id FROM $TEAMS_TABLE WHERE name = '$winner'")"
    OPPONENT_ID="$($PSQL "SELECT team_id FROM $TEAMS_TABLE WHERE name = '$opponent'")"

    eval "$PSQL \"INSERT INTO $GAMES_TABLE (year, round, winner_id, opponent_id, winner_goals, opponent_goals) 
    VALUES ('$year', '$round', '$WINNER_ID', '$OPPONENT_ID', '$winner_goals', '$opponent_goals');\""

done < <(tail -n +2 "$CSV_FILE")
