#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games,teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #get winner name
  if [[ $WINNER != winner ]]
  then
    #get team_id
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
   
    #if team_id not found from winner name
    if [[ -z $TEAM_ID ]]
    then
      #insert winner name were team_id gets auto-assigned
      INSERT_WINNER_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
        
        #if input succesfful, then print confirmation
        if [[ $INSERT_WINNER_NAME == 'INSERT 0 1' ]]
        then
          echo "Inserted into team name, $WINNER"
        fi
       
    fi
  fi  

  #get opponent name
  if [[ $OPPONENT != opponent ]]
  then
    #get team_id
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
   
      #if team_id not found from opponent name
      if [[ -z $TEAM_ID ]]
      then
        #insert oponent name were team_id gets auto-assigned
        INSERT_OPPONENT_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
          
          #print confirmation of successful input
          if [[ $INSERT_OPPONENT_NAME == 'INSERT 0 1' ]]
          then
            echo "Inserted into team name, $OPPONENT"
          fi
      
      fi
  fi

  #get winner_id variable from teams(team_id)
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name LIKE '$WINNER'")
  #get opponent_id variable from teams(team_id)
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name LIKE '$OPPONENT'")

  if [[ $YEAR != year ]]
  then
    #insert game result values
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND','$WINNER_ID','$OPPONENT_ID',$WINNER_GOALS,$OPPONENT_GOALS)")
      
      #print confirmation of successful input
      if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into games, $YEAR $ROUND $WINNER_ID $OPPONENT_ID $WINNER_GOALS $OPPONENT_GOALS
      fi
  fi
     
done
