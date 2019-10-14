#!/bin/bash
#
# Title:      PSAutomate
# Based On:   PGBlitz (Reference Title File)
# Original Author(s):  Admin9705 - Deiteq
# PSAutomate Auther: fattylewis
# URL:        https://psautomate.io - http://github.psautomate.io
# GNU:        General Public License v3.0
################################################################################

# To Get List for Rebuilding or TLD
docker ps --format '{{.Names}}' > /psa/tmp/backup.list
sed -i -e "/traefik/d" /psa/tmp/backup.list
sed -i -e "/watchtower/d" /psa/tmp/backup.list
sed -i -e "/wp-*/d" /psa/tmp/backup.list
sed -i -e "/x2go*/d" /psa/tmp/backup.list
sed -i -e "/psautomate/d" /psa/tmp/backup.list
sed -i -e "/cloudplow/d" /psa/tmp/backup.list
sed -i -e "/oauth/d" /psa/tmp/backup.list
sed -i -e "/psaui/d" /psa/tmp/backup.list

rm -rf /psa/tmp/backup.build 1>/dev/null 2>&1
#### Commenting Out To Let User See
while read p; do
  echo -n "$p" >> /psa/tmp/backup.build
  echo -n " " >> /psa/tmp/backup.build
done </psa/tmp/backup.list
running=$(cat /psa/tmp/backup.list)

# If Blank, Exit
if [ "$running" == "" ]; then
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️ WARNING! - No Apps are Running! Exiting!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
sleep 2
exit
fi

# Menu Interface
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Traefik - Provider Interface
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
NOTE: App Must Be Actively Running! To quit, type >>> exit

EOF
echo PROGRAMS:
echo $running
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# Standby
read -p 'Type an Application Name | Press [ENTER]: ' typed < /dev/tty

if [ "$typed" == "exit" ]; then exit; fi

tcheck=$(echo $running | grep "\<$typed\>")
if [ "$tcheck" == "" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️ WARNING! - Type an Application Name! Case Senstive! Restarting!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
sleep 3
bash /psa/traefik/tld.sh
exit
fi

if [ "$typed" == "" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️ WARNING! - The TLD Application Name Cannot Be Blank!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
sleep 3
bash /psa/traefik/tld.sh
exit
else
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅️  PASS: TLD Application Set
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# Prevents From Repeating
cat /psa/var/tld.program > /psa/var/old.program
echo "$typed" > /psa/var/tld.program

sleep 3
fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🍖  NOM NOM - Rebuilding Your Old App & New App Containers!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

sleep 4
old=$(cat /psa/var/old.program)
new=$(cat /psa/var/tld.program)

touch /psa/var/tld.type
tldtype=$(cat /psa/var/tld.type)

if [[ "$old" != "$new" && "$old" != "NOT-SET" ]]; then

  if [[ "$tldtype" == "standard" ]]; then
    if [ -e "bash /psa/apps/programs/$old/start.sh" ]; then bash /psa/apps/programs/$old/start.sh; fi
  elif [[ "$tldtype" == "wordpress" ]]; then
    echo "$old" > /psa/tmp/wp_id
    ansible-playbook /psa/psapress/wordpress.yml
    echo "$typed" > /psa/tmp/wp_id
  fi

fi

if [ -e "bash /psa/apps/programs/$new/start.sh" ]; then bash /psa/apps/programs/$new/start.sh; fi
echo "standard" > /psa/var/tld.type
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
read -p '✅️ Process Complete! Acknowledge Info | Press [ENTER] ' name < /dev/tty
