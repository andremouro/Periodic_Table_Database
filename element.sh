#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
ELEMENT=$1

if [[ -z $ELEMENT ]]
then
echo -e 'Please provide an element as an argument.'
else
  #if not numeric
  if [[ ! $ELEMENT =~ ^[0-9]+$ ]]
  then
    # read the element
    AT_NUM=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$ELEMENT' OR name = '$ELEMENT'")
  else
    #if numeric
    AT_NUM=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $ELEMENT")
  fi
  if [[ -z $AT_NUM ]]
  then
  echo "I could not find that element in the database."
  else
    DETAILS=$($PSQL "SELECT elements.atomic_number, name,symbol,types.type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM 
    elements FULL JOIN properties ON elements.atomic_number = properties.atomic_number 
    FULL JOIN types ON properties.type_id=types.type_id WHERE elements.atomic_number=$AT_NUM")
    #echo the message
    echo "$DETAILS" | while read ATNUM BAR NAME BAR SYMBOL BAR TYPE BAR ATOMIC_MASS BAR MELTING BAR BOILING
    do
      echo "The element with atomic number $ATNUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi
fi