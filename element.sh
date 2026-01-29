#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

if [[ $1 =~ ^[0-9]+$ ]]
then
  CONDITION="atomic_number=$1"
else
  CONDITION="symbol=INITCAP('$1') OR name=INITCAP('$1')"
fi

RESULT=$($PSQL "
SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius
FROM elements
JOIN properties USING(atomic_number)
JOIN types USING(type_id)
WHERE $CONDITION
")

if [[ -z $RESULT ]]
then
  echo "I could not find that element in the database."
  exit
fi

IFS="|" read ATOMIC NAME SYMBOL TYPE MASS MELT BOIL <<< "$RESULT"

echo "The element with atomic number $ATOMIC is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
