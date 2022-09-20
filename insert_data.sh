#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "truncate teams, games")

cat games.csv | while IFS="," read -r year round winner opponent winner_goals opponent_goals
do
  #get winner id
  winnerid=$($PSQL "select team_id from teams where name = '$winner'")
  # echo "winner id: $winnerid"
  
  #if not winner id
  if [[ -z $winnerid ]]
  then
  #insert winner into teams
    inserted_teams=$($PSQL "insert into teams(name) values('$winner')")
    # if [[ $inserted_teams == "INSERT 0 1" ]]
    # then
    #   echo "Team inserted is: '$winner'"
    # fi
    winnerid=$($PSQL "select team_id from teams where name = '$winner'")
  fi

  #get oppid
  oppid=$($PSQL "select team_id from teams where name = '$opponent'")
  # echo "opp id $oppid"

  #if not opp id
  if [[ -z $oppid ]]
  then
  #insert opp into teams
    insert_to_teams=$($PSQL "insert into teams(name) values('$opponent')")
    # if [[ $insert_to_teams == "INSERT 0 1" ]]
    # then
    #   echo "Opponent inserted '$opponent'"
    # fi
    oppid=$($PSQL "select team_id from teams where name = '$opponent'")
  fi

  # echo "$year $round $winnerid $oppid $winner_goals $opponent_goals"
  echo $($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($year, '$round', $winnerid, $oppid, $winner_goals, $opponent_goals)")
done < <(tail -n +2 games.csv)
