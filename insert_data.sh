#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games CASCADE")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
  if [[ $WINNER != "winner" ]]
  then
  RES=$($PSQL "SELECT COUNT(*) FROM teams WHERE name='$WINNER'")

    if [[ $RES == 0 ]]
    then
      RES=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
    fi
  RES=$($PSQL "SELECT COUNT(*) FROM teams WHERE name='$OPPONENT'")
    
    if [[ $RES == 0 ]]
    then 
      RES=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
    fi
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
  if [[ $WINNER != "winner" ]]
  then
    WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WIN_ID, $OPP_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    
  fi
done