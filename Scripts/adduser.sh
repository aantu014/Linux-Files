###normall user add###
cat -n aantu014.csv | head -200 | cut -d "," -f1 | while IFS="," read username;
do
  useradd "$username"
done


###useradd with comments###
cat -n aantu014.csv | head -400 | tail -200 | cut -d "," -f1,2,3 | sed 's/,[a-z]/\U&/g' | while IFS="," read username firstname lastname;
do
  useradd "$username" -c "$firstname $lastname"
done


###normal group add###
cat -n aantu014.csv | head -600 | tail -200 | cut -d "," -f6 | sed 's/,[a-z]/\U&/g' | while IFS="," read groupname;
do
  groupadd "$groupname"
done

###useradd with comments shell and group
cat -n aantu014.csv | head -1000 | tail -400 | cut -d "," -f1,2,3,7,10 | while IFS="," read username firstname lastname groupname shell;
do
  groupadd "$groupname"
  useradd -c "$firstname $lastname" -G "$groupname" -s "$shell" "$username"
done
