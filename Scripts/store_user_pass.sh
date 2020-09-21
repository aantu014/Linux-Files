cat aantu014.csv | cut -d "," -f1,4,7,8 | while IFS="," read username gender color fruit;
do
  if [[ "$gender" == "m" ]]; then
    htpasswd -b /root/aantu014.htpasswd "$username" "$color"
  elif [[ "$gender" == "f" ]]; then
    htpasswd -b /root/aantu014.htpasswd "$username" "$fruit"
  else
    echo "Error not valid"
  fi
done
