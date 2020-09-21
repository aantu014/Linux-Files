cat aantu014.csv | cut -d "," -f1,4,7,8,11 | while IFS="," read username gender color fruit permission;
do
  if [[ "$gender" == "m" ]]; then
    mysql -e "GRANT $permission ON *.* to $username@'%' IDENTIFIED by '$color'"
  elif [[ "$gender" == "f" ]]; then
    mysql -e "GRANT $permission ON *.* to $username@'%' IDENTIFIED by '$fruit'"
  else
    echo "Error not valid"
  fi
done
