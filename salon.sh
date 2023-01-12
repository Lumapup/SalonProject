#!/bin/bash

PSQL="psql --tuples-only -X --username=freecodecamp --dbname=salon -c"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo "$1"
  fi
  echo -e "\n~~~~~ Salon Appointment Scheduler ~~~~~\n"
  echo "$($PSQL "SELECT * FROM services;")" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
  echo -e "\nPlease select which service you would like to schedule:"
  read SERVICE_ID_SELECTED
  if [[ -z $($PSQL "SELECT * FROM services WHERE service_id=$SERVICE_ID_SELECTED") ]]
  then
    MAIN_MENU "Please select a valid service."
  else
    # Valid option selected!

    echo -e "\nPlease enter your phone number:"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\nPlease enter your name:"
      read CUSTOMER_NAME
      CUSTOMER_INSERT_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    fi
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    echo -e "\nPlease enter the time you would like to schedule your$SERVICE_NAME:"
    read SERVICE_TIME
    
    INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
    
    echo -e "I have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

  fi
}

MAIN_MENU