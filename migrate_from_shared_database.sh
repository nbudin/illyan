if [ $# != 2 ]
then
  echo "Usage: $0 shared_db app_db"
  exit 1
fi

SHARED_DB=$1
APP_DB=$2

for t in accounts email_addresses groups groups_people open_id_identities people
do
  echo "Migrating $t"
  COLUMNS=$(mysql -N -u root $APP_DB -e "describe $t" |cut -f 1 |sed 's/^/`/;s/$/`/' |paste -s -d ',')
  mysql -u root -e "INSERT IGNORE INTO $APP_DB.$t ($COLUMNS) SELECT $COLUMNS FROM $SHARED_DB.$t"
done